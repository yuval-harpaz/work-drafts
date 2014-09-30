function LFfigSim

cd /home/yuval/Dropbox/MEG/LF/data
load ratioSim2
ratio=squeeze(ratio(2,:,:))';
X=[reps,fliplr(reps)];
Y=[min(ratio),fliplr(max(ratio))];
load fields
r31=corr(field31,fieldCl');
r50=corr(field50,fieldCl');

figure;
%set(p,'Font','TimesNewRoman','FontSize',16)
%plot(reps,mean(ratio),'lineWidth',2,'Color',[0 0 0]
plot(reps,r31,'Color',[0.7 0.7 0.7],'LineWidth',2)
set(gca,'FontSize',16,'FontName','Times')
hold on
plot(reps,r50,'--','Color',[0.7 0.7 0.7],'LineWidth',2)
integ=(r31-r50)/2+mean(ratio);
plot(reps,integ,'k','LineWidth',2)
plot(400,integ(4),'ko')
fill(X,Y,[0.7 0.7 0.7],'LineStyle','none')
title('Cleaning Quality by N cycles')
l1=legend('corr to 31Hz','corr to 50Hz','corr + loss integration','optimal N cycles','range of signal loss');
set(l1,'location','southeast','box','off');
xlabel({'N Cycles',' '})
ylabel('| loss of signal (ratio) |   correlation (r)     |')

box off
%% fields

cfg=[];
cfg.interpolation      = 'linear';
cfg.zlim=[0 30];
cfg.comment='no';

figure;
topoplot248(10^12*field31,cfg);
set(gca,'Fontsize',20,'FontName','times')
set(gcf,'color','w')
title('31Hz, Raw')
colorbar
figure;
topoplot248(10^12*field50,cfg);
set(gca,'Fontsize',20,'FontName','times')
set(gcf,'color','w')
title('50Hz, Raw')
colorbar
cfg.zlim=[0 8];

figure;
topoplot248(10^12*fieldCl(1,:),cfg);
set(gca,'Fontsize',20,'FontName','times')
set(gcf,'color','w')
title('50Hz, N = 100')
colorbar
figure;
topoplot248(10^12*fieldCl(4,:),cfg);
set(gca,'Fontsize',20,'FontName','times')
set(gcf,'color','w')
title('50Hz, N = 400')
colorbar

