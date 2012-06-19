% lambda2

%% read the data, exclude MOG trials
cd /home/yuval/Data/MOI704
load temp
load data
load trialinfo
% now for all data
chan={'A191','A215'}; % or A191 and A199
[~,chi]=ismember(chan,data.label);

cfg=[];
cfg.trials=trialinfo;
cfg.hpfilter='yes';
cfg.hpfreq=1;
dataNoMOG=ft_preprocessing(cfg,data);
t=dataNoMOG.time{1,1};

%% average
cfg=[];cfg.channel='A191';
avg=timelockanalysis(cfg,dataNoMOG);

plot(avg.time,avg.avg)
%% find SNR peaks etc
[trials,pI,nI,pP,nP,asip]=findTempInTrials(temp,dataNoMOG,chi(1),trialinfo,0.115,0.145);

figure;plot(t(pP),'r.');hold on;plot(t(nP),'b.');

%% average peaks for ~0.115ms
peak115ms=(0.10<trials(7,:) & trials(7,:)<0.13);sum(peak115ms)
trNum=find(peak115ms);
pkLat=trials(7,peak115ms);
avgTrace=avgByInd('A191',trNum,pkLat,dataNoMOG,401);
% tempRaw=avgTrace(181:213);tempRaw=tempRaw>0;
%% make new template
%s115=nearest(t,0.115);
half=fliplr(avgTrace(1,1:201));
x1=find(half<0,1);
x1=203-x1;
x2=find(avgTrace(1,201:end)<0,1)+199;
figure;plot(avgTrace);hold on;plot([x1 x2],avgTrace([x1 x2]),'.m');

x=x1:197;y=avgTrace(x);
p = polyfit(x,y,1);
f1 = polyval(p,x1:201);
x=205:x2;y=avgTrace(x);%.*10^14;
p = polyfit(x,y,1);
f2 = polyval(p,201:x2);
figure;plot(avgTrace,'m');hold on; plot(x1:201,f1,'b'); plot(201:x2,f2,'k')

temp=[f1(1:end-1) mean([f1(end) f2(1)]) f2(2:end)];
tempPad=zeros(1,length(temp).*2);
tempPad(length(temp*2)+1:end)=temp;

save temp115 temp tempPad
%% fit template to data
load temp115
deadT=0;
[trials,pI,nI,pP,nP,asip]=findTempInTrials(temp,dataNoMOG,chi(1),trialinfo,0.115,0.145,[],[],deadT);
%figure;plot(t(pP),'r.');hold on;plot(t(nP),'b.');
figure;hist(t(pP),50);title(['deadT = ',num2str(deadT)]);

%% average again by new index
peak115ms=(0.10<trials(7,:) & trials(7,:)<0.13);sum(peak115ms)
trNum=find(peak115ms);
pkLat=trials(7,peak115ms);
avgTrace=avgByInd('A191',trNum,pkLat,dataNoMOG,401);
