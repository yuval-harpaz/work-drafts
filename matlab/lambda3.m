
%% load data
cd /home/yuval/Data/MOI704
load temp
load data
load trialinfo
chan={'A191','A215'}; % or A191 and A199
[~,chi]=ismember(chan,data.label);

cfg=[];
cfg.trials=trialinfo;
cfg.hpfilter='yes';
cfg.hpfreq=1;
dataNoMOG=ft_preprocessing(cfg,data);
t=dataNoMOG.time{1,1};


%% find template for all alpha spikes
[trials,pI,nI,pP,nP,asip,peaks]=findTempInTrials(temp,dataNoMOG,chi(1),trialinfo,0.115,0.145,[],[],30);
counter=0;
avgTrace=zeros(1,51);
for triali=1:length(peaks)
    if ~isempty(peaks(1,triali).pos)
        for pi=1:length(peaks(1,triali).pos)
            pSamp=peaks(1,triali).pos(pi);
            if pSamp>26
                avgTrace=avgTrace+dataNoMOG.trial{1,triali}(chi(1),pSamp-25:pSamp+25);
                counter=counter+1;
            end
        end
    end
end
avgTrace=avgTrace./counter;
plot(avgTrace)

tempAll=avgTrace(9:40);
save tempAll tempAll
save avgAlpha avgTrace

%% lines from temp
half=fliplr(avgTrace(1,1:26));
x1=find(half<0,1);
x1=29-x1;
x2=find(avgTrace(1,26:end)<0,1)+24;
figure;plot(avgTrace);hold on;plot([x1 x2],avgTrace([x1 x2]),'.m');
x=x1:25;y=avgTrace(x);
p1 = polyfit(x,y,1);
f1 = polyval(p1,x1:25);
x=26:x2;y=avgTrace(x);%.*10^14;
p2 = polyfit(x,y,1);
f2 = polyval(p2,26:x2);


%calculate meeting point of the two lines;
a1=p1(1);b1=p1(2);a2=p2(1);b2=p2(2);
X=(b2-b1)./(a1-a2);
Y=a1*X+b1;


% move ascending line to begin at x,y = (1,0)
P1=[p1(1),-p1(1)];
F1=polyval(P1,1:25);
F1=F1(F1<Y);
% find shifted X
Xsh=(Y-P1(2))/P1(1);
% find descending line
P2=[p2(1),Y-(p2(1)*Xsh)];
F2=polyval(P2,length(F1):length(F1)+20);
F2=F2(F2<Y);F2=F2(F2>0);
figure;plot(avgTrace,'m');hold on; % plot(x1:25,f1,'b'); plot(26:x2,f2,'k');
plot(Xsh,Y,'ro')
plot(1:length(F1),F1,'.g')
plot(length(F1)+1:length(F2)+length(F1),F2,'.g')
legend('averaged trace','meeting point of curves','new template points')

temp=[F1 F2];
tempPad=zeros(1,2*length(temp));
tempPad(length(temp)+1:end)=temp;

save tempAlpha temp tempPad avgTrace
% % limit line to hight of Y
% nearest(F1,Y)
% F1=F1(1:find(F1>mx,1));
% plot(1:length(F1),F1,'g')
% 
% P2=[p2(1),F1(end)-p2(1)*length(F1)];
% F2=polyval(P2,length(F1):length(F1)+20);
% F2=F2(find(F2>0));
% plot(length(F1):length(F2)+length(F1)-1,F2,'g')

%% cd /home/yuval/Data/MOI704
load tempAlpha
load data
load trialinfo
chan={'A191','A215'}; % or A191 and A199
[~,chi]=ismember(chan,data.label);

cfg=[];
cfg.trials=trialinfo;
cfg.hpfilter='yes';
cfg.hpfreq=1;
dataNoMOG=ft_preprocessing(cfg,data);
t=dataNoMOG.time{1,1};
[~,time0]=max(abs(temp));
[trials,pI,nI,pP,nP,asip,peaks]=findTempInTrials(temp,time0,dataNoMOG,chi(1),trialinfo,0.115,0.145,[],[],30);
figure;
hist(data.time{1,1}(pP),50);
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
hold on;
hist(data.time{1,1}(nP),50)
legend('positive','negative')
title('peaks on signal trace')

[~,time0]=max(abs(tempPad));
[trials,pI,nI,pP,nP,asip,peaks]=findTempInTrials(tempPad,time0,dataNoMOG,chi(1),trialinfo,0.115,0.145,[],[],30);
figure;
hist(data.time{1,1}(pP),50);
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
hold on;
hist(data.time{1,1}(nP),50)
legend('positive','negative')
title('padded peaks on signal trace')

%% create temp for M200
load tempM150 % equals to load temp
[~,~,~,pP,~,~,peaks]=findTempInTrials(tempPad,dataNoMOG,chi(1),trialinfo,0.2,[],[],[],30);
figure;hist(data.time{1,1}(pP),50);
figure;plot(t(pP),'o') % 160:230ms
sizeTemp=101;
counter=0;
s1=nearest(t,0.160);s2=nearest(t,0.230);
avgTrace=zeros(1,sizeTemp);
for triali=1:length(peaks)
    if ~isempty(peaks(1,triali).pos)
        for pi=1:length(peaks(1,triali).pos)
            pSamp=peaks(1,triali).pos(pi);
            if pSamp > s1 && pSamp < s2
                avgTrace=avgTrace+dataNoMOG.trial{1,triali}(chi(1),pSamp-(sizeTemp-1)/2:pSamp+(sizeTemp-1)/2);
                counter=counter+1;
            end
        end
    end
end
avgTrace=avgTrace./counter;
plot(avgTrace);title(['average of ',num2str(counter),' trials']);
save avgTrace194ms avgTrace
% find positive range around peak
midl=(sizeTemp-1)./2+1;
half=fliplr(avgTrace(1,1:midl));
x1=find(half<0,1);
x1=midl-x1;
x2=find(avgTrace(1,midl:end)<0,1)+midl;
figure;plot(avgTrace);hold on;plot([x1 x2],avgTrace([x1 x2]),'.m');
x=x1:midl;y=avgTrace(x);
p1 = polyfit(x,y,1);
f1 = polyval(p1,x1:midl);
x=midl+1:x2;y=avgTrace(x);%.*10^14;
p2 = polyfit(x,y,1);
f2 = polyval(p2,midl+1:x2);
figure;plot(avgTrace,'m');hold on;

%calculate meeting point of the two lines;
a1=p1(1);b1=p1(2);a2=p2(1);b2=p2(2);
X=(b2-b1)./(a1-a2);
Y=a1*X+b1;


% move ascending line to begin at x,y = (1,0)
P1=[p1(1),-p1(1)];
F1=polyval(P1,1:midl);
F1=F1(F1<Y);
% find shifted X
Xsh=(Y-P1(2))/P1(1);
% find descending line
P2=[p2(1),Y-(p2(1)*Xsh)];
F2=polyval(P2,length(F1):length(F1)+120);
F2=F2(F2<Y);F2=F2(F2>0);
figure;plot(avgTrace,'m');hold on; % plot(x1:25,f1,'b'); plot(26:x2,f2,'k');
plot(x1:x2,[f1 f2]);
plot(Xsh,Y,'ro')
plot(1:length(F1),F1,'.g')
plot(length(F1)+1:length(F2)+length(F1),F2,'.g')

legend('averaged trace','fitted lines','meeting point of lines','new template points')
temp=[F1 F2];
tempPad=zeros(1,2*length(temp));
tempPad(length(temp)+1:end)=temp;
save temp195ms temp tempPad
%% create trials with indices for alpha like M115 peaks, M150 peaks and M200

% alpha
load tempAlpha
[~,time0]=max(abs(tempPad));
[~,~,~,pP,~,~,alpha]=findTempInTrials(tempPad,time0,dataNoMOG,chi(1),trialinfo,0.115,[],[],[],30);
figure;hist(data.time{1,1}(pP),50);title('Alpha template')
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')

load tempM150 % equals to load temp
[~,time0]=max(abs(tempPad));
[~,~,~,~,nP,~,M150]=findTempInTrials(tempPad,time0,dataNoMOG,chi(1),trialinfo,[],0.145,[],[],30);
figure;hist(data.time{1,1}(nP),50);title('M150 template');

load temp195ms
[~,time0]=max(abs(temp));
[~,~,~,pP,~,~,alpha]=findTempInTrials(temp,time0,dataNoMOG,chi(1),trialinfo,0.195,[],[],[],30);
figure;hist(data.time{1,1}(pP),50);title('Alpha template')
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')




%% find alpha template in data

% [trials,pI,nI,pP,nP,asip,peaks]=findTempInTrials(tempAll,dataNoMOG,chi(1),trialinfo,0.115,0.145,[],[],30);
% 
% figure;plot(t(pP),'r.');hold on;plot(t(nP),'b.');
% figure;
% hist(data.time{1,1}(pP),50);
% h = findobj(gca,'Type','patch');
% set(h,'FaceColor','r')
% hold on;
% hist(data.time{1,1}(nP),50)
% legend('positive','negative')
% title('peaks on signal trace')
% 
% peakPre=(0>trials(7,:) | trials(7,:)>0.16);sum(peakPre)
% trNum=find(peakPre);
% pkLat=trials(7,peakPre);
% avgTrace=avgByInd('A191',trNum,pkLat,dataNoMOG,401);
