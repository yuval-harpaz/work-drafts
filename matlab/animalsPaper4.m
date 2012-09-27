%% plot peaks distribution
%   A '^' shaped template 100ms wide (10Hz) is fitted to unaveraged trials
% (one channel only). Signed SNR curves are created for each trial. SNR 
% peaks and throughs represent timing of transient activity in the raw
% data. The timing of these events is displayed for each trial and as a
% histogram for all the trials

cd /home/yuval/Data/Amyg/1
load datacln;
cfg              = [];
cfg.keeptrials = 'yes';
cfg.output       = 'pow';
cfg.channel      = 'A191';
cfg.method       = 'mtmconvol';
cfg.foi          = 10;    % freq of interest
cfg.t_ftimwin    = 1./cfg.foi;
cfg.toi          = -0.2:0.001:0.5;
cfg.tapsmofrq  = 1;
cfg.trials='all';%[1:2];
cfg.tail=[]; % pad the template with zeros, 'beg' 'end' 'both' or [] for no padding
cfg.feedback = 'no';
[TF,wlt] = freqanalysis_triang_temp(cfg, datacln);

peaks=peaksInTrials1freq(TF,wlt);

[~,chani]=ismember('A191',peaks.label);
post=[];negt=[];
posTri=[];negTri=[];
for ti=1:length(peaks.chan{1,chani}.trial)
    try
        p=peaks.chan{1,chani}.trial{1,ti}.time(1,peaks.chan{1,chani}.trial{1,ti}.SNR>0);
        post=[post,p];
        posTri=[posTri,ti.*ones(size(p))];
    end
    
    try
        n=peaks.chan{1,chani}.trial{1,ti}.time(1,peaks.chan{1,chani}.trial{1,ti}.SNR<0);
        negt=[negt,n];
        negTri=[negTri,ti.*ones(size(n))];
    end
end

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

%% Make a template based on the averaged data

cd /home/yuval/Data/Amyg/1
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
title 
ylabel('Amplitude (fT)')
xlabel ('Latency')
legend ('whole trace','template')
save template170 template170
%% look for the M170 template in the data
load A191
load template170
Peaks=struct;
Peaks.label{1,1}='A191';
Peaks.wlt{1,1}=-template170;
% baseline correction for the template
tapBlc = Peaks.wlt{1,1}-mean(Peaks.wlt{1,1});
% normalizing the template
tmplt=tapBlc./sqrt(sum(tapBlc.*tapBlc));
% find max point for the template
[~,time0]=max(tmplt);
t=A191avg.time;
deadSamples=round(0.06*A191.fsample); % 0.06 for 60ms dead time
for triali=1:length(A191.trial)
    x=A191.trial{1,triali};
    % do the fit
    [SNR,SigX,sigSign]=fitTemp(x,tmplt,time0);
    %             sx=smooth(x,10);
    %             pos=sx>0;neg=-(sx<0);posneg=pos+neg;
    %             SNRn=SNR.*posneg';
    SNRn=SNR.*sigSign;
    
    %         firstSamp=true;
    %         lastSamp=false;
    ispeak=false;
    %pkCount=0;
    Peaks.chan{1,1}.trial{1,triali}.time=[];
    Peaks.chan{1,1}.trial{1,triali}.SNR=[];
    Peaks.chan{1,1}.trial{1,triali}.wlti=1;
%     SNR=squeeze(data.powspctrm(triali,1,1,:));
    try
        [SigPeaks, SigIpeaks] = findPeaks(abs(SNRn),1,deadSamples, 'MAD');
        if ~isempty(SigIpeaks)
            Peaks.chan{1,1}.trial{1,triali}.time=t(SigIpeaks);
            Peaks.chan{1,1}.trial{1,triali}.SNR=SNRn(SigIpeaks);
            %peaks.chan{1,chani}.trial{1,triali}.wlti=[peaks.chan{1,chani}.trial{1,triali}.wlti,maxi];
        end
    end
    if isempty(Peaks.chan{1,1}.trial{1,triali}.time)
        display(['nothoing for trial ',num2str(triali)]);
    else
        % spectrum(triali,1,1:length(SNRn),1) = SNRn;
        display(num2str(triali))
    end
end

post=[];negt=[];
posTri=[];negTri=[];
chani=1;
for ti=1:length(Peaks.chan{1,chani}.trial)
    try
        p=Peaks.chan{1,chani}.trial{1,ti}.time(1,Peaks.chan{1,chani}.trial{1,ti}.SNR>0);
        post=[post,p];
        posTri=[posTri,ti.*ones(size(p))];
    end
    
    try
        n=Peaks.chan{1,chani}.trial{1,ti}.time(1,Peaks.chan{1,chani}.trial{1,ti}.SNR<0);
        negt=[negt,n];
        negTri=[negTri,ti.*ones(size(n))];
    end
end

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
figure;
plot(A191avg.time(1:(begi-1)),femto*sm(1:(begi-1)),'k-','LineWidth',3)
hold on
plot(A191avg.time(begi:1:endi),femto*smooth(template170,5),'k--','LineWidth',3)
plot(A191avg.time((endi+1):end),femto*sm((endi+1):end),'k-','LineWidth',3)
title 
ylabel('Amplitude (fT)')
xlabel ('Latency')
legend ('whole trace','template')
save template170 template170
figure;plot(sm);
hold on
plot([begi endi],sm([begi endi]),'r.')
template170=A191avg.avg(begi:endi);
plot([begi:endi],-template170,'k')
save template170TtoT template170
%% look for through to through M170 temp in data
load A191
load template170TtoT

% begi=find(fliplr(upToPeak)<0,1);
% begi=length(upToPeak)-begi+2;


Peaks=struct;
Peaks.label{1,1}='A191';
Peaks.wlt{1,1}=-template170;
% baseline correction for the template
tapBlc = Peaks.wlt{1,1}-mean(Peaks.wlt{1,1});
% normalizing the template
tmplt=tapBlc./sqrt(sum(tapBlc.*tapBlc));
% find max point for the template
[~,time0]=max(tmplt);
t=A191avg.time;
deadSamples=round(0.06*A191.fsample); % 0.06 for 60ms dead time
for triali=1:length(A191.trial)
    x=A191.trial{1,triali};
    % do the fit
    [SNR,SigX,sigSign]=fitTemp(x,tmplt,time0);
    %             sx=smooth(x,10);
    %             pos=sx>0;neg=-(sx<0);posneg=pos+neg;
    %             SNRn=SNR.*posneg';
    SNRn=SNR.*sigSign;
    
    %         firstSamp=true;
    %         lastSamp=false;
    ispeak=false;
    %pkCount=0;
    Peaks.chan{1,1}.trial{1,triali}.time=[];
    Peaks.chan{1,1}.trial{1,triali}.SNR=[];
    Peaks.chan{1,1}.trial{1,triali}.wlti=1;
%     SNR=squeeze(data.powspctrm(triali,1,1,:));
    try
        [SigPeaks, SigIpeaks] = findPeaks(abs(SNRn),1,deadSamples, 'MAD');
        if ~isempty(SigIpeaks)
            Peaks.chan{1,1}.trial{1,triali}.time=t(SigIpeaks);
            Peaks.chan{1,1}.trial{1,triali}.SNR=SNRn(SigIpeaks);
            %peaks.chan{1,chani}.trial{1,triali}.wlti=[peaks.chan{1,chani}.trial{1,triali}.wlti,maxi];
        end
    end
    if isempty(Peaks.chan{1,1}.trial{1,triali}.time)
        display(['nothoing for trial ',num2str(triali)]);
    else
        % spectrum(triali,1,1:length(SNRn),1) = SNRn;
        display(num2str(triali))
    end
end

post=[];negt=[];
posTri=[];negTri=[];
chani=1;
for ti=1:length(Peaks.chan{1,chani}.trial)
    try
        p=Peaks.chan{1,chani}.trial{1,ti}.time(1,Peaks.chan{1,chani}.trial{1,ti}.SNR>0);
        post=[post,p];
        posTri=[posTri,ti.*ones(size(p))];
    end
    
    try
        n=Peaks.chan{1,chani}.trial{1,ti}.time(1,Peaks.chan{1,chani}.trial{1,ti}.SNR<0);
        negt=[negt,n];
        negTri=[negTri,ti.*ones(size(n))];
    end
end
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

load /home/yuval/Data/Amyg/1/TF100
cfg=[];
cfg.layout='4D248.lay';
ft_multiplotTFR(cfg,TF)
figure;
plot(TF.time,squeeze(mean(TF.powspctrm(:,22,1,:),1)))
title('average SNR trace for A191 100ms (10Hz) template')
% %% show M100 issue
% 
% cd('/home/yuval/Data/Amyg/1');
% load win
% load peaks
% [~,chani]=ismember('A191',peaks.label);
% pos100=peakSorter('A191',peaks,win100,ones(length(peaks.chan{1,chani}.trial),1),'pos','biggest','noWlts');
% % pos100=peakSorter(chP,peaks,win100,ones(length(peaks.chan{1,chani}.trial),1),'pos','biggest');
% %figure;hist(pos100.cond1pos.timewin{1,1}(:,4))
% trials=1:length(peaks.chan{1,1}.trial);
% trialsM100=pos100.cond1pos.timewin{1,1}(:,1);
% trialsNoM100=trials(setxor(trialsM100,1:length(trials)))';
% load datacln
% minN=min(length(trialsM100),length(trialsNoM100)); % to compare equal num of trials
% cfg=[];
% cfg.trials=trialsM100(1:minN);
% M100=ft_timelockanalysis(cfg,datacln);
% cfg.trials=trialsNoM100(1:minN);
% noM100=ft_timelockanalysis(cfg,datacln);
% 
% cfg=[];
% cfg.channel='A191';
% figure;ft_singleplotER(cfg,M100,noM100);
% 
% 
% load /home/yuval/Data/Amyg/peakM100A191
% chP='A191';timewin=[0.075 0.135];
% load /home/yuval/Data/Amyg/A191Alpha
% subi= 1;
% sub=num2str(subi);
% cd(['/home/yuval/Data/Amyg/',sub]);
% subFreq=freqs(subi);
% subWin=round(1000/subFreq)./1000;
% load peaks
% t100=peakM100(subi,3);
% halfWin=0.015;
% tbeg=t100-halfWin-subWin;
% tend=t100+halfWin-subWin;
% timewindow=[tbeg tend];
% chP='A191';
% [~,chani]=ismember(chP,peaks.label);
% pos100=peakSorter(chP,peaks,timewindow,ones(length(peaks.chan{1,chani}.trial),1),'pos','biggest','noWlts');
% neg100=peakSorter(chP,peaks,timewindow,ones(length(peaks.chan{1,chani}.trial),1),'neg','biggest','noWlts');
% trials=1:length(peaks.chan{1,1}.trial);
% trialsM100=pos100.cond1pos.timewin{1,1}(:,1);
% trialsNoM100=neg100.cond1neg.timewin{1,1}(:,1);
% load datacln
% minN=min(length(trialsM100),length(trialsNoM100)); % to compare equal num of trials
% cfg=[];
% cfg.trials=trialsM100(1:minN);
% M100=ft_timelockanalysis(cfg,datacln);
% cfg.trials=trialsNoM100(1:minN);
% noM100=ft_timelockanalysis(cfg,datacln);
% cfg=[];
% cfg.channel=chP;
% figure;
% subplot(1,2,1)
% plot(M100.time,M100.avg(chani,:));
% hold on
% plot(M100.time,noM100.avg(chani,:),'r');
% ylim([-7e-13 7e-13])
% legend('positive peaks','negative peaks');
% xp=M100.avg(chani,:);xn=noM100.avg(chani,:);
% subplot(1,2,2)
% plot(M100.time,(xp-xn)./2)
% hold on;plot(M100.time,(xp+xn)./2,'r')
% legend('(positive-negative)/2','(positive+negative)/2');
% 
% %% compare conditions, M250
% cd /home/yuval/Data/Amyg/1
% load datacln
% cfg              = [];
% cfg.keeptrials = 'yes';
% cfg.output       = 'pow';
% cfg.channel      = 'A191';
% cfg.method       = 'mtmconvol';
% cfg.foi          = 20;    % freq of interest
% cfg.t_ftimwin    = 1./cfg.foi;
% cfg.toi          = -0.2:0.001:0.5;
% cfg.tapsmofrq  = 1;
% cfg.trials='all';%[1:2];
% cfg.tail=[]; % pad the template with zeros, 'beg' 'end' 'both' or [] for no padding
% [TF,wlt] = freqanalysis_triang_temp(cfg, datacln);
% 
% 
% peaks=peaksInTrials1freq(TF,wlt);
% chP='A191';[~,chani]=ismember(chP,peaks.label);
% posPeaks=peakSorter(chP,peaks,[0.08 0.13;0.2 0.3],datacln.trialinfo,'pos','earliest','noWlts');
% 
% 
% [~,chani]=ismember(chP,datacln.label);
% %amp=datacln.trialinfo;
% halfWin=2;snrThr=0.8;
% trialinfo=ampLatByCond(datacln.trialinfo,posPeaks,2,datacln,chani,halfWin,snrThr);
% 
% trialinfoNoNaN=trialinfo(find(~isnan(trialinfo(:,2))),:);
% animals=trialinfoNoNaN(trialinfoNoNaN(:,1)==100,2:3);
% landscape=trialinfoNoNaN(trialinfoNoNaN(:,1)==102,2:3);
% fruits=trialinfoNoNaN(trialinfoNoNaN(:,1)==104,2:3);
% vehicles=trialinfoNoNaN(trialinfoNoNaN(:,1)==106,2:3);
% 
% anN=sum(trialinfo(:,1)==100);ann=sum(trialinfoNoNaN(:,1)==100);
% laN=sum(trialinfo(:,1)==102);lan=sum(trialinfoNoNaN(:,1)==102);
% frN=sum(trialinfo(:,1)==104);frn=sum(trialinfoNoNaN(:,1)==104);
% veN=sum(trialinfo(:,1)==106);ven=sum(trialinfoNoNaN(:,1)==106);
% anR=ann/anN;
% allR=(lan+frn+ven)/(laN+frN+veN);
% binomStat(anN,ann,allR)
% 
% [~,p,~,stat]=ttest2(animals(:,2),landscape(:,2)); % latency
% [~,p,~,stat]=ttest2(animals(:,1),landscape(:,1)); % amplitude
% [~,p,~,stat]=ttest2(animals(:,2),vehicles(:,2));
% [~,p,~,stat]=ttest2(animals(:,2),fruits(:,2));
% all=[landscape(:,2);fruits(:,2)];
% [~,p,~,stat]=ttest2(animals(:,2),all)
% 
% X1=animals(:,2);X2=landscape(:,2);X3=fruits(:,2);X4=vehicles(:,2);
% X=[X1;X2;X3;X4];
% g1=ones(size(X1));g2=2*ones(size(X2));g3=3*ones(size(X3));g4=4*ones(size(X4));
% group=[g1;g2;g3;g4];
% [p,table,stats] = anova1(X,group,'on')
% 
% 
% figure;
% plot(animals(:,2),'r.');
% hold on;
% plot(landscape(:,2),'g.')
% legend('animals','landscape')
% figure;
% plot(animals(:,1),'r.');
% hold on;
% plot(landscape(:,1),'g.')
% legend('animals','landscape')
% 
% 
% 
% cfg=[];
% cfg.channel='A191';
% cfg.trials=find(datacln.trialinfo(:,1)==100);
% anim=ft_timelockanalysis(cfg,datacln);
% cfg.trials=find(datacln.trialinfo(:,1)==102);
% land=ft_timelockanalysis(cfg,datacln);
% cfg.trials=find(datacln.trialinfo(:,1)==104);
% frui=ft_timelockanalysis(cfg,datacln);
% cfg.trials=find(datacln.trialinfo(:,1)==106);
% vehi=ft_timelockanalysis(cfg,datacln);
% ft_singleplotER([],anim,land,frui,vehi)
% legend('animals','landscape','fruits','vehicles')
% plot(mean(animals(:,2)),0,'o')
% plot(mean(landscape(:,2)),0,'ro')
% plot(mean(vehicles(:,2)),0,'ko')
% plot(mean(fruits(:,2)),0,'go')
% 
% %% M170
% 
% negPeaks=peakSorter(chP,peaks,[0.14 0.24],datacln.trialinfo,'neg','biggest','noWlts');
% 
% [~,chani]=ismember(chP,datacln.label);
% %amp=datacln.trialinfo;
% halfWin=2;snrThr=0.9;
% trialinfo=ampLatByCond(datacln.trialinfo,negPeaks,1,datacln,chani,halfWin,snrThr);
% 
% trialinfoNoNaN=trialinfo(find(~isnan(trialinfo(:,2))),:);
% animals=trialinfoNoNaN(trialinfoNoNaN(:,1)==100,2:3);
% landscape=trialinfoNoNaN(trialinfoNoNaN(:,1)==102,2:3);
% fruits=trialinfoNoNaN(trialinfoNoNaN(:,1)==104,2:3);
% vehicles=trialinfoNoNaN(trialinfoNoNaN(:,1)==106,2:3);
% 
% anN=sum(trialinfo(:,1)==100);ann=sum(trialinfoNoNaN(:,1)==100);
% laN=sum(trialinfo(:,1)==102);lan=sum(trialinfoNoNaN(:,1)==102);
% frN=sum(trialinfo(:,1)==104);frn=sum(trialinfoNoNaN(:,1)==104);
% veN=sum(trialinfo(:,1)==106);ven=sum(trialinfoNoNaN(:,1)==106);
% anR=ann/anN;
% allR=(lan+frn+ven)/(laN+frN+veN);
% binomStat(anN,ann,allR)
% 
% 
% y=trialinfoNoNaN(:,3);
% wts=ones(length(y),1);
% x=1:length(y);
% x=[wts,x'];
% [b,bint,r,rint,stats] = regress(y,x)
% plot(y)
% 
% 
% 
