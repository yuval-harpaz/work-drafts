aliceReduceSpikeComp('idan');
aliceReduceSpikeComp('odelia');
aliceReduceSpikeComp('maor');
aliceReduceSpikeComp('liron');
aliceReduceSpikeComp('inbal');
aliceReduceSpikeComp('mark');
aliceReduceSpikeComp('yoni');
aliceReduceSpikeComp('ohad');

aliceGAnotReduced('alice','avgReducedSC','SC')

cd /home/yuval/Copy/MEGdata/alice/ga
load('GavgMaliceSC.mat')
load('GavgEaliceSC.mat')
load LRpairsEEG; LRpairsEEG=LRpairs; load LRpairs

GavgMalice=correctBL(GavgMalice,[-0.2 -0.05]);
GavgEalice=correctBL(GavgEalice,[-0.2 -0.05]);
GavgMaliceSC=GavgMalice;
GavgEaliceSC=GavgEalice;
[~,MLi]=ismember(LRpairs(:,1),GavgMaliceSC.label);
[~,MRi]=ismember(LRpairs(:,2),GavgMaliceSC.label);
[~,ELi]=ismember(LRpairsEEG(:,1),GavgEaliceSC.label);
[~,ERi]=ismember(LRpairsEEG(:,2),GavgEaliceSC.label);
t0=-0.2;t1=0.55;
s0=nearest(GavgMaliceSC.time,t0);
s1=nearest(GavgMaliceSC.time,t1);
time=GavgMaliceSC.time(s0:s1);
s0e=nearest(GavgEaliceSC.time,t0);
s1e=nearest(GavgEaliceSC.time,t1);
timeE=GavgEaliceSC.time(s0e:s1e);
s3e=nearest(timeE,-0.05);s3=nearest(time,-0.05);
MaLSC=squeeze(mean(abs(mean(GavgMaliceSC.individual(:,MLi,s0:s1),1))));
MaRSC=squeeze(mean(abs(mean(GavgMaliceSC.individual(:,MRi,s0:s1),1))));
MaLSC=correctBL(MaLSC',[1 s3]);
MaRSC=correctBL(MaRSC',[1 s3]);


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
plot(time,MaLSC,'--')
plot(time,MaRSC,'r--')
legend('left reduced','right reduced','left no spike','right no spike')

EaL=squeeze(mean(abs(mean(GavgEalice.individual(:,ELi,s0e:s1e),1))));
EaR=squeeze(mean(abs(mean(GavgEalice.individual(:,ERi,s0e:s1e),1))));
EaL=correctBL(EaL',[1 s3]);
EaR=correctBL(EaR',[1 s3]);
EaLSC=squeeze(mean(abs(mean(GavgEaliceSC.individual(:,ELi,s0e:s1e),1))));
EaRSC=squeeze(mean(abs(mean(GavgEaliceSC.individual(:,ERi,s0e:s1e),1))));
EaLSC=correctBL(EaLSC',[1 s3]);
EaRSC=correctBL(EaRSC',[1 s3]);
figure;
plot(timeE,EaL)
hold on
plot(timeE,EaR,'r')
plot(timeE,EaLSC,'--')
plot(timeE,EaRSC,'r--')
legend('left reduced','right reduced','left no spike','right no spike')

%%

t=-0.022;
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[t t];
cfg.zlim=[-3e-14 3e-14];
cfg.interactive='yes';
% cfg.trials=3;
figure;ft_topoplotER(cfg,GavgMaliceSC,GavgMalice)

t=-0.022;
cfg=[];
cfg.layout='WG32.lay';
cfg.xlim=[t t];
cfg.zlim=[-2 2];
cfg.interactive='yes';
figure;ft_topoplotER(cfg,GavgEaliceSC,GavgEalice)

