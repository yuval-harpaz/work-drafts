% here we work with "tutorial for begginers". find it in ~/work-drafts/docs
% the functions are in ft_BIU repository (fieldtrip)

% take a look at all the channels at the beginning of the file just to see
% that it is sane and whether there are bad channels.
% four figures will open.
findBadChans('c,rfhp0.1Hz');
% see the heartbeat artifact and try to find it in the cleaned file
% xc,hb,lf_c,*

% with the following function you don't see all the channels but it squeezes into
% one figure. you have to choose the time of interest in seconds.
% the oddball data has muscle artifact around 30s.
tracePlot_BIU(20,40,'c,rfhp0.1Hz');

% to detect eyeblinks best see the topography. for this we have to read
% the data with fieldtrip.

%% FieldTrip .

% most fieldtrip functions require a configuration structure (cfg) and data
% as input. we begin by defining trials. for now we just want to read some
% 10 sec of continuous data. the function ft_definetrial will use for this purpose 
% our trialfun_raw function. here is how it works.

cfg.dataset='c,rfhp0.1Hz';
cfg.trialdef.beginning=25;
cfg.trialdef.end=26;
cfg.trialfun='trialfun_raw';
cfg1=ft_definetrial(cfg);
% take a look at cfg1.trl where the trial is defined in samples rather than
% second. cfg1 will be the configuration structure for the next function
% which actually reads the data. we add fields to it to specify filters,
% baseline correction and other options.

cfg1.channel='MEG'; % only reads MEG channels
cfg1.bpfilter='yes'; % bandpass filter
cfg1.bpfreq=[1 90]; % bandpass frequencies
cfg1.blc='yes'; % removes the mean value of each channel
data=ft_preprocessing(cfg1);

% the timeline is in data.time{1,1}. the data is in data.trial{1,1}. you can plot it simply by
plot(data.time{1,1},data.trial{1,1}); % all the channels are super imposed.
% or plot one channel (channel number one, see data.label for it's name)
plot(data.time{1,1},data.trial{1,1}(1,:));

% let's see the data in alpha frequency
hold on
cfg1.bpfreq=[8 13];
alpha=ft_preprocessing(cfg1);
plot(alpha.time{1,1},alpha.trial{1,1}(1,:),'r');

% now 1 to 90Hz but no baseline correction
cfg1.bpfreq=[1 90]; % as before
cfg1.blc='no';
noBLC=ft_preprocessing(cfg1);
plot(noBLC.time{1,1},noBLC.trial{1,1}(1,:),'g');

% a function to visualize data trial by trial
trialPlot(data) % beware, a feature designed for topoplots my get out of hand when clicking on the traces. use alt+F4 on emergencies to close figures.

% more suffisticated functions to view the data are ft_multiplotER
% ft_topoplotER and ft_singleplotER, designed for averaged data. here we
% will average the data across trials (only one trial) for the functions to
% work.
data=ft_timelockanalysis([],data);

% here is a time point with a blink
cfg2=[];
cfg2.layout='4D248.lay';
cfg2.interactive='yes';
cfg2.xlim=[25.7 25.7];
ft_topoplotER(cfg2,data)





