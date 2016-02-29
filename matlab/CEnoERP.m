cd /home/yuval/Data/Daniel
DIR=dir('6*')
Subs={DIR(:).name}';
for subi=1:length(Subs)
    cd /home/yuval/Data/Daniel
    cd(Subs{subi})
    DIR=dir('*.bdf');
    cfg=[];
    cfg.dataset=DIR.name;
    event = ft_read_event(cfg.dataset);
    trigger = [event(strcmp('STATUS', {event.type})).value]';
    sample  = [event(strcmp('STATUS', {event.type})).sample]';
    index=find(trigger>=30 & trigger<=39);
    samp0=sample(index);
    trl=samp0-512;
    trl(:,2)=samp0+512;
    trl(:,3)=-512;
    cfg.trl=trl;
    cfg.channel={'all','-Status','-EXG8'};
    cfg.reref         = 'yes';
    cfg.refchannel    = [69 70];
    cfg.demean='yes';
    cfg.baselinewindow=[-0.25 -0.15];
    cfg.bpfilter='yes';
    cfg.bpfreq=[1 40];
    data=ft_preprocessing(cfg);
    avg=ft_timelockanalysis([],data);
    badChanI=std(avg.avg')>5;
    badChan=data.label(badChanI);
    cfg=[];
    cfg.badChan=badChan;
    trials=badTrials(cfg,data,0);
    cfg=[];
    cfg.trials=trials;
    %badTrials([],data)
    avg=ft_timelockanalysis(cfg,data);
    time=avg.time;
    avg=avg.avg;
    avg(badChanI,:)=0;
    AVG(1:64,1:1025,subi)=avg(1:64,:);
    disp(['XXXXXXX ',Subs{subi},' XXXXXXX'])
end
figure;plot(time,squeeze(mean(AVG,3)))
gavg=ft_timelockanalysis([],data);
gavg.avg=squeeze(mean(AVG,3));
gavg.label=gavg.label(1:64);
cfg=[];
cfg.xlim=[0.1 0.1];
cfg.interactive='yes';
cfg.layout='biosemi64';
ft_topoplotER(cfg,gavg)