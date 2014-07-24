%% random numbers
sRate=1017.23;
sRates=[sRate*2/3 sRate sRate*2];
reps=[100 500 1000 1500 2000 2500 3000 3500 4000 4500];
neg=[];
ratio=[];
% for perm=1:100
%     for i=1:10
%         disp('')
%     end
%     for i=1:10
%         disp(['PERM ',num2str(perm)])
%     end
%     for i=1:10
%         disp('')
%     end
repCount=0;
permN=500;
progress=0;
for repi=1:length(reps)
    rateCount=0;
    repCount=repCount+1;
    
    for ratei=1:length(sRates)
    progress=progress+1;
    disp([num2str(progress),' of 30'])
        rateCount=rateCount+1;
        data=rand(permN,round(100*sRates(ratei)));
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
        
        
        ratio(rateCount,repCount,1:permN)=(fcl50-f50)./f50;
        % [~,p,~,stat]=ttest(f(:,50),fcl(:,50))
        %             [~,p,~,stat]=ttest(f50,fcl50)
        %             if p<0.1 && stat.tstat>0 % clean lower than raw
        %                 neg(rateCount,repCount)=true;
        %             else
        %                 neg(rateCount,repCount)=false;
        %             end
        
    end
end
clear data
C=[];
for sRatei=1:length(sRates)
    for repi=1:length(reps)
        [~,~,c]=ttest(squeeze(ratio(sRatei,repi,:)),[],[],'left');
        C(sRatei,repi)=c(2);
    end
end
M=squeeze(mean(ratio,3));
Min=min(M);
x =  [reps,fliplr(reps)];
%y =  [M(1,:),fliplr(C(1,:))];
y =  [M,fliplr(C)];

figure;
line(reps,M)
hold on
fill(x,y,[.9 .9 .9],'linestyle','none')
legend('s-rate 508','s-rate 678','s-rate 1017','s-rate 2035','confidence intervals')
line(reps,M)
xlim([100 4500])



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
f50=f(:,50);
fBL=mean(f(:,[25:49 51:99 101:125]),2);
%fBL=median(fBL);
trig=readTrig_BIU;

%lf=correctLF(data.trial{1,1},data.fsample,trig,4500,50);
% [~,mini]=min(f(:,50));
% [~,i50]=sort(f(:,50));
% n=100;
% chan=data.trial{1,1}(i50(1:n),:);
% f=abs(fftBasic(chan,data.fsample));
%correctLF(chan,data.fsample,'time',50,50);
%sRates=data.fsample;
try
    matlabpool
end
reps=[100 500 1000 1500 2000 2500 3000 3500 4000 4500];
neg=[];
ratio=[];
repCount=0;
for repi=1:length(reps)
    rateCount=0;
    repCount=repCount+1;
    lf=correctLF(data.trial{1,1},data.fsample,trig,reps(repCount),50,4);
    close;
    fcl=abs(fftBasic(lf,data.fsample));
    fcl50=fcl(:,50);
    
    ratio(1,repCount)=mean((fcl50-fBL)./fBL);
    ratio(2,repCount)=std((fcl50-fBL)./fBL);
    repi
end
figure;plot(reps,ratio(1,:))
hold on;plot(reps,ratio(1,:)+ratio(2,:)/sqrt(248),'k.')

figure;plot(f','r');hold on;plot(fcl','g');
figure;plot(1:508,mean(f./repmat(fBL,1,508)),'r');hold on;plot(1:508,mean(fcl./repmat(fBL,1,508)),'g');
%% empty room long
% short segment
cd /home/yuval/Data/emptyRoom2
Trig=readTrig_BIU;
reps=[100 500 1000 1500 2000 2500 3000 3500 4000 4500];
try
    matlabpool
end
samp100s=round(1.017249990200457e+03*100);
startSamp=1;
ratio=[];
for segi=1:35
    cfg=[];
    cfg.channel='MEG';
    cfg.dataset=source;
    cfg.trl=[startSamp samp100s*segi 0];
    data=ft_preprocessing(cfg);
    f=abs(fftBasic(data.trial{1,1},data.fsample));
    f50=f(:,50);
    fBL=mean(f(:,[25:49 51:99 101:125]),2);
    trig=Trig(cfg.trl(1):cfg.trl(2));
    for repi=1:length(reps)
        rateCount=0;
        lf=correctLF(data.trial{1,1},data.fsample,trig,reps(repi),50,4);
        close;
        fcl=abs(fftBasic(lf,data.fsample));
        fcl50=fcl(:,50);
        ratio(1:248,repi,segi)=(fcl50-fBL)./fBL;
        disp(num2str(repi))
    end
    startSamp=startSamp+samp100s;
    disp([' SEG SEG SEG ',num2str(segi)])
end
save ratio35seg ratio reps
rat=squeeze(mean(ratio));
ra=mean(rat,2);
sd=std(rat,[],2);
figure;plot(reps,ra)
hold on;plot(reps,ra+sd/sqrt(35),'k.')

% global
cd /home/yuval/Data/emptyRoom2
Trig=readTrig_BIU;
trig=Trig(1:3560375);
ratio=[];
cfg=[];
cfg.channel='MEG';
cfg.dataset=source;
cfg.trl=[1 1 0];
dummy=ft_preprocessing(cfg);
for chani=36:248
    cfg.channel=dummy.label{chani,1};
    cfg.trl=[1 3560375 0];
    data=ft_preprocessing(cfg);
    f(chani,1:508)=abs(fftBasic(data.trial{1,1},data.fsample));
    f50(chani)=f(chani,50);
    fBL(chani)=mean(f(chani,[25:49 51:99 101:125]),2);
    lf=correctLF(data.trial{1,1},data.fsample,trig,'GLOBAL',50);
    close;
    fcl(chani,1:508)=abs(fftBasic(lf,data.fsample));
    fcl50(chani)=fcl(chani,50);
    ratio(chani)=(fcl50(chani)-fBL(chani))./fBL(chani);
    disp([' CHANNEL ',num2str(chani)])
end
save ratioG ratio fcl f fBL f50
rat=squeeze(mean(ratio));
ra=mean(rat,2);
sd=std(rat,[],2);
figure;plot(reps,ra)
hold on;plot(reps,ra+sd/sqrt(35),'k.')

cd /home/yuval/Data/emptyRoom2
Trig=readTrig_BIU;
reps=[100 500 1000 1500 2000 2500 3000 3500 4000 4500];
try
    matlabpool
end
samp100s=round(1.017249990200457e+03*100);
startSamp=1;
ratio=[];
for segi=1:35
    cfg=[];
    cfg.channel='MEG';
    cfg.dataset=source;
    cfg.trl=[startSamp samp100s*segi 0];
    data=ft_preprocessing(cfg);
    f=abs(fftBasic(data.trial{1,1},data.fsample));
    f50(1:248,segi)=f(:,50);
    fBL(1:248,segi)=mean(f(:,[25:49 51:99 101:125]),2);
    trig=Trig(cfg.trl(1):cfg.trl(2));
%     for repi=1:length(reps)
%         rateCount=0;
%         lf=correctLF(data.trial{1,1},data.fsample,trig,reps(repi),50,4);
%         close;
%         fcl=abs(fftBasic(lf,data.fsample));
%         fcl50=fcl(:,50);
%         ratio(1:248,repi,segi)=(fcl50-fBL)./fBL;
%         disp(num2str(repi))
%     end
    startSamp=startSamp+samp100s;
    disp([' SEG SEG SEG ',num2str(segi)])
end
save f f f50 fBL
%% consistency
cd /home/yuval/Data/emptyRoom2
Trig=readTrig_BIU;
reps=4000;
try
    matlabpool
end
samp100s=round(1.017249990200457e+03*100);
startSamp=1;
ratio=[];
for segi=1:35
    cfg=[];
    cfg.channel='MEG';
    cfg.dataset=source;
    cfg.trl=[startSamp samp100s*segi 0];
    data=ft_preprocessing(cfg);
    f=abs(fftBasic(data.trial{1,1},data.fsample));
    f50=f(:,50);
    fBL=mean(f(:,[25:49 51:99 101:125]),2);
    trig=Trig(cfg.trl(1):cfg.trl(2));
    for repi=1:length(reps)
        rateCount=0;
        [lf,wu]=correctLF(data.trial{1,1},data.fsample,trig,reps(repi),50,4);
        meanLine = oneLineCycle(data.trial{1,1}, wu);
        ml(1:248,1:22,segi)=meanLine-repmat(mean(meanLine,2),1,size(meanLine,2));
        close;
        fcl=abs(fftBasic(lf,data.fsample));
        fcl50=fcl(:,50);
        ratio(1:248,repi,segi)=(fcl50-fBL)./fBL;
        %disp(num2str(repi))
    end
    startSamp=startSamp+samp100s;
    disp([' SEG SEG SEG ',num2str(segi)])
end
save ml ml

for segi=1:35
    difs(segi,1:248)=mean(abs(ml(:,:,segi)-mean(ml(:,:,setdiff(1:35,segi)),3)),2);
end
figure;plot(mean(difs,2))

for chani=1:248
    figure;
    plot(squeeze(ml(chani,1:22,1:34)),'k')
    ylim([-10e-14 10e-14]);
    hold on
    plot(squeeze(ml(chani,1:22,35)),'r')
    pause
    close
end

%% 'time' method 
cd /home/yuval/Data/emptyRoom2
reps=4000;
try
    matlabpool
end
samp100s=round(1.017249990200457e+03*100);
startSamp=1;
ratioT=[];
for segi=1:35
    cfg=[];
    cfg.channel='MEG';
    cfg.dataset=source;
    cfg.trl=[startSamp samp100s*segi 0];
    data=ft_preprocessing(cfg);
    f=abs(fftBasic(data.trial{1,1},data.fsample));
    f50=f(:,50);
    fBL=mean(f(:,[25:49 51:99 101:125]),2);
    for repi=1:length(reps)
        rateCount=0;
        [lf,wu]=correctLF(data.trial{1,1},data.fsample,'time',reps(repi),50,4);
        meanLine = oneLineCycle(data.trial{1,1}, wu);
        mlT(1:248,1:22,segi)=meanLine-repmat(mean(meanLine,2),1,size(meanLine,2));
        close;
        fcl=abs(fftBasic(lf,data.fsample));
        fcl50=fcl(:,50);
        ratioT(1:248,repi,segi)=(fcl50-fBL)./fBL;
        %disp(num2str(repi))
    end
    startSamp=startSamp+samp100s;
    disp([' SEG SEG SEG ',num2str(segi)])
end
save time ratioT mlT

for segi=1:35
    difs(segi,1:248)=mean(abs(ml(:,:,segi)-mean(ml(:,:,setdiff(1:35,segi)),3)),2);
end
figure;plot(mean(difs,2))

for chani=1:248
    figure;
    plot(squeeze(ml(chani,1:22,1:34)),'k')
    ylim([-10e-14 10e-14]);
    hold on
    plot(squeeze(ml(chani,1:22,35)),'r')
    pause
    close
end

%% drift estimate
f=abs(fftBasic(data.trial{1,1},data.fsample));
[~,lfi]=max(f(:,50));
len=round(1000*data.fsample/50);
starti=1;
for wini=1:5
    samps=starti:(starti+len);
    %[samps(1) samps(end)]
    starti=starti+round(len/2);
    [~,wu]=correctLF(data.trial{1,1}(lfi,samps),data.fsample,'time','GLOBAL',50,4);
    title([num2str(round(starti/data.fsample)),'s'])
    meanLine(wini,1:22) = oneLineCycle(data.trial{1,1}(lfi,samps),wu);
    %[~,maxi]=max(meanLine(1,2:20));
    snr(wini,1:60)=match_temp(repmat(meanLine(wini,2:21),1,3),meanLine(1,2:21),2);
    [~,I]=findPeaks(snr(wini,:),1,10);
    lag(wini)=I(end);
    %plot(snr)
end
sampPer500Cyc=mean(diff(lag));
Lf=(len/2-sampPer500Cyc)/(len/2)*50;
correctLF(data.trial{1,1}(lfi,:),data.fsample,'time',500,50,4);
correctLF(data.trial{1,1}(lfi,:),data.fsample,'time',500,Lf,4);

cfg=[];
cfg.channel=data.label{lfi};
cfg.dataset=source;
data=ft_preprocessing(cfg);

[fHD,F]=fftBasicHD(data.trial{1,1},data.fsample);
fHD=abs(fHD);
figure;plot(F,fHD);
i49=nearest(F,49);
i51=nearest(F,51);
[~,maxi]=max(fHD(i49:i51));
maxi=maxi+i49-1;
maxf=F(maxi);
plot(maxf,fHD(maxf),'r')
correctLF(data.trial{1,1},data.fsample,'time',500,maxf,4);
correctLF(data.trial{1,1},data.fsample,'time',500,50,4);
correctLF(data.trial{1,1},data.fsample,'time',1000,maxf,4);


%% old
figure;plot(f','r');hold on;plot(fcl','g');
figure;plot(1:508,mean(f./repmat(fBL,1,508)),'r');hold on;plot(1:508,mean(fcl./repmat(fBL,1,508)),'g');

cd /home/yuval/Data/emptyRoom2
try
    matlabpool
end
reps=[250 500];
for peri=1:248
    cfg=[];
    cfg.channel=['A',num2str(peri)];
    cfg.dataset=source;
    %cfg.trl=[1,2000000,0];
    data=ft_preprocessing(cfg);
    data=data.trial{1,1};
    % save data data -v7.3
    % clear data
    hdr=ft_read_header(source);
    f=abs(fftBasic(data,hdr.Fs));
    f50=f(:,50);
    fBL=mean(f(:,[25:49 51:99 101:125]),2);
    trig=readTrig_BIU;
    %trig=trig(1:2000000);
    
    
    
    neg=[];
    ratio=[];
    repCount=0;
    for repi=1:length(reps)
        rateCount=0;
        repCount=repCount+1;
        lf=correctLF(data,hdr.Fs,trig,reps(repCount),50,4);
        close;
        fcl=abs(fftBasic(lf,hdr.Fs));
        fcl50=fcl(:,50);
        ratio(repCount,peri)=(fcl50-fBL)./fBL;
        %ratio(2,repCount)=std((fcl50-fBL)./fBL);
    end
    peri
end
save ratio ratio reps
figure;plot(reps,mean(ratio,2))
hold on;plot(reps,std(ratio,[],2),'k.')

figure;plot(f','r');hold on;plot(fcl','g');
figure;plot(1:508,f./fBL,'r');hold on;plot(1:508,fcl./fBL,'g');

correctLF(data.trial{1,1}(end,:),1017.23,readTrig_BIU,1000,50);
ToDo
check long empty room to see decrease for many cycles per template
try no weights / planar or other systems
run pca to clean template?
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
