%% finding time and amp of A191 M100 for all clean trials
% A191
chP='A191';
timewin=[0.075 0.135];
for subi= [1:12]
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    load peaks
    [~,chani]=ismember(chP,peaks.label);
    load datacln
    avg=ft_timelockanalysis([],datacln);
    t=avg.time;
    sampVec=[nearest(t,timewin(1)):nearest(t,timewin(2))];
    cfg=[];
    cfg.channel=chP;
    cfg.ylim=[-5e-13 5e-13];
     figure;ft_singleplotER(cfg,avg);
     xlabel(['SUB ',sub]);
     hold on;
    [maxv,maxi]=max(smooth(avg.avg(chani,sampVec),5)');
     plot(t(maxi+sampVec(1)-1),maxv,'rx');
     pause
     close all
    peakM100(subi,1:4)=[subi,chani,t(maxi+sampVec(1)-1),maxv];
end
cd('/home/yuval/Data/Amyg');
save peakM100A191 peakM100
%% plot average high and low M100 trials
cd('/home/yuval/Data/Amyg');
load A191Alpha
load peakM100A191
chP='A191';timewin=[0.075 0.135];
for subi= 1:12
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    load peaks
    %chani=peakM100(subji,2);
    %chP=peaks.label{chani};
    t100=peakM100(subi,3);
    halfWin=0.015;
    tbeg=t100-halfWin;
    tend=t100+halfWin;
    timewindow=[tbeg tend];
    load peaks
    [~,chani]=ismember(chP,peaks.label);
    pos100=peakSorter(chP,peaks,timewindow,ones(length(peaks.chan{1,chani}.trial),1),'pos','biggest','noWlts');
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
    %cfg.layout='4D248.lay';
    %cfg.interactive='yes';
    %cfg.zlim=[-1e-12 1e-12];
    %cfg.showlabels='yes';
    cfg.channel=chP;
    %subplot(2,10,subcount)
    pkM100=zeros(1,500);
    pkM100(find(M100.time==peakM100(subi,3)))=peakM100(subi,4);
    figure;
    %ft_singleplotER(cfg,M100,noM100);
    plot(M100.time(1:500),M100.avg(chani,1:500));
    hold on
    plot(M100.time(1:500),noM100.avg(chani,1:500),'r');
    plot(M100.time(1:500),pkM100,'k');
    xlabel(['SUB ',sub,' pow ',num2str(round(amp(subi)*10^27))]);
    ylim([-7e-13 7e-13])
end

%% examining the raw data to test alpha parameters
% testing 9.5min from first trial continuous data
cd('/home/yuval/Data/Amyg');
load peakM100A191
chP='A191';
xc=zeros(1,1018);
for subi= [1:12]
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    load data
    try
        samp1=data.cfg.trl(1,1);
        fileName=data.cfg.dataset;
    catch % subject 2
        samp1=data.cfg.previous.previous.trl(1,1);
        fileName=data.cfg.previous.previous.dataset;
    end
    samp2=samp1+579833; % 9.5min
    
    clear data
    cfg.dataset=fileName;
    cfg.trl=[samp1 samp2 0];
    cfg.continuous='yes';
    cfg.channel=chP;
    cfg.demean='yes';
    cfg.lpfilter='yes';
    cfg.lpfreq=40;
    A191=ft_preprocessing(cfg);
    XC=xcorr(A191.trial{1,1},1017);
    xc(subi,:)=XC(1018:end);
    
end
for subi=1:12
    minxc(subi)=find(diff(xc(subi,:))>0,1);
    i1=minxc(subi);i2=find(diff(xc(subi,i1:end))<0,1);
    maxxc(subi)=i1+i2-1;
end
for subi= 2:12
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    load datacln
    cfg              = [];
    %    cfg.keeptrials = 'yes';
    cfg.output       = 'pow';
    cfg.method       = 'mtmfft';
    cfg.foi          = 8:13;  % freq of interest 3 to 100Hz
    cfg.tapsmofrq  = 1;
    cfg.trials='all';
    cfg.channel='all';
    rawF = ft_freqanalysis(cfg, datacln);
    cfg=[];
    cfg.interactive='yes';
    cfg.highlight='labels';
    cfg.highlightchannels={'A191'};
    cfg.xlim=[9 10];
    cfg.layout='4D248.lay';
    ft_topoplotER(cfg,rawF);
    pause
    close
end
% I chose freqs by hand
freqs=[9 8 10 12 10 9 11 12 11 8 8 11]';
load peakM100A191;
lat=peakM100(:,3);
corr(lat,freqs) % no correlation between alpha and M100 latency

for subi= 1:12
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    load datacln
    cfg              = [];
    %    cfg.keeptrials = 'yes';
    cfg.output       = 'pow';
    cfg.method       = 'mtmfft';
    cfg.foi          = freqs(subi);  % freq of interest 3 to 100Hz
    cfg.tapsmofrq  = 1;
    cfg.trials='all';
    cfg.channel='A191';
    F = ft_freqanalysis(cfg, datacln);
    amp(subi)=squeeze(F.powspctrm);
end
save A191Alpha freqs amp
plot(peakM100(:,4),amp','o')
xlabel('M100 amplitude')
ylabel('alpha power')
corr(peakM100(:,4),amp')
% spctrm=sqrt(amp');
% corr(peakM100(:,4),spctrm)
exi=[1:6 8:11];
M100=peakM100(exi,4);
alphaAmp=amp(exi);
corr(M100,alphaAmp')

%% check pretrigger alpha pow vs M100 amp
cd /home/yuval/Data/Amyg
load peakM100allTrialsSmooth5
for subji= 1:size(peakM100,1)
    sub2=false;
    subi=peakM100(subji,1);
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    load alphainfo
    load datacln
    halfWin=2; % how many samples left and right for M100 to take
    s100=round(1017.25*t100);
    for triali=1:size(M100dist,1);
        data=smooth(datacln.trial{1,M100dist(triali,1)}(chani,:),20)';
        M100dist(triali,4)=max(data(1,s100-halfWin:s100+halfWin)); % amplitude of M100
    end

%     
%     [freq,fourier]=fftYH(raws,Fs);
% fLim=nearest(freq,40)
% plot(freq(1,1:fLim),real(fourier(1,1:fLim)).^2);
% plot(freq(1,1:fLim),real(fourier(2,1:fLim)).^2);

%% check previuos peak as predictor 
cd('/home/yuval/Data/Amyg');
load A191Alpha
chP='A191';
load peakM100A191;
t100=peakM100(:,3);
for subi= 1:12
    prev=[];
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    load datacln
    [~,chani]=ismember(chP,datacln.label);
    s100=nearest(datacln.time{1,1},t100(subi));
    %si=[s100-111,s100-100,s100-91,s100]; % sample index for M100, 41 and 82ms before;
    subFreq=freqs(subi);
    sampWin=round(1017.25/subFreq);
    si=[s100-sampWin,s100-round(sampWin./2),s100];
    for triali=1:length(datacln.trial)
        data=datacln.trial{1,triali}(chani,:);
        data=smooth(data,5);
        prev(triali,1:3)=data(si);
    end
    coef(subi,1:2)=[corr(prev(:,1),prev(:,3)),corr(prev(:,2),prev(:,3))];
    y=prev(:,3);
    X=ones(size(prev(:,1)));X(:,2)=prev(:,1);
    [b,bint,r,rint,stats] = regress(y,X);
    B(subi)=b(2);
    A(subi)=mean(y)-mean(X(:,2)).*b(2);
    F(subi,1:2)=stats(1,2:3);
    subi
end
coef
cd /home/yuval/Data/Amyg
save coef coef freqs peakM100
save reg F B A
%% compare quiet with noisy trials
for subi= 1:12
    rms=[];
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    load datacln
    cfg=[];
    cfg.bpfilter='yes';
    cfg.bpfreq=[7 14];
    cfg.demean='yes';
    cfg.baselinewindow=[-0.15 0];
    dataA=ft_preprocessing(cfg,datacln);
    [~,chani]=ismember(chP,datacln.label);
    s50=nearest(dataA.time{1,1},0.05);
    baseline=[s50-102,s50];
    for triali=1:length(datacln.trial)
        data=dataA.trial{1,triali}(chani,baseline(1):baseline(2));
        pow=data.*data;
        rms(triali)=sqrt(mean(pow));
    end
    trlSmall=find(rms<prctile(rms,50));
    trlBig=find(rms>prctile(rms,50));
    cfg=[];
    cfg.channel='A191';
    cfg.trials=trlBig;
    big=ft_timelockanalysis(cfg,datacln);
    cfg.trials=trlSmall;
    small=ft_timelockanalysis(cfg,datacln);
    figure;
    ft_singleplotER([],big,small);
    title(sub)
end
%% testing conditions after removing alpha effects
cd('/home/yuval/Data/Amyg');
load A191Alpha
chP='A191';
load peakM100A191;
load reg;
t100=peakM100(:,3);
for subi= 1:12
    a=[];y=[];
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    load datacln
    [~,chani]=ismember(chP,datacln.label);
    s100=nearest(datacln.time{1,1},t100(subi));
    subFreq=freqs(subi);
    sampWin=round(1017.25/subFreq);
    sx=s100-sampWin;
    for triali=1:length(datacln.trial)
        data=datacln.trial{1,triali}(chani,:);
        data=smooth(data,5);
        y(triali)=data(s100); % y=bx+a
        x=data(sx);
        if F(subi,2) < 0.05 && B(subi)>0
            a(triali)=y(triali)-B(subi)*x;
        else
            a(triali)=y(triali);
        end
    end
    a100=a(find(datacln.trialinfo==100)); % animals
    a102=a(find(datacln.trialinfo==102)); % landscape
    a104=a(find(datacln.trialinfo==104)); % fruits
    a106=a(find(datacln.trialinfo==106)); % vehicles
    A(subi,1:4)=[mean(a100),mean(a102),mean(a104),mean(a106)];
    Y(subi,1:4)=[mean(y(find(datacln.trialinfo==100))),mean(y(find(datacln.trialinfo==102))),mean(y(find(datacln.trialinfo==104))),mean(y(find(datacln.trialinfo==106)))];
    subi
end
cd ..
save correctedM100 A Y 
[~,p,~,stat]=ttest(A(:,1),mean(A(:,2:4),2))
[~,p,~,stat]=ttest(Y(:,1),mean(Y(:,2:4),2))
% [~,p,~,stat]=ttest(A([1:9 12],1),mean(A([1:9 12],2:4),2))