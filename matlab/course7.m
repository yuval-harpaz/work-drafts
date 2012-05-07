cd oddball
if ~exist('oddball.rtw','file')
    !cp /home/meg/SAM_BIU/docs/SuDi0811.rtw oddball.rtw
end

load trl % this was calculated in course6 (auditory data)
source='c,rfhp0.1Hz';
cfg=[];
cfg.dataset=source;
cfg.trialfun='trialfun_beg';
cfg2=ft_definetrial(cfg);
cfg2.trl=trl;
cfg2.demean='yes';
cfg2.baselinewindow=[-0.2 0];
cfg2.bpfilter='yes';
cfg2.bpfreq=[3 30];
cfg2.channel={'MEG','MEGREF'};
data=ft_preprocessing(cfg2);

cfg4.latency=[-0.1 0.6];
cfg4.trials=find(data.trialinfo==128);
cfg4.channel='MEG';
standard=ft_timelockanalysis(cfg4,data);
cfg4.trials=find(data.trialinfo==64);
oddball=ft_timelockanalysis(cfg4,data);

% choose time of interest
cfg=[];
cfg.interactive='yes';
cfg.layout='4D248.lay';
cfg.zlim=[-5e-14 5e-14];
figure;
ft_multiplotER(cfg,standard,oddball);

toi=[0.043657 0.075163]; % toi=[0.26 0.354];
close all

% for SAM we have to create a text file with the timing of the trials by
% condition,
% and we want a list of all the trials pulled together.
% trl=data.cfg.trl;
trigTime=(trl(:,1)-trl(:,3))./1017.25;
Trig2mark(...
    'All',trigTime',...
    'Standard',trigTime(find(trl(:,4)==128),1)',...
    'Oddball',trigTime(find(trl(:,4)==64),1)',...
    'Novel',trigTime(find(trl(:,4)==32),1)');

fitMRI2hs('c,rfhp0.1Hz')

hs2afni % for AFNI (required for nudging)
hs2afni('small'); % for ft_sourceplot (view only)

% to see the headshape on top of the MRI:
hdsh=ft_read_mri('hds+ORIG.BRIK');
hs_points=hdsh.anatomy>0;
mri=ft_read_mri('warped+ORIG.BRIK');
mri.anatomy=mri.anatomy+hs_points;
cfg=[];cfg.interactive='yes';
figure, ft_sourceplot(cfg,mri);
% see that the headshape fits the MRI with AFNI
% if you have to nudge this is the time.

% for Nolte model proceed to these steps
!~/abin/3dSkullStrip -input warped+orig -prefix mask -mask_vol -skulls -o_ply ortho
!meshnorm ortho_brainhull.ply > hull.shape

%% param file
cd ..
createPARAM('allTrials','ERF','All',toi,'All',[(toi(1)-toi(2)) 0],[1 40],[-0.1 0.5],[],[],'MultiSphere');


% to run SAM you have to be one folder above the data
!SAMcov -r oddball -d c,rfhp0.1Hz -m allTrials -v
!SAMwts -r oddball -d c,rfhp0.1Hz -m allTrials -c Alla -v
!SAMerf -r oddball -d c,rfhp0.1Hz -m allTrials -v
!cp oddball/SAM/*svl oddball/
% now see the image in afni
createPARAM('allinduced','SPM','All',toi,'All',[(toi(1)-toi(2)) 0],[1 40],[-0.1 0.5],[],[],'MultiSphere');
!SAMcov -r oddball -d c,rfhp0.1Hz -m allinduced -v
!SAMwts -r oddball -d c,rfhp0.1Hz -m allinduced -c Alla -v
% FIXME, this line didn't work!SAMspm -r oddball -d c,rfhp0.1Hz -m allinduced -v

%% read the weights and compute images by yourself
cd oddball;
wtsNoSuf='SAM/allTrials,1-40Hz,Alla';
[SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts'); %save in mat format, quicker to read later.
% after watching the SAMerf image we choose a voxel of interest
vox=[1.5,-5.5,5.5];
% lets visualize the weights used for source loc to this voxel
plotWeights(wtsNoSuf,vox)

% now we want a virtual sensor created for this voxel to be created for 2
% conditions
[voxi,allInd]=voxIndex(vox,100.*[...
    SAMHeader.XStart SAMHeader.XEnd ...
    SAMHeader.YStart SAMHeader.YEnd ...
    SAMHeader.ZStart SAMHeader.ZEnd],...
    100.*SAMHeader.StepSize,1);
wts=ActWgts(voxi,:);
vsSt=ActWgts(voxi,:)*standard.avg;
vsOd=ActWgts(voxi,:)*oddball.avg;
plot(oddball.time,vsSt);hold on;
plot(oddball.time,vsOd,'r');
legend('standard','oddball')

% now we want the whole brain activity at one time point, beware, messy!
t=0.2733;
[vs,timeline,allInd]=VS_slice(oddball,wtsNoSuf,1,[t t]);
[vs,allInd]=inScalpVS(vs,allInd); % excluding out of the scalp grid points
vsSlice2afni(allInd,vs,'oddRaw');
 !~/abin/afni -dset warped+orig &
 
 % let's compute power for toi=[0.26 0.354]; see bias to the middle
 [vs,timeline,allInd]=VS_slice(oddball,wtsNoSuf,1,[toi(1) toi(2)]);
 [vs,allInd]=inScalpVS(vs,allInd);
 pow=mean(vs'.^2);
 vsSlice2afni(allInd,pow','oddPow');
 
% so we want to normalize
[vsBL,timeline,allInd]=VS_slice(oddball,wtsNoSuf,1,[toi(1)-toi(2) 0]);
[vsBL,allInd]=inScalpVS(vsBL,allInd);
powBL=mean(vsBL'.^2);
nai=(pow-powBL)./powBL;
vsSlice2afni(allInd,nai','oddNai');

% or perhapse to show z scores
vsZ=zScoreVS(vs); %standardize channels to avoid bias to medial vs.
powZ=mean(vsZ'.^2);
vsSlice2afni(allInd,powZ','oddZ');

grid2t(grid);
cd ..
!SAMwts -r oddball -d c,rfhp0.1Hz -m allTrials -c Alla -t pnt.txt -v
cd oddball/SAM;
wtsNoSuf='pnt.txt';
[SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts');
filter=wts2filter(ActWgts,sourceGlobal.inside,size(sourceGlobal.outside,1));

sourceTest=OBbeamform(data,timewin,'SAM',MRIcr,filter)
sourceTest=OBbeamform(data,timewin,'sam',MRIcr)
sourceTest=OBbeamform(dataavg,timewin,'sam',MRIcr)