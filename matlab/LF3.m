%% random numbers

sRates=[500 1000 2000];
reps=[100 500 1000 3000 5000 7500 10000];
neg=[];
ratio=[];
for perm=1:100
    repCount=0;
    for repi=1:length(reps)
        rateCount=0;
        repCount=repCount+1;
        for ratei=1:length(sRates)
            rateCount=rateCount+1;
            data=rand(100,300*sRates(ratei));
            data=data-0.5;
            lf=correctLF(data,sRates(ratei),'time',reps(repCount),50,4);
            close;
            f=abs(fftBasic(data,sRates(ratei)));
            fcl=abs(fftBasic(lf,sRates(ratei)));
            % figure;
            % plot(mean(f));hold on;plot(mean(fcl),'r')
            %lfBL=mean(fcl(:,[1:49 51:99]),2);
            fcl50=fcl(:,50);
            f50=f(:,50);
            
            
            ratio(rateCount,repCount,perm)=mean((fcl50-f50)./f50);
            % [~,p,~,stat]=ttest(f(:,50),fcl(:,50))
%             [~,p,~,stat]=ttest(f50,fcl50)
%             if p<0.1 && stat.tstat>0 % clean lower than raw
%                 neg(rateCount,repCount)=true;
%             else
%                 neg(rateCount,repCount)=false;
%             end
            
        end
    end
end
ratMean=mean(squeeze(mean(ratio,1)),2);
for repi=1:7
    x=squeeze(ratio(:,repi,:));
    ratSD(repi)=std(x(:));
end
figure;plot(reps,squeeze(mean(ratio,3)));
hold on
plot(reps,ratMean,'k')
plot(reps,ratMean+ratSD','.k')
legend('s-rate 500','s-rate 1000','s-rate 2000','mean','SD')

figure;plot(f(1,:),'r');hold on;plot(fcl(1,:),'g')
ylim([0 2])
xlim([40 110])
title ('abs(fourier) for random numbers, ONE CHANNEL')
figure;plot(mean(f),'r');hold on;plot(mean(fcl),'g')
ylim([0 2])
xlim([40 110])
title ('abs(fourier) for random numbers, averaged over 100 CHANNELS')
% legend(num2str(sRates'))
%plot(reps,mean(squeeze(ratio(1,:,:)),2)+std(squeeze(ratio(1,:,:))')'./10,'r.')
%% empty room
cd /home/yuval/Data/emptyRoom

cfg=[];
cfg.channel='MEG';
cfg.dataset=source;
data=ft_preprocessing(cfg);
f=abs(fftBasic(data.trial{1,1},data.fsample));
[~,mini]=min(f(:,50));
[~,i50]=sort(f(:,50));
n=100;
chan=data.trial{1,1}(i50(1:n),:);
f=abs(fftBasic(chan,data.fsample));
%correctLF(chan,data.fsample,'time',50,50);
%sRates=data.fsample;
reps=[100 500 1000 1500 2000 2500 3000];% 5000 7500 10000];
neg=[];
ratio=[];
repCount=0;
trig=readTrig_BIU;
for repi=1:length(reps)
    rateCount=0;
    repCount=repCount+1;
    lf=correctLF(chan,data.fsample,trig,reps(repCount),50);
    close;
    fcl=abs(fftBasic(lf,data.fsample));
    fcl50=fcl(:,50);
    f50=f(:,50);
    ratio(1,repCount)=mean((fcl50-f50)./f50);
    ratio(2,repCount)=std((fcl50-f50)./f50);
end
figure;plot(reps,ratio(1,:))
hold on;plot(reps,ratio(1,:)+ratio(2,:)/sqrt(n),'k.')

figure;plot(f','r');hold on;plot(fcl','g');
%% 
figure;
plot(mean(lf));hold on;plot(mean(data),'r')
% 1017 sRate
N=[512,1024,2048,4096];

nPerm=100;
LF=[];
for perm=1:nPerm
    
    for i=1:4
        lf=correctLF(rand(100,100000),1017.23,'time',N(i),50,4,0.1);
        close;
        fcl=mean(abs(fftBasic(lf(:,50000:end),1017.23)),1);
        LF(i,perm)=fcl(50);
    end
    lf=correctLF(rand(100,100000),1017.23,'time','GLOBAL',50,4,0.1);
    close;
    fcl=abs(fftBasic(lf(:,50000:end),1017.23));
    LF(5,perm)=fcl(50);
end
ttest2(LF(3,:),LF(4,:))
figure;
plot(LF')
saveas(1,'100perm1017.png')



N=[512,1024,2048,4096];
nPerm=10;
LF=[];
sRate=500;
for perm=1:nPerm
    
    for i=1:4
        lf=correctLF(rand(100,150000),sRate,'time',N(i),50,4,0.1);
        close;
        fcl=mean(abs(fftBasic(lf(:,50000:end),sRate)),1);
        LF(i,perm)=fcl(50);
    end
%     lf=correctLF(rand(100,100000),sRate,'time','GLOBAL',50,4,0.1);
%     close;
%     fcl=abs(fftBasic(lf(:,50000:end),sRate));
%     LF(5,perm)=fcl(50);
end
%ttest2(LF(3,:),LF(4,:))
figure;
plot(LF')
legend(num2str(N'))
%saveas(1,'100perm1017.png')

% legend(num2str(N(1)),num2str(N(2)),num2str(N(3)),num2str(N(4)),'GLOBAL')
% baselineFreq=[1:49,51:100];
% p=[];
% t=[];
% for i=1:5
%     [~,p(i),~,stat]=ttest(LF(i,baselineFreq)',LF(i,50));
%     t(i)=stat.tstat;
% end
