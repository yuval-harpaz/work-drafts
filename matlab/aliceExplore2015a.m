cd /home/yuval/Copy/MEGdata/alice/ga2015
load ga
load gaR
load ../ga/GavgE20
load ../ga/GavgM20

%% Gavg all alice paragraphs
t0=-0.2;t1=0.55;
s0=nearest(avgMr.time,t0);
s1=nearest(avgMr.time,t1);
time=avgMr.time(s0:s1);
s3=nearest(time,-0.05);
samples=s0:s1;
wts=squeeze(mean(avgMr.individual(:,:,samples)));
for subi=1:8
    data=squeeze(avgMr.individual(subi,:,samples));
    mult=wts'*data;
    tc=mult(logical(eye(763)));
    tc=tc/mean(tc(1:s3));
    TCalice(subi,1:763)=tc;
end
figure;plot(time,TCalice)
title('MEG')

s0e=nearest(avgEr.time,t0);
s1e=nearest(avgEr.time,t1);
timeE=avgEr.time(s0e:s1e);
s3e=nearest(timeE,-0.05);
%chi=[1:12,14:18,20:32];
samples=s0e:s1e;
wts=squeeze(mean(avgEr.individual(:,:,samples)));
for subi=1:8
    %eval(['data=squeeze(GavgE',cond{condi},'.individual(',num2str(subi),',chi,',samples,'));']);
    data=squeeze(avgEr.individual(subi,:,samples));
    mult=wts'*data;
    tc=mult(logical(eye(769)));
    tc=tc/mean(tc(1:s3e));
    TCeAlice(subi,1:769)=tc;
end
figure;plot(timeE,TCeAlice)
title('EEG')


%% avg subjects first
load LRpairsEEG; LRpairsEEG=LRpairs; load LRpairs
LRpairsEEG(6,:)=[];
[~,MLi]=ismember(LRpairs(:,1),avgMr.label);
[~,MRi]=ismember(LRpairs(:,2),avgMr.label);
[~,ELi]=ismember(LRpairsEEG(:,1),avgEr.label);
[~,ERi]=ismember(LRpairsEEG(:,2),avgEr.label);
MaL=squeeze(mean(abs(mean(avgMr.individual(:,MLi,s0:s1),1))));
MaR=squeeze(mean(abs(mean(avgMr.individual(:,MRi,s0:s1),1))));
MaL=correctBL(MaL',[1 s3]);
MaR=correctBL(MaR',[1 s3]);
figure;
plot(time,MaL)
hold on
plot(time,MaR,'r')

t=0.3;
T=nearest(avgMr.time,t);
wtsL=mean(avgMr.individual(:,MLi,T));
wtsR=mean(avgMr.individual(:,MRi,T));
for subi=1:8
    ML(subi)=wtsL*avgMr.individual(subi,MLi,T)';
    MR(subi)=wtsR*avgMr.individual(subi,MRi,T)';
end
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[t t];
cfg.zlim=[-3e-14 3e-14];
figure;ft_topoplotER(cfg,avgMr)
[~,p]=ttest(ML',MR')

t=0.1;
T=nearest(avgMr.time,t);
wtsL=mean(avgMr.individual(:,MLi,T));
wtsR=mean(avgMr.individual(:,MRi,T));
for subi=1:8
    ML(subi)=wtsL*avgMr.individual(subi,MLi,T)';
    MR(subi)=wtsR*avgMr.individual(subi,MRi,T)';
end
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[t t];
cfg.zlim=[-1e-13 1e-13];
figure;ft_topoplotER(cfg,avgMr)
[~,p]=ttest(ML',MR')

t=0.186;
T=nearest(avgMr.time,t);
wtsL=mean(avgMr.individual(:,MLi,T));
wtsR=mean(avgMr.individual(:,MRi,T));
for subi=1:8
    ML(subi)=wtsL*avgMr.individual(subi,MLi,T)';
    MR(subi)=wtsR*avgMr.individual(subi,MRi,T)';
end
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[t t];
cfg.zlim=[-1e-13 1e-13];
figure;ft_topoplotER(cfg,avgMr)
[~,p]=ttest(ML',MR')

% ERP
EaL=squeeze(mean(abs(mean(avgEr.individual(:,ELi,s0e:s1e),1))));
EaR=squeeze(mean(abs(mean(avgEr.individual(:,ERi,s0e:s1e),1))));
EaL=correctBL(EaL',[1 s3]);
EaR=correctBL(EaR',[1 s3]);


figure;
plot(timeE,EaL)
hold on
plot(timeE,EaR,'r')

t=0.11;
T=nearest(avgEr.time,t);
wtsL=mean(avgEr.individual(:,ELi,T));
wtsR=mean(avgEr.individual(:,ERi,T));
for subi=1:8
    EL(subi)=wtsL*avgEr.individual(subi,ELi,T)';
    ER(subi)=wtsR*avgEr.individual(subi,ERi,T)';
end
cfg=[];
cfg.layout='WG32.lay';
cfg.xlim=[t t];
figure;ft_topoplotER(cfg,avgEr)
[~,p]=ttest(EL',ER')

t=0.175;
T=nearest(avgEr.time,t);
wtsL=mean(avgEr.individual(:,ELi,T));
wtsR=mean(avgEr.individual(:,ERi,T));
for subi=1:8
    EL(subi)=wtsL*avgEr.individual(subi,ELi,T)';
    ER(subi)=wtsR*avgEr.individual(subi,ERi,T)';
end
cfg=[];
cfg.layout='WG32.lay';
cfg.xlim=[t t];
figure;ft_topoplotER(cfg,avgEr)
[~,p]=ttest(EL',ER')



M20L=squeeze(mean(abs(mean(GavgM20.individual(:,MLi,:),1))));
M20R=squeeze(mean(abs(mean(GavgM20.individual(:,MRi,:),1))));
M20L=correctBL(M20L',[1 s3]);
M20R=correctBL(M20R',[1 s3]);
figure;
plot(GavgM20.time,M20L)
hold on
plot(GavgM20.time,M20R,'r')
ylim([-0.5e-14 2.5e-14])



M20L=squeeze(mean(mean(abs(GavgM20.individual(:,MLi,:)),2)));
M20R=squeeze(mean(mean(abs(GavgM20.individual(:,MRi,:)),2)));
M20L=correctBL(M20L',[1 s3]);
M20R=correctBL(M20R',[1 s3]);
figure;
plot(GavgM20.time,M20L)
hold on
plot(GavgM20.time,M20R,'r')
ylim([-0.5e-14 2.5e-14])


%% ttests for avg subj first L and R
samples=s0:s1;
wtsL=squeeze(mean(avgMr.individual(:,MLi,samples)));
wtsR=squeeze(mean(avgMr.individual(:,MRi,samples)));
TCmAliceL=[];
TCmAliceR=[];
for subi=1:8
    %eval(['data=squeeze(GavgE',cond{condi},'.individual(',num2str(subi),',chi,',samples,'));']);
    data=squeeze(avgMr.individual(subi,MLi,samples));
    mult=wtsL'*data;
    tc=mult(logical(eye(763)));
    tc=tc/mean(tc(1:s3));
    TCmAliceL(subi,1:763)=tc;
    data=squeeze(avgMr.individual(subi,MRi,samples));
    mult=wtsR'*data;
    tc=mult(logical(eye(763)));
    tc=tc/mean(tc(1:s3));
    TCmAliceR(subi,1:763)=tc;
end



D={};
D.avg=TCmAliceL;
D.avg(end+1:end*2,:)=TCmAliceR;
D.time=time;
%D.label{1}='A1';
cfg=[];
cfg.notBefore=0.07;
cfg.notAfter=0.35;
cfg.method='absMean';
cfg.maxDist=0.3;
cfg.zThr=0;
cfg.smooth=20;
Ithroughs=findCompLims(cfg,D);
oksamp=[];
for compi=1:3
    oksamp=[oksamp,Itroughs(compi,1):Itroughs(compi,2)];
end
    


figure;
plot(time,TCmAliceL,'k')
hold on
plot(time,TCmAliceR,'r')
[~,pL]=ttest(TCmAliceL(:,oksamp));
sig=pL<0.01;
sig=oksamp(sig);
plot(time(sig),-10,'.k')
[~,pR]=ttest(TCmAliceR(:,oksamp));
sig=pR<0.01;
sig=oksamp(sig);
plot(time(sig),-20,'.r')

samples=s0e:s1e;
wtsL=squeeze(mean(avgEr.individual(:,ELi,samples)));
wtsR=squeeze(mean(avgEr.individual(:,ERi,samples)));
for subi=1:8
    %eval(['data=squeeze(GavgE',cond{condi},'.individual(',num2str(subi),',chi,',samples,'));']);
    data=squeeze(avgEr.individual(subi,ELi,samples));
    mult=wtsL'*data;
    tc=mult(logical(eye(769)));
    tc=tc/mean(tc(1:s3e));
    TCeAliceL(subi,1:769)=tc;
    data=squeeze(avgEr.individual(subi,ERi,samples));
    mult=wtsR'*data;
    tc=mult(logical(eye(769)));
    tc=tc/mean(tc(1:s3e));
    TCeAliceR(subi,1:769)=tc;
end


D={};
D.avg=TCeAliceL;
D.avg(end+1:end*2,:)=TCeAliceR;
D.time=timeE;
%D.label{1}='A1';
cfg=[];
cfg.notBefore=0.07;
cfg.notAfter=0.35;
cfg.method='absMean';
cfg.maxDist=0.3;
cfg.zThr=0;
cfg.smooth=20;
Ithroughs=findCompLims(cfg,D);
oksamp=Itroughs(1,1):Itroughs(end,end);
figure;
plot(timeE,TCeAliceL,'k')
hold on
plot(time,TCeAliceR,'r')
[~,pL]=ttest(TCeAliceL(:,oksamp));
sig=pL<0.05;
sig=oksamp(sig);
plot(time(sig),-25,'.k')
[~,pR]=ttest(TCeAliceR(:,oksamp));
sig=pR<0.01;
sig=oksamp(sig);
plot(time(sig),-50,'.r')
title('EEG')
xlim([-0.2 0.6])


%% ttests for avg chans first L and R
samples=s0:s1;
TCmAliceL=[];
TCmAliceR=[];
TCmAliceL=squeeze(mean(abs(avgMr.individual(:,MLi,samples)),2));
TCmAliceR=squeeze(mean(abs(avgMr.individual(:,MRi,samples)),2));
TCmAliceL=correctBL(TCmAliceL,[1:153]);
TCmAliceR=correctBL(TCmAliceR,[1:153]);
D={};
D.avg=TCmAliceL;
D.avg(end+1:end*2,:)=TCmAliceR;
D.time=time;
%D.label{1}='A1';
cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.35;
cfg.method='absMean';
cfg.maxDist=0.3;
cfg.zThr=0;
cfg.smooth=20;
Ithroughs=findCompLims(cfg,D);
oksamp=Itroughs(1,1):Itroughs(end,end);
figure;
plot(time,TCmAliceL,'k')
hold on
plot(time,TCmAliceR,'r')
[~,pL]=ttest(TCmAliceL(:,oksamp));
sig=pL<0.01;
sig=oksamp(sig);
plot(time(sig),-1e-14,'.k')
[~,pR]=ttest(TCmAliceR(:,oksamp));
sig=pR<0.01;
sig=oksamp(sig);
plot(time(sig),-1.5e-14,'.r')
title('MEG')
%EEG
samples=s0e:s1e;
TCeAliceL=[];
TCeAliceR=[];
TCeAliceL=squeeze(mean(abs(avgEr.individual(:,ELi,samples)),2));
TCeAliceR=squeeze(mean(abs(avgEr.individual(:,ERi,samples)),2));
TCeAliceL=correctBL(TCeAliceL,[1:153]);
TCeAliceR=correctBL(TCeAliceR,[1:153]);

D={};
D.avg=TCeAliceL;
D.avg(end+1:end*2,:)=TCeAliceR;
D.time=timeE;
%D.label{1}='A1';
cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.35;
cfg.method='absMean';
cfg.maxDist=0.3;
cfg.zThr=0;
cfg.smooth=20;
Ithroughs=findCompLims(cfg,D);
oksamp=Itroughs(1,1):Itroughs(end,end);
figure;
plot(timeE,TCeAliceL,'k')
hold on
plot(timeE,TCeAliceR,'r')
[~,pL]=ttest(TCeAliceL(:,oksamp));
sig=pL<0.05;
sig=oksamp(sig);
plot(time(sig),-0.5,'.k')
[~,pR]=ttest(TCeAliceR(:,oksamp));
sig=pR<0.01;
sig=oksamp(sig);
plot(time(sig),-0.7,'.r')
title('EEG')
xlim([-0.2 0.6])



%% ttests for avg subj first L and R WbW
[~,ELi]=ismember(LRpairsEEG(:,1),GavgE20.label);
[~,ERi]=ismember(LRpairsEEG(:,2),GavgE20.label);
samples=1:length(GavgM20.time);
wtsL=squeeze(mean(GavgM20.individual(:,MLi,samples)));
wtsR=squeeze(mean(GavgM20.individual(:,MRi,samples)));
TCmAliceL=[];
TCmAliceR=[];
for subi=1:8
    %eval(['data=squeeze(GavgE',cond{condi},'.individual(',num2str(subi),',chi,',samples,'));']);
    data=squeeze(GavgM20.individual(subi,MLi,samples));
    mult=wtsL'*data;
    tc=mult(logical(eye(815)));
    tc=tc-mean(tc(1:s3));
    TCmAliceL(subi,1:815)=tc;
    data=squeeze(GavgM20.individual(subi,MRi,samples));
    mult=wtsR'*data;
    tc=mult(logical(eye(815)));
    tc=tc-mean(tc(1:s3));
    TCmAliceR(subi,1:815)=tc;
end



D={};
D.avg=TCmAliceL;
D.avg(end+1:end*2,:)=TCmAliceR;
D.time=GavgM20.time;
%D.label{1}='A1';
cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.5;
cfg.method='absMean';
cfg.maxDist=0.3;
cfg.zThr=0;
cfg.smooth=20;
Ithroughs=findCompLims(cfg,D);
oksamp=Itroughs(1,1):Itroughs(end,end);


figure;
plot(GavgM20.time,TCmAliceL,'k')
hold on
plot(GavgM20.time,TCmAliceR,'r')
[~,pL]=ttest(TCmAliceL(:,oksamp));
sig=pL<0.01;
sig=oksamp(sig);
plot(GavgM20.time(sig),-0.5e-25,'.k')
[~,pR]=ttest(TCmAliceR(:,oksamp));
sig=pR<0.01;
sig=oksamp(sig);
plot(GavgM20.time(sig),-0.75e-25,'.r')
title('MEG')

samples=1:length(GavgE20.time);
wtsL=squeeze(mean(GavgE20.individual(:,ELi,samples)));
wtsR=squeeze(mean(GavgE20.individual(:,ERi,samples)));
for subi=1:8
    %eval(['data=squeeze(GavgE',cond{condi},'.individual(',num2str(subi),',chi,',samples,'));']);
    data=squeeze(GavgE20.individual(subi,ELi,samples));
    mult=wtsL'*data;
    tc=mult(logical(eye(820)));
    tc=tc-mean(tc(1:s3e));
    TCeAliceL(subi,1:820)=tc;
    data=squeeze(GavgE20.individual(subi,ERi,samples));
    mult=wtsR'*data;
    tc=mult(logical(eye(820)));
    tc=tc-mean(tc(1:s3e));
    TCeAliceR(subi,1:820)=tc;
end


D={};
D.avg=TCeAliceL;
D.avg(end+1:end*2,:)=TCeAliceR;
D.time=GavgE20.time;
%D.label{1}='A1';
cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.5;
cfg.method='absMean';
cfg.maxDist=0.3;
cfg.zThr=0;
cfg.smooth=20;
Ithroughs=findCompLims(cfg,D);
oksamp=Itroughs(1,1):Itroughs(end,end);
figure;
plot(GavgE20.time,TCeAliceL,'k')
hold on
plot(GavgE20.time,TCeAliceR,'r')
[~,pL]=ttest(TCeAliceL(:,oksamp));
sig=pL<0.05;
sig=oksamp(sig);
plot(time(sig),-5,'.k')
[~,pR]=ttest(TCeAliceR(:,oksamp));
sig=pR<0.01;
sig=oksamp(sig);
plot(time(sig),-10,'.r')
title('EEG')
xlim([-0.2 0.6])


%% ttests for avg chans first L and R WbW
samples=s0:s1;
TCmAliceL=[];
TCmAliceR=[];
TCmAliceL=squeeze(mean(abs(GavgM20.individual(:,MLi,samples)),2));
TCmAliceR=squeeze(mean(abs(GavgM20.individual(:,MRi,samples)),2));
TCmAliceL=correctBL(TCmAliceL,[1:153]);
TCmAliceR=correctBL(TCmAliceR,[1:153]);
D={};
D.avg=TCmAliceL;
D.avg(end+1:end*2,:)=TCmAliceR;
D.time=time;
%D.label{1}='A1';
cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.35;
cfg.method='absMean';
cfg.maxDist=0.3;
cfg.zThr=0;
cfg.smooth=20;
Ithroughs=findCompLims(cfg,D);
oksamp=Itroughs(1,1):Itroughs(end,end);
figure;
plot(time,TCmAliceL,'k')
hold on
plot(time,TCmAliceR,'r')
[~,pL]=ttest(TCmAliceL(:,oksamp));
sig=pL<0.01;
sig=oksamp(sig);
plot(time(sig),-1e-14,'.k')
[~,pR]=ttest(TCmAliceR(:,oksamp));
sig=pR<0.01;
sig=oksamp(sig);
plot(time(sig),-1.5e-14,'.r')
title('MEG')
%EEG
samples=s0e:s1e;
TCeAliceL=[];
TCeAliceR=[];
TCeAliceL=squeeze(mean(abs(GavgE20.individual(:,ELi,samples)),2));
TCeAliceR=squeeze(mean(abs(GavgE20.individual(:,ERi,samples)),2));
TCeAliceL=correctBL(TCeAliceL,[1:153]);
TCeAliceR=correctBL(TCeAliceR,[1:153]);

D={};
D.avg=TCeAliceL;
D.avg(end+1:end*2,:)=TCeAliceR;
D.time=GavgE20.time;
%D.label{1}='A1';
cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.35;
cfg.method='absMean';
cfg.maxDist=0.3;
cfg.zThr=0;
cfg.smooth=20;
Ithroughs=findCompLims(cfg,D);
oksamp=Itroughs(1,1):Itroughs(end,end);
figure;
plot(GavgE20.time,TCeAliceL,'k')
hold on
plot(GavgE20.time,TCeAliceR,'r')
[~,pL]=ttest(TCeAliceL(:,oksamp));
sig=pL<0.05;
sig=oksamp(sig);
plot(GavgE20.time(sig),-0.5,'.k')
[~,pR]=ttest(TCeAliceR(:,oksamp));
sig=pR<0.01;
sig=oksamp(sig);
plot(GavgE20.time(sig),-0.7,'.r')
title('EEG')
xlim([-0.2 0.6])

