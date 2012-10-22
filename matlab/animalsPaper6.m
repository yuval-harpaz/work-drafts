
%% Make a template based on the averaged data
cd /home/yuval/Data/Amyg/1
if ~exist('A191.mat','file')
    load datacln
    cfg=[];
    cfg.trials=1:100;
    cfg.channel='A191';
    cfg.feedback='no';
    A191=ft_preprocessing(cfg,datacln);
    cfg=[];
    cfg.feedback='no';
    A191avg=ft_timelockanalysis(cfg,A191);
    save A191 A191 A191avg
else
    load A191
end
th=2*max(abs(A191avg.avg(1:nearest(A191avg.time,0))));
deadSamples=round(0.06*A191.fsample); % 0.06 for 60ms dead time
% find positive peaks on average curves
[peaks, Ipeaks]=findPeaks(A191avg.avg,0,deadSamples);
thi=find(peaks>th);
posPeaks=peaks(thi);posIpeaks=Ipeaks(thi);posTpeaks=A191avg.time(posIpeaks)
% find negative peaks
[peaks, Ipeaks]=findPeaks(-A191avg.avg,0,deadSamples);
thi=find(peaks>th);
negPeaks=peaks(thi);negIpeaks=Ipeaks(thi);negTpeaks=A191avg.time(negIpeaks)



% M170 template
mi=nearest(negTpeaks,0.17)
upToPeak=smooth(-A191avg.avg(1:negIpeaks(mi)),20)';
begi=find(fliplr(upToPeak)<0,1);
begi=length(upToPeak)-begi+2;
fromPeak=smooth(-A191avg.avg(negIpeaks(mi):end),20)';
endi=find(fromPeak<0,1);
endi=negIpeaks(mi)+endi-2;
template170=A191avg.avg(begi:endi);
femto=10^15;
sm=smooth(A191avg.avg,5);
figure;
plot(A191avg.time(1:(begi-1)),femto*sm(1:(begi-1)),'k-','LineWidth',3)
hold on
plot(A191avg.time(begi:1:endi),femto*template170(1:1:end),'k--','LineWidth',3)
plot(A191avg.time((endi+1):end),femto*sm((endi+1):end),'k-','LineWidth',3)
ylabel('Amplitude (fT)')
xlabel ('Latency')
legend ('whole trace','template')
if ~exist('template170','file')
    save template170 template170
end
%% Look for M170 template in the data
load A191
load template170
cfg=[];
cfg.channel = 'A191';
cfg.deadSamples = 60;
cfg.template = -template170;
Peaks=peaks1c1f(cfg,A191);
[post,negt,posTri,negTri]=peakPosNeg1c(Peaks,cfg.channel);
[n1,x1]=hist(post,50);
[n2,x2]=hist(negt,50);
figure;
h1=bar(x1,n1,'hist');
hold on
h2=bar(x2,n2,'hist');
set(h2,'edgecolor','k')
set(h2,'facecolor','k')
set(h1,'edgecolor','k')
set(h1,'facecolor','w')
legend ('pos','neg')
ylim([0 75]);
title('Count of Peaks by time bins')
xlabel ('Latency')
ylabel('Number of Events')


figure;
h3=plot(post,posTri,'d','markerfacecolor','w','markeredgecolor','k');
hold on
h4=plot(negt,negTri,'d','markerfacecolor','k','markeredgecolor','k');
ylabel('Trial Number')
xlabel ('Latency')
xlim([-0.1 0.5])
ylim([0 max(negTri)])
legend ('pos','neg')
title('Distribution of Peaks by latency and trials')

%% Make through to through M170 template
load A191
th=2*max(abs(A191avg.avg(1:nearest(A191avg.time,0))));
deadSamples=round(0.06*A191.fsample); % 0.06 for 60ms dead time
% find throughs on average curves
[peaks, Ipeaks]=findPeaks(-A191avg.avg,0,deadSamples);
thi=find(peaks>th);
negPeaks=peaks(thi);negIpeaks=Ipeaks(thi);negTpeaks=A191avg.time(negIpeaks)
mi=nearest(negTpeaks,0.17);
upToPeak=smooth(-A191avg.avg(1:negIpeaks(mi)),20)';
d=diff(upToPeak(1:end-20));
begi=find(d<0,1,'last')+1;
fromPeak=smooth(-A191avg.avg(negIpeaks(mi):end),20)';
d=diff(fromPeak(20:end));
endi=find(d>0,1)+negIpeaks(mi)+20;
sm=smooth(A191avg.avg,5);
femto=10^15;
template170=A191avg.avg(begi:endi);
figure;
plot(A191avg.time(1:(begi-1)),femto*sm(1:(begi-1)),'k-','LineWidth',3)
hold on
plot(A191avg.time(begi:1:endi),femto*smooth(template170,5),'k--','LineWidth',3)
plot(A191avg.time((endi+1):end),femto*sm((endi+1):end),'k-','LineWidth',3)
ylabel('Amplitude (fT)')
xlabel ('Latency')
legend ('whole trace','template')
if ~exist('template170TtoT','file')
    save template170TtoT template170
end
%% Look for through to through M170 in the data
load A191
load template170TtoT
cfg=[];
cfg.channel = 'A191';
cfg.deadSamples = 60;
cfg.template = -template170;
Peaks=peaks1c1f(cfg,A191);
[post,negt,posTri,negTri]=peakPosNeg1c(Peaks,cfg.channel);

[n1,x1]=hist(post,50);
[n2,x2]=hist(negt,50);
figure;
h1=bar(x1,n1,'hist');
hold on
h2=bar(x2,n2,'hist');
set(h2,'edgecolor','k')
set(h2,'facecolor','k')
set(h1,'edgecolor','k')
set(h1,'facecolor','w')
legend ('pos','neg')
ylim([0 75]);
title('Count of Peaks by time bins')
xlabel ('Latency')
ylabel('Number of Events')


figure;
h3=plot(post,posTri,'d','markerfacecolor','w','markeredgecolor','k');
hold on
h4=plot(negt,negTri,'d','markerfacecolor','k','markeredgecolor','k');
ylabel('Trial Number')
xlabel ('Latency')
xlim([-0.1 0.5])
ylim([0 max(negTri)])
legend ('pos','neg')
title('Distribution of Peaks by latency and trials')


%% show freq_analysis
% FIXME there's a bias to wide templates
cd /home/yuval/Data/Amyg/1
if ~exist('TF.mat','file')
    load datacln;
    cfg              = [];
    cfg.keeptrials   = 'yes';
    cfg.output       = 'pow';
    cfg.channel      = 'all';
    cfg.method       = 'mtmconvol';
    cfg.foi          = 2:2:30;    % freq of interest
    cfg.t_ftimwin    = 1./cfg.foi;
    cfg.toi          = -0.2:0.001:0.5;
    cfg.tapsmofrq    = 1;
    cfg.trials       = 'all';
    cfg.tail         = []; % pad the template with zeros, 'beg' 'end' 'both' or [] for no padding
    cfg.feedback     = 'yes';
    [TF,wlt] = freqanalysis_triang_temp(cfg, datacln);
    save /home/yuval/Data/Amyg/1/TF TF wlt -v7.3
else
    load TF
end
% cfg=[];
% cfg.layout='4D248.lay';
% cfg.interactive='yes';
% cfg.xlim=[0 0.5];
% ft_multiplotTFR(cfg,TF)
figure;
plot(TF.time,squeeze(mean(TF.powspctrm(:,22,5,:),1)))
title('average SNR trace for A191 100ms (10Hz) template')
a191TF=squeeze(TF.powspctrm(:,22,:,:));
a191TF=squeeze(mean(a191TF(1:100,:,:)));
a191TF=flipud(a191TF);
X=TF.time;
Y=[2:2:30];
Y=round(1000.*ones(size(Y))./Y);
figure('OuterPosition',[500 500 400 300]);
imagesc(X,Y,a191TF);
xlim([0 0.5])
xlabel ('Latency')
ylabel('template width (ms)')
%% triang temp, histogram based time-freq

load A191
sr=A191.fsample;
x=[-0.2:0.015:0.7];
Npos=zeros(size(x));
Nneg=Npos;
wltCount=0;
freqs=[3.4 60];
% setting window widths as odd numbers for templates to have a peak in the
% middle, and 10 sample diff between windows covering the freq range of
% interest
widths=[10*floor(sr/freqs(2)/10)+1:10:10*ceil(sr/freqs(1)/10)+1];

cfg=[];
cfg.channel = 'A191';
for wlti=widths
    wltCount=wltCount+1;
    cfg.template=window(@triang,wlti)';
    %cfg.deadSamples = round(N*6/10);
    cfg.deadSamples = 60;
    Peaks=peaks1c1f(cfg,A191);
    [post,negt,posTri,negTri]=peakPosNeg1c(Peaks,cfg.channel);
    n1=hist(post,x);
    n2=hist(negt,x);
    Npos(wltCount,:)=n1;
    Nneg(wltCount,:)=n2;
    display([num2str(wlti),' samples template'])
end

% Y=freqs;
% Y=round(1000.*ones(size(Y))./Y);
figure('OuterPosition',[500 500 400 300]);
imagesc(x,widths,Nneg);
xlabel ('Latency')
ylabel('template width (ms)')
title('count of NEGATIVE peaks per latency time bin and template width')
figure('OuterPosition',[500 500 400 300]);
imagesc(x,widths,Npos);
xlabel ('Latency')
ylabel('template width (ms)')
title('count of POSITIVE peaks per latency time bin and template width')

figure;
imagesc(x,widths,Npos-Nneg);
title('Npos - Nneg')

%% deterend to detect higher frequencies
load A191
sr=A191.fsample;
x=[-0.2:0.015:0.7];
Npos=zeros(size(x));
Nneg=Npos;
wltCount=0;
freqs=[3.4 60];
% setting window widths as odd numbers for templates to have a peak in the
% middle, and 10 sample diff between windows covering the freq range of
% interest
widths=[10*floor(sr/freqs(2)/10)+1:10:10*ceil(sr/freqs(1)/10)+1];

cfg=[];
cfg.channel = 'A191';
for wlti=widths
    wltCount=wltCount+1;
    cfg.template=window(@triang,wlti)';
    %cfg.deadSamples = round(N*6/10);
    cfg.deadSamples = 60;
    Peaks=peaksDetrended(cfg,A191);
    [post,negt,posTri,negTri]=peakPosNeg1c(Peaks,cfg.channel);
    n1=hist(post,x);
    n2=hist(negt,x);
    Npos(wltCount,:)=n1;
    Nneg(wltCount,:)=n2;
    display([num2str(wlti),' samples template'])
end

% Y=freqs;
% Y=round(1000.*ones(size(Y))./Y);
figure('OuterPosition',[500 500 400 300]);
imagesc(x,widths,Nneg);
xlabel ('Latency')
ylabel('template width (ms)')
title('count of NEGATIVE peaks per latency time bin and template width')
figure('OuterPosition',[500 500 400 300]);
imagesc(x,widths,Npos);
xlabel ('Latency')
ylabel('template width (ms)')
title('count of POSITIVE peaks per latency time bin and template width')

figure;
imagesc(x,widths,Npos-Nneg);
title('Npos - Nneg')
