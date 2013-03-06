%% Frequency and Time Frequency analysis
% Here we do frequency analysis to visual data.
% We first reject trials with high frequency noise (muscles).
% Next we correct MOG (eye movement artifact).
% After cleaning we perform frequency analysis and then time frequency
% analysis.
% The data we use is already after heartbeat correction.
%% reject high frequency noise trials (muscle artifact)
% here we read the data with a 60Hz high pass filter 
% we take a large window because of the sliding windows for low freqs
cd somsens

fileName='hb_c,rfhp0.1Hz';
cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.5;
cfg.trialdef.poststim=1;
cfg.trialdef.offset=-0.5; %NOTE large baseline to measure low freq
cfg.trialdef.visualtrig= 'visafter';
cfg.trialfun='BIUtrialfun';
cfg.trialdef.eventvalue= [222 230 240 250];
cfg=ft_definetrial(cfg);

cfg.demean='yes';
cfg.baselinewindow=[-0.5 0];
cfg.channel='MEG';
cfg.padding=0.1;
cfg.feedback='no';
dataorig=ft_preprocessing(cfg);

cfg=[];
cfg.method='summary';
cfg.channel='MEG';
cfg.alim=1e-12;
cfg1.hpfilter='yes';
cfg1.hpfreq=60; %SEE?
dataNoMscl=ft_rejectvisual(cfg, dataorig); % data high freq reject visual
% reject bad trials


%% clean MOG by PCA, find L-R component
% first clear some memory
clear dataorig

trig=readTrig_BIU(fileName);
trig=clearTrig(trig);
% up-down eye movement
startt=find(trig==50,1)/1017.25; %877.4451
endt=find(trig==52,1)/1017.25; %886.3406
cfg2=[];
cfg2.dataset=fileName;
cfg2.trialdef.beginning=startt;
cfg2.trialdef.end=endt;
cfg2.trialfun='trialfun_raw'; % the other usefull trialfun we have are trialfun_beg and trialfun_BIU
cfg=ft_definetrial(cfg2);
cfg.demean='yes';% old version was: cfg1.blc='yes';
%cfg1.baselinewindow=[-0.1,0];
cfg.lpfilter='yes';
cfg.lpfreq=40;
cfg.channel='MEG';
MOGud=ft_preprocessing(cfg);
% left right eye movement
startt=find(trig==52,1)/1017.25;
endt=find(trig==54,1)/1017.25;
cfg2.trialdef.beginning=startt;
cfg2.trialdef.end=endt;
cfg=ft_definetrial(cfg2);
cfg.demean='yes';% old version was: cfg1.blc='yes';
%cfg1.baselinewindow=[-0.1,0];
cfg.lpfilter='yes';
cfg.lpfreq=40;
cfg.channel='MEG';
cfg.feedback='no';
MOGlr=ft_preprocessing(cfg);

cfg=[];
cfg.method='pca';
compMOGud           = ft_componentanalysis(cfg, MOGud);
compMOGlr           = ft_componentanalysis(cfg, MOGlr);
% see the components and find the HB and MOG artifact
% remember the numbers of the bad components and close the data browser
cfg=[];
cfg.layout='4D248.lay';
cfg.channel = 1:5;
cfg.continuous='yes';
cfg.event.type='';
cfg.event.sample=1;
cfg.blocksize=3;
ft_databrowser(cfg,compMOGud);

close
%% clean MOG by PCA, find Up-Down component
ft_databrowser(cfg,compMOGlr);
% remember the component number for up-down and for left-right MOG. we'll
close
%% now you clean the data from MOG
% set the bad comps as the value for cfgrc.component.
cfg = [];
cfg.component = 1; % change
cfg.feedback='no';
dataca = ft_rejectcomponent(cfg, compMOGud,dataNoMscl);
cfg.component = 1; % change
dataca = ft_rejectcomponent(cfg, compMOGlr,dataca);
% clear the workspace a little.
clear dataNoMscl comp* MOG* trig cfg* endt startt


%% check if there are bad trials left
cfg=[];
cfg.method='summary'; %trial
cfg.channel='MEG';
cfg.alim=1e-12;
datacln=ft_rejectvisual(cfg, dataca);
clear dataca
%% frequency analysis
cfgfr=[];
%cfgfr.trials=find(datacln.trialinfo==222);
cfgfr.output       = 'pow';
cfgfr.channel      = 'MEG';
cfgfr.method       = 'mtmfft';
cfgfr.taper        = 'hanning';
cfgfr.foi          = 1:100;
cfgfr.feedback='no';
FrAll = ft_freqanalysis(cfgfr, datacln);

% plot results for alpha
cfgp = [];
cfgp.xlim = [9 11];         
cfgp.layout       = '4D248.lay';
cfgp.interactive='yes';
ft_topoplotER(cfgp, FrAll);

%% time-frequency analysis

% go to FieldTrip website and search for time frequency tutorial

% we will check frequencies with a moving window of 0.5s. the freq
% resolution is therefore 2Hz (1/winlength).
% we set the window size in the field t_ftimwin
% just to play with it a little we test only trial number 1.
cfgtfr              = [];
cfgtfr.output       = 'pow';
cfgtfr.channel      = 'MEG';
cfgtfr.method       = 'mtmconvol';
cfgtfr.taper        = 'hanning';
cfgtfr.foi          = 1:30;                            % freq of interest 3 to 100Hz
cfgtfr.t_ftimwin    = ones(length(cfgtfr.foi),1).*0.5;  % length of time window fixed at 0.5 sec
cfgtfr.toi          = -0.1:0.02:0.5;                    % time window "slides" from -0.1 to 0.5 sec in steps of 0.02 sec (20 ms)
cfgtfr.trials=1;
cfgtfr.channel='A54';
cfgtfr.feedback='no';
TFtest = ft_freqanalysis(cfgtfr, datacln);
% now plot one channel
figure;ft_singleplotTFR([], TFtest);

%% Window size effect
% now a window with smaller size for smaller frequencies
% we start with a window length of 1 cycle for every frequency
cfgtfr.t_ftimwin    = 1./cfgtfr.foi;  % 1 cycle per window
TFtest = ft_freqanalysis(cfgtfr, datacln);
figure;ft_singleplotTFR([], TFtest);

%% 3 cycles per windows
% we now move to 3 cycles per window (10Hz will be tested with a sliding
% window of 30ms. more cycles - smoother results but you loose low freqs.
cfgtfr.t_ftimwin    = 3./cfgtfr.foi;  % 1 cycle per window
TFtest = ft_freqanalysis(cfgtfr, datacln);
figure;ft_singleplotTFR([], TFtest);

%% 7 cycles per windows

cfgtfr.t_ftimwin    = 7./cfgtfr.foi;  % 1 cycle per window
TFtest = ft_freqanalysis(cfgtfr, datacln);
figure;ft_singleplotTFR([], TFtest);

%% 1 cycle, all chanels
% now we'll do 1 cycle per freq for the whole data and all the channels. it
% will take a few minutes.
cfgtfr.t_ftimwin    = 1./cfgtfr.foi;
cfgtfr.trials='all';
cfgtfr.channel='MEG';
cfgtfr.keeptrials='yes';
TFrAll = ft_freqanalysis(cfgtfr, datacln);
cfgp = [];
%cfgp.ylim = [3 30];
fig1=figure;
set(fig1,'Position',[0,0,800,800]);
cfgp.layout       = '4D248.lay';
cfgp.interactive='yes';
ft_multiplotTFR(cfgp, TFrAll);

%% Normalization
% a bit messy. needs some normalization.
fig2=figure;
set(fig2,'Position',[0,0,800,800]);
cfgp.baseline=[-0.5 0];
cfgp.baselinetype = 'relative'; %or 'absolute'
ft_multiplotTFR(cfgp, TFrAll);

%% within subject (between trials) statistics.
% first baseline correction
baseline=mean(TFrAll.powspctrm(:,:,:,1:6),4);
for timei=2:31;
    TFrAll.powspctrm(:,:,:,timei)=TFrAll.powspctrm(:,:,:,timei)-baseline;
end
% no compute the statistic
cfg=[];
cfg.method='stats';
nsubj=size(TFrAll.powspctrm,1);
cfg.design(1,:) = [ones(1,nsubj)];
cfg.latency     = [0 0.35];
cfg.frequency   = [1 20];
cfg.statistic = 'ttest'; % compares the mean to zero
cfg.feedback='no';
frstat=ft_freqstatistics(cfg,TFrAll);
% now plot 1-probability (1 = sig, less than 0.95 not sig)
cfg=[];
cfg.layout='4D248.lay';
frstat.powspctrm=1-frstat.prob;
cfg.zlim=[0.999 1]
cfg.interactive='yes';
fig3=figure;
set(fig3,'Position',[0,0,800,800]);
ft_multiplotTFR(cfg, frstat);

