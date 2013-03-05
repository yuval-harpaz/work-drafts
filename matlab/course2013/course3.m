%% cleanMEG repository, createCleanFile function.
% The function can clean different artifacts. 
% It can clean the the heartbeat but sometimes fails.
% It can clean the electricity artifact without filter, allowing measurment of
% 50Hz brain activity. We have markers on the trigger channel for the 50Hz
% sycles recorded from the wall, trigger value 256.
% It can clean building vibrations by our accelerometer channels X4 X5 and
% X6
% It can do some agressive cleaning in the frequency domain (byFFT option)
% The first example cleans only a part of the data (30s) to save time.
% The second example 

%% cleaning 30 seconds
cd somsens
% cleaning the directory before starting
if exist('tryCleanOP.mat','file')
    !rm tryCleanOP.mat
end
if exist('hb,lf_c,rfhp0.1Hz','file')
    !rm hb,lf_c,rfhp0.1Hz
end
% cleaning
fileName = 'c,rfhp0.1Hz';
p=pdf4D(fileName);
cleanCoefs = createCleanFile(p, fileName,'byLF',256,'HeartBeat',[],'CleanPartOnly',[0 30]);  
title('First 100s of the data after averaging all MEG channels together')
%% Cleaning the whole data
% This is a more standard example. 
% this takes time.

% cleanCoefs = createCleanFile(p, fileName,...
%     'byLF',256 ,'Method','Adaptive',...
%     'xClean',[4,5,6],...
%     'byFFT',0,...
%     'HeartBeat',[],...
%     'maskTrigBits', 512);




%% The trigger channel
% The trigger channel is a digital channel recorded simultaneously with the MEG.
% It has information about 50Hz cycles but also about the onset of visual stimuli (value 2048)
% and the timing of events (trials) of different sorts like left and right
% somatosensory stimulation.
% The first thing to happen in this data is 2 minutes rest with eyes open and two minutes eyes closed.
% These are marked by the trigger values 90 and 92.
% The 50Hz is recorded twice here which makes the trigger channel rise in
% 256 and 512 every 20ms (and often both up to 768).

% first read the trigger channel
trig=readTrig_BIU('c,rfhp0.1Hz');
% now we are getting rid of the 50Hz markers by making a clear trigger
% chanel  - trigCl.
trigCl=clearTrig(trig);
xlim([28000 29000])
legend ('original trigger','cleared trigger')
title('REST')
% first lets see what different trigger values exist. 
unique(trigCl)
% 90 - the first rest, 92 - second rest. 102 - right index finger. 104 -
% left index finger. 222 230 240 and 250 are different visual stimuli. 50,
% 52 and 54 are in the end of the experiment, they are, they, I forgot what they are.

% now look at one second of the somatosensory experiment.

trigCl=clearTrig(trig);
xlim([400000 401017]);
legend ('original trigger','cleared trigger')
title('SOMATOSENSORY')
% now one visual trial

trigCl=clearTrig(trig);
xlim([500000 501017])
legend ('original trigger','cleared trigger')
title('VISUAL')


%% read raw data
% Trigger value 104 marks left index finger stimulation.
% We use a trial function called BIUtrialfun to tell fieldtrip how to read
% our trigger channel while ignoring 256, consider visual trigger and so on.
% We read 0.3s after the finger press and 0.1s before.
% ft_definetrial only checks the trigger channel. ft_preprocessing actually
% reads the data. here no real preprocessing is done, no baseline
% correction or filters applied.

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
cfg1.feedback='no';
raw=ft_preprocessing(cfg1);
% averaging
cfg=[];
cfg.feedback='no';
rawAvg=ft_timelockanalysis(cfg,raw);
%plotting
cfg4.layout='4D248.lay';
cfg4.interactive='yes';
cfg4.ylim=[-2e-13 2e-13];
fig1=figure;
set(fig1,'Position',[0,0,800,800])
ft_multiplotER(cfg4,rawAvg);
title ('Averaged data with no BL correction')
% some channels are off the image leaving a streight line over or below.
% even 'OK' channels are sometimes all below or above zero.
%% read data with baseline correction
cfg1.demean='yes';% old version was: cfg1.blc='yes';
cfg1.baselinewindow=[-0.1,0];
blc=ft_preprocessing(cfg1);
% averaging
blcAvg=ft_timelockanalysis(cfg,blc);
% now make an interactive multiplot and look for the evoked response
fig2=figure;
set(fig2,'Position',[0,0,800,800])
ft_multiplotER(cfg4,blcAvg);
title ('Averaged data with BL correction')
% click and drag to choose channels


