function alicePlotLR(xlim)

cd /home/yuval/Copy/MEGdata/alice/ga
load GavgMaliceLR1
load GavgEaliceLR1
load GavgMalice
load GavgEalice

figure('position',[20,20,1000,1000]);

subplot(2,2,1)
cfg=[];
cfg.xlim=[xlim xlim];
%cfg.interactive='yes';
cfg.layout='WG32.lay';
cfg.zlim=[];
ft_topoplotER(cfg,GavgEalice);
subplot(2,2,3)
aliceTtest0('GavgEaliceLR1',xlim,1);
% cfg.zlim=[];
% ft_topoplotER(cfg,GavgEaliceLR1);
subplot(2,2,2)
cfg.layout='4D248.lay';
cfg.zlim=[];
ft_topoplotER(cfg,GavgMalice);
subplot(2,2,4)
aliceTtest0('GavgMaliceLR1',xlim,1);
% cfg.zlim=[];
% ft_topoplotER(cfg,GavgMaliceLR1);





