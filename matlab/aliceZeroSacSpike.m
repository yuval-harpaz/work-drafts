aliceReduceAvgZeroSpike('idan');
aliceReduceAvgZeroSpike('odelia');
aliceReduceAvgZeroSpike('maor');
aliceReduceAvgZeroSpike('liron');
aliceReduceAvgZeroSpike('inbal');
aliceReduceAvgZeroSpike('mark');
aliceReduceAvgZeroSpike('yoni');
aliceReduceAvgZeroSpike('ohad');

aliceGAnotReduced('alice','avgReducedZS','ZS')

cd /home/yuval/Copy/MEGdata/alice/ga
load('GavgMaliceZS.mat')
load('GavgEaliceZS.mat')
load LRpairsEEG; LRpairsEEG=LRpairs; load LRpairs

GavgMalice=correctBL(GavgMalice,[-0.2 -0.05]);
GavgEalice=correctBL(GavgEalice,[-0.2 -0.05]);
GavgMaliceZS=GavgMalice;
GavgEaliceZS=GavgEalice;
[~,MLi]=ismember(LRpairs(:,1),GavgMaliceZS.label);
[~,MRi]=ismember(LRpairs(:,2),GavgMaliceZS.label);
[~,ELi]=ismember(LRpairsEEG(:,1),GavgEaliceZS.label);
[~,ERi]=ismember(LRpairsEEG(:,2),GavgEaliceZS.label);
t0=-0.2;t1=0.55;
s0=nearest(GavgMaliceZS.time,t0);
s1=nearest(GavgMaliceZS.time,t1);
time=GavgMaliceZS.time(s0:s1);
s0e=nearest(GavgEaliceZS.time,t0);
s1e=nearest(GavgEaliceZS.time,t1);
timeE=GavgEaliceZS.time(s0e:s1e);
s3e=nearest(timeE,-0.05);s3=nearest(time,-0.05);
MaLZS=squeeze(mean(abs(mean(GavgMaliceZS.individual(:,MLi,s0:s1),1))));
MaRZS=squeeze(mean(abs(mean(GavgMaliceZS.individual(:,MRi,s0:s1),1))));
MaLZS=correctBL(MaLZS',[1 s3]);
MaRZS=correctBL(MaRZS',[1 s3]);


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
plot(time,MaLZS,'--')
plot(time,MaRZS,'r--')
legend('left reduced','right reduced','left no spike','right no spike')

EaL=squeeze(mean(abs(mean(GavgEalice.individual(:,ELi,s0e:s1e),1))));
EaR=squeeze(mean(abs(mean(GavgEalice.individual(:,ERi,s0e:s1e),1))));
EaL=correctBL(EaL',[1 s3]);
EaR=correctBL(EaR',[1 s3]);
EaLZS=squeeze(mean(abs(mean(GavgEaliceZS.individual(:,ELi,s0e:s1e),1))));
EaRZS=squeeze(mean(abs(mean(GavgEaliceZS.individual(:,ERi,s0e:s1e),1))));
EaLZS=correctBL(EaLZS',[1 s3]);
EaRZS=correctBL(EaRZS',[1 s3]);
figure;
plot(timeE,EaL)
hold on
plot(timeE,EaR,'r')
plot(timeE,EaLZS,'--')
plot(timeE,EaRZS,'r--')
legend('left reduced','right reduced','left no spike','right no spike')

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

