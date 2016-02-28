event = ft_read_event(cfg.dataset);
trigger = [event(strcmp('STATUS', {event.type})).value]';
sample  = [event(strcmp('STATUS', {event.type})).sample]';
index=find(trigger>=30 & trigger<=39);
samp0=sample(index);
trl=samp0-102;
trl(:,2)=samp0+512;
trl(:,3)=-102;
cfg.trl=trl;
cfg.channel='EEG';
cfg.demean='yes';
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
data=ft_preprocessing(cfg);

avg=ft_timelockanalysis([],data);
plot(avg.time,avg.avg)
badTrials([],data)
