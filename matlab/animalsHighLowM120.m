%% average high and low M100 trials
for subi= [1:6 8:11]
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    load win
    load peaks
    [~,chani]=ismember(chP,peaks.label);
    pos100=peakSorter(chP,peaks,win100,ones(length(peaks.chan{1,chani}.trial),1),'pos','biggest','noWlts');
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
    figure;ft_singleplotER(cfg,M100,noM100);
    xlabel(['SUB ',sub]);
end

%% find pretrig alpha phase
subjCount=0;
for subi= [1:6 8:11]
    subjCount=subjCount+1;
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    load win
    load peaks
    [~,chani]=ismember(chP,peaks.label);
    posPre=peakSorter(chP,peaks,[-0.05 0.04],ones(length(peaks.chan{1,chani}.trial),1),'pos','biggest','noWlts');
    t100=mean(win100);
    tBest=t100-0.1;tWorst=tBest-0.05;
    distFromWorst=abs(posPre.cond1pos.timewin{1,1}(:,2)-tWorst);
    load datacln
    ti=nearest(datacln.time{1,1},t100);
    trcount=0;raw=[];
    tind=[posPre.cond1pos.timewin{1,1}(:,1)]';
    for triali=tind;
        trcount=trcount+1;
        % data=smooth(datacln.trial{1,triali}(chani,:),5)';
        % raw(trcount,1)=data(1,ti);
        halfWin=10;
        raw(trcount,1)=max(datacln.trial{1,triali}(chani,ti-halfWin:ti+halfWin));
        %display(num2str(trcount))
    end
    coef(subjCount)=corr(raw,distFromWorst);
    display(['done with sub',sub])
end
cd /home/yuval/Data/Amyg
[~,p,~,stat]=ttest(coef)
save dist_M120 coef


%% get peak time for each sub
subCount=0;
for subi= [1:6 8:11]
    subCount=subCount+1;
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    load win
    load peaks
    [~,chani]=ismember(chP,peaks.label);
    pos100=peakSorter(chP,peaks,win100,ones(length(peaks.chan{1,chani}.trial),1),'pos','biggest','noWlts');
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
%     cfg=[];
%     cfg.channel=chP;
%     figure;ft_singleplotER(cfg,M100);
%     xlabel(['SUB ',sub]);
%     hold on;
    [maxv,maxi]=max(M100.avg(chani,255:560));
%     plot(M100.time(maxi+255-1),maxv,'rx');
%     pause
%     close all
    peakM100(subCount,1:4)=[subi,chani,M100.time(maxi),maxv];
end
cd /home/yuval/Data/Amyg
save peakM100 peakM100

subCount=0;
for subi= [1:6 8:11]
    subCount=subCount+1;
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    load win
    load peaks
    [~,chani]=ismember(chP,peaks.label);
    load datacln
    avg=ft_timelockanalysis([],datacln);
    cfg=[];
    cfg.channel=chP;
    cfg.ylim=[-5e-13 5e-13];
%     figure;ft_singleplotER(cfg,avg);
%     xlabel(['SUB ',sub]);
%     hold on;
    [maxv,maxi]=max(smooth(avg.avg(chani,255:430),5)');
%     plot(avg.time(maxi+255-1),maxv,'rx');
%     pause
%     close all
    peakM100(subCount,1:4)=[subi,chani,avg.time(maxi+255-1),maxv];
end
cd /home/yuval/Data/Amyg
save peakM100allTrialsSmooth5 peakM100

%% check pretrig phase of alpha

% first we check peak freq for pretrigger second
cd /home/yuval/Data/Amyg
load peakM100allTrialsSmooth5
for subji= 1:size(peakM100,1)
    sub2=false;
     subi=peakM100(subji,1);
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    cfg=[];
    cfg.dataset='hb_c,rfhp0.1Hz';
    if ~exist('hb_c,rfhp0.1Hz','file')
        cfg.dataset='c,rfhp0.1Hz';
        warning('using uncleaned data')
        sub2=true;
    end
    chani=peakM100(subji,2);
    load datacln
    if sub2
        trlx=datacln.cfg.previous.previous.previous.previous.trl(:,1);
        badx=datacln.cfg.artifact(:,1);
        badx=[badx;datacln.cfg.previous.artifact(:,1)];
    else
        trlx=datacln.cfg.previous.trl(:,1);
        badx=datacln.cfg.artifact(:,1);
    end
    trlyNew=setxor(trlx,badx);
    cfg.trl=trlyNew-1017;
    cfg.trl(:,2)=trlyNew;
    cfg.trl(:,3)=-1;
    cfg.channel=datacln.label{chani};
    pre=ft_preprocessing(cfg)
    cfg              = [];
    cfg.keeptrials = 'yes';
    cfg.output       = 'pow';
    cfg.method       = 'mtmfft';
    cfg.foi          = 8:13;  % freq of interest 3 to 100Hz
    cfg.tapsmofrq  = 1;
    cfg.trials='all';
    preF = ft_freqanalysis(cfg, pre);
    save preF preF;
    sq=squeeze(preF.powspctrm(:,1,:));
    [Fv,Fi]=max(sq');
    Fi=preF.freq(Fi);
    alphainfo=datacln.trialinfo;
    alphainfo(:,2)=Fi;
    alphainfo(:,3)=Fv;
    save alphainfo alphainfo
    display(['done with sub',sub]);
end
% choose trials with greter than thr alpha and where the peak was not 8 or
% 13Hz
cd /home/yuval/Data/Amyg
load peakM100allTrialsSmooth5
for subji= 1:size(peakM100,1)
    subi=peakM100(subji,1);
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    load alphainfo
    thr=prctile(alphainfo(:,3),25);
    passthr=alphainfo(:,3)>thr;
    ispeak=round(alphainfo(:,2))>8 & round(alphainfo(:,2))<13;
    trfreq=alphainfo(:,2).*ispeak.*passthr;
    save trfreq trfreq
end
% determine angle of M100
cd /home/yuval/Data/Amyg
load peakM100allTrialsSmooth5
for subji= 1:size(peakM100,1)
    subi=peakM100(subji,1);
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    load trfreq
    load peaks
    chani=peakM100(subji,2);
    chP=peaks.label{chani};
    t100=peakM100(subji,3);
    cycle=1/9;
    tend=t100-cycle./2;
    tbeg=t100-1.5*cycle;
    timewindow=[tbeg tend];
    posPre=peakSorter(chP,peaks,timewindow,ones(length(peaks.chan{1,chani}.trial),1),'pos','biggest','noWlts');
    
    trcount=0;M100dist=[];
    for triali=1:length(posPre.cond1pos.timewin{1,1})
        trnum=posPre.cond1pos.timewin{1,1}(triali,1);
        if ~trfreq(trnum,1)==0
            trcount=trcount+1;
            M100dist(trcount,1)=trnum; %trial number
            M100dist(trcount,2)=t100-posPre.cond1pos.timewin{1,1}(triali,2); % distance
            Angle=M100dist(trcount,2)/(1/trfreq(trnum,1)/360);
            Angle=Angle-360*floor(Angle/360); % in case there is more than 360
            M100dist(trcount,3)=Angle; % angle
        end
    end
    load datacln
    halfWin=2; % how many samples left and right for M100 to take
    s100=round(1017.25*t100);
    for triali=1:size(M100dist,1);
        data=smooth(datacln.trial{1,M100dist(triali,1)}(chani,:),20)';
        M100dist(triali,4)=max(data(1,s100-halfWin:s100+halfWin)); % amplitude of M100
    end
%    figure;plot(M100dist(:,3),M100dist(:,4),'.')
%    title([num2str(halfWin*2+1),' samples'])
    save(['../M100dist',sub], 'M100dist')
%     alpha=circ_ang2rad(M100dist(:,3));
%     y=M100dist(:,4);
%     cftool(alpha,y);
%     pause
%     display('aha');
%             
%         tBest=t100-trfreq(triali,1);
%     0.1;tWorst=tBest-0.05;
%     distFromWorst=abs(posPre.cond1pos.timewin{1,1}(:,2)-tWorst);
end
cd /home/yuval/Data/Amyg
for subji= 1:size(peakM100,1)
    subi=peakM100(subji,1);
    sub=num2str(subi);
    load(['M100dist',sub])
    subplot(2,10,subji)
    plot(M100dist(:,3),M100dist(:,4),'.')
    ylim([-1.5e-12,1.5e-12])
    title([num2str(peakM100(subji,3)),' ',num2str(peakM100(subji,4))])
end
avg=ft_timelockanalysis([],datacln);
avg.time=0;
avg.avg=zeros(246,1);
for subji= 1:size(peakM100,1)
    subi=peakM100(subji,1);
    sub=num2str(subi);
    %load(['M100dist',sub])
    subplot(2,10,10+subji)
%     plot(M100dist(:,3),M100dist(:,4),'.')
%     ylim([-1.5e-12,1.5e-12])
cfg=[];
cfg.layout='4D248.lay';
cfg.marker='off';
cfg.highlight='on';
cfg.highlightchannel=avg.label(peakM100(subji,2));
cfg.comment='no';
    ft_topoplotER(cfg,avg)
end


%% trying one chan for all
load peakM100allTrialsSmooth5
gAvg=zeros(246,1);
for subji= 1:size(peakM100,1)
    subi=peakM100(subji,1);
    sub=num2str(subi);
    subCount=subCount+1;
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
%     load win
%     load peaks
%     [~,chani]=ismember(chP,peaks.label);
    load datacln
    avg=ft_timelockanalysis([],datacln);
    gAvg=gAvg+avg.avg(:,nearest(avg.time,peakM100(subji,3)))
%     cfg=[];
%     cfg.channel=chP;
%     cfg.ylim=[-5e-13 5e-13];
% %     figure;ft_singleplotER(cfg,avg);
% %     xlabel(['SUB ',sub]);
% %     hold on;
%     [maxv,maxi]=max(smooth(avg.avg(chani,255:430),5)');
% %     plot(avg.time(maxi+255-1),maxv,'rx');
% %     pause
% %     close all
%     peakM100(subCount,1:4)=[subi,chani,avg.time(maxi+255-1),maxv];
end
gAvg=gAvg./subji;
avg.time=0;
avg.avg=gAvg;
cfg=[];
cfg.layout='4D248.lay';
cfg.marker='labels';
% cfg.highlight='on';
% cfg.highlightchannel=avg.label(peakM100(subji,2));
cfg.comment='no';
cfg.interactive='yes';
ft_topoplotER(cfg,avg);
% chose 'A191'; chani=22
chani=22;chP='A191';
%
cd /home/yuval/Data/Amyg
load peakM100allTrialsSmooth5
for subji= 1:size(peakM100,1)
    subi=peakM100(subji,1);
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    load trfreq
    load peaks
    %chani=peakM100(subji,2);
    %chP=peaks.label{chani};
    t100=peakM100(subji,3);
    cycle=1/9;
    tend=t100-cycle./2;
    tbeg=t100-1.5*cycle;
    timewindow=[tbeg tend];
    posPre=peakSorter(chP,peaks,timewindow,ones(length(peaks.chan{1,chani}.trial),1),'pos','biggest','noWlts');
    
    trcount=0;M100dist=[];
    for triali=1:length(posPre.cond1pos.timewin{1,1})
        trnum=posPre.cond1pos.timewin{1,1}(triali,1);
        if ~trfreq(trnum,1)==0
            trcount=trcount+1;
            M100dist(trcount,1)=trnum; %trial number
            M100dist(trcount,2)=t100-posPre.cond1pos.timewin{1,1}(triali,2); % distance
            Angle=M100dist(trcount,2)/(1/trfreq(trnum,1)/360);
            Angle=Angle-360*floor(Angle/360); % in case there is more than 360
            M100dist(trcount,3)=Angle; % angle
        end
    end
    load datacln
    halfWin=2; % how many samples left and right for M100 to take
    s100=round(1017.25*t100);
    for triali=1:size(M100dist,1);
        data=smooth(datacln.trial{1,M100dist(triali,1)}(chani,:),20)';
        M100dist(triali,4)=max(data(1,s100-halfWin:s100+halfWin)); % amplitude of M100
    end
%    figure;plot(M100dist(:,3),M100dist(:,4),'.')
%    title([num2str(halfWin*2+1),' samples'])
    save(['../M100A191dist',sub], 'M100dist')
%     alpha=circ_ang2rad(M100dist(:,3));
%     y=M100dist(:,4);
%     cftool(alpha,y);
%     pause
%     display('aha');
%             
%         tBest=t100-trfreq(triali,1);
%     0.1;tWorst=tBest-0.05;
%     distFromWorst=abs(posPre.cond1pos.timewin{1,1}(:,2)-tWorst);
end
cd /home/yuval/Data/Amyg
for subji= 1:size(peakM100,1)
    subi=peakM100(subji,1);
    sub=num2str(subi);
    load(['M100A191dist',sub])
    subplot(2,10,subji)
    plot(M100dist(:,3),M100dist(:,4),'.')
    ylim([-1.5e-12,1.5e-12])
    title([num2str(peakM100(subji,3)),' ',num2str(peakM100(subji,4))])
end

 subji=1 %1:10
    subi=peakM100(subji,1);
    sub=num2str(subi);
    load(['M100A191dist',sub])
    alpha=circ_ang2rad(M100dist(:,3));
    y=M100dist(:,4);
    cftool(alpha,y);
for subi=1:10
    eval(['Phase(subi)=fittedmodel',num2str(subi),'.c1;']);
end
save Phase Phase
circ_mean(Phase')
% tests wheather the mean angle is sig'ly different than 270
[h mu ul ll]=circ_mtest(Phase',circ_ang2rad(270));

% testing circular-linear correlation
cd /home/yuval/Data/Amyg
load peakM100allTrialsSmooth5
alpha=[];x=[];
for subji= 1:size(peakM100,1)
    subi=peakM100(subji,1);
    sub=num2str(subi);
    load(['M100A191dist',sub])
    [rho pval]=circ_corrcl(M100dist(:,3),M100dist(:,4));
	sd=std(M100dist(:,4));
    mn=mean(M100dist(:,4));
    zs=(M100dist(:,4)-mn)./sd;
    alpha=[alpha M100dist(:,3)'];
    x=[x zs'];
    r(subji)=rho;
end
plot(alpha,x,'.')
[rho pval]=circ_corrcl(alpha,x)
cftool(circ_ang2rad(alpha),x);

%     display('aha');
%             
%         tBest=t100-trfreq(triali,1);
%     0.1;tWorst=tBest-0.05;
%     distFromWorst=abs(posPre.cond1pos.timewin{1,1}(:,2)-tWorst);