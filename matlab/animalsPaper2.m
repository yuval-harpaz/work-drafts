
%% plot peak distribution
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
set(h2,'facecolor','k')
set(h2,'edgecolor','k')
set(h1,'facecolor','w')
whitebg([0.5 0.5 0.5]);
legend ('pos','neg')
title('Count of Peaks by time bins')

figure;
plot(post,posTri,'w.')
hold on
plot(negt,negTri,'k.')
ylabel('Trial Number')
xlabel ('Latency')

%% realign
clear
cd /home/yuval/Data/Amyg/1
load datacln
cfg=[];
cfg.trials=1:100;
cfg.channel='A191';
A191=ft_preprocessing(cfg,datacln);
A191avg=ft_timelockanalysis([],A191);
plot(A191avg.time,A191avg.avg)
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

% M100 template
mi=nearest(posTpeaks,0.1)
upToPeak=smooth(A191avg.avg(1:posIpeaks(mi)),20)';
begi=find(fliplr(upToPeak)<0,1);
begi=length(upToPeak)-begi+2;
fromPeak=smooth(A191avg.avg(posIpeaks(mi):end),20)';
endi=find(fromPeak<0,1);
endi=posIpeaks(mi)+endi-2;
template100=A191avg.avg(begi:endi);
plot(template100)

% M170 template
mi=nearest(negTpeaks,0.17)
upToPeak=smooth(-A191avg.avg(1:negIpeaks(mi)),20)';
begi=find(fliplr(upToPeak)<0,1);
begi=length(upToPeak)-begi+2;
fromPeak=smooth(-A191avg.avg(negIpeaks(mi):end),20)';
endi=find(fromPeak<0,1);
endi=negIpeaks(mi)+endi-2;
template170=A191avg.avg(begi:endi);
plot(template170)

% M250 template
mi=nearest(posTpeaks,0.25)
upToPeak=smooth(A191avg.avg(1:posIpeaks(mi)),20)';
begi=find(fliplr(upToPeak)<0,1);
begi=length(upToPeak)-begi+2;
fromPeak=smooth(A191avg.avg(posIpeaks(mi):end),20)';
endi=find(fromPeak<0,1);
endi=posIpeaks(mi)+endi-2;
template250=A191avg.avg(begi:endi);
plot(template250)
M250win=[A191avg.time(begi) A191avg.time(endi)];

%% look for M170 temp in data
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
for ti=1:length(peaks.chan{1,chani}.trial)
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
set(h2,'facecolor','k')
set(h2,'edgecolor','k')
set(h1,'facecolor','w')
whitebg([0.5 0.5 0.5]);
legend ('pos','neg')
title('Count of Peaks by time bins')

figure;
plot(post,posTri,'w.')
hold on
plot(negt,negTri,'k.')
ylabel('Trial Number')
xlabel ('Latency')


% FIXME change M250win to M170win
A191M170=peakSorter('A191',Peaks,M250win,A191.trialinfo,'pos','biggest','noWlts');
RAdata=zeros(size(Peaks.wlt{1,1}));
[~,samp0]=max(smooth(Peaks.wlt{1,1},20)); % the peak in the template
trCount=0;
for condi=[100:2:106]
    pks=[];
    eval(['pks=A191M170.cond',num2str(condi),'pos.timewin{1,1};'])
    for triali=1:size(pks,1)
        trCount=trCount+1;
        samp=find(A191.time{1,1}==pks(triali,2)); % the peak in the trial
        samp1=samp-samp0+1; % first sample to take from the trial to make the new template
        samp2=samp+(length(Peaks.wlt{1,1})-samp0);
        RAdata(trCount,1:length(Peaks.wlt{1,1}))=A191.trial{1,pks(triali,1)}(1,samp1:samp2);
    end
end
        
% RAtemp=mean(RAdata,1);

[~, score] = princomp(RAdata');
RAtemp=score(:,1)';
endsamp=samp0+find(RAtemp(samp0:end)<RAtemp(1),1)-1; % cut smeared end
RAtemp=RAtemp(1:endsamp);

% second realignmet
Peaks2=struct;
Peaks2.label{1,1}='A191';
Peaks2.wlt{1,1}=RAtemp;
% baseline correction for the template
tapBlc = Peaks2.wlt{1,1}-mean(Peaks2.wlt{1,1});
% normalizing the template
tmplt=tapBlc./sqrt(sum(tapBlc.*tapBlc));
% find max point for the template
[~,time0]=max(tmplt);
t=A191avg.time;

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
    Peaks2.chan{1,1}.trial{1,triali}.time=[];
    Peaks2.chan{1,1}.trial{1,triali}.SNR=[];
    Peaks2.chan{1,1}.trial{1,triali}.wlti=1;
%     SNR=squeeze(data.powspctrm(triali,1,1,:));
    try
        [SigPeaks, SigIpeaks] = findPeaks(abs(SNRn),1,deadSamples, 'MAD');
        if ~isempty(SigIpeaks)
            Peaks2.chan{1,1}.trial{1,triali}.time=t(SigIpeaks);
            Peaks2.chan{1,1}.trial{1,triali}.SNR=SNRn(SigIpeaks);
            %peaks.chan{1,chani}.trial{1,triali}.wlti=[peaks.chan{1,chani}.trial{1,triali}.wlti,maxi];
        end
    end
    if isempty(Peaks2.chan{1,1}.trial{1,triali}.time)
        display(['nothoing for trial ',num2str(triali)]);
    else
        % spectrum(triali,1,1:length(SNRn),1) = SNRn;
        display(num2str(triali))
    end
end

A191RA=peakSorter('A191',Peaks2,M250win,A191.trialinfo,'pos','biggest','noWlts');
RAdata2=zeros(size(RAtemp));
[~,samp0]=max(smooth(RAtemp,20)); % the peak in the template
trCount=0;
for condi=[100:2:106]
    pks=[];
    eval(['pks=A191RA.cond',num2str(condi),'pos.timewin{1,1};'])
    for triali=1:size(pks,1)
        trCount=trCount+1;
        samp=find(A191.time{1,1}==pks(triali,2)); % the peak in the trial
        samp1=samp-samp0+1; % first sample to take from the trial to make the new template
        samp2=samp+(length(RAtemp)-samp0);
        RAdata2(trCount,1:length(RAtemp))=A191.trial{1,pks(triali,1)}(1,samp1:samp2);
    end
end
        
% Peaks=mean(RAdata,1);
avg2=mean(RAdata2,1);
[~, score] = princomp(RAdata2');
RAtemp2=score(:,1)';
figure;plot(RAtemp2)
endsamp=samp0+find(RAtemp(samp0:end)<RAtemp(1),1)-1; % cut smeared end
RAtemp=RAtemp(1:endsamp);


% plot Peaks (looking for avg M250 temp)


% plot Peaks (looking for avg M250 temp)
post=[];negt=[];
posTri=[];negTri=[];
chani=1;
for ti=1:length(peaks.chan{1,chani}.trial)
    try
        p=Peaks2.chan{1,chani}.trial{1,ti}.time(1,Peaks2.chan{1,chani}.trial{1,ti}.SNR>0);
        post=[post,p];
        posTri=[posTri,ti.*ones(size(p))];
    end
    
    try
        n=Peaks2.chan{1,chani}.trial{1,ti}.time(1,Peaks2.chan{1,chani}.trial{1,ti}.SNR<0);
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
set(h2,'facecolor','k')
set(h2,'edgecolor','k')
set(h1,'facecolor','w')
whitebg([0.5 0.5 0.5]);
legend ('pos','neg')
title('Count of Peaks2 by time bins')

figure;
plot(post,posTri,'w.')
hold on
plot(negt,negTri,'k.')
ylabel('Trial Number')
xlabel ('Latency')


%% look for through to through M170 temp in data
mi=nearest(negTpeaks,0.17);
upToPeak=smooth(-A191avg.avg(1:negIpeaks(mi)),20)';
d=diff(upToPeak(1:end-20));
begi=find(d<0,1,'last')+1;
% begi=find(fliplr(upToPeak)<0,1);
% begi=length(upToPeak)-begi+2;
fromPeak=smooth(-A191avg.avg(negIpeaks(mi):end),20)';
d=diff(fromPeak(20:end));
endi=find(d>0,1)+negIpeaks(mi)+20;
sm=smooth(-A191avg.avg,20);
figure;plot(sm);
hold on
plot([begi endi],sm([begi endi]),'r.')
template170=A191avg.avg(begi:endi);
plot([begi:endi],-template170,'b')

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
for ti=1:length(peaks.chan{1,chani}.trial)
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
set(h2,'facecolor','k')
set(h2,'edgecolor','k')
set(h1,'facecolor','w')
whitebg([0.5 0.5 0.5]);
legend ('pos','neg')
title('Count of Peaks by time bins')

figure;
plot(post,posTri,'w.')
hold on
plot(negt,negTri,'k.')
ylabel('Trial Number')
xlabel ('Latency')


M170win=[A191avg.time(begi+20) A191avg.time(endi-20)];
A191M170=peakSorter('A191',Peaks,M170win,A191.trialinfo,'neg','biggest','noWlts');
RAdata=zeros(size(Peaks.wlt{1,1}));
[~,samp0]=max(smooth(Peaks.wlt{1,1},20)); % the peak in the template
trCount=0;
for condi=[100:2:106]
    pks=[];
    eval(['pks=A191M170.cond',num2str(condi),'neg.timewin{1,1};'])
    for triali=1:size(pks,1)
        trCount=trCount+1;
        samp=find(A191.time{1,1}==pks(triali,2)); % the peak in the trial
        samp1=samp-samp0+1; % first sample to take from the trial to make the new template
        samp2=samp+(length(Peaks.wlt{1,1})-samp0);
        RAdata(trCount,1:length(Peaks.wlt{1,1}))=A191.trial{1,pks(triali,1)}(1,samp1:samp2);
    end
end
        
% RAtemp=mean(RAdata,1);

[~, score] = princomp(RAdata');
RAtemp=score(:,1)';
%endsamp=samp0+find(RAtemp(samp0:end)<RAtemp(1),1)-1; % cut smeared end
%RAtemp=RAtemp(1:endsamp);

% second realignmet
Peaks2=struct;
Peaks2.label{1,1}='A191';
Peaks2.wlt{1,1}=-RAtemp;
% baseline correction for the template
tapBlc = Peaks2.wlt{1,1}-mean(Peaks2.wlt{1,1});
% normalizing the template
tmplt=tapBlc./sqrt(sum(tapBlc.*tapBlc));
% find max point for the template
[~,time0]=max(tmplt);
t=A191avg.time;

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
    Peaks2.chan{1,1}.trial{1,triali}.time=[];
    Peaks2.chan{1,1}.trial{1,triali}.SNR=[];
    Peaks2.chan{1,1}.trial{1,triali}.wlti=1;
%     SNR=squeeze(data.powspctrm(triali,1,1,:));
    try
        [SigPeaks, SigIpeaks] = findPeaks(abs(SNRn),1,deadSamples, 'MAD');
        if ~isempty(SigIpeaks)
            Peaks2.chan{1,1}.trial{1,triali}.time=t(SigIpeaks);
            Peaks2.chan{1,1}.trial{1,triali}.SNR=SNRn(SigIpeaks);
            %peaks.chan{1,chani}.trial{1,triali}.wlti=[peaks.chan{1,chani}.trial{1,triali}.wlti,maxi];
        end
    end
    if isempty(Peaks2.chan{1,1}.trial{1,triali}.time)
        display(['nothoing for trial ',num2str(triali)]);
    else
        % spectrum(triali,1,1:length(SNRn),1) = SNRn;
        display(num2str(triali))
    end
end

A191RA=peakSorter('A191',Peaks2,M170win,A191.trialinfo,'neg','biggest','noWlts');
RAdata2=zeros(size(RAtemp));
[~,samp0]=max(smooth(RAtemp,20)); % the peak in the template
trCount=0;
for condi=[100:2:106]
    pks=[];
    eval(['pks=A191RA.cond',num2str(condi),'neg.timewin{1,1};'])
    for triali=1:size(pks,1)
        trCount=trCount+1;
        samp=find(A191.time{1,1}==pks(triali,2)); % the peak in the trial
        samp1=samp-samp0+1; % first sample to take from the trial to make the new template
        samp2=samp+(length(RAtemp)-samp0);
        RAdata2(trCount,1:length(RAtemp))=A191.trial{1,pks(triali,1)}(1,samp1:samp2);
    end
end
        
% Peaks=mean(RAdata,1);
avg2=mean(RAdata2,1);
[~, score] = princomp(RAdata2');
RAtemp2=score(:,1)';
figure;plot(RAtemp2)
endsamp=samp0+find(RAtemp(samp0:end)<RAtemp(1),1)-1; % cut smeared end
RAtemp=RAtemp(1:endsamp);


% plot Peaks (looking for avg M250 temp)


% plot Peaks (looking for avg M250 temp)
post=[];negt=[];
posTri=[];negTri=[];
chani=1;
for ti=1:length(peaks.chan{1,chani}.trial)
    try
        p=Peaks2.chan{1,chani}.trial{1,ti}.time(1,Peaks2.chan{1,chani}.trial{1,ti}.SNR>0);
        post=[post,p];
        posTri=[posTri,ti.*ones(size(p))];
    end
    
    try
        n=Peaks2.chan{1,chani}.trial{1,ti}.time(1,Peaks2.chan{1,chani}.trial{1,ti}.SNR<0);
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
set(h2,'facecolor','k')
set(h2,'edgecolor','k')
set(h1,'facecolor','w')
whitebg([0.5 0.5 0.5]);
legend ('pos','neg')
title('Count of Peaks2 by time bins')

figure;
plot(post,posTri,'w.')
hold on
plot(negt,negTri,'k.')
ylabel('Trial Number')
xlabel ('Latency')

%% look for M250 temp in data
Peaks=struct;
Peaks.label{1,1}='A191';
Peaks.wlt{1,1}=template250;
% baseline correction for the template
tapBlc = Peaks.wlt{1,1}-mean(Peaks.wlt{1,1});
% normalizing the template
tmplt=tapBlc./sqrt(sum(tapBlc.*tapBlc));
% find max point for the template
[~,time0]=max(tmplt);
t=A191avg.time;

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

A191M250=peakSorter('A191',Peaks,M250win,A191.trialinfo,'pos','biggest','noWlts');
RAdata=zeros(size(Peaks.wlt{1,1}));
[~,samp0]=max(smooth(Peaks.wlt{1,1},20)); % the peak in the template
trCount=0;
for condi=[100:2:106]
    pks=[];
    eval(['pks=A191M250.cond',num2str(condi),'pos.timewin{1,1};'])
    for triali=1:size(pks,1)
        trCount=trCount+1;
        samp=find(A191.time{1,1}==pks(triali,2)); % the peak in the trial
        samp1=samp-samp0+1; % first sample to take from the trial to make the new template
        samp2=samp+(length(Peaks.wlt{1,1})-samp0);
        RAdata(trCount,1:length(Peaks.wlt{1,1}))=A191.trial{1,pks(triali,1)}(1,samp1:samp2);
    end
end
        
% RAtemp=mean(RAdata,1);

[~, score] = princomp(RAdata');
RAtemp=score(:,1)';
endsamp=samp0+find(RAtemp(samp0:end)<RAtemp(1),1)-1; % cut smeared end
RAtemp=RAtemp(1:endsamp);

% second realignmet
Peaks2=struct;
Peaks2.label{1,1}='A191';
Peaks2.wlt{1,1}=RAtemp;
% baseline correction for the template
tapBlc = Peaks2.wlt{1,1}-mean(Peaks2.wlt{1,1});
% normalizing the template
tmplt=tapBlc./sqrt(sum(tapBlc.*tapBlc));
% find max point for the template
[~,time0]=max(tmplt);
t=A191avg.time;

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
    Peaks2.chan{1,1}.trial{1,triali}.time=[];
    Peaks2.chan{1,1}.trial{1,triali}.SNR=[];
    Peaks2.chan{1,1}.trial{1,triali}.wlti=1;
%     SNR=squeeze(data.powspctrm(triali,1,1,:));
    try
        [SigPeaks, SigIpeaks] = findPeaks(abs(SNRn),1,deadSamples, 'MAD');
        if ~isempty(SigIpeaks)
            Peaks2.chan{1,1}.trial{1,triali}.time=t(SigIpeaks);
            Peaks2.chan{1,1}.trial{1,triali}.SNR=SNRn(SigIpeaks);
            %peaks.chan{1,chani}.trial{1,triali}.wlti=[peaks.chan{1,chani}.trial{1,triali}.wlti,maxi];
        end
    end
    if isempty(Peaks2.chan{1,1}.trial{1,triali}.time)
        display(['nothoing for trial ',num2str(triali)]);
    else
        % spectrum(triali,1,1:length(SNRn),1) = SNRn;
        display(num2str(triali))
    end
end

A191RA=peakSorter('A191',Peaks2,M250win,A191.trialinfo,'pos','biggest','noWlts');
RAdata2=zeros(size(RAtemp));
[~,samp0]=max(smooth(RAtemp,20)); % the peak in the template
trCount=0;
for condi=[100:2:106]
    pks=[];
    eval(['pks=A191RA.cond',num2str(condi),'pos.timewin{1,1};'])
    for triali=1:size(pks,1)
        trCount=trCount+1;
        samp=find(A191.time{1,1}==pks(triali,2)); % the peak in the trial
        samp1=samp-samp0+1; % first sample to take from the trial to make the new template
        samp2=samp+(length(RAtemp)-samp0);
        RAdata2(trCount,1:length(RAtemp))=A191.trial{1,pks(triali,1)}(1,samp1:samp2);
    end
end
        
% Peaks=mean(RAdata,1);
avg2=mean(RAdata2,1);
[~, score] = princomp(RAdata2');
RAtemp2=score(:,1)';
figure;plot(RAtemp2)
endsamp=samp0+find(RAtemp(samp0:end)<RAtemp(1),1)-1; % cut smeared end
RAtemp=RAtemp(1:endsamp);


% plot Peaks (looking for avg M250 temp)
post=[];negt=[];
posTri=[];negTri=[];
chani=1;
for ti=1:length(peaks.chan{1,chani}.trial)
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
set(h2,'facecolor','k')
set(h2,'edgecolor','k')
set(h1,'facecolor','w')
whitebg([0.5 0.5 0.5]);
legend ('pos','neg')
title('Count of Peaks by time bins')

figure;
plot(post,posTri,'w.')
hold on
plot(negt,negTri,'k.')
ylabel('Trial Number')
xlabel ('Latency')

% plot Peaks (looking for avg M250 temp)
post=[];negt=[];
posTri=[];negTri=[];
chani=1;
for ti=1:length(peaks.chan{1,chani}.trial)
    try
        p=Peaks2.chan{1,chani}.trial{1,ti}.time(1,Peaks2.chan{1,chani}.trial{1,ti}.SNR>0);
        post=[post,p];
        posTri=[posTri,ti.*ones(size(p))];
    end
    
    try
        n=Peaks2.chan{1,chani}.trial{1,ti}.time(1,Peaks2.chan{1,chani}.trial{1,ti}.SNR<0);
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
set(h2,'facecolor','k')
set(h2,'edgecolor','k')
set(h1,'facecolor','w')
whitebg([0.5 0.5 0.5]);
legend ('pos','neg')
title('Count of Peaks2 by time bins')

figure;
plot(post,posTri,'w.')
hold on
plot(negt,negTri,'k.')
ylabel('Trial Number')
xlabel ('Latency')
%% show freq_analysis

load /home/yuval/Data/Amyg/1/TF100
cfg=[];
cfg.layout='4D248.lay';
ft_multiplotTFR(cfg,TF)
figure;
plot(TF.time,squeeze(mean(TF.powspctrm(:,22,1,:),1)))
title('average SNR trace for A191 100ms (10Hz) template')
%% show M100 issue

cd('/home/yuval/Data/Amyg/1');
load win
load peaks
[~,chani]=ismember('A191',peaks.label);
pos100=peakSorter('A191',peaks,win100,ones(length(peaks.chan{1,chani}.trial),1),'pos','biggest','noWlts');
% pos100=peakSorter(chP,peaks,win100,ones(length(peaks.chan{1,chani}.trial),1),'pos','biggest');
%figure;hist(pos100.cond1pos.timewin{1,1}(:,4))
trials=1:length(peaks.chan{1,1}.trial);
trialsM100=pos100.cond1pos.timewin{1,1}(:,1);
trialsNoM100=trials(setxor(trialsM100,1:length(trials)))';
load datacln
minN=min(length(trialsM100),length(trialsNoM100)); % to compare equal num of trials
cfg=[];
cfg.trials=trialsM100(1:minN);
M100=ft_timelockanalysis(cfg,datacln);
cfg.trials=trialsNoM100(1:minN);
noM100=ft_timelockanalysis(cfg,datacln);

cfg=[];
cfg.channel='A191';
figure;ft_singleplotER(cfg,M100,noM100);


load /home/yuval/Data/Amyg/peakM100A191
chP='A191';timewin=[0.075 0.135];
load /home/yuval/Data/Amyg/A191Alpha
subi= 1;
sub=num2str(subi);
cd(['/home/yuval/Data/Amyg/',sub]);
subFreq=freqs(subi);
subWin=round(1000/subFreq)./1000;
load peaks
t100=peakM100(subi,3);
halfWin=0.015;
tbeg=t100-halfWin-subWin;
tend=t100+halfWin-subWin;
timewindow=[tbeg tend];
chP='A191';
[~,chani]=ismember(chP,peaks.label);
pos100=peakSorter(chP,peaks,timewindow,ones(length(peaks.chan{1,chani}.trial),1),'pos','biggest','noWlts');
neg100=peakSorter(chP,peaks,timewindow,ones(length(peaks.chan{1,chani}.trial),1),'neg','biggest','noWlts');
trials=1:length(peaks.chan{1,1}.trial);
trialsM100=pos100.cond1pos.timewin{1,1}(:,1);
trialsNoM100=neg100.cond1neg.timewin{1,1}(:,1);
load datacln
minN=min(length(trialsM100),length(trialsNoM100)); % to compare equal num of trials
cfg=[];
cfg.trials=trialsM100(1:minN);
M100=ft_timelockanalysis(cfg,datacln);
cfg.trials=trialsNoM100(1:minN);
noM100=ft_timelockanalysis(cfg,datacln);
cfg=[];
cfg.channel=chP;
figure;
subplot(1,2,1)
plot(M100.time,M100.avg(chani,:));
hold on
plot(M100.time,noM100.avg(chani,:),'r');
ylim([-7e-13 7e-13])
legend('positive peaks','negative peaks');
xp=M100.avg(chani,:);xn=noM100.avg(chani,:);
subplot(1,2,2)
plot(M100.time,(xp-xn)./2)
hold on;plot(M100.time,(xp+xn)./2,'r')
legend('(positive-negative)/2','(positive+negative)/2');

%% compare conditions, M250
cd /home/yuval/Data/Amyg/1
load datacln
cfg              = [];
cfg.keeptrials = 'yes';
cfg.output       = 'pow';
cfg.channel      = 'A191';
cfg.method       = 'mtmconvol';
cfg.foi          = 20;    % freq of interest
cfg.t_ftimwin    = 1./cfg.foi;
cfg.toi          = -0.2:0.001:0.5;
cfg.tapsmofrq  = 1;
cfg.trials='all';%[1:2];
cfg.tail=[]; % pad the template with zeros, 'beg' 'end' 'both' or [] for no padding
[TF,wlt] = freqanalysis_triang_temp(cfg, datacln);


peaks=peaksInTrials1freq(TF,wlt);
chP='A191';[~,chani]=ismember(chP,peaks.label);
posPeaks=peakSorter(chP,peaks,[0.08 0.13;0.2 0.3],datacln.trialinfo,'pos','earliest','noWlts');


[~,chani]=ismember(chP,datacln.label);
%amp=datacln.trialinfo;
halfWin=2;snrThr=0.8;
trialinfo=ampLatByCond(datacln.trialinfo,posPeaks,2,datacln,chani,halfWin,snrThr);

trialinfoNoNaN=trialinfo(find(~isnan(trialinfo(:,2))),:);
animals=trialinfoNoNaN(trialinfoNoNaN(:,1)==100,2:3);
landscape=trialinfoNoNaN(trialinfoNoNaN(:,1)==102,2:3);
fruits=trialinfoNoNaN(trialinfoNoNaN(:,1)==104,2:3);
vehicles=trialinfoNoNaN(trialinfoNoNaN(:,1)==106,2:3);

anN=sum(trialinfo(:,1)==100);ann=sum(trialinfoNoNaN(:,1)==100);
laN=sum(trialinfo(:,1)==102);lan=sum(trialinfoNoNaN(:,1)==102);
frN=sum(trialinfo(:,1)==104);frn=sum(trialinfoNoNaN(:,1)==104);
veN=sum(trialinfo(:,1)==106);ven=sum(trialinfoNoNaN(:,1)==106);
anR=ann/anN;
allR=(lan+frn+ven)/(laN+frN+veN);
binomStat(anN,ann,allR)

[~,p,~,stat]=ttest2(animals(:,2),landscape(:,2)); % latency
[~,p,~,stat]=ttest2(animals(:,1),landscape(:,1)); % amplitude
[~,p,~,stat]=ttest2(animals(:,2),vehicles(:,2));
[~,p,~,stat]=ttest2(animals(:,2),fruits(:,2));
all=[landscape(:,2);fruits(:,2)];
[~,p,~,stat]=ttest2(animals(:,2),all)

X1=animals(:,2);X2=landscape(:,2);X3=fruits(:,2);X4=vehicles(:,2);
X=[X1;X2;X3;X4];
g1=ones(size(X1));g2=2*ones(size(X2));g3=3*ones(size(X3));g4=4*ones(size(X4));
group=[g1;g2;g3;g4];
[p,table,stats] = anova1(X,group,'on')


figure;
plot(animals(:,2),'r.');
hold on;
plot(landscape(:,2),'g.')
legend('animals','landscape')
figure;
plot(animals(:,1),'r.');
hold on;
plot(landscape(:,1),'g.')
legend('animals','landscape')



cfg=[];
cfg.channel='A191';
cfg.trials=find(datacln.trialinfo(:,1)==100);
anim=ft_timelockanalysis(cfg,datacln);
cfg.trials=find(datacln.trialinfo(:,1)==102);
land=ft_timelockanalysis(cfg,datacln);
cfg.trials=find(datacln.trialinfo(:,1)==104);
frui=ft_timelockanalysis(cfg,datacln);
cfg.trials=find(datacln.trialinfo(:,1)==106);
vehi=ft_timelockanalysis(cfg,datacln);
ft_singleplotER([],anim,land,frui,vehi)
legend('animals','landscape','fruits','vehicles')
plot(mean(animals(:,2)),0,'o')
plot(mean(landscape(:,2)),0,'ro')
plot(mean(vehicles(:,2)),0,'ko')
plot(mean(fruits(:,2)),0,'go')

%% M170

negPeaks=peakSorter(chP,peaks,[0.14 0.24],datacln.trialinfo,'neg','biggest','noWlts');

[~,chani]=ismember(chP,datacln.label);
%amp=datacln.trialinfo;
halfWin=2;snrThr=0.9;
trialinfo=ampLatByCond(datacln.trialinfo,negPeaks,1,datacln,chani,halfWin,snrThr);

trialinfoNoNaN=trialinfo(find(~isnan(trialinfo(:,2))),:);
animals=trialinfoNoNaN(trialinfoNoNaN(:,1)==100,2:3);
landscape=trialinfoNoNaN(trialinfoNoNaN(:,1)==102,2:3);
fruits=trialinfoNoNaN(trialinfoNoNaN(:,1)==104,2:3);
vehicles=trialinfoNoNaN(trialinfoNoNaN(:,1)==106,2:3);

anN=sum(trialinfo(:,1)==100);ann=sum(trialinfoNoNaN(:,1)==100);
laN=sum(trialinfo(:,1)==102);lan=sum(trialinfoNoNaN(:,1)==102);
frN=sum(trialinfo(:,1)==104);frn=sum(trialinfoNoNaN(:,1)==104);
veN=sum(trialinfo(:,1)==106);ven=sum(trialinfoNoNaN(:,1)==106);
anR=ann/anN;
allR=(lan+frn+ven)/(laN+frN+veN);
binomStat(anN,ann,allR)


y=trialinfoNoNaN(:,3);
wts=ones(length(y),1);
x=1:length(y);
x=[wts,x'];
[b,bint,r,rint,stats] = regress(y,x)
plot(y)



% % find timewindows of interest
% negt=negt(negTri<101);
% post=post(posTri<101);
% t=datacln.time{1,1};
% edges=t(1:10:end-1)+((t(2)-t(1))./2);
% cn=histc(negt,edges);cp=histc(post,edges);
% R=(cp-cn)/mean([cp cn]); % pos to neg ration
% figure;plot(edges,R,'k');
% maxR=max(abs(R(1:nearest(edges,0))))
% cn=cn(1:end-1);cp=cp(1:end-1); % last value is when t = the end of window
% r=(cp-cn)/mean([cp cn]);
% wpos=find(r>maxR);
% wneg=find(r<-maxR);
%
% winPos=getTwin(edges,wpos);
% winNeg=getTwin(edges,wneg);
% save win winPos winNeg