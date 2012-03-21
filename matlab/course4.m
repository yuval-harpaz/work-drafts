%% component analysis
% cd to somsens

% another cleaning method is good for HB and also for blinks is ICA.
% pca may also work for large artifacts such as HB.
% first let's read the visual data.

fileName='c,rfhp0.1Hz'; % we read an uncleaned file so we can see HB as a component.
cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.1;
cfg.trialdef.poststim=0.5;
cfg.trialdef.offset=-0.1;
cfg.trialdef.visualtrig= 'visafter';
cfg.trialfun='BIUtrialfun';
cfg.trialdef.eventvalue=  [222 230 240 250]; %left index finger
cfg1=ft_definetrial(cfg);
cfg1.demean='yes';% old version was: cfg1.blc='yes';
cfg1.baselinewindow=[-0.1,0];
cfg1.bpfilter='yes';
cfg1.bpfreq=[1 40];
cfg1.channel='MEG';
dataorig=ft_preprocessing(cfg1);
% averaging

avg=ft_timelockanalysis([],dataorig);

cfgmp=[]
cfgmp.layout='4D248.lay';
cfgmp.interactive='yes';
ft_multiplotER(cfgmp,avg);
%% component analysis 
% ICA takes a lot of time. 
% pca is faster but (ask me in class).

cfgc            = [];
cfgc.method='pca';
cfgc.numcomponent=20;
comp           = ft_componentanalysis(cfgc, dataorig);

%see the components and find the artifact
cfgb=[];
cfgb.layout='4D248.lay';
cfgb.channel = {comp.label{1:5}};
comppic=ft_databrowser(cfgb,comp);
% see the ica components. 
% look for heartbeat. it repeats almost every trial. remember it's number.
cfgrc = [];
cfgrc.component = 1; % change
dataica = ft_rejectcomponent(cfgrc, comp);

%% component analysis on raw data
% we have eye movement block in the end of the experiment
% where is trig=50?
trig=readTrig_BIU('c,rfhp0.1Hz');
trig=clearTrig(trig);

startt=find(trig==50,1)/1017.25;
endt=find(trig==52,1)/1017.25;
cfg=[];
cfg.dataset='c,rfhp0.1Hz';
cfg.trialdef.beginning=startt;
cfg.trialdef.end=endt;
cfg.trialfun='trialfun_raw'; % the other usefull trialfun we have are trialfun_beg and trialfun_BIU
cfg1=ft_definetrial(cfg);
cfg1.demean='yes';% old version was: cfg1.blc='yes';
cfg1.baselinewindow=[-0.1,0];
cfg1.lpfilter='yes';
cfg1.lpfreq=40;
cfg1.channel='MEG';
MOG=ft_preprocessing(cfg1);
% lets view the raw data for one channel
cfgb=[];
cfgb.layout='4D248.lay';
cfgb.continuous='yes';
cfgb.event.type='';
cfgb.event.sample=1;
cfgb.blocksize=3;
cfgb.channel='A248';
comppic=ft_databrowser(cfgb,MOG);
%% PCA
cfgp=[];
cfgc.method='pca';
compMOG           = ft_componentanalysis(cfgc, MOG);
% see the components and find the HB and MOG artifact
% remember the numbers of the bad components and close the data browser
cfgb=[];
cfgb.layout='4D248.lay';
cfgb.channel = {comp.label{1:5}};
cfgb.continuous='yes';
cfgb.event.type='';
cfgb.event.sample=1;
cfgb.blocksize=3;
comppic=ft_databrowser(cfgb,compMOG);

% set the bad comps as the value for cfgrc.component.
cfgrc = [];
cfgrc.component = [1 2]; % change
dataica = ft_rejectcomponent(cfgrc, compMOG,dataorig);


%% reject visual trial by trial
cfg=[];
cfg.method='trial'; %trial
cfg.channel='MEG';
cfg.alim=1e-12;
datacln=ft_rejectvisual(cfg, dataica);

% reject visual by variance
cfg=[];
cfg.method='summary'; %trial
cfg.channel='MEG';
cfg.alim=1e-12;
datacln=ft_rejectvisual(cfg, dataica);


clnAvg=ft_timelockanalysis([],datacln);
cfgmp=[]
cfgmp.layout='4D248.lay';
cfgmp.interactive='yes';
ft_multiplotER(cfgmp,clnAvg,avg)

