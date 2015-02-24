cd /home/yuval/Copy/MEGdata/alice/ga2015
load('raw.mat')
% subplot(2,1,1)
% plot(avgEr.time,squeeze(mean(avgEraw.individual,1)),'k')
% hold on
% plot(avgEr.time,squeeze(mean(avgEr.individual,1)),'g')
f1=figure;
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
M20=mean(GavgM20.individual(:,:,s1:s2),3);
s1=nearest(avgMr.time,t(1));
s2=nearest(avgMr.time,t(2));
Mr=mean(avgMr.individual(:,:,s1:s2),3);
s1=nearest(GavgE20.time,t(1));
s2=nearest(GavgE20.time,t(2));
E20=mean(GavgE20.individual(:,:,s1:s2),3);
s1=nearest(avgEr.time,t(1));
s2=nearest(avgEr.time,t(2));
Er=mean(avgEr.individual(:,:,s1:s2),3);


[~,~,sigT]=permuteMat(Mr,M20);



cfg=[];
cfg.zlim=[-130 130];
cfg.interpolate='linear';
cfg.highlight          = 'on';
cfg.comment='no';
cfg.highlightchannel   =  sigT;

figure;
topoplot248(10^15.*mean(Mr),cfg)
colorbar
set (gca,'fontsize',16)
title('MEG, Natural')

figure;
topoplot248(10^15.*mean(M20),cfg)
colorbar
set (gca,'fontsize',16)
title('MEG, Word by Word')

%[~,~,sigT]=permuteMat(Er,E20);
cfg.zlim=[-3 3];
cfg.highlightchannel   =  [20 28 29];%sigT;
cfg=rmfield(cfg,'interpolate');
figure;
topoplot30(mean(Er),cfg)
colorbar
set (gca,'fontsize',16)
title('EEG, Natural')

figure
topoplot30(mean(E20),cfg)
colorbar
set (gca,'fontsize',16)
title('EEG, Word by Word')
%%

[~,~,sigT]=permuteMat(Mr);
cfg=[];
cfg.zlim=[-130 130];
cfg.interpolate='linear';
cfg.highlight          = 'on';
cfg.comment='no';
cfg.highlightchannel   =  sigT;

figure;
topoplot248(10^15.*mean(Mr),cfg)
colorbar
set (gca,'fontsize',16)
title('MEG, Natural')
[~,~,sigT]=permuteMat(M20);
cfg.highlightchannel   =  sigT;
figure;
topoplot248(10^15.*mean(M20),cfg)
colorbar
set (gca,'fontsize',16)
title('MEG, Word by Word')

%[~,~,sigT]=permuteMat(Er,E20);
cfg.zlim=[-3 3];
cfg.highlightchannel   =  [20 28 29];%sigT;
cfg=rmfield(cfg,'interpolate');
figure;
topoplot30(mean(Er),cfg)
colorbar
set (gca,'fontsize',16)
title('EEG, Natural')

figure
topoplot30(mean(E20),cfg)
colorbar
set (gca,'fontsize',16)
title('EEG, Word by Word')

%% 
cd /home/yuval/Copy/MEGdata/alice/ga2015
load GavgEqTrl

GavgE20.label=GavgE20.label([1:12,14:18,20:32]);
GavgE20.individual=GavgE20.individual(:,[1:12,14:18,20:32],:);
GavgE20=correctBL(GavgE20,[-0.2 -0.05]);
GavgM20=correctBL(GavgM20,[-0.2 -0.05]);
avgEr=correctBL(avgEr,[-0.2 -0.05]);
avgMr=correctBL(avgMr,[-0.2 -0.05]);
t0=-0.2;t1=0.55;
s0=nearest(avgMr.time,t0);
s20=nearest(GavgM20.time,t0);
s1=nearest(avgMr.time,t1);
s21=nearest(GavgM20.time,t1);
time=avgMr.time(s0:s1);
s3=nearest(time,-0.05);
samplesM=s0:s1;
samplesM20=s20:s21;
s0e=nearest(avgEr.time,t0);
s20e=nearest(GavgE20.time,t0);
s1e=nearest(avgEr.time,t1);
s21e=nearest(GavgE20.time,t1);
timeE=avgEr.time(s0e:s1e);
s3e=nearest(timeE,-0.05);
samplesE=s0e:s1e;
samplesE20=s20e:s21e;


cfg=[];
cfg.neighbours='all';
cfg.method='meanAbs';
MaC1st=clustData(cfg,avgMr); % average across subjects first
M20C1st=clustData(cfg,GavgM20);
MaC1st=correctBL(MaC1st,[-0.2 -0.05]);
M20C1st=correctBL(M20C1st,[-0.2 -0.05]);
MaC1st=squeeze(MaC1st.individual(:,:,samplesM));
M20C1st=squeeze(M20C1st.individual(:,:,samplesM20));
%figure;plot(time,MaC1st,'k');hold on;plot(time,M20C1st,'r')
EaC1st=correctBL(squeeze(mean(abs(avgEr.individual(:,:,samplesE)),2)),[1 s3e]);
E20C1st=correctBL(squeeze(mean(abs(GavgE20.individual(:,:,samplesE20)),2)),[1 s3e]);
% figure;plot(timeE,EaC1st,'k');hold on;plot(timeE,E20C1st,'r')


MaS1st=correctBL(squeeze(mean(abs(mean(avgMr.individual(:,:,samplesM),1)),2))',[1 s3]); % average across channels first
M20S1st=correctBL(squeeze(mean(abs(mean(GavgM20.individual(:,:,samplesM20),1)),2))',[1 s3]);
EaS1st=correctBL(squeeze(mean(abs(mean(avgEr.individual(:,:,samplesE),1)),2))',[1 s3e]); % average across channels first
E20S1st=correctBL(squeeze(mean(abs(mean(GavgE20.individual(:,:,samplesE20),1)),2))',[1 s3e]);
% figure;plot(time,[MaS1st;M20S1st]);
% figure;plot(timeE,[EaS1st;E20S1st]);


figure;plot(time,mean(MaC1st),'k')
set (gca,'fontsize',16)
hold on
plot(time,mean(M20C1st),'r')
h=ttest(MaC1st,M20C1st);
t=time(find(h));
t=t(t>0.04);t=t(t<0.5);
plot(t,0,'*k')
title('MEG')
xlim([-0.2 0.55])
xlabel('Time(s)')
ylabel('Amplitude (Tesla)')
set(gcf,'color','w')
l2=legend('Natural','Word by Word')
set(l2,'box','off')
figure;plot(timeE,mean(EaC1st),'k')
set (gca,'fontsize',16)
hold on
plot(timeE,mean(E20C1st),'r')
h=ttest(EaC1st,E20C1st);
t=timeE(find(h));
t=t(t>0.06);t=t(t<0.5);
plot(t,0,'*k')
title('EEG')
xlim([-0.2 0.55])
xlabel('Time(s)')
ylabel('Amplitude (mV)')
set(gcf,'color','w')