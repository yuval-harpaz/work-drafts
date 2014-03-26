function DenisHBcomp(subNum)
sub=num2str(subNum)

cd /home/yuval/Data/Denis/main_fifs
cd (sub)

load HBtimes
HBtimes=HBtimes(HBtimes>1);
HBtimes=HBtimes(1:end-3);
cfg=[];
% cfg.trl=round(HBtimes'*678.17)-678;
% cfg.trl(:,2)=round(HBtimes'*678.17)+678;
% cfg.trl(:,3)=-678;
cfg.dataset='main_lf_raw.fif';
% cfg.trl=[1,67817,0];
cfg.channel='MEG';
raw=ft_preprocessing(cfg);
[avgHB,avgTimes]=meanHB(raw.trial{1,1},678.17,HBtimes);
avghb.time=avgTimes;
avghb.avg=avgHB;
for chani=1:248
    avghb.label{chani,1}=['A',num2str(chani)];
end
cfg=[];
cfg.notBefore=-0.3;
cfg.notAfter=0.5;
cfg.zThr=0.5;
cfg.maxDist=0.05;
cfg.method='absMean';
cfg.pToP=0.02;
[~,Ipeaks]=findCompLims(cfg,avghb);
Ri=nearest(Ipeaks,679);
topoQ=avgHB(:,Ipeaks(Ri-1));
topoR=avgHB(:,679);
topoS=avgHB(:,Ipeaks(Ri+1));
topoT=avgHB(:,Ipeaks(Ri+2));
topoShake=avgHB(:,Ipeaks(Ri+4));

cfg = [];
cfg.topo      = [topoQ,topoR,topoS,topoT,topoShake];
cfg.topolabel = raw.label;
comp     = ft_componentanalysis(cfg, raw);

cfg = [];
cfg.component = [1,2,3,4,5]; % change
cfg.feedback='no';
dataca = ft_rejectcomponent(cfg, comp,raw);
avgHBca=meanHB(dataca.trial{1,1},678.17,HBtimes);
figure;
plot(avgTimes,avgHB,'r')
hold on
plot(avgTimes,avgHBca,'g')
Shi2=nearest(avgTimes,0.666);
topoShake2=avgHB(:,Shi2);
cfg = [];
cfg.topo      = topoShake2;
cfg.topolabel = raw.label;
comp     = ft_componentanalysis(cfg, raw);
cfg = [];
cfg.component = 1; % change
cfg.feedback='no';
dataca = ft_rejectcomponent(cfg, comp,raw);
avgHBhbca=meanHB(dataca.trial{1,1},678.17,HBtimes);
avgHBhb=meanHB(raw.trial{1,1},678.17,HBtimes);
figure;
plot(avgTimes,avgHB,'r')
hold on
plot(avgTimes,avgHBhb,'k')
plot(avgTimes,avgHBhbca,'g')
%%

load dataLf
topoTrace=topo'*data;
coef=polyfit(topoTrace',mean(data)',1);
topoSc=topo*coef(1);
ttsc=topoSc'*data;
figure;plot(ttsc,'r');hold on;plot(mean(data),'k')

    %test=topoSc*ttsc;
    test=topo*topoTrace(1:10172);
    sc=max(abs(mean(test)));
    sc2=max(abs(mean(topoTrace(1:10172))));
    coef=polyfit(sc*mean(data(:,1:10172))',sc*mean(test)',1);
    coef=coef(1);
dataComp=zeros(size(data));
sc=max(abs(topoTrace))
c=0;
for chani=1:248
%     sc=max(abs(data(chani,:)));
%     
    coef=polyfit(sc*data(chani,:)',sc*topoTrace',1);
    dataComp(chani,:)=data(chani,:)-topoTrace/coef(1);
    c=c+1;
    coefs(c)=coef(1);
end
figure;plot(data(chani,:),'k');hold on;plot(dataComp(chani,:),'g');plot(topoTrace/coef(1),'r')
[avgHB,avgTimes]=meanHB(data,678.17,HBtimes,1);
avgHBR=meanHB(dataComp,678.17,HBtimes);
figure;plot(avgTimes,avgHB,'r');hold on;plot(avgTimes,avgHBR,'g')