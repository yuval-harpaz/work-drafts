gaM=ft_timelockgrandaverage([],avgM2,avgM4,avgM6,avgM8,avgM10,avgM12,avgM14,avgM16,avgM18);
gaE=ft_timelockgrandaverage([],avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);
cfg=[];
cfg.layout='WG32.lay';
cfg.interactive='yes';
ft_multiplotER(cfg,gaE);


cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
ft_multiplotER(cfg,gaM);


gafM=ft_freqgrandaverage([],megLR2,megLR4,megLR6,megLR8,megLR10,megLR12,megLR14,megLR16,megLR18);
gafE=ft_freqgrandaverage([],eegLR2,eegLR4,eegLR6,eegLR8,eegLR10,eegLR12,eegLR14,eegLR16,eegLR18);
gafMrest=ft_freqgrandaverage([],megLR100,megLR102);
gafErest=ft_freqgrandaverage([],eegLR100,eegLR102);
% cfg=[];
% cfg.layout='WG32.lay';
% cfg.interactive='yes';
% cfg.xlim=[9 11];
% ft_topoplotER(cfg,gafE);
% 
% figure;
% cfg=[];
% cfg.layout='4D248.lay';
% cfg.interactive='yes';
% cfg.xlim=[9 11];
% ft_topoplotER(cfg,gafM);



figure;
cfg=[];
cfg.xlim=[10 10];
cfg.comment='no';
cfg.layout='WG32.lay';
cfg.zlim=[-0.3 0.3];
subplot(2,2,1)
ft_topoplotER(cfg,gafE);
subplot(2,2,3)
ft_topoplotER(cfg,gafErest);
cfg.layout='4D248.lay';
cfg.zlim=[-2e-27 2e-27];
subplot(2,2,2)
ft_topoplotER(cfg,gafM);
subplot(2,2,4)
ft_topoplotER(cfg,gafMrest);



gaCohM=ft_freqgrandaverage([],megCoh2,megCoh4,megCoh6,megCoh8,megCoh10,megCoh12,megCoh14,megCoh16,megCoh18);
gaCohE=ft_freqgrandaverage([],eegCoh2,eegCoh4,eegCoh6,eegCoh8,eegCoh10,eegCoh12,eegCoh14,eegCoh16,eegCoh18);
gaCohMrest=ft_freqgrandaverage([],megCoh100,megCoh102);
gaCohErest=ft_freqgrandaverage([],eegCoh100,eegCoh102);
figure;
cfg=[];
cfg.xlim=[10 10];
cfg.comment='no';
cfg.zlim=[0 1];
cfg.layout='WG32.lay';
subplot(2,2,1)
ft_topoplotER(cfg,gaCohE);
cfg.layout='4D248.lay';
subplot(2,2,2)
ft_topoplotER(cfg,gaCohM);
cfg.layout='WG32.lay';
subplot(2,2,3)
ft_topoplotER(cfg,gaCohErest);
cfg.layout='4D248.lay';
subplot(2,2,4)
ft_topoplotER(cfg,gaCohMrest);


