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
