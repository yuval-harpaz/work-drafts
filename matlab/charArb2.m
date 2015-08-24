

load data TRL
cfg=[];
cfg.trl=TRL;
cfg.dataset=source;
cfg.demean='yes';
cfg.channel='MEG';
%cfg.feedback='no';
cfg.hpfilter='yes';
cfg.hpfreq=1;
data=ft_preprocessing(cfg);
cfg=[];
cfg.method='summary';
cfg.preproc.hpfilter='yes';
cfg.preproc.hpfreq=60;
datacln=ft_rejectvisual(cfg,data);
save datacln.mat datacln -v7.3