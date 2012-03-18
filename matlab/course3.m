%% real work now
% 
% here we work with somatosensory stimulation data

% first check the trigger channel
trig=readTrig_BIU('c,rfhp0.1Hz');
trig=clearTrig(trig);
unique(trig)


% read raw data


fileName='c,rfhp0.1Hz';
cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.1;
cfg.trialdef.poststim=0.3;
cfg.trialdef.offset=-0.1;
cfg.trialfun='BIUtrialfun';
cfg.trialdef.eventvalue= 104; %left index finger
cfg1=ft_definetrial(cfg);
raw=ft_preprocessing(cfg1);
% averaging
rawAvg=ft_timelockanalysis([],raw);
%% read data with baseline correction
cfg1.demean='yes';% old version was: cfg1.blc='yes';
cfg1.baselinewindow=[-0.1,0];
blc=ft_preprocessing(cfg1);
% averaging
blcAvg=ft_timelockanalysis([],blc);
% plot one channel to see the blc effect
cfg3.channel='A70';
ft_singleplotER(cfg3,blcAvg,rawAvg);
% now make an interactive multiplot and look for the evoked response
cfg4.layout='4D248.lay';
cfg4.interactive='yes';
cfg4.zlim=[-2e-13 2e-13];
ft_multiplotER(cfg4,blcAvg)


%% run the following commands to clean the heartbeat of the first 30s of the data

fileName = 'c,rfhp0.1Hz';
p=pdf4D(fileName);
cleanCoefs = createCleanFile(p, fileName,'byLF',256,'HeartBeat',[],'CleanPartOnly',[0 30]);  

%% DO NOT RUN IT NOW, this takes time.
cleanCoefs = createCleanFile(p, fileName,...
    'byLF',256 ,'Method','Adaptive',...
    'xClean',[4,5,6],...
    'byFFT',0,...
    'HeartBeat',[],...
    'maskTrigBits', 512);

%% now let's compare averages of cleaned (hb_*) and raw data.

% this is a do it yourself part.
% open a new script
% copy parts from this script to a new one

% give up? open answer1 and run it's content.

%% component analysis
% another cleaning method is good for HB and also for blinks, ICA.
% pca may also work for large artifacts such as HB.

cfgc            = [];
cfgc.method='pca';
cfgc.channel = 'MEG';
comp           = ft_componentanalysis(cfgc, blc);

% now view the components
cfgb=[];
cfgb.layout='4D248.lay';
cfgb.channel = {comp.label{1:5}};
comppic=ft_databrowser(cfgb,comp);

% ICA is more reliable but takes a lot of time. fatsica is also better than
% pca. to make it faster still we downsample the data from ~1000 samples 
% per seconds to 300.
cfgds            = [];
cfgds.resamplefs = 300;
cfgds.detrend    = 'no';
dummy           = ft_resampledata(cfgds, blc);


cfgc            = [];
cfgc.channel    = {'MEG'};
cfgc.method='fastica';
comp_dummy           = ft_componentanalysis(cfgc, dummy);

%see the components and find the artifact
cfgb=[];
cfgb.layout='4D248.lay';
cfgb.channel = {comp.label{1:5}};
comppic=ft_databrowser(cfgb,comp_dummy);
% see the ica components. 
% look for heartbeat. it repeats almost every trial.
% look also for blinks. there is a little at trial 4 and also at 37.
% remember the numbers of the bad components

%run the ICA in the original data
cfg = [];
cfg.topo      = comp_dummy.topo;
cfg.topolabel = comp_dummy.topolabel;
comp     = ft_componentanalysis(cfg, blc);


% set the bad coms as the value for cfgrc.component.
cfgrc = [];
cfgrc.component = [3 7]; % change
dataica = ft_rejectcomponent(cfgrc, comp);

%% base line correction again
dataica=correctBL(dataica,[-0.1 0]);


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

cfg4.layout='4D248.lay';
cfg4.interactive='yes';
cfg4.zlim=[-2e-13 2e-13];
ft_multiplotER(cfg4,blcAvg,clnAvg)


