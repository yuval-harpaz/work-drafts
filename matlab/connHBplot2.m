function connHBplot2
win0t=0:0.1:0.6;
win0=round(2034.5*win0t);

cd /media/yuval/win_disk/Data/connectomeDB/MEG
load posCorr70
load posCorrPCA
posCorrHB(2,:)=[];
posCorrRaw(2,:)=[];
posCorrSSP(2,:)=[];
posCorrICA2(2,:)=[];
posCorrPCAcont(2,:)=[];
posCorrTopo(2,:)=[];
load HB100s
HB=mean(HBall);
HB=HB-HB(1);
time=-0.1:1/2034.5:0.65;
bars=[mean(posCorrRaw);mean(posCorrICA2);mean(posCorrHB);mean(posCorrSSP);mean(posCorrTopo);mean(posCorrPCAcont)];
SD=[std(posCorrRaw);std(posCorrICA2);std(posCorrHB);std(posCorrSSP);std(posCorrTopo);std(posCorrPCAcont)];
SE=SD./sqrt(size(posCorrHB,1));
figure;
set(gca, 'xcolor', 'w');
set(gcf,'color','w')
h1=subplot(1,2,1);
bar(win0t,bars');
hold on
plot(time,HB./5e-13.*0.3,'r')
for rowi=1:6
    pos=(rowi-3.5).*(0.1/7.5);
    e1 = errorbar(win0t+pos,bars(rowi,:),SE(rowi,:),'k');
    set(e1,'linestyle','none')
end
ylim([-0.1 0.3])
xlim([-0.1 0.7])
title('ConnectomeDB, magnetometers')
xlabel('Time (s)')
ylabel('Mean correlation (r)')
box off
set(h1,'color','none','YTick',0:0.1:0.3)
colors = hsv(8);
colormap(colors)



cd /home/yuval/Data/OMEGA
load posCorr
load posCorrTopo
load HB100s
HBctf=mean(HBall);
HBctf=HBctf-HBctf(1);
HBsc=HBctf./5e-13.*0.3;
bars=[mean(posCorrRaw);mean(posCorrICA1);mean(posCorrHB);mean(posCorrSSP);mean(posCorrTopo);zeros(1,7)];
SD=[std(posCorrRaw);std(posCorrICA2);std(posCorrHB);std(posCorrSSP);std(posCorrTopo);std(posCorrPCAcont)];
SE=SD./sqrt(size(posCorrHB,1));
h2=subplot(1,2,2);
bar(win0t,bars');
hold on
plot(time,smooth(HBsc,20),'r')
for rowi=1:5
    pos=(rowi-3.5).*(0.1/7.5);
    e1 = errorbar(win0t+pos,bars(rowi,:),SE(rowi,:),'k');
    set(e1,'linestyle','none')
end
ylim([-0.1 0.3])
xlim([-0.1 0.7])
ylabel('Heartbeat Amplitude (pT)')
title('OMEGA, axial gradiometers')
colormap(colors)
xlabel('Time (s)')
box off
set(h2,'YAxisLocation', 'right','color','none','YTick',0:0.15:0.3,'YtickLabel',[0 0.25 0.5])
l2=legend('Not Cleaned','ICA','Template','PCA QRS','R Topo','PCA cont');
set(l2,'box','off')
