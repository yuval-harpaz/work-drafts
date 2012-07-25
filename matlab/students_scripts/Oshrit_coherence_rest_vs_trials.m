% Connectivity on the sensor level - participant quad02. (rest vs. words vs. non-words)

% My data is located on smb://k213-4/megdata/oshrit/quad02/1
% I have used course3 for defining cfg, course5 for freq. analysis,
% course10 connectivity (coherence)
% The procedure: 1. extract data and do preprocessing, 2. freq. analysis to
% find the sensor with highest power 3. coherence between the sensor from
% left and right.

% The trigers, I've used in the script"
% trig (rest, trval=[92 94]; 92- eyes open, 94 - eyes close)
% trig (one_back, trval=[100 102] 100 - words, 102 - word one back; nonwords: trval=[200 202] 200 - nonwords, 202 - nonword one back )

% --------------(1)------------------------
% frequency analysis of rest- 
% find channels with maximum alpha in region around motor cortex (manually), in the right and left hemisphere. 

% Yuval gave me a clean data, that was clean from HB and 50hz and building
% movements. It is very important to clean HB before doing freq. analysis.
fileName='xc,hb,lf_c,rfhp0.1Hz';

% all the trigers
% trig=readTrig_BIU('xc,hb,lf_c,rfhp0.1Hz');
% plot(trig);

% preprocessing in order to obtain the data.
cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventtype='TRIGGER';
% The following parameters set the duration (and "location" in time) of the trial
cfg.trialdef.prestim=0.0;
cfg.trialdef.poststim=150.0; % 2.5 minutes of rest
cfg.trialdef.offset=-0.0;
cfg.trialfun='BIUtrialfun';
cfg.trialdef.eventvalue= 92; %trig of eyes open 
cfg=ft_definetrial(cfg);
cfg.channel = {'MEG', '-A204', '-A74'}; % removing specific bad channels
cfg.demean='yes'; %baseline correction-  it is a good idea to do blc before doing freq. analysis.
dataorig=ft_preprocessing(cfg);

% read epochs of 1s - since the long 2.5 minutes trial gave an error: "out of
% memory".
t=dataorig.cfg.trl(1,1):1017:dataorig.cfg.trl(1,2); % 1017 -is a sec
trl=t';
trl(:,2)=t'+1017;
trl(:,3)=0;

cfg=[];
cfg.dataset=fileName;
cfg.channel = {'MEG', '-A204', '-A74'}; % removing specific bad channels
cfg.trl=trl;
cfg.demean='yes'; %baseline correction-  it is a good idea to do blc before doing freq. analysis.
dataorig=ft_preprocessing(cfg);


% % In order check if there are bad trials left:
% % we want to reject trials in order to avoid muscle artifacts.
% % If I want to reject bad trials, I need first to define trials. Since it is rest, there are no trials. 
% %Trials are defined by triggers (we can ues them to separate trials), however in rest there are no triggers.
% cfg=[];
% cfg.dataset=fileName;
% cfg.method='summary'; %trial
% cfg.channel='MEG';
% cfg.alim=1e-12;
% datacln=ft_rejectvisual(cfg, dataorig); % allow the user to make a visual selection of the data that should be rejected


% using freq. analaysis with with a Hanning window
% http://fieldtrip.fcdonders.nl/tutorial/timefrequencyanalysis
cfgfr=[];
cfgfr.output       = 'pow';
cfgfr.channel      = 'MEG'; % I can also separate to MR and ML (running separetly for for MEG left and Meg right)
cfgfr.method       = 'mtmfft';
cfgfr.taper        = 'hanning';
cfgfr.foi          = 8:14; % freq. of  interest: alpha
FrAll = ft_freqanalysis(cfgfr, dataorig);
% In Frall there are labels with the number for each channel, and powspctrm
% with the power for each of the selected freq.

% Automatically
% I can calculate the sum or mean of all freq. 8:9:10:11:12:13:14 in each
% channel. I can use cfg.channel and simply define 'MR' or 'ML'(or ft_channelselection). 

% or
% Manually
% Plot results for mu/alpha and then I can manually select from the mu
% dipole. It gives a curve indicating the power at each freq. 
cfgp = [];
cfgp.xlim = [9 11];        
cfgp.layout       = '4D248.lay';
cfgp.interactive='yes';
ft_topoplotER(cfgp, FrAll);

% The result of manually choosing the highest channel at the left and right
% hemisphere:
% Right: chan A114, Left: chan A96. foi (freq. of interest) 10 and 12Hz.

cfg=[];
cfg.channel={'A96','A114'};
rest2chans=ft_preprocessing(cfg,dataorig);
% taking the data from only the relevant channels.

% --------------(2)------------------------
% connectivity in rest for channels with higest power.
% using coherence calculation- from course10.

cfg           = [];
cfg.method    = 'mtmfft';
cfg.output    = 'fourier'; % in order to do coherence calculation I need also the phase (not only amplitude), so we'll repeat freq. analysis, this time 'fourier'.
cfg.tapsmofrq = 1; % no smothing - works better with Tal's data.
cfg.foi=[10 12];
freq          = ft_freqanalysis(cfg, rest2chans);
cfg           = [];
cfg.method    = 'coh';
cohLR_r       = ft_connectivityanalysis(cfg, freq);
% the results of coherence calculation:
%for 10Hz cohLR.cohspctrm= [ 1.0000    0.6184; 0.6184    1.0000];
%for 12Hz cohLR.cohspctrm= [ 1.0000    0.5845; 0.5845    1.0000];


% --------------(3)------------------------
% same channels of one back (words)
cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.0;
cfg.trialdef.poststim=1.0; % 1 sec per word
cfg.trialdef.offset=-0.0;
cfg.trialfun='BIUtrialfun';
cfg.trialdef.eventvalue= 100; %trig of one_back words  
cfg=ft_definetrial(cfg);
cfg.channel = {'A96', 'A114'}; %choosing specific channels taken form analysis of rest
cfg.demean='yes'; %baseline correction- it is a good idea to do blc before doing freq. analysis.
dataorig=ft_preprocessing(cfg);

cfg           = [];
cfg.method    = 'mtmfft';
cfg.output    = 'fourier'; %in order to do coherence calculation I need also the phase (not only amplitude), so we'll repeat freq. analysis.
cfg.tapsmofrq = 1; %no smoothing - works better with Tal's data.
cfg.foi=[10 12];
freq          = ft_freqanalysis(cfg, dataorig);
cfg           = [];
cfg.method    = 'coh';
cohLR_w       = ft_connectivityanalysis(cfg, freq);
% the results of coherence calculation:
%for 10Hz cohLR.cohspctrm= [ 1.0000    0.7156; 0.7156    1.0000];
%for 12Hz cohLR.cohspctrm= [ 1.0000    0.4201; 0.4201    1.0000];

% --------------(4)------------------------
% same channels of one back (non-words)
cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.0;
cfg.trialdef.poststim=1.0; % 1 sec per non-word
cfg.trialdef.offset=-0.0;
cfg.trialfun='BIUtrialfun';
cfg.trialdef.eventvalue= 200; %trig of one_back non-words
cfg=ft_definetrial(cfg);
cfg.channel = {'A96', 'A114'}; % choosing specific channels taken form analysis of rest
cfg.demean='yes'; %base line correction-  it is a good idea to do blc before doing freq. analysis.
dataorig=ft_preprocessing(cfg);

cfg           = [];
cfg.method    = 'mtmfft';
cfg.output    = 'fourier'; %in order to do coherence calculation I nedd also the phase (not only amplitude), so we'll repeat freq. analysis.
cfg.tapsmofrq = 1; %no smothing - works better with Tal's data.
cfg.foi=[10 12];
freq          = ft_freqanalysis(cfg, dataorig);
cfg           = [];
cfg.method    = 'coh';
cohLR_nw      = ft_connectivityanalysis(cfg, freq);
% the results of coherence calculation:
%for 10Hz cohLR.cohspctrm= [1.0000    0.5835; 0.5835    1.0000];
%for 12Hz cohLR.cohspctrm= [1.0000    0.6902; 0.6902    1.0000];

% --------------(4)------------------------
% comparing results
% a bar plot of cohLR.cohspctrm for the 3 options: rest, words, non-words,
% at 10Hz and at 12Hz.
X = [cohLR_r.cohspctrm(2,1,1), cohLR_r.cohspctrm(2,1,2); cohLR_w.cohspctrm(2,1,1), cohLR_w.cohspctrm(2,1,2); cohLR_nw.cohspctrm(2,1,1), cohLR_nw.cohspctrm(2,1,2)];
F=bar(X);
set(gca,'XTickLabel', {'rest', 'words', 'non-words'});
legend('10Hz', '12Hz');
ylabel('coh');

