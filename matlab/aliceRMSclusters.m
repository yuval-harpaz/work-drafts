cd /home/yuval/Copy/MEGdata/alice/ga2015
load('gaR.mat')
%load('ga.mat')
load ../ga/GavgM20
load ../ga/GavgE20
load neighbours7cm
cfg=[];
cfg.neighbours=neighbours;
cfg.method='RMS';
MaRMS=clustData(cfg,avgMr);
M20RMS=clustData(cfg,GavgM20);
MaRMS=correctBL(MaRMS,[-0.2 -0.05]);
M20RMS=correctBL(M20RMS,[-0.2 -0.05]);
t=0.1;
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[t t];
cfg.interactive='yes';
%cfg.zlim='maxabs';
cfg.zlim=[-1e-13 1e-13];
figure;ft_topoplotER(cfg,MaRMS,M20RMS);

