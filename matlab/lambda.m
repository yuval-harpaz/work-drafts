
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

%% read and filter A191
cd /home/yuval/Data/MOI704
load data
load trialinfo

cfg=[];
cfg.channel='A191';
cfg.bpfilter='yes';
cfg.bpfreq=[3 50];
cfg.trials=trialinfo;
dA191=ft_preprocessing(cfg,data);

%% find peak time and topography
avg=ft_timelockanalysis([],dA191);
[~,negPeak]=min(avg.avg);
plot(avg.time,avg.avg);hold on;plot(avg.time(1,negPeak),avg.avg(1,negPeak),'mo');

cfg=[];cfg.trials=trialinfo;avg=ft_timelockanalysis(cfg1,data)
cfg=[];cfg.layout='4D248.lay';cfg.xlim=[avg.time(1,negPeak) avg.time(1,negPeak)];
figure;ft_topoplotER(cfg,avg);
topo=avg.avg(:,negPeak);

%% make template from average;
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

%% test, find temp on averaged data.
load temp
load tempPeakAl
x=[];x=tempPeakAl;
% tmpBlc = tempPad-mean(tempPad);
tmpBlc = temp-mean(temp);
tmplt=tmpBlc./sqrt(sum(tmpBlc.*tmpBlc)); % normalize template, sum of squares =0;
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


%figure;hold on;

% tmpBlc = temp-mean(temp);
tmpBlc = tempPad-mean(tempPad);
tmplt=tmpBlc./sqrt(sum(tmpBlc.*tmpBlc));
limSNR = 1;    limSig = 0;
allSigIpeaks={};
asip=[];nI=[];pI=[];nP=[];pP=[];
trials=trialinfo;
trials(2,:)=dataNoMOG.trialinfo;
for triali=1:length(dataNoMOG.trial)
    x=[];
    x=dataNoMOG.trial{1,triali}(chi,:);
    [SNR,SigX]=fitTemp(x,tmplt);
    %plot(SNR);
    [SigPeaks, SigIpeaks] = findPeaks(SigX,3, 0, 'MAD');
    asip=[asip,SigIpeaks];
    Ppos=SigIpeaks(x(SigIpeaks)>0);
    Pneg=SigIpeaks(x(SigIpeaks)<0);
    pP=[pP Ppos];nP=[nP Pneg];
    allSigIpeaks{triali}=SigIpeaks;
    SNRpeaks = SNR(SigIpeaks);
    I= SigIpeaks(SigPeaks>limSig & SNRpeaks'>limSNR);
    Ipos=I(x(I)>0);
    Ineg=I(x(I)<0);
    pI=[pI Ipos];nI=[nI Ineg];
    try
        s=[];
        s=Pneg(nearest(dataNoMOG.time{1,1}(Pneg),0.145));
        trials(3,triali)=dataNoMOG.time{1,1}(s);
        trials(4,triali)=dataNoMOG.trial{1,triali}(chi,s);
    catch me
        display(num2str(triali))
    end
    try
        s=[];
        s=Ineg(nearest(dataNoMOG.time{1,1}(Ineg),0.145));
        trials(5,triali)=dataNoMOG.time{1,1}(s);
        trials(6,triali)=dataNoMOG.trial{1,triali}(chi,s);
    catch me
        display(num2str(triali))
    end
end

% save tempPadData trials
open ttests;

c210=trials(2,:)==210;c220=trials(2,:)==220;c200=trials(2,:)==200;
halfwin=0.02;
p145ms=((0.145-halfwin)<trials(3,:) & trials(3,:)<(0.145+halfwin));sum(p145ms)

figure;hist(trials(3,(p145ms & c200)),5);ylim([0 20]);
figure;hist(trials(3,(p145ms & c210)),5);ylim([0 20]);
figure;hist(trials(3,(p145ms & c220)),5);ylim([0 20]);

figure;hist(trials(4,(p145ms & c200)));ylim([0 20]);
figure;hist(trials(4,(p145ms & c210)));ylim([0 20]);
figure;hist(trials(4,(p145ms & c220)));ylim([0 20]);
tbl=[trials(4,(p145ms & c200))',trials(4,(p145ms & c210))'];
[h,p]=ttest(trials(4,(p145ms & c200))',trials(4,(p145ms & c210))')
% see distribution of peaks
% figure;hist(data.time{1,1}(asip),50)

figure;
hist(data.time{1,1}(pI),25);
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
hold on;
hist(data.time{1,1}(nI),25)
legend('positive','negative')
title('good fit points')

figure;
hist(data.time{1,1}(pP),25);
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
hold on;
hist(data.time{1,1}(nP),25)
legend('positive','negative')
title('peaks on signal trace')
% find peaks in signal and SNR and decide on cutoff limits

%% make traces of peak topography component
load data
load avgAll
load topo
compMtx=zeros(length(data.trial),size(data.trial{1,1},2));
for triali=1:length(data.trial)
    compMtx(triali,:)=data.trial{1,triali}'*topo;
end

load temp
limSNR = 1;    limSig = 0;%0.5*1e-45;
%tmpBlc = tempPad-mean(tempPad);
tmpBlc = temp-mean(temp);
tmplt=tmpBlc./sqrt(sum(tmpBlc.*tmpBlc));
allSigIpeaks={};
asip=[];nI=[];pI=[];nP=[];pP=[];
for triali=1:size(compMtx,1)
    x=[];
    x=compMtx(triali,:);
    [SNR,SigX]=fitTemp(x,tmplt);
     %plot(SNR);
    [SigPeaks, SigIpeaks] = findPeaks(SigX,3, 0, 'MAD');
    asip=[asip,SigIpeaks];
    Ppos=SigIpeaks(x(SigIpeaks)>0);
    Pneg=SigIpeaks(x(SigIpeaks)<0);
    pP=[pP Ppos];nP=[nP Pneg];
    allSigIpeaks{triali}=SigIpeaks;
    SNRpeaks = SNR(SigIpeaks);
    I = SNRpeaks>=limSNR;
    I= SigIpeaks(SigPeaks>limSig & SNRpeaks'>limSNR);
    Ipos=I(x(I)>0);
    Ineg=I(x(I)<0);
    pI=[pI Ipos];nI=[nI Ineg];
    if ~isempty(pI)
        display(num2str(triali))
    end
    
end
figure;hist(t(pI),25);
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
hold on;
hist(t(nI),25);
legend ('pos','neg')
title('good fit')

load avgAll
t=avg.time;
avgCompTrace=avg.avg'*topo;
figure;plot(t,avgCompTrace);

figure;
subplot(1,2,1)
hist(t(pP),75);
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
hold on;
hist(t(nP),75)
plot(t,10^(-log10(max(avgCompTrace))+1).*avgCompTrace+30,'g')
legend('positive','negative','component for averaged data')
title('number of peaks detected in the component trace')
subplot(1,2,2);
cfg=[];
cfg.xlim=[0.154 0.154];
ft_topoplotER(cfg,avg);

figure;hist(t(pI),75);title('positive peaks')
figure;hist(t(nP),75);title('negative peaks')

%% limSig = 10^0.386

sum(SNRpeaks>limSNR)
I = SNRpeaks>=limSNR;
figure
hist(log10(SigPeaks(I)),50)
limSig = 10^0.923
I= SigIpeaks(SigPeaks>8 & SNRpeaks'>2.4);

