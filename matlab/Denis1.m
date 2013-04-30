cd /home/yuval/Copy/social_motor_study/204707
%% clean the heartbeat
FN='c,rfDC';
p=pdf4D(FN);
cleanCoefs = createCleanFile_fhb(p, FN,...
'byLF',0 ,...
'xClean',0,...
'chans2ignore',204,...
'byFFT',0,...
'HeartBeat',[])

%% make trl list
FN=['hb_',FN];
trialSamps=importdata('204707_conditions.csv');
samps=trialSamps.data(:,1);
samps(161:320,1)=trialSamps.data(:,2);
trl=samps-203; % 203 is baseline of 300ms
trl(:,2)=trl+678;
trl(:,3)=-203;
%% read raw data
cfg=[];
cfg.dataset=FN;
cfg.trl=trl;
cfg.bpfreq=[1 40];
cfg.bpfilter='yes';
cfg.demean='yes';
cfg.baselinewindow=[-0.2 0];
data=ft_preprocessing(cfg);
data.trialinfo(1:160,1)=1; % 1=con 2=inc
data.trialinfo(161:320,1)=2;
%% remove muscle artifact trials
cfg=[];
cfg.method='summary';
cfg.channel='MEG';
cfg.alim=1e-12;
cfg.hpfilter='yes';
cfg.hpfreq=60;
dataNoMscl=ft_rejectvisual(cfg, data);

%% remove blinks
cfg=[];
cfg.method='pca';
comp          = ft_componentanalysis(cfg, dataNoMscl);
cfg=[];
cfg.layout='4D248.lay';
cfg.channel = 1:5;
ft_databrowser(cfg,comp);

cfg = [];
cfg.component = 1; % change
dataPCA = ft_rejectcomponent(cfg, comp);
cfg=[];
cfg.demean='yes';
cfg.baselinewindow=[-0.1 0];
dataPCA=ft_preprocessing(cfg,dataPCA);
%% reject some other noisy trials
cfg=[];
cfg.method='summary';
cfg.channel='MEG';
cfg.alim=1e-12;
dataCln=ft_rejectvisual(cfg, dataPCA);
save dataCln dataCln
%% average
cfg=[];
cfg.trials=find(dataCln.trialinfo==1);
con=ft_timelockanalysis(cfg,dataCln);
cfg.trials=find(dataCln.trialinfo==2);
inc=ft_timelockanalysis(cfg,dataCln);
save con con
save inc inc
cfg=[];
cfg.xlim = [170 170];
cfg.layout       = '4D248.lay';
cfg.interactive='yes';
ft_topoplotER(cfg, con,inc);

%% make MarkerFile.mrk
samps=dataCln.sampleinfo;
samps=(samps+203)/678.17;
contrig=samps(find(dataCln.trialinfo==1));
inctrig=samps(find(dataCln.trialinfo==2));
all=samps(find(dataCln.trialinfo));
trig2mark('congruent',contrig','incongruent',inctrig','All',all');
%% making param file (one for all subjects)
createPARAM('AllTrials','SPM','All',[0.15 0.3],[],[],[3 35],[-0.1 0.7],'Pseudo-Z',0.5,'MultiSphere','Power',[60 90]);
% change the box size to fit Denis tilt
%% global wts
cd /home/yuval/Copy/social_motor_study
!~/bin/SAMcov64 -r 204707 -d hb_c,rfDC -m AllTrials -v
!~/bin/SAMwts64 -r 204707 -d hb_c,rfDC -m AllTrials -c Alla -v
cd 204707
covDir='/home/yuval/Copy/social_motor_study/204707/SAM/AllTrials,3-35Hz';
wtsFile='/home/yuval/Copy/social_motor_study/204707/SAM/AllTrials,3-35Hz,Alla.wts';
normWts(covDir,wtsFile);

[SAMHeader, ActIndex, ActWgts]=readWeights(wtsFile);
boxSize=[...
SAMHeader.XStart SAMHeader.XEnd ...
SAMHeader.YStart SAMHeader.YEnd ...
SAMHeader.ZStart SAMHeader.ZEnd];

% fix when normWts gets stuch
load ('/home/yuval/Copy/social_motor_study/204707/SAM/AllTrials,3-35Hz/NoiseCovWts.mat')
cfg=[];
cfg.step=5;
cfg.boxSize=1000*boxSize;
cfg.prefix='NoiseCovWts';
VS2Brik(cfg,ns);

%% make images
wtsFile='/home/yuval/Copy/social_motor_study/204707/SAM/AllTrials,3-35Hz,Alla.wts';
[SAMHeader, ~, ActWgts]=readWeights(wtsFile);
boxSize=[...
SAMHeader.XStart SAMHeader.XEnd ...
SAMHeader.YStart SAMHeader.YEnd ...
SAMHeader.ZStart SAMHeader.ZEnd];

load /home/yuval/Copy/social_motor_study/204707/con
load /home/yuval/Copy/social_motor_study/204707/inc
incVS=ActWgts*inc.avg;
conVS=ActWgts*con.avg;
time=[0.15 0.3];
samp=[nearest(inc.time,time(1)),nearest(inc.time,time(2))];
inc250=mean((incVS(:,samp(1):samp(2))).^2,2);
con250=mean((conVS(:,samp(1):samp(2))).^2,2);

cd /home/yuval/Copy/social_motor_study/204707
cfg=[];
cfg.step=5;
cfg.boxSize=1000*boxSize;
cfg.prefix='con250';
VS2Brik(cfg,con250);
cfg.prefix='inc250';
VS2Brik(cfg,inc250);


ns=ActWgts;
ns=ns-repmat(mean(ns,2),1,size(ns,2));
ns=ns.*ns;
ns=mean(ns,2);




