%% sub 1 had no c,* only hb_c,*
cd /home/yuval/Data/Amyg
load Gavg
cfg=[];
cfg.interactive='yes';
cfg.xlim=[0.11 0.11];
cfg.layout='4D248.lay';
ft_topoplotER(cfg,gavg)

load LRpairs
L0=LRpairs(:,1);
[~,L0i]=ismember(L0,Gavg.label);
R0=LRpairs(:,2);
[~,R0i]=ismember(R0,Gavg.label);
subj=[2:3,5,7:12]; % subject 1 has huge components not on time, 4 and 6 have wrong COH
traceL=squeeze(mean(Gavg.individual(subj,L0i,:),2));
traceR=squeeze(mean(Gavg.individual(subj,R0i,:),2));
avg=mean(traceL);
avg(2,:)=-mean(traceR);
s0=nearest(Gavg.time,0.05);
s1=nearest(Gavg.time,0.12);
s2=nearest(Gavg.time,0.17);
[~,tM1]=min(avg(:,s0:s1)');
tM1=tM1+s0-1;
[~,tM2]=max(avg(:,s1:s2)');
tM2=tM2+s1-1;
figure;plot(Gavg.time,avg)
hold on
plot(Gavg.time(tM1(1)),avg(1,tM1(1)),'or')
plot(Gavg.time(tM1(2)),avg(2,tM1(2)),'or')
plot(Gavg.time(tM2(1)),avg(1,tM2(1)),'or')
plot(Gavg.time(tM2(2)),avg(2,tM2(2)),'or')
legend('L','R')

figure;plot(Gavg.time,traceL)

figure;topoplot248(squeeze(mean(Gavg.individual(subj,:,nearest(Gavg.time,0.075)))));title('75ms')
figure;topoplot248(squeeze(mean(Gavg.individual(subj,:,nearest(Gavg.time,0.12)))));title('120ms')
figure;topoplot248(squeeze(mean(Gavg.individual(subj,:,nearest(Gavg.time,0.06)))));title('60ms')

L1 = {'A184', 'A201', 'A202', 'A217', 'A218', 'A235', 'A236', 'A237'};
[~,L1i]=ismember(L1,Gavg.label);
R1 = LRhomolog(L1);
[~,R1i]=ismember(R1,Gavg.label);
L2 =  {'A72', 'A73', 'A101', 'A102', 'A103', 'A133', 'A134', 'A135', 'A160', 'A161', 'A162', 'A181', 'A182', 'A183', 'A199', 'A200', 'A215', 'A216', 'A234'};
[~,L2i]=ismember(L2,Gavg.label);
R2 = LRhomolog(L2);
[~,R2i]=ismember(R2,Gavg.label);
L3 = {'A43', 'A44', 'A45', 'A46', 'A68', 'A69', 'A70', 'A71', 'A97', 'A98', 'A99', 'A100', 'A129', 'A130', 'A131', 'A132', 'A157', 'A158', 'A159', 'A180', 'A197', 'A198', 'A214', 'A232', 'A233'};
[~,L3i]=ismember(L3,Gavg.label);
R3 = LRhomolog(L3);
[~,R3i]=ismember(R3,Gavg.label);
L4 = {'A67', 'A95', 'A96', 'A127', 'A128', 'A155', 'A156', 'A179', 'A196', 'A213', 'A230', 'A231'};
[~,L4i]=ismember(L4,Gavg.label);
R4 = LRhomolog(L4);
[~,R4i]=ismember(R4,Gavg.label);


for APi=1:4
    traceL=squeeze(mean(Gavg.individual(subj,eval(['L',num2str(APi),'i']),:),2));
    traceR=squeeze(mean(Gavg.individual(subj,eval(['R',num2str(APi),'i']),:),2));
    avg=mean(traceL);
    avg(2,:)=-mean(traceR);
    s0=nearest(Gavg.time,0.05);
    s1=nearest(Gavg.time,0.12);
    s2=nearest(Gavg.time,0.17);
    [~,tM1]=min(avg(:,s0:s1)');
    tM1=tM1+s0-1;
    [~,tM2]=max(avg(:,s1:s2)');
    tM2=tM2+s1-1;
    figure;plot(Gavg.time,avg)
    hold on
    plot(Gavg.time(tM1(1)),avg(1,tM1(1)),'or')
    plot(Gavg.time(tM1(2)),avg(2,tM1(2)),'or')
    plot(Gavg.time(tM2(1)),avg(1,tM2(1)),'or')
    plot(Gavg.time(tM2(2)),avg(2,tM2(2)),'or')
    
end

for APi=1:4
    traceL=squeeze(mean(Gavg.individual(subj,eval(['L',num2str(APi),'i']),:),2));
    traceR=squeeze(mean(Gavg.individual(subj,eval(['R',num2str(APi),'i']),:),2));
    traceR=-traceR;
    s0=nearest(Gavg.time,0.05);
    s1=nearest(Gavg.time,0.12);
    s2=nearest(Gavg.time,0.17);
    [~,tM1(1,1:10)]=min(traceL(:,s0:s1)');
    [~,tM1(2,1:10)]=min(traceR(:,s0:s1)');
    tM1=tM1+s0-1;
    [~,tM2(1,1:10)]=min(traceL(:,s1:s2)');
    [~,tM2(2,1:10)]=min(traceR(:,s1:s2)');
    tM2=tM2+s1-1;
    figure;plot(Gavg.time,avg)
    hold on
    plot(Gavg.time(tM1(1)),avg(1,tM1(1)),'or')
    plot(Gavg.time(tM1(2)),avg(2,tM1(2)),'or')
    plot(Gavg.time(tM2(1)),avg(1,tM2(1)),'or')
    plot(Gavg.time(tM2(2)),avg(2,tM2(2)),'or')
FIXME run statistics? timing is messy
    
end