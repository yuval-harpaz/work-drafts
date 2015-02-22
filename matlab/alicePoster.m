cd /home/yuval/Copy/MEGdata/alice/ga2015
load('raw.mat')
% subplot(2,1,1)
% plot(avgEr.time,squeeze(mean(avgEraw.individual,1)),'k')
% hold on
% plot(avgEr.time,squeeze(mean(avgEr.individual,1)),'g')
f1=figure
plot(avgMr.time(1,1),mean(avgMraw.individual(:,1,1)),'k')
hold on
plot(avgMr.time(1,1),mean(avgMr.individual(:,1,1)),'g')
plot(avgMr.time,squeeze(mean(avgMraw.individual,1)),'k')
plot(avgMr.time,squeeze(mean(avgMr.individual,1)),'g')
ylim([-1.5e-13 1.5e-13])
xlim([-0.5 0.5])
l=legend('raw','cleaned','location','northwest');
set(l,'box','off');
set(gca,'fontsize',15)
xlabel('Time(s)')
ylabel('Amplitude (Tesla)')

load GavgEqTrl

GavgE20.label=GavgE20.label([1:12,14:18,20:32]);
GavgE20.individual=GavgE20.individual(:,[1:12,14:18,20:32],:);
GavgE20=correctBL(GavgE20,[-0.2 -0.05]);
GavgM20=correctBL(GavgM20,[-0.2 -0.05]);
avgEr=correctBL(avgEr,[-0.2 -0.05]);
avgMr=correctBL(avgMr,[-0.2 -0.05]);

t=[0.0875 0.1125];
s1=nearest(GavgM20.time,t(1));
s2=nearest(GavgM20.time,t(2));
M=mean(mean(GavgM20.individual(:,:,s1:s2),3));
cfg=[];
cfg.zlim=[-1e-13 1e-13];
cfg.interpolate='linear';
figure;
topoplot248(M,cfg)
s1=nearest(avgMr.time,t(1));
s2=nearest(avgMr.time,t(2));
M=mean(mean(avgMr.individual(:,:,s1:s2),3));
figure;
topoplot248(M,cfg)


s1=nearest(GavgE20.time,t(1));
s2=nearest(GavgE20.time,t(2));
E=mean(mean(GavgE20.individual(:,:,s1:s2),3));
cfg=[];
cfg.zlim=[-3 3];
figure;
topoplot30(E,cfg)
s1=nearest(avgEr.time,t(1));
s2=nearest(avgEr.time,t(2));
E=mean(mean(avgEr.individual(:,:,s1:s2),3));
figure
topoplot30(E,cfg)



