
%% Make a template based on the averaged data
cd /home/yuval/Data/Amyg/1
load datacln
cfg=[];
cfg.trials=1:100;
cfg.channel='A191';
cfg.feedback='no';
A191a=ft_preprocessing(cfg,datacln);
cfg.trials=101:200;
A191b=ft_preprocessing(cfg,datacln);
cfg.trials='all';
A191=ft_preprocessing(cfg,datacln);
cfg=[];
cfg.feedback='no';
A191aAvg=ft_timelockanalysis(cfg,A191a);
A191bAvg=ft_timelockanalysis(cfg,A191b);

plot(A191aAvg.avg,'k--','LineWidth',3)
hold on
plot(A191bAvg.avg,'k-','LineWidth',3)
legend('  1 to 100','101 to 200')

th=2*max(abs(A191avg.avg(1:nearest(A191avg.time,0))));
deadSamples=round(0.06*A191.fsample); % 0.06 for 60ms dead time
% find positive peaks on average curves
[peaks, Ipeaks]=findPeaks(A191avg.avg,0,deadSamples);
thi=find(peaks>th);
posPeaks=peaks(thi);posIpeaks=Ipeaks(thi);posTpeaks=A191avg.time(posIpeaks);
% find negative peaks
[peaks, Ipeaks]=findPeaks(-A191avg.avg,0,deadSamples);
thi=find(peaks>th);
negPeaks=peaks(thi);negIpeaks=Ipeaks(thi);negTpeaks=A191avg.time(negIpeaks);



% M170 template based on 75 trials
cfg=[];
cfg.trials=1:75;
cfg.feedback='no';
A191avg=ft_timelockanalysis(cfg,A191);
mi=nearest(negTpeaks,0.17);
upToPeak=smooth(-A191avg.avg(1:negIpeaks(mi)),20)';
begi=find(fliplr(upToPeak)<0,1);
begi=length(upToPeak)-begi+2;
fromPeak=smooth(-A191avg.avg(negIpeaks(mi):end),20)';
endi=find(fromPeak<0,1);
endi=negIpeaks(mi)+endi-2;
template170=A191avg.avg(begi:endi);
femto=10^15;
sm=smooth(A191avg.avg,5);


%% Look for M170 template in the data

cfg=[];
cfg.channel = 'A191';
cfg.deadSamples = 60;
cfg.template = -template170;
Peaks=peaks1c1f(cfg,A191);
[post,negt,posTri,negTri]=peakPosNeg1c(Peaks,cfg.channel);
[n1,x1]=hist(post,50);
[n2,x2]=hist(negt,50);



%% Make through to through M170 template

th=2*max(abs(A191avg.avg(1:nearest(A191avg.time,0))));
deadSamples=round(0.06*A191.fsample); % 0.06 for 60ms dead time
% find throughs on average curves
[peaks, Ipeaks]=findPeaks(-A191avg.avg,0,deadSamples);
thi=find(peaks>th);
negPeaks=peaks(thi);negIpeaks=Ipeaks(thi);negTpeaks=A191avg.time(negIpeaks)
mi=nearest(negTpeaks,0.17);
upToPeak=smooth(-A191avg.avg(1:negIpeaks(mi)),20)';
d=diff(upToPeak(1:end-20));
begi2=find(d<0,1,'last')+1;
fromPeak=smooth(-A191avg.avg(negIpeaks(mi):end),20)';
d=diff(fromPeak(20:end));
endi2=find(d>0,1)+negIpeaks(mi)+20;
sm=smooth(A191avg.avg,5);
femto=10^15;
template170w=A191avg.avg(begi2:endi2);


%% Look for through to through M170 in the data

cfg=[];
cfg.channel = 'A191';
cfg.deadSamples = 60;
cfg.template = -template170w;
Peaks2=peaks1c1f(cfg,A191);
[post2,negt2,posTri2,negTri2]=peakPosNeg1c(Peaks2,cfg.channel);
% make figures
figure('OuterPosition',[100 100 1500 1000]);
subplot(2,3,1)
plot(A191avg.time(1:(begi-1)),femto*sm(1:(begi-1)),'k-','LineWidth',3)
hold on
plot(A191avg.time(begi:1:endi),femto*template170(1:1:end),'k--','LineWidth',3)
plot(A191avg.time((endi+1):end),femto*sm((endi+1):end),'k-','LineWidth',3)
ylabel('Amplitude (fT)')
xlabel ('Latency')
legend ('whole trace','template')
subplot(2,3,2);
h3=plot(post,posTri,'d','markerfacecolor','w','markeredgecolor','k');
hold on
h4=plot(negt,negTri,'d','markerfacecolor','k','markeredgecolor','k');
ylabel('Trial Number')
xlabel ('Latency')
xlim([-0.1 0.5])
ylim([0 max(negTri)])
legend ('pos','neg')
title('Distribution of Peaks by latency and trials')
subplot(2,3,3)
h1=bar(x1,n1,'hist');
hold on
h2=bar(x2,n2,'hist');
set(h2,'edgecolor','k')
set(h2,'facecolor','k')
set(h1,'edgecolor','k')
set(h1,'facecolor','w')
legend ('pos','neg')
ylim([0 100]);
title('Count of Peaks by time bins')
xlabel ('Latency')
ylabel('Number of Events')


subplot(2,3,4)
plot(A191avg.time(1:(begi2-1)),femto*sm(1:(begi2-1)),'k-','LineWidth',3)
hold on
plot(A191avg.time(begi2:1:endi2),femto*smooth(template170w,5),'k--','LineWidth',3)
plot(A191avg.time((endi2+1):end),femto*sm((endi2+1):end),'k-','LineWidth',3)
ylabel('Amplitude (fT)')
xlabel ('Latency')
legend ('whole trace','template')
subplot(2,3,6)
[n3,x3]=hist(post2,50);
[n4,x4]=hist(negt2,50);
h3=bar(x3,n3,'hist');
hold on
h4=bar(x4,n4,'hist');
set(h4,'edgecolor','k')
set(h4,'facecolor','k')
set(h3,'edgecolor','k')
set(h3,'facecolor','w')
legend ('pos','neg')
ylim([0 100]);
title('Count of Peaks by time bins')
xlabel ('Latency')
ylabel('Number of Events')


subplot(2,3,5)
h5=plot(post2,posTri2,'d','markerfacecolor','w','markeredgecolor','k');
hold on
h6=plot(negt2,negTri2,'d','markerfacecolor','k','markeredgecolor','k');
ylabel('Trial Number')
xlabel ('Latency')
xlim([-0.1 0.5])
ylim([0 max(negTri2)])
legend ('pos','neg')
% title('Distribution of Peaks by latency and trials')


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

