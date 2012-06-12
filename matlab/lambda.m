
fn='c,rfhp0.1Hz,ee,o';

p=pdf4D(fn);
cleanCoefs = createCleanFile(p, fn,...
    'byLF',0 ,...
    'chans2ignore',[74,204],...
    'byFFT',0,...
    'HeartBeat',[]);

% cleanCoefs = createCleanFile(p, fn,...
%     'byLF',256 ,'Method','Adaptive',...
%     'xClean',[4,5,6],...
%     'chans2ignore',[74,204],...
%     'byFFT',0,...
%     'HeartBeat',0,... % use [] for automatic HB cleaning, use 0 to avoid HB cleaning
%     'maskTrigBits', 512);
fn=['hb_',fn];
trig=readTrig_BIU(fn);
trig=fixVisTrig(trig,200);
unique(trig)
cfg=[];
cfg.dataset=fn;
cfg.trialdef.eventvalue=[200,210,220];
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
% comp.trial(1,2:end+1)=comp.trial;
% comp.time(1,2:end+1)=comp.time;
% avgcomp=ft_timelockanalysis([],comp);
% comp.trial{1,1}=avgcomp.avg;
% comp.sampleinfo(2:end+1,:)=comp.sampleinfo;
% comp.trialinfo(2:end+1,:)=comp.trialinfo;
for tri=1:length(comp.trial)
    trStd(1:2,tri)=std(comp.trial{1,tri}(1:2,102:508)');
end
plot(1:360,trStd,'o');

mx=max(trStd);
z=zscore(mx);



% cfg = [];
% cfg.component = [1 2]; % change
% data = ft_rejectcomponent(cfg, comp);

% cfg=[];
% cfg.method='summary'; %trial
% cfg.channel='MEG';
% %cfg.alim=1e-12;
% data=ft_rejectvisual(cfg, data);

cfg=[];
trialinfo=find(z<2);
save trialinfo trialinfo
cfg.trials=trialinfo;
avg=ft_timelockanalysis(cfg,data);
avg=correctBL(avg,[-0.1 0]);
cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
ft_multiplotER(cfg,avg);

% x=0.144
cfg=[];
cfg.layout='4D248.lay';
cfg.channel = {'A199','A191'};
ft_databrowser(cfg,data);

%% tfr
cd /home/yuval/Data/MOI704
load data
cfg              = [];
%cfg.keeptapers = 'yes';
cfg.keeptrials = 'yes';
cfg.output       = 'pow';
cfg.channel      = 'MEG';
cfg.method       = 'mtmconvol';
cfg.taper        ='triang';%'dpss' 'hanning' 'alpha';
cfg.foi          = 3:30;                            % freq of interest 3 to 100Hz
cfg.t_ftimwin    = 1./cfg.foi;   % ones(length(cfg.foi),1).*0.5;  % length of time window fixed at 0.5 sec
cfg.toi          = -0.2:0.005:0.7;                  % time window "slides" from -0.1 to 0.5 sec in steps of 0.02 sec (20 ms)
cfg.tapsmofrq  = 1;
cfg.trials='all';
cfg.channel='MEG';
TF = ft_freqanalysis(cfg, data);
cfgp = [];
%cfgp.ylim = [3 30];         
cfgp.layout       = '4D248.lay';
cfgp.interactive='yes';
cfgp.baseline=[-0.2 0];
cfgp.baselinetype = 'absolute'; %or 'absolute'
ft_multiplotTFR(cfgp, TF);

%% only 9Hz t=0.15 chan=A191
cd /home/yuval/Data/MOI704
load data
load trialinfo

cfg=[];
cfg.channel='A191';
cfg.bpfilter='yes';
cfg.bpfreq=[3 50];
cfg.trials=trialinfo;
dA191=ft_preprocessing(cfg,data);
% find local minima
avg=ft_timelockanalysis([],dA191);
[~,negPeak]=min(avg.avg);
plot(avg.time,avg.avg);hold on;plot(avg.time(1,negPeak),avg.avg(1,negPeak),'mo');
hlfwin=15; % how many sampls left and right of 0.15 to take

for triali=1:length(dA191.trial)
    figure;
    flipd=-dA191.trial{1,triali}; %(1,357-hlfwin:357+hlfwin);
    [pks,locs] = findpeaks(flipd);
    nearPeak(triali)=locs(nearest(locs,354));
%     mn(triali)=min(dA191.trial{1,triali}(1,306:408));
% if ~isempty(nearPeak(triali))
    plot(dA191.time{1,1},dA191.trial{1,triali},'m');hold on;plot(dA191.time{1,1}(nearPeak(triali)),dA191.trial{1,triali}(nearPeak(triali)),'k');
    title(num2str(triali));
    resp = input('ENTER = ok, 0 = bad peak ')
    if isempty(resp);resp=1;else;resp=0;end;
    peak01(triali)=resp;
    close;
    save peak01 peak01
end


% average traces of chosen peaks
tempPeak=zeros(size(dA191.trial{1,1}));
countPks=0;
for triali=1:length(dA191.trial)
    if peak01(triali)
        tempPeak=tempPeak+dA191.trial{1,triali};
        countPks=countPks+1;
    end
end
tempPeak=tempPeak./countPks;
plot(dA191.time{1,1},tempPeak);

% align spikes
halfAvg=200;
tempPeakAl=zeros(1,(2*halfAvg+1));
countPks=0;
for triali=1:length(dA191.trial)
    if peak01(triali)
        sampBeg=nearPeak(triali)-halfAvg;
        sampEnd=nearPeak(triali)+halfAvg;
        tempPeakAl=tempPeakAl+dA191.trial{1,triali}(sampBeg:sampEnd);
        countPks=countPks+1;
    end
end
tempPeakAl=tempPeakAl./countPks;
halfAvg=200;
tempPeakAlAl=zeros(1,(2*halfAvg+1));
countPks=0;
for triali=1:length(dA191.trial)
    %if peak01(triali)
        sampBeg=nearPeak(triali)-halfAvg;
        sampEnd=nearPeak(triali)+halfAvg;
        tempPeakAlAl=tempPeakAlAl+dA191.trial{1,triali}(sampBeg:sampEnd);
        countPks=countPks+1;
    %end
end
tempPeakAlAl=tempPeakAlAl./countPks;

plot(dA191.time{1,1}(negPeak-200:negPeak+200),tempPeakAl,'k');
hold on;
plot(dA191.time{1,1}(negPeak-200:negPeak+200),tempPeak(negPeak-200:negPeak+200),'b');
plot(dA191.time{1,1}(negPeak-200:negPeak+200),avg.avg(negPeak-200:negPeak+200),'c');
plot(dA191.time{1,1}(negPeak-200:negPeak+200),tempPeakAlAl,'m');
legend('chosen aligned','chosen','all','all aligned');
save tempPeakAl tempPeakAl

% make V shape temp

%temp=zeros(1,401);

half=fliplr(tempPeakAl(1,1:201));
x1=find(half>0,1);
x1=201-x1;
x2=find(tempPeakAl(1,201:end)>0,1)+201;
x=x1:201;y=tempPeakAl(x);
p = polyfit(x,y,1);
f = polyval(p,x);
figure;plot(x,y,'o',x,f,'-')
f1=f;

x=201:x2;y=tempPeakAl(x);%.*10^14;
p = polyfit(x,y,1);
f = polyval(p,x);
figure;plot(x,y,'o',x,f,'-')
% temp=[f1 f];
temp=[f1(1:end-1) mean([f1(end) f(1)]) f(2:end)];
temp=temp(temp<0);
tempPad=zeros(1,length(temp).*2);
tempPad(length(temp*2)+1:end)=temp;
tempPad(tempPad>0)=0;
figure;plot(tempPad);
save temp temp tempPad

% test, find temp on averaged data.
load temp
load tempPeakAl
x=[];x=tempPeakAl;
tmplt=tempPad./sqrt(sum(tmplt.*tmplt)); % normalize template, sum of squares =0;
[SNR,SigX]=fitTemp(x,tmplt);
figure;plot(SNR);
[SigPeaks, SigIpeaks] = findPeaks(SigX,3, 0, 'MAD');
SNRpeaks = SNR(SigIpeaks);
hold on;
plot(SigIpeaks,SNRpeaks,'ok')
% figure
% hist(log10(SNRpeaks),50)

% now for all data
chan='A191';
[~,chi]=ismember(chan,data.label);
load data
load trialinfo
cfg=[];
cfg.trials=trialinfo;
cfg.hpfilter='yes';
cfg.hpfreq=1;
dataNoMOG=ft_preprocessing(cfg,data);
% tmplt=tempPad;
allSigIpeaks={};
asip=[];
for triali=1:length(dataNoMOG.trial)
    x=[];
    x=dataNoMOG.trial{1,triali}(chi,:);
    [SNR,SigX]=fitTemp(x,tmplt);
%     figure;plot(SNR);
    [SigPeaks, SigIpeaks] = findPeaks(SigX,3, 0, 'MAD');
    asip=[asip,SigIpeaks];
    allSigIpeaks{triali}=SigIpeaks;
%     SNRpeaks = SNR(SigIpeaks);
%     hold on;
%     plot(SigIpeaks,SNRpeaks,'ok')
end

% see distribution of peaks
hist(data.time{1,1}(asip),50)


% find peaks in signal and SNR and decide on cutoff limits

% limSig = 10^0.386
limSNR = 10^0.386;
sum(SNRpeaks>limSNR)
I = SNRpeaks>=limSNR;
figure
hist(log10(SigPeaks(I)),50)
limSig = 10^0.923
I= SigIpeaks(SigPeaks>8 & SNRpeaks'>2.4);



% cfg=[];
% cfg.layout='4D248.lay';
% cfg.channel = {'A191'};
% ft_databrowser(cfg,dA191);
% for triali=1:length(dA191.trial)
%     mn(triali)=min(dA191.trial{1,triali}(1,306:408));
% end
% plot(mn,'o')
% smooth20=dA191;
% for triali=1:length(dA191.trial)
%     smooth20.trial{1,triali}=smooth(dA191.trial{1,triali},20)';
% end
% cfg=[];
% cfg.layout='4D248.lay';
% cfg.channel = {'A191'};
% ft_databrowser(cfg,smooth20);

% cfg              = [];
% cfg.keeptrials = 'yes';
% cfg.output       = 'pow';
% cfg.channel      = 'MEG';
% cfg.method       = 'mtmconvol';
% cfg.taper        ='triang';%'dpss' 'hanning' 'alpha';
% cfg.foi          = 9;                            % freq of interest 3 to 100Hz
% cfg.t_ftimwin    = 1./cfg.foi;   % ones(length(cfg.foi),1).*0.5;  % length of time window fixed at 0.5 sec
% cfg.toi          = [0.1:0.01:0.2];                  % time window "slides" from -0.1 to 0.5 sec in steps of 0.02 sec (20 ms)
% cfg.tapsmofrq  = 2;
% cfg.trials='all';
% %cfg.channel='A191';
% TF = ft_freqanalysis(cfg, dA191);
% plot(max(squeeze(TF.powspctrm)'),'o')
