% the purpose of this script is to get you familiared with different
% artifacts and how to detect them using home made functions and FieldTrip.
% later we will use fieldtrip to see "evoked" brain signal. for this we
% have to be aware of different preprocessing tecniques such as filters and
% base line correction.


% here we work with "tutorial for begginers". find it in ~/work-drafts/docs
% the functions are in ft_BIU repository (fieldtrip)

%% View the raw data - all channels, first 10sec
% cd to oddball data

% take a look at all the channels at the beginning of the file just to see
% that it is sane and whether there are bad channels.
% four figures will open.
findBadChans('c,rfhp0.1Hz');
% see the heartbeat artifact and try to find it in the cleaned file
% xc,hb,lf_c,*
% do it yourself, copy the script line above (line9) to the command window,
% change the name of the file and ENTER

%% View the raw data - every 4th channel, a selected time window
% with the following function you don't see all the channels (shows every
% fourth channel) 
% but it squeezes into one figure. you have to choose the time of interest in seconds.
% the oddball data has muscle artifact around 30s.
tracePlot_BIU(25,35,'c,rfhp0.1Hz');


% to detect eyeblinks best see the topography. for this we have to read
% the data with fieldtrip.

%% View the raw data with FieldTrip .

% cd to somatosensory data
cd ../somsens
% most fieldtrip functions require a configuration structure (cfg) and data
% as input. we begin by defining trials. for now we just want to read some
% 1sec of continuous data. the function ft_definetrial will use for this purpose 
% our trialfun_raw function. here is how it works.
time=[25 26];
samples=round(1017.25*time);
cfg=[];
cfg.dataset='c,rfhp0.1Hz';
cfg.trl=[samples,0];
cfg.channel='A70';
data=ft_preprocessing(cfg);
% let's plot it
figure;
plot(data.time{1,1},data.trial{1,1});
xlim([0,1])
%% Preprocessing- How filters change the pictures

% we want to overlay more plots on the same figure so we want to hold it
% on. otherwise new figures will erase the old ones.
hold on
% now we'll see a few filters. to see high frequencies we'll use highpass
% filter. we'll add fields to the same cfg we used before.

cfg.hpfilter='yes';
cfg.hpfreq=30;
high=ft_preprocessing(cfg);
plot(data.time{1,1},high.trial{1,1},'r');

% now lowpass filter
cfg.hpfilter='no';
cfg.lpfilter='yes';
cfg.lpfreq=8;
low=ft_preprocessing(cfg);
plot(data.time{1,1},low.trial{1,1},'g');

% now bandpass filter for the in between freq.
cfg.lpfilter='no';
cfg.bpfilter='yes';
cfg.bpfreq=[8 30];
mid=ft_preprocessing(cfg);
plot(data.time{1,1},mid.trial{1,1},'k');

% add a legend
legend('all','over 30Hz','below 8Hz','8-30Hz')

%% Preprocessing - Baseline correction
% now we want all the MEG channels between 1 and 40Hz.

%let's start with new cfg1 as before

cfg.channel='MEG'; % only reads MEG channels
cfg.bpfilter='no';
cfg.lpfilter='yes';
cfg.lpfreq=[1 40]; % bandpass frequencies
data=ft_preprocessing(cfg);

% the timeline is in data.time{1,1}. the data is in data.trial{1,1}. you can plot it simply by
plot(data.time{1,1},data.trial{1,1}); % all the channels are super imposed.
% or plot one channel (channel number one, see data.label for it's name)
figure;
plot(data.time{1,1},data.trial{1,1}(1,:));


hold on
cfg.blc='yes'; % now with baseline correction
BLC=ft_preprocessing(cfg);
plot(BLC.time{1,1},BLC.trial{1,1}(1,:),'g');
close all
%% View the epoched data.

% a function to visualize data trial by trial
% beware, a feature designed for topoplots my get out of hand when clicking on the traces. use alt+F4 on emergencies to close figures.
trialPlot(BLC) 

%% FieldTrip plots
% more suffisticated functions to view the data are ft_multiplotER
% ft_topoplotER and ft_singleplotER, designed for averaged data. here we
% will average the data across trials (only one trial) for the functions to
% work, not that it does any averaging.
% here is a time point with a blink. It is interactive, mark an area on the plot and click in the middle
data=ft_timelockanalysis([],data);
cfg2=[];
cfg2.layout='4D248.lay';
cfg2.interactive='yes';
cfg2.xlim=[25.7 25.7];
cfg2.marker = 'labels';
figure;
ft_topoplotER(cfg2,data)
