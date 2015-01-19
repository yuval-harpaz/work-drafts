cd /home/yuval/Copy/MEGdata/alice/ga
load GavgM20
load GavgM2
load GavgM4
load GavgE20
load GavgE2
load GavgE4
load LRpairsEEG; LRpairsEEG=LRpairs; load LRpairs
LRpairsEEG(6,:)=[];
GavgM20=correctBL(GavgM20,[-0.2 -0.05]);
GavgM2=correctBL(GavgM2,[-0.2 -0.05]);
GavgM4=correctBL(GavgM4,[-0.2 -0.05]);
GavgE20=correctBL(GavgE20,[-0.2 -0.05]);
GavgE2=correctBL(GavgE2,[-0.2 -0.05]);
GavgE4=correctBL(GavgE4,[-0.2 -0.05]);
[~,MLi]=ismember(LRpairs(:,1),GavgM2.label);
[~,MRi]=ismember(LRpairs(:,2),GavgM2.label);
[~,ELi]=ismember(LRpairsEEG(:,1),GavgE2.label);
[~,ERi]=ismember(LRpairsEEG(:,2),GavgE2.label);
t0=-0.2;t1=0.55;
s0=nearest(GavgM2.time,t0);
s1=nearest(GavgM2.time,t1);
s2=nearest(GavgM20.time,t1);
time=GavgM2.time(s0:s1);
s0e=nearest(GavgE2.time,t0);
s1e=nearest(GavgE2.time,t1);
s2e=nearest(GavgE20.time,t1);
timeE=GavgE2.time(s0e:s1e);
s3e=nearest(timeE,-0.05);s3=nearest(time,-0.05);
%% average channels first
M20L=squeeze(mean(abs(GavgM20.individual(:,MLi,1:s2+1)),2));
M20R=squeeze(mean(abs(GavgM20.individual(:,MRi,1:s2+1)),2));
M2L=squeeze(mean(abs(GavgM2.individual(:,MLi,s0:s1)),2));
M2R=squeeze(mean(abs(GavgM2.individual(:,MRi,s0:s1)),2));
M4L=squeeze(mean(abs(GavgM4.individual(:,MLi,s0:s1)),2));
M4R=squeeze(mean(abs(GavgM4.individual(:,MRi,s0:s1)),2));
E20L=squeeze(mean(abs(GavgE20.individual(:,ELi,1:s2e)),2));
E20R=squeeze(mean(abs(GavgE20.individual(:,ERi,1:s2e)),2));
E2L=squeeze(mean(abs(GavgE2.individual(:,ELi,s0e:s1e)),2));
E2R=squeeze(mean(abs(GavgE2.individual(:,ERi,s0e:s1e)),2));
E4L=squeeze(mean(abs(GavgE4.individual(:,ELi,s0e:s1e)),2));
E4R=squeeze(mean(abs(GavgE4.individual(:,ERi,s0e:s1e)),2));

M20L=correctBL(M20L,[1 s3]);
M20R=correctBL(M20R,[1 s3]);
M2L=correctBL(M2L,[1 s3]);
M2R=correctBL(M2R,[1 s3]);
M4L=correctBL(M4L,[1 s3]);
M4R=correctBL(M4R,[1 s3]);
% E20L=
% E20R=
% E2L=
% E2R=
% E4L=
% E4R=

figure;
plot(time,mean(M2L))
hold on
plot(time,mean(M2R),'r')
ylim([-0.5e-14 2.5e-14])
figure;
plot(time,mean(M4L))
hold on
plot(time,mean(M4R),'r')
ylim([-0.5e-14 2.5e-14])
figure;
plot(time,mean(M20L))
hold on
plot(time,mean(M20R),'r')
ylim([-0.5e-14 2.5e-14])

figure;
plot(timeE,mean(E2L))
hold on
plot(timeE,mean(E2R),'r')
ylim([0.1 1.8])
figure;
plot(timeE,mean(E4L))
hold on
plot(timeE,mean(E4R),'r')
ylim([0.1 1.8])
figure;
plot(timeE,mean(E20L))
hold on
plot(timeE,mean(E20R),'r')
ylim([0.1 1.8])

%% average subjects first
M20L=squeeze(mean(abs(mean(GavgM20.individual(:,MLi,1:s2+1),1))));
M20R=squeeze(mean(abs(mean(GavgM20.individual(:,MRi,1:s2+1),1))));
M2L=squeeze(mean(abs(mean(GavgM2.individual(:,MLi,s0:s1),1))));
M2R=squeeze(mean(abs(mean(GavgM2.individual(:,MRi,s0:s1),1))));
M4L=squeeze(mean(abs(mean(GavgM4.individual(:,MLi,s0:s1),1))));
M4R=squeeze(mean(abs(mean(GavgM4.individual(:,MRi,s0:s1),1))));
E20L=squeeze(mean(abs(mean(GavgE20.individual(:,ELi,1:s2e),1))));
E20R=squeeze(mean(abs(mean(GavgE20.individual(:,ERi,1:s2e),1))));
E2L=squeeze(mean(abs(mean(GavgE2.individual(:,ELi,s0e:s1e),1))));
E2R=squeeze(mean(abs(mean(GavgE2.individual(:,ERi,s0e:s1e),1))));
E4L=squeeze(mean(abs(mean(GavgE4.individual(:,ELi,s0e:s1e),1))));
E4R=squeeze(mean(abs(mean(GavgE4.individual(:,ERi,s0e:s1e),1))));
s3e=nearest(timeE,-0.05);s3=nearest(time,-0.05);
M20L=correctBL(M20L',[1 s3]);
M20R=correctBL(M20R',[1 s3]);
M2L=correctBL(M2L',[1 s3]);
M2R=correctBL(M2R',[1 s3]);
M4L=correctBL(M4L',[1 s3]);
M4R=correctBL(M4R',[1 s3]);
% E20L=
% E20R=
% E2L=
% E2R=
% E4L=
% E4R=

figure;
plot(time,M2L)
hold on
plot(time,M2R,'r')
ylim([-0.5e-14 2.5e-14])
figure;
plot(time,M4L)
hold on
plot(time,M4R,'r')
ylim([-0.5e-14 2.5e-14])
figure;
plot(time,M20L)
hold on
plot(time,M20R,'r')
ylim([-0.5e-14 2.5e-14])

figure;
plot(timeE,E2L)
hold on
plot(timeE,E2R,'r')
ylim([0 1.8])
figure;
plot(timeE,E4L)
hold on
plot(timeE,E4R,'r')
ylim([0 1.8])
figure;
plot(timeE,E20L)
hold on
plot(timeE,E20R,'r')
ylim([0 1.8])


cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
cfg.xlim=[0.283 0.283];
figure;ft_topoplotER(cfg,GavgM4,GavgM2)
cfg.xlim=[0.2 0.2];
figure;ft_topoplotER(cfg,GavgM20);

% Left bias M400
T=nearest(GavgM20.time,0.434);
wtsL=mean(GavgM20.individual(:,MLi,T));
wtsR=mean(GavgM20.individual(:,MRi,T));
for subi=1:8
    ML(subi)=wtsL*GavgM20.individual(subi,MLi,T)';
    MR(subi)=wtsR*GavgM20.individual(subi,MRi,T)';
end
[~,p]=ttest(ML',MR')

cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[0.434 0.434];
figure;ft_topoplotER(cfg,GavgM20)

% Left bias M283
t=0.283;
T=nearest(GavgM4.time,t);
wtsL=mean(GavgM4.individual(:,MLi,T));
wtsR=mean(GavgM4.individual(:,MRi,T));
for subi=1:8
    ML(subi)=wtsL*GavgM4.individual(subi,MLi,T)';
    MR(subi)=wtsR*GavgM4.individual(subi,MRi,T)';
end
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[t t];
figure;ft_topoplotER(cfg,GavgM4)
[~,p]=ttest(ML',MR')

% Left bias M383
t=0.383;
T=nearest(GavgM2.time,t);
wtsL=mean(GavgM2.individual(:,MLi,T));
wtsR=mean(GavgM2.individual(:,MRi,T));
for subi=1:8
    ML(subi)=wtsL*GavgM2.individual(subi,MLi,T)';
    MR(subi)=wtsR*GavgM2.individual(subi,MRi,T)';
end
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[t t];
figure;ft_topoplotER(cfg,GavgM4)
[~,p]=ttest(ML',MR')


% Right bias M170
T=nearest(GavgM2.time,0.18);
wtsL=mean(GavgM2.individual(:,MLi,T));
wtsR=mean(GavgM2.individual(:,MRi,T));
for subi=1:8
    ML(subi)=wtsL*GavgM2.individual(subi,MLi,T)';
    MR(subi)=wtsR*GavgM2.individual(subi,MRi,T)';
end
[~,p]=ttest(ML,MR)
wtsL=mean(GavgM4.individual(:,MLi,T));
wtsR=mean(GavgM4.individual(:,MRi,T));
for subi=1:8
    ML(subi)=wtsL*GavgM4.individual(subi,MLi,T)';
    MR(subi)=wtsR*GavgM4.individual(subi,MRi,T)';
end
[~,p]=ttest(ML,MR)

cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[0.18 0.18];
figure;ft_topoplotER(cfg,GavgM4,GavgM2,GavgM20)

%% Gavg all saccades
load GavgMalice
GavgMalice=correctBL(GavgMalice,[-0.2 -0.05]);
MaL=squeeze(mean(abs(mean(GavgMalice.individual(:,MLi,s0:s1),1))));
MaR=squeeze(mean(abs(mean(GavgMalice.individual(:,MRi,s0:s1),1))));
MaL=correctBL(MaL',[1 s3]);
MaR=correctBL(MaR',[1 s3]);
figure;
plot(time,MaL)
hold on
plot(time,MaR,'r')


% Left bias M300
t=0.3;
T=nearest(GavgMalice.time,t);
wtsL=mean(GavgMalice.individual(:,MLi,T));
wtsR=mean(GavgMalice.individual(:,MRi,T));
for subi=1:8
    ML(subi)=wtsL*GavgMalice.individual(subi,MLi,T)';
    MR(subi)=wtsR*GavgMalice.individual(subi,MRi,T)';
end
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[t t];
cfg.zlim=[-3e-14 3e-14];
figure;ft_topoplotER(cfg,GavgMalice)
[~,p]=ttest(ML',MR')

% Right bias M170
t=0.18;
T=nearest(GavgMalice.time,t);
wtsL=mean(GavgMalice.individual(:,MLi,T));
wtsR=mean(GavgMalice.individual(:,MRi,T));
for subi=1:8
    ML(subi)=wtsL*GavgMalice.individual(subi,MLi,T)';
    MR(subi)=wtsR*GavgMalice.individual(subi,MRi,T)';
end
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[t t];
cfg.zlim=[-5e-14 5e-14];
figure;ft_topoplotER(cfg,GavgMalice)
[~,p]=ttest(ML',MR')

% Right bias M100
t=0.0855;
T=nearest(GavgMalice.time,t);
wtsL=mean(GavgMalice.individual(:,MLi,T));
wtsR=mean(GavgMalice.individual(:,MRi,T));
for subi=1:8
    ML(subi)=wtsL*GavgMalice.individual(subi,MLi,T)';
    MR(subi)=wtsR*GavgMalice.individual(subi,MRi,T)';
end
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[t t];
cfg.zlim=[-10e-14 10e-14];
figure;ft_topoplotER(cfg,GavgMalice)
[~,p]=ttest(ML',MR')

% ERP
load GavgEalice
GavgEalice=correctBL(GavgEalice,[-0.2 -0.05]);
EaL=squeeze(mean(abs(mean(GavgEalice.individual(:,ELi,s0e:s1e),1))));
EaR=squeeze(mean(abs(mean(GavgEalice.individual(:,ERi,s0e:s1e),1))));
EaL=correctBL(EaL',[1 s3]);
EaR=correctBL(EaR',[1 s3]);
figure;
plot(timeE,EaL)
hold on
plot(timeE,EaR,'r')
t=0.1;
cfg=[];
cfg.layout='WG32.lay';
cfg.xlim=[t t];
figure;ft_topoplotER(cfg,GavgEalice)

t=0.17;
cfg=[];
cfg.layout='WG32.lay';
cfg.xlim=[t t];
figure;ft_topoplotER(cfg,GavgEalice)

t=0.3;
cfg=[];
cfg.layout='WG32.lay';
cfg.xlim=[t t];
figure;ft_topoplotER(cfg,GavgEalice)

figure;
plot(timeE,E20L)
hold on
plot(timeE,E20R,'r')

t=0.36;
T=nearest(GavgEalice.time,t);
wtsL=mean(GavgEalice.individual(:,ELi,T));
wtsR=mean(GavgEalice.individual(:,ERi,T));
for subi=1:8
    EL(subi)=wtsL*GavgEalice.individual(subi,ELi,T)';
    ER(subi)=wtsR*GavgEalice.individual(subi,ERi,T)';
end
% cfg=[];
% cfg.layout='WG32.lay';
% cfg.xlim=[t t];
% cfg.zlim=[-1 1];
% figure;ft_topoplotER(cfg,GavgEalice)
[~,p]=ttest(EL,ER)

%% GavgM20_2 (WbW2)
cd /home/yuval/Copy/MEGdata/alice/ga
load GavgM20_2
load LRpairs
GavgM20=correctBL(GavgM20,[-0.2 -0.05]);
[~,MLi]=ismember(LRpairs(:,1),GavgM20.label);
[~,MRi]=ismember(LRpairs(:,2),GavgM20.label);
t0=-0.2;t1=0.55;
s0=nearest(GavgM20.time,t0);
s1=nearest(GavgM20.time,t1);
time=GavgM20.time(s0:s1);
s3=nearest(time,-0.05);
M20L=squeeze(mean(abs(mean(GavgM20.individual(:,MLi,s0:s1),1))));
M20R=squeeze(mean(abs(mean(GavgM20.individual(:,MRi,s0:s1),1))));
M20L=correctBL(M20L',[1 s3]);
M20R=correctBL(M20R',[1 s3]);
figure;
plot(time,M20L)
hold on
plot(time,M20R,'r')
ylim([-0.5e-14 2.5e-14])



M20L=squeeze(mean(abs(mean(GavgM20.individual(:,MLi,s0:s1),1))));
M20R=squeeze(mean(abs(mean(GavgM20.individual(:,MRi,s0:s1),1))));
M20L=correctBL(M20L',[1 s3]);
M20R=correctBL(M20R',[1 s3]);
figure;
plot(time,M20L)
hold on
plot(time,M20R,'r')
ylim([-0.5e-14 2.5e-14])
