% the purpose of this script is to get you familiared with different
% artifacts and how to detect them using home made functions and FieldTrip.
% later we will use fieldtrip to see "evoked" brain signal. for this we
% have to be aware of different preprocessing tecniques such as filters and
% base line correction.


% here we work with "tutorial for begginers". find it in ~/work-drafts/docs
% the functions are in ft_BIU repository (fieldtrip)

%% View the raw data
% cd to oddball data

% take a look at all the channels at the beginning of the file just to see
% that it is sane and whether there are bad channels.
% four figures will open.
findBadChans('c,rfhp0.1Hz');
% see the heartbeat artifact and try to find it in the cleaned file
% xc,hb,lf_c,*
% do it yourself, copy the script line above (line9) to the command window,
% change the name of the file and ENTER


% with the following function you don't see all the channels (shows every
% fourth channel) 
% but it squeezes into one figure. you have to choose the time of interest in seconds.
% the oddball data has muscle artifact around 30s.
tracePlot_BIU(25,35,'c,rfhp0.1Hz');


% to detect eyeblinks best see the topography. for this we have to read
% the data with fieldtrip.

%% View the raw data with FieldTrip .

% cd to somatosensory data

% most fieldtrip functions require a configuration structure (cfg) and data
% as input. we begin by defining trials. for now we just want to read some
% 10 sec of continuous data. the function ft_definetrial will use for this purpose 
% our trialfun_raw function. here is how it works.

cfg.dataset='c,rfhp0.1Hz';
cfg.trialdef.beginning=25;
cfg.trialdef.end=26;
cfg.trialfun='trialfun_raw'; % the other usefull trialfun we have are trialfun_beg and trialfun_BIU
cfg1=ft_definetrial(cfg);

% take a look at cfg1.trl where the trial is defined in samples rather than
% seconds. cfg1 will be the configuration structure for the next function
% which actually reads the data. we add fields to it to specify filters,
% baseline correction and other options. fist let's just read unprocessed
% data of one channel, say A70.


cfg1.channel='A70'; % 'MEG' for all MEG channels. {'MEG' 'MEGREF' '-A204'} will read meg channels, refference channels but not channel A204.
data=ft_preprocessing(cfg1);
% let's plot it
plot(data.time{1,1},data.trial{1,1});

%% Preprocessing- How filters change the pictures

% we want to overlay more plots on the same figure so we want to hold it
% on. otherwise new figures will erase the old ones.
hold on
% now we'll see a few filters. to see high frequencies we'll use highpass
% filter. we'll add fields to the same cfg we used before.

cfg1.hpfilter='yes';
cfg1.hpfreq=30;
high=ft_preprocessing(cfg1);
plot(data.time{1,1},high.trial{1,1},'r');

% now lowpass filter
cfg1.hpfilter='no';
cfg1.lpfilter='yes';
cfg1.lpfreq=8;
low=ft_preprocessing(cfg1);
plot(data.time{1,1},low.trial{1,1},'g');

% now bandpass filter for the in between freq.
cfg1.lpfilter='no';
cfg1.bpfilter='yes';
cfg1.bpfreq=[8 30];
mid=ft_preprocessing(cfg1);
plot(data.time{1,1},mid.trial{1,1},'k');

% add a legend
legend('all','over 30Hz','below 8Hz','8-30Hz')

%% Preprocessing - Baseline correction
% now we want all the MEG channels between 1 and 40Hz.

%close the figures
close all

%let's start with new cfg1 as before
cfg1=ft_definetrial(cfg);
cfg1.channel='MEG'; % only reads MEG channels
cfg1.lpfilter='yes';
cfg1.lpfreq=[1 40]; % bandpass frequencies
data=ft_preprocessing(cfg1);

% the timeline is in data.time{1,1}. the data is in data.trial{1,1}. you can plot it simply by
plot(data.time{1,1},data.trial{1,1}); % all the channels are super imposed.
% or plot one channel (channel number one, see data.label for it's name)
plot(data.time{1,1},data.trial{1,1}(1,:));


hold on
% now 1 to 90Hz but with baseline correction
cfg1.blc='yes';
BLC=ft_preprocessing(cfg1);
plot(BLC.time{1,1},BLC.trial{1,1}(1,:),'g');

%% View the epoched data.
close all
% a function to visualize data trial by trial
trialPlot(BLC) % beware, a feature designed for topoplots my get out of hand when clicking on the traces. use alt+F4 on emergencies to close figures.


close all
% more suffisticated functions to view the data are ft_multiplotER
% ft_topoplotER and ft_singleplotER, designed for averaged data. here we
% will average the data across trials (only one trial) for the functions to
% work, not that it does any averaging.
data=ft_timelockanalysis([],data);

% here is a time point with a blink
cfg2=[];
cfg2.layout='4D248.lay';
cfg2.interactive='yes';
cfg2.xlim=[25.7 25.7];
cfg2.electrodes = 'labels';
ft_topoplotER(cfg2,data)

% mark an area on the plot and click in the middle