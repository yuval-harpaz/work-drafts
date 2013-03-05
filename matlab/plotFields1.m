function plotFields1
cd /home/yuval/Dropbox/MEGpaper/files/matlab
load /home/yuval/Documents/Dropbox/MEGpaper/files/matlab/avg25



titlepos=0.65
zlimvar=0.07;

avgD=avgDre;
avgD.avg=10^12*(avgDre.avg+avgDur.avg)./2;
cfg=[];
cfg.layout='4D246.lay';
cfg.xlim = [0.151 0.234];
cfg.interactive='no';
cfg.zlim=[-zlimvar zlimvar];
cfg.comment='no';
cfg.electrodes='';
figure;
subplot(2,3,1);
topoplotER(cfg,avgD);
title('Dominant','FontName','Times','FontSize',30,'Position',[0 titlepos 1]);
subplot(2,3,4);
cfg.xlim = [0.234 0.387];
topoplotER(cfg,avgD);
colorbar('Position',[0.63 0.25 0.02 0.5],'FontName','Times','FontSize',15)
annotation('textbox',[0.65 0.8 0.1 0.08],...
    'String',{'pT'},...
    'FontSize',25,'FontName','Times',...
    'LineStyle','none');
 
avgS.avg=10^12*(avgSre.avg+avgSur.avg)./2;
cfg.xlim = [0.151 0.234];
subplot(2,3,2);
topoplotER(cfg,avgS);
title('Subordinate','FontSize',30,'FontName','Times','Position',[0 titlepos 1]);
subplot(2,3,5);
cfg.xlim = [0.234 0.387];
topoplotER(cfg,avgS);

annotation('textbox',[0.03 0.68 0.1 0.08],...
    'String',{'M170'},...
    'FontSize',30,'FontName','Times',...
    'LineStyle','none');
annotation('textbox',[0.03 0.21 0.1 0.08],...
    'String',{'M350'},...
    'FontSize',30,'FontName','Times',...
    'LineStyle','none');
%% %% diff in fT
avgDiff=avgDre;
avgDiff.avg=10^15*(avgS.avg-avgD.avg);
cfg=[];
cfg.layout='4D246.lay';
cfg.xlim = [0.151 0.234];
cfg.interactive='no';
cfg.zlim=[-10 10];
cfg.comment='no';
cfg.electrodes='';
%figure;
subplot(2,3,3);
topoplotER(cfg,avgDiff);
title('Sub-Dom','FontSize',30,'FontName','Times','Position',[0 0.7 1]);



subplot(2,3,6);
cfg.xlim = [0.234 0.387];
topoplotER(cfg,avgDiff);
title('','FontSize',30,'FontName','Times','Position',[0 0.7 1]);
annotation('textbox',[0.92 0.8 0.1 0.08],...
    'String',{'fT'},...
    'FontSize',25,'FontName','Times',...
    'LineStyle','none');
%colorbar [0.63 0.8 0.1 0.08]
%colorbar('XAxisLocation','top','Position',[0.91 0.25 0.02 0.5],'FontName','Times','FontSize',20) 
colorbar('Position',[0.91 0.25 0.02 0.5],'FontName','Times','FontSize',20) 
