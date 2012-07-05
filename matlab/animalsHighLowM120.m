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
        data=datacln.trial{1,triali};
        raw(trcount,1)=data(chani,ti);
        %display(num2str(trcount))
    end
    coef(subjCount)=corr(raw,distFromWorst);
end
cd /home/yuval/Data/Amyg
[~,p,~,stat]=ttest(coef)
save dist_M120 coef
    
    
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