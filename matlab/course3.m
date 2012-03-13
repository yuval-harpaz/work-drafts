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
cfg1=definetrial(cfg);
raw=ft_preprocessing(cfg1);
% averaging
rawAvg=ft_timelockanalysis([],raw);
%% read data with baseline correction
cfg1.blc='yes';
cfg1.blcwindow=[-0.1,0];
blc=ft_preprocessing(cfg1);
% averaging
blcAvg=ft_timelockanalysis([],blc);
% plot one channel to see the blc effect
cfg3.channel='A70';
ft_singleplotER(cfg3,blcAvg,rawAvg);
% now make an interactive multiplot and look for the evoked response
cfg4.layout='4D248.lay';
cfg4.interactive='yes';
ft_multiplotER(cfg4,blcAvg)


%% run the following commands to clean the heartbeat of the first 30s of the data

fileName = 'c,rfhp0.1Hz';
p=pdf4D(fileName);
cleanCoefs = createCleanFile(p, fileName,'byLF',0,'HeartBeat',[],'CleanPartOnly',[0 30]);  

%% DO NOT RUN IT NOW, this takes time.
cleanCoefs = createCleanFile(p, fileName,...
    'byLF',256 ,'Method','Adaptive',...
    'xClean',[4,5,6],...
    'byFFT',0,...
    'HeartBeat',[],...
    'maskTrigBits', 512);

%% now let's compare averages of cleaned and raw data.

% this is a do it yourself part.
% copy parts from this script to a new one


