cd /home/yuval/Data/Amyg/1
fileName='c,rfhp0.1Hz';
p=pdf4D(fileName);
cleanCoefs = createCleanFile_fhb(p, fileName,'byLF',0,'byFFT',0,'HeartBeat',[]);
trig=readTrig_BIU('hb_c,rfhp0.1Hz');
trigf=fixVisTrig(trig,0.1);

cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventvalue=[100,102,104,106,108];
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.2;
cfg.trialdef.poststim=0.7;
cfg.trialdef.offset=-0.2;
cfg=ft_definetrial(cfg);
cfg.channel={'MEG','-A74','-A204'};
cfg.demean='yes';
cfg.baselinewindow=[-0.2 0];
% cfg.bpfilter='yes';
% cfg.bpfreq=[3 50];
data=ft_preprocessing(cfg);

cfg            = [];
cfg.method    = 'pca';
comp           = ft_componentanalysis(cfg, data);
cfg=[];
cfg.layout='4D248.lay';
cfg.channel = 1:5;
ft_databrowser(cfg,comp);
cfg=[];
cfg.method='summary';
cfg.preproc.hpfilter='yes';
cfg.preproc.hpfreq=60;
datacln=ft_rejectvisual(cfg,data);
cfg=[];
cfg.method='summary';
datacln=ft_rejectvisual(cfg,datacln);
cfg=[];
cfg.hpfilter='yes';
cfg.hpfreq=1;
cfg.demean='yes';
cfg,baselinewindow=[-0.15 0];
datacln=ft_preprocessing(cfg,datacln)
save datacln datacln
trialinfo=datacln.trialinfo;
save trialinfo trialinfo
avg=ft_timelockanalysis([],datacln);
cfg=[];
cfg.interactive='yes';
cfg.layout='4D248.lay';
ft_multiplotER(cfg,avg);

cfg              = [];
cfg.keeptrials = 'yes';
cfg.output       = 'pow';
cfg.channel      = 'MEG';
cfg.method       = 'mtmconvol';
cfg.taper        ='triang'; % not required
cfg.foi          = [10:5:40];                            % freq of interest 3 to 100Hz
cfg.t_ftimwin    = 1./cfg.foi;   % ones(length(cfg.foi),1).*0.5;  % length of time window fixed at 0.5 sec
cfg.toi          = 0:0.005:0.35;                  % time window "slides" from -0.1 to 0.5 sec in steps of 0.02 sec (20 ms)
cfg.tapsmofrq  = 1;
cfg.trials='all';%[1:2];
cfg.channel='all';
cfg.tail='beg'; % pad the template with zeros, 'beg' 'end' 'both' or [] for no padding
[TF,wlt] = freqanalysis_triang_temp(cfg, datacln);
save TFpad TF wlt
cfgp = [];
cfgp.channel='A190';
mn=min(min(squeeze(mean(TF.powspctrm(:,1,:,:),1))));
mx=max(max(squeeze(mean(TF.powspctrm(:,1,:,:),1))));
z=abs(mx);if abs(mn)>abs(mx);z=abs(mn);end
cfgp.zlim=[-z z];
figure;ft_singleplotTFR(cfgp, TF);

peaks=peaksInTrials(TF,wlt);


post=[];negt=[];
for ti=1:length(peaks.chan{1,1}.trial)
    post=[post,peaks.chan{1,1}.trial{1,ti}.time(1,peaks.chan{1,1}.trial{1,ti}.SNR>0)];
    negt=[negt,peaks.chan{1,1}.trial{1,ti}.time(1,peaks.chan{1,1}.trial{1,ti}.SNR<0)];
end
% figure;
% plot(post,'or')
% hold on
% plot(negt,'ob')

figure;hist(post,35);
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
hold on;
hist(negt,35);
legend ('pos','neg')
title('Count of Peaks')

[~,chani]=ismember('A190',data.label)
posSNR=[];negSNR=[];
for ti=1:length(peaks.chan{1,chani}.trial)
    try
        posSNR=[posSNR,peaks.chan{1,chani}.trial{1,ti}.SNR(1,peaks.chan{1,chani}.trial{1,ti}.SNR>0)];
    end
    try
        negSNR=[negSNR,peaks.chan{1,chani}.trial{1,ti}.SNR(1,peaks.chan{1,chani}.trial{1,ti}.SNR<0)];
    end
end
figure;
plot(post,posSNR,'.r')
hold on
plot(negt,abs(negSNR),'.b')
legend ('pos','neg')
title('Absolute SNR Values')


cfgp = [];
cfgp.layout       = '4D248.lay';
cfgp.interactive='yes';
ft_multiplotTFR(cfgp, TF);


cfg              = [];
cfg.keeptrials = 'yes';
cfg.output       = 'pow';
cfg.channel      = 'MEG';
cfg.method       = 'mtmconvol';
cfg.taper        ='triang'; % not required
cfg.foi          = [10:5:40];                            % freq of interest 3 to 100Hz
cfg.t_ftimwin    = 1./cfg.foi;   % ones(length(cfg.foi),1).*0.5;  % length of time window fixed at 0.5 sec
cfg.toi          = 0:0.005:0.35;                  % time window "slides" from -0.1 to 0.5 sec in steps of 0.02 sec (20 ms)
cfg.tapsmofrq  = 1;
cfg.trials='all';%[1:2];
cfg.channel='all';
cfg.tail=[]; % pad the template with zeros, 'beg' 'end' 'both' or [] for no padding
[TF,wlt] = freqanalysis_triang_temp(cfg, datacln);
save TF TF wlt

peaks=peaksInTrials(TF,wlt);
save peaks peaks

[~,chani]=ismember('A190',peaks.label);
post=[];negt=[];
for ti=1:length(peaks.chan{1,chani}.trial)
    try
        post=[post,peaks.chan{1,chani}.trial{1,ti}.time(1,peaks.chan{1,chani}.trial{1,ti}.SNR>0)];
    end
    try
        negt=[negt,peaks.chan{1,chani}.trial{1,ti}.time(1,peaks.chan{1,chani}.trial{1,ti}.SNR<0)];
    end
end

figure;hist(post,45);
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
hold on;
hist(negt,45);
legend ('pos','neg')
title('Count of Peaks')

posSNR=[];negSNR=[];
for ti=1:length(peaks.chan{1,chani}.trial)
    try
        posSNR=[posSNR,peaks.chan{1,chani}.trial{1,ti}.SNR(1,peaks.chan{1,chani}.trial{1,ti}.SNR>0)];
    end
    try
        negSNR=[negSNR,peaks.chan{1,chani}.trial{1,ti}.SNR(1,peaks.chan{1,chani}.trial{1,ti}.SNR<0)];
    end
end
figure;
plot(post,posSNR,'.r')
hold on
plot(negt,abs(negSNR),'.b')
legend ('pos','neg')
title('Absolute SNR Values')
%% defining time windows of interest automatically
edges=t(1:2:end-1)+((t(2)-t(1))./2);
cn=histc(negt,edges);cp=histc(post,edges);
figure;plot(edges,(cp-cn)/mean([cp cn]),'k');
cn=cn(1:end-1);cp=cp(1:end-1); % last value is when t = the end of window
wpos=find((cp-cn)/mean([cp cn])>1);
wneg=find((cp-cn)/mean([cp cn])<-1);

winPos=getTwin(edges,wpos);
winNeg=getTwin(edges,wneg);
save win winPos winNeg
%% characterizing conditions
[~,chani]=ismember('A190',peaks.label);
load win
load peaks
load trialinfo
method='biggest'; % 'biggest' or 'earliest'
A190pos=peakSorter('A190',peaks,winPos,trialinfo,'pos','biggest')
A190neg=peakSorter('A190',peaks,winNeg,trialinfo,'neg','biggest')
save A190 A190pos A190neg winPos winNeg
[~,p]=ttest2((A190pos.cond100pos.timewin{1,2}(:,2)),(A190pos.cond106pos.timewin{1,2}(:,2)))

%% M100 for all conditions, compare with / without M100 trials
load win
load peaks
A190posAll=peakSorter('A190',peaks,winPos,ones(length(peaks.chan{1,1}.trial),1),'pos','biggest');
trials=1:length(peaks.chan{1,1}.trial);
trialsM100=A190posAll.cond1pos.timewin{1,1}(:,1);
trialsNoM100=trials(setxor(trialsM100,1:length(trials)))';
load datacln
minN=min(length(trialsM100),length(trialsNoM100)); % to compare equal num of trials
cfg=[];
cfg.trials=trialsM100(1:minN);
M100=ft_timelockanalysis(cfg,datacln);
cfg.trials=trialsNoM100(1:minN);
noM100=ft_timelockanalysis(cfg,datacln);

cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
cfg.zlim=[-1e-12 1e-12];
cfg.showlabels='yes';
ft_multiplotER(cfg,M100,noM100)

%% compare baseline low / high alpha trials
load datacln
[~,chani]=ismember('A190',datacln.label);
% blwin=[-0.2 0];
% A190bl=peakSorter('A190',peaks,blwin,ones(length(peaks.chan{1,1}.trial),1),'both','biggest');
s1=nearest(datacln.time{1,1},-0.15);
s2=nearest(datacln.time{1,1},0);
y=datacln.trial{1,1}(chani,s1:s2);
Fs = 1017.25;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = length(y);                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
% x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t); 
% y = x + 2*randn(size(t));     % Sinusoids plus noise
plot(datacln.time{1,1},datacln.trial{1,1}(chani,:));hold on;
plot(datacln.time{1,1}(s1:s2),y,'r')

% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
NFFT = 1024;
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.

figure;plot(f(6:20),2*abs(Y(6:20))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
f1=nearest(f,8);
f2=nearest(f,13);

for triali=1:length(datacln.trial)
    y=datacln.trial{1,triali}(chani,s1:s2);
    Y = fft(y,NFFT)/L;
    F(triali)=sum(abs(real(Y(f1:f2))));
end
plot(F,'.')
alphaLow=find(F<0.5e-12);
trials=1:length(datacln.trial);
alphaHigh=trials(setxor(alphaLow,trials));

minN=min(length(alphaHigh),length(alphaLow)); % to compare equal num of trials
cfg=[];
cfg.trials=alphaHigh(1:minN);
aHigh=ft_timelockanalysis(cfg,datacln);
cfg.trials=alphaLow(1:minN);
aLow=ft_timelockanalysis(cfg,datacln);

cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
cfg.zlim=[-1e-12 1e-12];
cfg.showlabels='yes';
ft_multiplotER(cfg,aLow,aHigh)





cfg              = [];
cfg.keeptrials = 'yes';
cfg.output       = 'pow';
cfg.channel      = 'MEG';
cfg.method       = 'tfr';
%cfg.taper        ='triang';%'dpss' 'hanning' 'alpha';
cfg.foi          = 5:13;                            % freq of interest 3 to 100Hz
cfg.t_ftimwin    = 1./cfg.foi;   % ones(length(cfg.foi),1).*0.5;  % length of time window fixed at 0.5 sec
cfg.toi          = -0.15:0.001:0.7;                  % time window "slides" from -0.1 to 0.5 sec in steps of 0.02 sec (20 ms)
cfg.tapsmofrq  = 1;
cfg.trials='all';
cfg.channel='MEG';
TFbl = ft_freqanalysis(cfg, datacln);
cfgp = [];
%cfgp.ylim = [3 30];         
cfgp.layout       = '4D248.lay';
cfgp.interactive='yes';
ft_multiplotTFR(cfgp, TFbl);
