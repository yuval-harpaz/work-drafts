%% averaging by preceding peak to see alpha decay through the trial
cd('/home/yuval/Data/Amyg');
load A191Alpha
load peakM100A191
chP='A191';timewin=[0.075 0.135];

for subi= 1:12
    sub=num2str(subi);
    cd(['/home/yuval/Data/Amyg/',sub]);
    %load peaks
    subFreq=freqs(subi);
    subWin=round(1000/subFreq)./1000;
    %si=[s100-sampWin,s100-round(sampWin./2),s100];
    %chani=peakM100(subji,2);
    %chP=peaks.label{chani};
    t100=peakM100(subi,3);
    halfWin=0.015;
    tbeg=t100-halfWin-subWin;
    tend=t100+halfWin-subWin;
    timewindow=[tbeg tend];
    load peaks
    [~,chani]=ismember(chP,peaks.label);
    pos100=peakSorter(chP,peaks,timewindow,ones(length(peaks.chan{1,chani}.trial),1),'pos','biggest','noWlts');
    neg100=peakSorter(chP,peaks,timewindow,ones(length(peaks.chan{1,chani}.trial),1),'neg','biggest','noWlts');
    % pos100=peakSorter(chP,peaks,win100,ones(length(peaks.chan{1,chani}.trial),1),'pos','biggest');
    %figure;hist(pos100.cond1pos.timewin{1,1}(:,4))
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
    %cfg.layout='4D248.lay';
    %cfg.interactive='yes';
    %cfg.zlim=[-1e-12 1e-12];
    %cfg.showlabels='yes';
    cfg.channel=chP;
    %subplot(2,10,subcount)
    %pkM100=zeros(1,length(M100.time));
    %pkM100(find(M100.time==peakM100(subi,3)))=peakM100(subi,4);
    figure;
    subplot(1,2,1)
    plot(M100.time,M100.avg(chani,:));
    hold on
    plot(M100.time,noM100.avg(chani,:),'r');
    %plot(M100.time,pkM100,'k');
    ylim([-7e-13 7e-13])
    legend('positive peaks','negative peaks');
    xp=M100.avg(chani,:);xn=noM100.avg(chani,:);
    subplot(1,2,2)
    plot(M100.time,(xp-xn))
    hold on;plot(M100.time,(xp+xn),'r')
    legend('positive-negative','positive+negative');
end
