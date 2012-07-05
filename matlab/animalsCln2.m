sub=12;
sub=num2str(sub);
fileName='hb_c,rfhp0.1Hz';
cd (['/home/yuval/Data/Amyg/',sub])
cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventvalue=[100,102,104,106,108];
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.2;
cfg.trialdef.poststim=0.7;
cfg.trialdef.offset=-0.2;
cfg=ft_definetrial(cfg);
cfg.channel={'MEG','-A74','-A204'};
cfg.demean='yes';
cfg.baselinewindow=[-0.2 0];
% cfg.bpfilter='yes';
% cfg.bpfreq=[3 50];
cfg.hpfilter='yes';
cfg.hpfreq=1;
cfg.baselinewindow=[-0.15 0];
data=ft_preprocessing(cfg);
save data data

cfg.method='summary';
cfg.preproc.hpfilter='yes';
cfg.preproc.hpfreq=60;
datacln=ft_rejectvisual(cfg,data);
cfg=[];
cfg.method='summary';
datacln=ft_rejectvisual(cfg,datacln);
save datacln datacln
trialinfo=datacln.trialinfo;
save trialinfo trialinfo
avg=ft_timelockanalysis([],datacln);
cfg=[];
cfg.interactive='yes';
cfg.layout='4D248.lay';
figure;ft_multiplotER(cfg,avg);