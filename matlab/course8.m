cd oddball

% first we want a headmodel
% put debug points here: in headmodel_BIU at lines 119 (D.inv{1}...) and
% 131 (eval([tinpoints...). in ft_prepare_local_spheres_mm in line 195(end)
% now run
[vol,grid,mesh,M1]=headmodel_BIU([],[],[],[],'localspheres');
save headmodel vol grid mesh M1
load ~/ft_BIU/matlab/files/sMRI.mat
mri_realign=sMRI;
mri_realign.transform=inv(M1)*sMRI.transform;
grid2t(grid);

load trl
trigTime=(trl(:,1)-trl(:,3))./1017.25;
Trig2mark(...
    'All',trigTime',...
    'Standard',trigTime(find(trl(:,4)==128),1)',...
    'Oddball',trigTime(find(trl(:,4)==64),1)',...
    'Novel',trigTime(find(trl(:,4)==32),1)');

cd ..
createPARAM('allTrials','ERF','All',toi,'All',[(toi(1)-toi(2)) 0],[1 40],[-0.1 0.5],[],[],'MultiSphere');
!SAMcov -r oddball -d c,rfhp0.1Hz -m allTrials -v
!SAMwts -r oddball -d c,rfhp0.1Hz -m allTrials -c Alla -v
!SAMerf -r oddball -d c,rfhp0.1Hz -m allTrials -v

!SAMwts -r oddball -d c,rfhp0.1Hz -m allTrials -c Alla -t pnt.txt -v

cd oddball/SAM;
wtsNoSuf='pnt.txt';
[SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts');
filter=wts2filter(ActWgts,grid.inside,size(grid.outside,1));

%% now to fieldtrip beamforming

% first we need data
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
cfg2.channel={'MEG'};
data=ft_preprocessing(cfg2);
cfg4=[];
cfg4.trials=find(data.trialinfo==128);

standard=ft_preprocessing(cfg4,data);
cfg=[];
cfg.method='summary'; %trial
cfg.alim=1e-12;
standard=ft_rejectvisual(cfg, standard);

stdAvg=ft_timelockanalysis([],standard);

toi=[0.043657 0.075163];
source=OBbeamform(stdAvg,toi,'sam',mri_realign)
source=OBbeamform(stdAvg,toi,'lcmv',mri_realign)
load('SAM/pnt.txt.mat')
sourceTest=OBbeamform(stdAvg,toi,'SAM',mri_realign,filter)

sourceTest=OBbeamform(standard,toi,'sam',mri_realign)


%% messy below, don't look
 % this was calculated in course6 (auditory data)

cd oddball;
wtsNoSuf='SAM/allTrials,1-40Hz,Alla';
[SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts'); %sa
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

[vol,grid,mesh,M1]=headmodel_BIU([],[],[],[],'localspheres');
load ~/ft_BIU/matlab/files/sMRI.mat
mri_realign=sMRI;
mri_realign.transform=inv(M1)*sMRI.transform;

