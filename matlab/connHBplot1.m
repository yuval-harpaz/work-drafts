win0t=0:0.1:0.6;
win0=round(2034.5*win0t);

cd /media/yuval/win_disk/Data/connectomeDB/MEG
load posCorr70
posCorrHB(2,:)=[];
posCorrRaw(2,:)=[];
posCorrSSP(2,:)=[];
posCorrICA2(2,:)=[];
load HB100s
HB=mean(HBall);
HB=HB-HB(1);
time=-0.1:1/2034.5:0.65;
bars=[mean(posCorrSSP);mean(posCorrHB);mean(posCorrICA2);mean(posCorrRaw)];
figure;
set(gca, 'xcolor', 'w');
set(gcf,'color','w')
h1=subplot(1,2,1);
bar(win0t,bars');
hold on
plot(time,HB./5e-13.*0.3,'r')
ylim([-0.1 0.3])
xlim([-0.1 0.7])
title('ConnectomeDB, magnetometers')
xlabel('Time (s)')
ylabel('Mean correlation (r)')
box off
set(h1,'color','none','YTick',0:0.1:0.3)

cd /home/yuval/Data/OMEGA
load posCorr
load HB100s
HBctf=mean(HBall);
HBctf=HBctf-HBctf(1);
HBsc=HBctf./5e-13.*0.3;
bars=[mean(posCorrSSP);mean(posCorrHB);mean(posCorrICA1);mean(posCorrRaw)];
h2=subplot(1,2,2);
bar(win0t,bars');
hold on
plot(time,HBsc,'r')
ylim([-0.1 0.3])
xlim([-0.1 0.7])
ylabel('Heartbeat Amplitude (pT)')
title('OMEGA, axial gradiometers')
xlabel('Time (s)')
box off
set(h2,'YAxisLocation', 'right','color','none','YTick',0:0.15:0.3,'YtickLabel',[0 0.25 0.5])
l2=legend('SSP','Template','ICA','Raw','average HB');
set(l2,'box','off')
