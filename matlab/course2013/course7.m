%% SAM beamforming

cd oddball


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
cfg2.bpfreq=[1 40];
cfg2.channel={'MEG'};%,'MEGREF'};
data=ft_preprocessing(cfg2);




%reject some trials
cfg=[];
cfg.method='summary';
cfg.channel='MEG';
cfg.alim=1e-12;
data=ft_rejectvisual(cfg, data); 
% average standard
cfg=[];
cfg.latency=[-0.1 0.6];
cfg.trials=find(data.trialinfo==128);
%cfg4.channel='MEG';
standard=ft_timelockanalysis(cfg,data);
% choose time of interest
cfg=[];
cfg.interactive='yes';
cfg.layout='4D248.lay';
cfg.zlim=[-5e-14 5e-14];
figure;
ft_multiplotER(cfg,standard);

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


hs2afni('small');

% to see the headshape on top of the MRI:
hdsh=ft_read_mri('hds+orig.BRIK');
hs_points=hdsh.anatomy>0;
mri=ft_read_mri('warped+orig.BRIK');
mri.anatomy=mri.anatomy+hs_points;
cfg=[];
cfg.interactive='yes';
figure, ft_sourceplot(cfg,mri);
% see that the headshape fits the MRI with AFNI
% if you have to nudge this is the time.

% for Nolte model proceed to these steps
!~/abin/3dSkullStrip -input warped+orig -prefix mask -mask_vol -skulls -o_ply ortho
!meshnorm ortho_brainhull.ply > hull.shape

%% SAMerf, evoked activity
% create a param file, copy the real time weights (rtw) used online to clean the data
% and run SAMcov, SAMwts and SAMerf
cd ..
createPARAM('allTrials','ERF','All',toi,'All',[(toi(1)-toi(2)) 0],[1 40],[-0.1 0.5],[],[],'MultiSphere');

if ~exist('oddball/oddball.rtw','file')
    !cp ~/SAM_BIU/docs/SuDi0811.rtw oddball/oddball.rtw
end
% to run SAM you have to be one folder above the data
if ~ exist('oddball/allTrials,Trig-All,43-75ms,1-40Hz,ERF.svl','file')
    !SAMcov -r oddball -d c,rfhp0.1Hz -m allTrials -v
    !SAMwts -r oddball -d c,rfhp0.1Hz -m allTrials -c Alla -v
    !SAMerf -r oddball -d c,rfhp0.1Hz -m allTrials -v -z 3
    !cp oddball/SAM/*svl oddball/
end

% now see the image in afni
!~/abin/afni -dset warped+orig &

%% SAMspm, induced activity
%SAMspm didn't work in this example, don't know why.

% createPARAM('allinduced','SPM','All',toi,'All',[(toi(1)-toi(2)) 0],[1 40],[-0.1 0.5],[],[],'MultiSphere');
% !SAMcov -r oddball -d c,rfhp0.1Hz -m allinduced -v
% !SAMwts -r oddball -d c,rfhp0.1Hz -m allinduced -c Alla -v
% !SAMspm -r oddball -d c,rfhp0.1Hz -m allinduced -v

%% read the weights and compute images by yourself
cd oddball;
wtsNoSuf='SAM/allTrials,1-40Hz,Alla';
if exist([wtsNoSuf,'.mat'],'file')
    load ([wtsNoSuf,'.mat'])
else
    [SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
    save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts'); %save in mat format, quicker to read later.
end
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

%% Use AFNI MATLAB library to make images from virtual sensorsvsMovies

% estimate noise
ns=ActWgts;
ns=ns-repmat(mean(ns,2),1,size(ns,2));
ns=ns.*ns;
ns=mean(ns,2);

% get toi mean square (different than SAMerf, no BL correction)
samples=[nearest(oddball.time,toi(1)),nearest(oddball.time,toi(2))];
vsSt=ActWgts*standard.avg(:,samples(1):samples(2));
vsStMS=mean(vsSt.*vsSt,2)./ns;
vsStMS=vsStMS./max(vsStMS); %scale
%make image 3D of mean square (MS, power)
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='StMS';
VS2Brik(cfg,vsStMS);

% Make a power movie of the whole trial
vsStS=(ActWgts*standard.avg).*(ActWgts*standard.avg);
ns=repmat(ns,1,size(vsStS,2));
vsStS=vsStS./ns;
vsStS=vsStS./max(max(max(vsStS)));

cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='StS';
cfg.torig=-200;
cfg.TR=1/1.017;
VS2Brik(cfg,vsStS);


% SAMspm
ns=ActWgts;
ns=ns-repmat(mean(ns,2),1,size(ns,2));
ns=ns.*ns;
ns=mean(ns,2);
spm=zeros(size(ActWgts,1),1);
tri=find(data.trialinfo==128);
for triali=tri'
        vs=ActWgts*data.trial{1,triali}(:,samples(1):samples(2));
        vs=vs-repmat(mean(vs,2),1,size(vs,2));
        pow=vs.*vs;
        pow=mean(pow,2);
        pow=pow./ns;
        spm=spm+pow;
        display(['trial ',num2str(triali)])
end
spm=spm./length(tri);
cfg=[];
%cfg.func='~/vsMovies/Data/funcTemp+orig';
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='StSPM';
VS2Brik(cfg,spm);

spmN=zeros(size(ActWgts,1),1);
tri=find(data.trialinfo==128);
for triali=tri'
        vs=ActWgts*data.trial{1,triali}(:,1:samples(1)-1);
        vs=vs-repmat(mean(vs,2),1,size(vs,2));
        pow=vs.*vs;
        pow=mean(pow,2);
        pow=pow./ns;
        spmN=spmN+pow;
        display(['trial ',num2str(triali)])
end
spmN=spmN./length(tri);
NAI=(spm-spmN)./spmN;
cfg=[];
%cfg.func='~/vsMovies/Data/funcTemp+orig';
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='StSPMnai';
VS2Brik(cfg,NAI);



cfg=[];
%cfg.func='~/vsMovies/Data/funcTemp+orig';
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='StSPM';
VS2Brik(cfg,spm);
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