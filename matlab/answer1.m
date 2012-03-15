fileName='hb_c,rfhp0.1Hz';
cfg.dataset=fileName;
cfg1=ft_definetrial(cfg);
cfg1.demean='yes';% old version was: cfg1.blc='yes';
cfg1.baselinewindow=[-0.1,0];
nohb=ft_preprocessing(cfg1);
nohbAvg=ft_timelockanalysis([],nohb);
ft_multiplotER(cfg4,nohbAvg,blcAvg)