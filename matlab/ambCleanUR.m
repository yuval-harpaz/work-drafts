
sub='25';
condi=2;


cd(['/home/yuval/Data/amb/',sub]);
conds={'Dom','Sub'};
cond=conds{condi};
load ([cond,'UR'],'UR')
cfg=[];
cfg.demean='yes';
cfg.channel={'MEG','-A61'};
UR=ft_preprocessing(cfg,UR);
cfg=[];
cfg.method='pca';
comp=ft_componentanalysis(cfg,UR);
cfg=[];
cfg.channel=comp.label(1:5);
cfg.layout='4D248.lay';
ft_databrowser(cfg,comp)
%%
cfg = [];
cfg.component = [1]; % change
URc = ft_rejectcomponent(cfg, comp);
cfg=[];
URc=ft_rejectvisual(cfg,URc);
display([sub,' ',cond])
eval([cond,'URc=URc;'])
%%
save URc DomURc SubURc
clear *UR*