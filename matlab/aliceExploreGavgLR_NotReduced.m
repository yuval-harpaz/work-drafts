%% Gavg all saccades
cd /home/yuval/Copy/MEGdata/alice/ga
load('GavgMaliceNR.mat')
load('GavgEaliceNR.mat')
load LRpairsEEG; LRpairsEEG=LRpairs; load LRpairs

GavgMalice=correctBL(GavgMalice,[-0.2 -0.05]);
GavgEalice=correctBL(GavgEalice,[-0.2 -0.05]);
GavgMaliceNR=GavgMalice;
GavgEaliceNR=GavgEalice;
[~,MLi]=ismember(LRpairs(:,1),GavgMaliceNR.label);
[~,MRi]=ismember(LRpairs(:,2),GavgMaliceNR.label);
[~,ELi]=ismember(LRpairsEEG(:,1),GavgEaliceNR.label);
[~,ERi]=ismember(LRpairsEEG(:,2),GavgEaliceNR.label);
t0=-0.2;t1=0.55;
s0=nearest(GavgMaliceNR.time,t0);
s1=nearest(GavgMaliceNR.time,t1);
time=GavgMaliceNR.time(s0:s1);
s0e=nearest(GavgEaliceNR.time,t0);
s1e=nearest(GavgEaliceNR.time,t1);
timeE=GavgEaliceNR.time(s0e:s1e);
s3e=nearest(timeE,-0.05);s3=nearest(time,-0.05);
MaLNR=squeeze(mean(abs(mean(GavgMaliceNR.individual(:,MLi,s0:s1),1))));
MaRNR=squeeze(mean(abs(mean(GavgMaliceNR.individual(:,MRi,s0:s1),1))));
MaLNR=correctBL(MaLNR',[1 s3]);
MaRNR=correctBL(MaRNR',[1 s3]);


load GavgMalice
load GavgEalice
GavgMalice=correctBL(GavgMalice,[-0.2 -0.05]);
GavgEalice=correctBL(GavgEalice,[-0.2 -0.05]);
MaL=squeeze(mean(abs(mean(GavgMalice.individual(:,MLi,s0:s1),1))));
MaR=squeeze(mean(abs(mean(GavgMalice.individual(:,MRi,s0:s1),1))));
MaL=correctBL(MaL',[1 s3]);
MaR=correctBL(MaR',[1 s3]);
figure;
plot(time,MaL)
hold on
plot(time,MaR,'r')
plot(time,MaLNR,'--')
plot(time,MaRNR,'r--')
legend('left reduced','right reduced','left not reduced','right not reduced')

EaL=squeeze(mean(abs(mean(GavgEalice.individual(:,ELi,s0e:s1e),1))));
EaR=squeeze(mean(abs(mean(GavgEalice.individual(:,ERi,s0e:s1e),1))));
EaL=correctBL(EaL',[1 s3]);
EaR=correctBL(EaR',[1 s3]);
EaLNR=squeeze(mean(abs(mean(GavgEaliceNR.individual(:,ELi,s0e:s1e),1))));
EaRNR=squeeze(mean(abs(mean(GavgEaliceNR.individual(:,ERi,s0e:s1e),1))));
EaLNR=correctBL(EaLNR',[1 s3]);
EaRNR=correctBL(EaRNR',[1 s3]);
figure;
plot(timeE,EaL)
hold on
plot(timeE,EaR,'r')
plot(timeE,EaLNR,'--')
plot(timeE,EaRNR,'r--')
legend('left reduced','right reduced','left not reduced','right not reduced')

%%
load GavgM20
%load GavgE20
GavgM20=correctBL(GavgM20,[-0.2 -0.05]);
t=0.3;
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[t t];
cfg.zlim=[-3e-14 3e-14];
figure;ft_topoplotER(cfg,GavgMalice)
t=0.38;
cfg.xlim=[t t];
figure;ft_topoplotER(cfg,GavgM20)

