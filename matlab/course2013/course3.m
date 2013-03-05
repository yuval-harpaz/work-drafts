%% real work now
%
% here we work with somatosensory stimulation data
%% cleanMEG repository, createCleanFile function.
%run the following commands to clean the heartbeat of the first 30s of the data

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
% open a figure
I = imread('~/work-drafts/docs/cleaningFig.png','png');
imshow(I);



%% the trigger channel
% ok, I was hiding something. there is more than somatosensory stimulation
% here. there is that, stimulating left and right index fingers.Then a 
% visual experiment begins where subjects press buttons to indicate whether
% pictures are painfull or not. Then somatosensory again. the first thing
% however is 2 minutes rest with eyes open and two minutes eyes closed.
% these different events are marked by the trigger channel.

% first check the trigger channel
trig=readTrig_BIU('c,rfhp0.1Hz');
plot(trig);
% the first 100s
xlim([0 170000])
%the first second of rest
xlim([28000 29000])
% messy, 50Hz power cycles are marked by values 256 and 512. 2048 marks the
% appearance of a visual stimulus on the screen. let's clear these three
% for now.
close
trigCl=clearTrig(trig);
% first lets see the possible values. 
unique(trigCl)
% 90 - the first rest, 92 - second rest. 102 - right index finger. 104 -
% left index finger. 222 230 240 and 250 are different visual stimuli. 50,
% 52 and 54 are in the end of the experiment, they are, they, I forgot.
% anyway

% now look at one second of the somatosensory experiment
xlim([400000 401017])
% now one visual trial
xlim([500000 501017])



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
cfg4.layout='4D248.lay';
cfg4.interactive='yes';
cfg4.zlim=[-2e-13 2e-13];
ft_multiplotER(cfg4,rawAvg)
%% read data with baseline correction
cfg1.demean='yes';% old version was: cfg1.blc='yes';
cfg1.baselinewindow=[-0.1,0];
blc=ft_preprocessing(cfg1);
% averaging
blcAvg=ft_timelockanalysis([],blc);
% now make an interactive multiplot and look for the evoked response
cfg4.layout='4D248.lay';
cfg4.interactive='yes';
cfg4.zlim=[-2e-13 2e-13];
ft_multiplotER(cfg4,blcAvg)



