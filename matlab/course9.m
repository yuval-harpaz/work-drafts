%% now to fieldtrip beamforming
% first go back to course8 and make sure you already run SAMwts with -t
% pnt.txt option.
cd oddball
load trl

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

load headmodel % it was created in course8 (and 7)
load ~/ft_BIU/matlab/files/sMRI.mat
mri_realign=sMRI;
mri_realign.transform=inv(M1)*sMRI.transform;

toi=[0.043657 0.075163];

% cov for avged data, toi only + baseline window
source=OBbeamform(stdAvg,toi,'sam',mri_realign)

% cov for whole averaged data
source=OBbeamform1(stdAvg,toi,'sam',mri_realign)

% same but with LCMV
source=OBbeamform1(stdAvg,toi,'lcmv',mri_realign)

% cov for raw data
source=OBbeamform(standard,toi,'sam',mri_realign)

% here we use the output of SAMwts as filter
% similar to cov for raw data

load('SAM/pnt.txt.mat')
filter=wts2filter(ActWgts,grid.inside,size(grid.outside,1));
sourceTest=OBbeamform(stdAvg,toi,'SAM',mri_realign,filter)

source=OBmne(stdAvg,toi,mri_realign)