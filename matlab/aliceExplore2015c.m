cd /home/yuval/Copy/MEGdata/alice/ga2015
load GavgEqTrl

GavgE20.label=GavgE20.label([1:12,14:18,20:32]);
GavgE20.individual=GavgE20.individual(:,[1:12,14:18,20:32],:);
GavgE20=correctBL(GavgE20,[-0.2 -0.05]);
GavgM20=correctBL(GavgM20,[-0.2 -0.05]);
avgEr=correctBL(avgEr,[-0.2 -0.05]);
avgMr=correctBL(avgMr,[-0.2 -0.05]);
%% first establish the differences between Sacc and WbW

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
%load neighbours7cm
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

figure;plot(timeE,mean(EaC1st),'k')
hold on
plot(timeE,mean(E20C1st),'r')
plot(timeE,EaS1st,'k','linewidth',2)
plot(timeE,E20S1st,'r','linewidth',2)
legend('Sacc, channels first','WbW, channels first', 'Sacc, subjects first','WbW, subjects first')
title('EEG')
h=ttest(EaC1st-repmat(EaS1st,8,1));
plot(timeE(find(h)),-0.1,'*k')
h=ttest(E20C1st-repmat(E20S1st,8,1));
plot(timeE(find(h)),-0.15,'*r')


figure;plot(time,mean(MaC1st),'k')
hold on
plot(time,mean(M20C1st),'r')
plot(time,MaS1st,'k','linewidth',2)
plot(time,M20S1st,'r','linewidth',2)
% legend('Sacc, channels first','WbW, channels first', 'Sacc, subjects first','WbW, subjects first')
title('MEG')
h=ttest(MaC1st-repmat(MaS1st,8,1));
plot(time(find(h)),0,'*k')
h=ttest(M20C1st-repmat(M20S1st,8,1));
t=time(find(h));
t=t(t>0.06);t=t(t<0.5);
plot(t,-0.2e-14,'*r')
xlim([-0.2 0.55])

figure;plot(time,mean(MaC1st),'k')
hold on
plot(time,mean(M20C1st),'r')
h=ttest(MaC1st,M20C1st);
t=time(find(h));
t=t(t>0.04);t=t(t<0.5);
plot(t,0,'*k')
title('MEG')
xlim([-0.2 0.55])

figure;plot(timeE,mean(EaC1st),'k')
hold on
plot(timeE,mean(E20C1st),'r')
h=ttest(EaC1st,E20C1st);
t=timeE(find(h));
t=t(t>0.06);t=t(t<0.5);
plot(t,0,'*k')
title('EEG')
legend('Saccades','WbW','sig')
xlim([-0.2 0.55])

%% LR saccades


load LRpairsEEG; LRpairsEEG=LRpairs; load LRpairs
LRpairsEEG(6,:)=[];
[~,MLi]=ismember(LRpairs(:,1),avgMr.label);
[~,MRi]=ismember(LRpairs(:,2),avgMr.label);
[~,ELi]=ismember(LRpairsEEG(:,1),avgEr.label);
[~,ERi]=ismember(LRpairsEEG(:,2),avgEr.label);
MaL=squeeze(mean(abs(avgMr.individual(:,MLi,s0:s1)),2));
MaR=squeeze(mean(abs(avgMr.individual(:,MRi,s0:s1)),2));
MaL=correctBL(MaL,[1 s3]);
MaR=correctBL(MaR,[1 s3]);
figure;
plot(time,mean(MaL))
hold on
plot(time,mean(MaR),'r')
h=ttest(MaL,MaR);
t=time(find(h));
t=t(t>0.04);t=t(t<0.5);
plot(t,0,'*k')
title('MEG')
legend('L','R','sig')


EaL=squeeze(mean(abs(avgEr.individual(:,ELi,s0e:s1e)),2));
EaR=squeeze(mean(abs(avgEr.individual(:,ERi,s0e:s1e)),2));
EaL=correctBL(EaL,[1 s3]);
EaR=correctBL(EaR,[1 s3]);

figure;
plot(timeE,mean(EaL))
hold on
plot(timeE,mean(EaR),'r')
h=ttest(EaL,EaR);
t=timeE(find(h));
t=t(t>0.04);t=t(t<0.5);
plot(t,0,'*k')
title('EEG')
legend('L','R','sig')

% LR WbW
MaL=squeeze(mean(abs(GavgM20.individual(:,MLi,s20:s21)),2));
MaR=squeeze(mean(abs(GavgM20.individual(:,MRi,s20:s21)),2));
MaL=correctBL(MaL,[1 s3]);
MaR=correctBL(MaR,[1 s3]);
figure;
plot(time,mean(MaL))
hold on
plot(time,mean(MaR),'r')
h=ttest(MaL,MaR);
t=time(find(h));
t=t(t>0.04);t=t(t<0.5);
plot(t,0,'*k')
title('MEG')
legend('L','R','sig')


EaL=squeeze(mean(abs(GavgE20.individual(:,ELi,s20e:s21e)),2));
EaR=squeeze(mean(abs(GavgE20.individual(:,ERi,s20e:s21e)),2));
EaL=correctBL(EaL,[1 s3]);
EaR=correctBL(EaR,[1 s3]);


figure;
plot(timeE,mean(EaL))
hold on
plot(timeE,mean(EaR),'r')
h=ttest(EaL,EaR);
t=timeE(find(h));
t=t(t>0.04);t=t(t<0.5);
plot(t,0,'*k')
title('EEG')
legend('L','R','sig')

%% 
% cfg=[];
% cfg.notBefore=0.07;
% cfg.notAfter=0.5;
% cfg.method='absMean';
% cfg.maxDist=0.3;
% cfg.zThr=0;
% %cfg.smooth=20;
% Ithroughs=findCompLims(cfg,avgEr);

P100a=[0.07 0.133];N170a=[0.133 0.208];N400a=[0.25 0.45];
M100a=[0.07 0.133];M170a=[0.133 0.279];M400a=[0.25 0.45];
P100w=[0.07 0.163];N170w=[0.163 0.3];N400w=[0.3 0.42];
M100w=[0.07 0.163];M170w=[0.163 0.3];M400w=[0.3 0.42];
MaL=squeeze(mean(abs(GavgM20.individual(:,MLi,s20:s21)),2));
MaR=squeeze(mean(abs(GavgM20.individual(:,MRi,s20:s21)),2));
MaL=correctBL(MaL,[1 s3]);
MaR=correctBL(MaR,[1 s3]);
EaL=squeeze(mean(abs(GavgE20.individual(:,ELi,s20e:s21e)),2));
EaR=squeeze(mean(abs(GavgE20.individual(:,ERi,s20e:s21e)),2));
EaL=correctBL(EaL,[1 s3]);
EaR=correctBL(EaR,[1 s3]);
t1=nearest(timeE,P100w(1));t2=nearest(timeE,P100w(2));
areaL=trapz(1000*timeE(t1:t2),EaL(:,t1:t2),2); % unit=ms by mV
areaR=trapz(1000*timeE(t1:t2),EaR(:,t1:t2),2); % unit=ms by mV
[~,P]=ttest(areaL,areaR)
t1=nearest(timeE,N170w(1));t2=nearest(timeE,N170w(2));
areaL=trapz(1000*timeE(t1:t2),EaL(:,t1:t2),2); % unit=ms by mV
areaR=trapz(1000*timeE(t1:t2),EaR(:,t1:t2),2); % unit=ms by mV
[~,P]=ttest(areaL,areaR)
t1=nearest(timeE,N400w(1));t2=nearest(timeE,N400w(2));
areaL=trapz(1000*timeE(t1:t2),EaL(:,t1:t2),2); % unit=ms by mV
areaR=trapz(1000*timeE(t1:t2),EaR(:,t1:t2),2); % unit=ms by mV
[~,P]=ttest(areaL,areaR)
t1=nearest(time,M100w(1));t2=nearest(time,M100w(2));
areaL=trapz(1000*time(t1:t2),MaL(:,t1:t2),2); % unit=ms by mV
areaR=trapz(1000*time(t1:t2),MaR(:,t1:t2),2); % unit=ms by mV
[~,P]=ttest(areaL,areaR)
t1=nearest(time,M170w(1));t2=nearest(time,M170w(2));
areaL=trapz(1000*time(t1:t2),MaL(:,t1:t2),2); % unit=ms by mV
areaR=trapz(1000*time(t1:t2),MaR(:,t1:t2),2); % unit=ms by mV
[~,P]=ttest(areaL,areaR)
t1=nearest(time,M400w(1));t2=nearest(time,M400w(2));
areaL=trapz(1000*time(t1:t2),MaL(:,t1:t2),2); % unit=ms by mV
areaR=trapz(1000*time(t1:t2),MaR(:,t1:t2),2); % unit=ms by mV
[~,P]=ttest(areaL,areaR)
figure;
t1=nearest(time,M400w(1));t2=nearest(time,M400w(2));
x=[time(t1:t2),time(t2:-1:t1)];
y=[mean(MaL(:,t1:t2)),mean(MaR(:,t2:-1:t1))];
fill(x,y,[0.5 0.5 0.5])
hold on
plot(time,mean(MaL))
plot(time,mean(MaR),'r')
axis tight
h=ttest(MaL,MaR);
t=time(find(h));
t=t(t>0.04);t=t(t<0.5);
plot(t,0,'*k')
title('MEG WbW')


MaL=squeeze(mean(abs(avgMr.individual(:,MLi,s0:s1)),2));
MaR=squeeze(mean(abs(avgMr.individual(:,MRi,s0:s1)),2));
MaL=correctBL(MaL,[1 s3]);
MaR=correctBL(MaR,[1 s3]);
EaL=squeeze(mean(abs(avgEr.individual(:,ELi,s0e:s1e)),2));
EaR=squeeze(mean(abs(avgEr.individual(:,ERi,s0e:s1e)),2));
EaL=correctBL(EaL,[1 s3]);
EaR=correctBL(EaR,[1 s3]);
t1=nearest(timeE,P100a(1));t2=nearest(timeE,P100a(2));
areaL=trapz(1000*timeE(t1:t2),EaL(:,t1:t2),2); % unit=ms by mV
areaR=trapz(1000*timeE(t1:t2),EaR(:,t1:t2),2); 
[~,P]=ttest(areaL,areaR)
t1=nearest(timeE,N170a(1));t2=nearest(timeE,N170a(2));
areaL=trapz(1000*timeE(t1:t2),EaL(:,t1:t2),2); 
areaR=trapz(1000*timeE(t1:t2),EaR(:,t1:t2),2); 
[~,P]=ttest(areaL,areaR)
t1=nearest(timeE,N400a(1));t2=nearest(timeE,N400a(2));
areaL=trapz(1000*timeE(t1:t2),EaL(:,t1:t2),2); 
areaR=trapz(1000*timeE(t1:t2),EaR(:,t1:t2),2); 
[~,P]=ttest(areaL,areaR)
t1=nearest(time,M100a(1));t2=nearest(time,M100a(2));
areaL=trapz(1000*time(t1:t2),MaL(:,t1:t2),2); 
areaR=trapz(1000*time(t1:t2),MaR(:,t1:t2),2); 
[~,P]=ttest(areaL,areaR)
t1=nearest(time,M170a(1));t2=nearest(time,M170a(2));
areaL=trapz(1000*time(t1:t2),MaL(:,t1:t2),2); 
areaR=trapz(1000*time(t1:t2),MaR(:,t1:t2),2); 
[~,P]=ttest(areaL,areaR)
t1=nearest(time,M400a(1));t2=nearest(time,M400a(2));
areaL=trapz(1000*time(t1:t2),MaL(:,t1:t2),2); 
areaR=trapz(1000*time(t1:t2),MaR(:,t1:t2),2); 
[~,P]=ttest(areaL,areaR)



figure;
t1=nearest(timeE,N400a(1));t2=nearest(timeE,N400a(2));
x=[timeE(t1:t2),timeE(t2:-1:t1)];
y=[mean(EaL(:,t1:t2)),mean(EaR(:,t2:-1:t1))];
fill(x,y,[0.5 0.5 0.5])
hold on
plot(timeE,mean(EaL))
plot(timeE,mean(EaR),'r')
axis tight
h=ttest(EaL,EaR);
t=timeE(find(h));
t=t(t>0.04);t=t(t<0.5);
plot(t,0,'*k')
title('EEG Saccades')


%% abs maps

clear
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
Mw=GavgM20;
Mw.individual=abs(GavgM20.individual);
Mw=correctBL(Mw,[-0.2 -0.05]);
Ew=GavgE20;
Ew.individual=abs(GavgE20.individual);
Ew=correctBL(Ew,[-0.2 -0.05]);
Ma=avgMr;
Ma.individual=abs(avgMr.individual);
Ma=correctBL(Ma,[-0.2 -0.05]);
Ea=avgEr;
Ea.individual=abs(avgEr.individual);
Ea=correctBL(Ea,[-0.2 -0.05]);

cfg=[];
cfg.zlim='maxabs';
cfg.zlim=[-1e-13 1e-13];
%cfg.interactive='yes';
cfg.layout='4D248.lay';
for i=60:20:300
    cfg.xlim=[i/1000 i/1000];
    figure;
    ft_topoplotER(cfg,Mw)
    title(['WbW',num2str(cfg.xlim(1))])
    figure;
    ft_topoplotER(cfg,Ma)
    title(['Sacc',num2str(cfg.xlim(1))])
end


cfg.layout='WG30.lay';
ft_topoplotER(cfg,Ew,Ea)




Mgw=ft_timelockanalysis([],GavgM20);
Mgw.avg=abs(Mgw.avg);
Mgw=correctBL(Mgw,[-0.2 -0.05]);
Egw=ft_timelockanalysis([],GavgE20);
Egw.avg=abs(Egw.avg);
Egw=correctBL(Egw,[-0.2 -0.05]);
cfg=[];
cfg.zlim=[-4e-14 4e-14];
%cfg.xlim=[0.1 0.1];
%cfg.interactive='yes';
cfg.layout='4D248.lay';
%figure;ft_topoplotER(cfg,Mw,Mgw)
cfg.xlim=[0.13 0.13];
figure;ft_topoplotER(cfg,Mw,Mgw)
figure;ft_singleplotER([],Mw,Mgw)
xlim([-0.2 0.55])

cfg=[];
cfg.zlim=[-1.5 1.5];
%cfg.xlim=[0.1 0.1];
%cfg.interactive='yes';
cfg.layout='WG30.lay';
%figure;ft_topoplotER(cfg,Mw,Mgw)
cfg.xlim=[0.13 0.13];
figure;ft_topoplotER(cfg,Ew,Egw)
figure;ft_singleplotER([],Ew,Egw)
xlim([-0.2 0.55])

%% selected channels
load LRpairs
chansM100aL = {'A131', 'A132', 'A133', 'A156', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A180', 'A181', 'A182', 'A183', 'A196', 'A197', 'A198', 'A199', 'A200', 'A201', 'A213', 'A214', 'A215', 'A216', 'A217', 'A218', 'A230', 'A231', 'A232', 'A233', 'A234', 'A235', 'A236'};
chansM100aR=LRpairs(find(ismember(LRpairs(:,1),chansM100aL)),2)';
% posterior peak at  {'A181', 'A199', 'A215'}, anterior peak at {'A197', 'A198'}
chansM100wR = {'A78', 'A79', 'A108', 'A109', 'A110', 'A111', 'A139', 'A140', 'A141', 'A142', 'A143', 'A166', 'A167', 'A168', 'A169', 'A170', 'A171', 'A188', 'A189', 'A190', 'A191', 'A192', 'A206', 'A207', 'A208', 'A209', 'A223', 'A224', 'A225'};
chansM100wL=LRpairs(find(ismember(LRpairs(:,2),chansM100wR)),1)';
% peak at {'A168', 'A169'}
chansM190aL = {'A67', 'A68', 'A69', 'A70', 'A71', 'A95', 'A96', 'A97', 'A98', 'A99', 'A100', 'A101', 'A102', 'A127', 'A128', 'A129', 'A130', 'A131', 'A132', 'A133', 'A134', 'A135', 'A155', 'A156', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A179', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A196', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A231', 'A232', 'A233', 'A234', 'A235', 'A236'};
chansM190aR=LRpairs(find(ismember(LRpairs(:,1),chansM190aL)),2)';
% posterior peak at {'A160', 'A181', 'A182'}, anterior peak = A130
chansM190wL = {'A67', 'A68', 'A69', 'A70', 'A71', 'A96', 'A97', 'A98', 'A99', 'A100', 'A101', 'A102', 'A128', 'A129', 'A130', 'A131', 'A132', 'A133', 'A134', 'A156', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A180', 'A181', 'A182', 'A183', 'A184', 'A196', 'A197', 'A198', 'A199', 'A200', 'A201', 'A214', 'A215', 'A216', 'A217', 'A218', 'A231', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237'};
chansM190wR=LRpairs(find(ismember(LRpairs(:,1),chansM190wL)),2)';
%  posterior peak {'A161', 'A181', 'A182', 'A199', 'A215'}, anterior peak at {'A197', 'A198'}
% posterior middle  = {'A136', 'A137', 'A138', 'A163', 'A164', 'A165', 'A166', 'A184', 'A185', 'A186', 'A187', 'A202', 'A203', 'A205'}
% posterior middle peak cfg.channel = {'A164', 'A165', 'A186'}

%post P7 P3 O1
%central FC1 C3 CP1
MLi=find(ismember(LRpairs,chansM100aL));
MRi=find(ismember(LRpairs,chansM100aR));
MaL=squeeze(mean(abs(avgMr.individual(:,MLi,s0:s1)),2));
MaR=squeeze(mean(abs(avgMr.individual(:,MRi,s0:s1)),2));
MaL=correctBL(MaL,[1 s3]);
MaR=correctBL(MaR,[1 s3]);
t=nearest(time,0.1);
[~,p]=ttest(MaL(:,t),MaR(:,t)); % p=0.0083


MLi=find(ismember(LRpairs,chansM190aL));
MRi=find(ismember(LRpairs,chansM190aR));
MaL=squeeze(mean(abs(avgMr.individual(:,MLi,s0:s1)),2));
MaR=squeeze(mean(abs(avgMr.individual(:,MRi,s0:s1)),2));
MaL=correctBL(MaL,[1 s3]);
MaR=correctBL(MaR,[1 s3]);
t=nearest(time,0.19);
[~,p]=ttest(MaL(:,t),MaR(:,t)); % p=0.146


MLi=find(ismember(LRpairs,chansM100wL));
MRi=find(ismember(LRpairs,chansM100wR));
MwL=squeeze(mean(abs(GavgM20.individual(:,MLi,s20:s21)),2));
MwR=squeeze(mean(abs(GavgM20.individual(:,MRi,s20:s21)),2));
MwL=correctBL(MwL,[1 s3]);
MwR=correctBL(MwR,[1 s3]);
t=nearest(time,0.13);
[~,p]=ttest(MwL(:,t),MwR(:,t)); % p=0.149


MLi=find(ismember(LRpairs,chansM190aL));
MRi=find(ismember(LRpairs,chansM190aR));
MwL=squeeze(mean(abs(GavgM20.individual(:,MLi,s20:s21)),2));
MwR=squeeze(mean(abs(GavgM20.individual(:,MRi,s20:s21)),2));
MwL=correctBL(MwL,[1 s3]);
MwR=correctBL(MwR,[1 s3]);
t=nearest(time,0.19);
[~,p]=ttest(MwL(:,t),MwR(:,t)); % p=0.1145

load LRpairsEEG
LRpairsEEG=LRpairs;load LRpairs
postL={'P7','P3','O1'};postR={'P8','P4','O2'};
centraL={'FC1','C3','CP1'};centraR={'FC2','C4','CP2'};

ELi=find(ismember(LRpairsEEG,postL));
ERi=find(ismember(LRpairsEEG,postR));
EaL=squeeze(mean(abs(avgEr.individual(:,ELi,s0e:s1e)),2));
EaR=squeeze(mean(abs(avgEr.individual(:,ERi,s0e:s1e)),2));
EaL=correctBL(EaL,[1 s3]);
EaR=correctBL(EaR,[1 s3]);
t=nearest(time,0.1);
[~,p]=ttest(EaL(:,t),EaR(:,t)); % p=0.6
t=nearest(time,0.19);
[~,p]=ttest(EaL(:,t),EaR(:,t)); % p=0.0898
ELi=find(ismember(LRpairsEEG,centraL));
ERi=find(ismember(LRpairsEEG,centraR));
EaL=squeeze(mean(abs(avgEr.individual(:,ELi,s0e:s1e)),2));
EaR=squeeze(mean(abs(avgEr.individual(:,ERi,s0e:s1e)),2));
EaL=correctBL(EaL,[1 s3]);
EaR=correctBL(EaR,[1 s3]);
t=nearest(time,0.1);
[~,p]=ttest(EaL(:,t),EaR(:,t)); % p=0.533
t=nearest(time,0.19);
[~,p]=ttest(EaL(:,t),EaR(:,t)); % p=0.0258

ELi=find(ismember(LRpairsEEG,postL));
ERi=find(ismember(LRpairsEEG,postR));
EwL=squeeze(mean(abs(GavgE20.individual(:,ELi,s20e:s21e)),2));
EwR=squeeze(mean(abs(GavgE20.individual(:,ERi,s20e:s21e)),2));
EwL=correctBL(EwL,[1 s3]);
EwR=correctBL(EwR,[1 s3]);
t=nearest(time,0.13);
[~,p]=ttest(EwL(:,t),EwR(:,t)); % p=0.1301
t=nearest(time,0.19);
[~,p]=ttest(EwL(:,t),EwR(:,t)); % p=0.0898
ELi=find(ismember(LRpairsEEG,centraL));
ERi=find(ismember(LRpairsEEG,centraR));
EwL=squeeze(mean(abs(GavgE20.individual(:,ELi,s20e:s21e)),2));
EwR=squeeze(mean(abs(GavgE20.individual(:,ERi,s20e:s21e)),2));
EwL=correctBL(EwL,[1 s3]);
EwR=correctBL(EwR,[1 s3]);
t=nearest(time,0.13);
[~,p]=ttest(EwL(:,t),EwR(:,t)); % p=0.905
t=nearest(time,0.19);
[~,p]=ttest(EwL(:,t),EwR(:,t)); % p=0.1139


