%% random numbers
% Fig. 1
cd /home/yuval/Dropbox/LF
sRate=2034.5;
%data=rand(100,round(100*sRate))-0.5;
load data/rand2034
lf=correctLF(data,sRate,'time','ADAPTIVE1',50);
close;
[f,F]=fftBasic(data,sRate);
f=abs(f);
fcl=abs(fftBasic(lf,sRate));
figure;
%figure('Color',[0.8 0.8 0.8]);
%set(gca,'Color',[0.8 0.8 0.8]);
plot(F,mean(f),'k','linewidth',4)
hold on
plot(F,mean(fcl),'color',[0.8 0.8 0.8],'linewidth',2)
ylim([0.3 0.8])
xlim([20 80])
legend('original','cleaned')

%% Fig. 2 and 3 
cd /home/yuval/Dropbox/LF
load data/ratio
rat=squeeze(mean(ratio(2:4,:,:),3));
C=[];
sRate=1017.23;
sRates=[sRate*2/3 sRate sRate*2];
for sRatei=1:length(sRates)
    for repi=1:length(reps)
        [~,p,c]=ttest(squeeze(ratio(sRatei,repi,:)),[],[],'left');
        C(sRatei,repi)=c(2);
    end
end
x=[reps(1:9),fliplr(reps(1:9))];
Cnn=-100*ones(size(C));
Cnn(rat<0)=C(rat<0);
maxC=max(Cnn);
y=[max(rat(:,1:9)),fliplr(maxC(1:9))];
y(8)=rat(2,8);
figure;
plot(reps,rat(1,:),'k','linewidth',2)
set(gca,'FontSize',16,'FontName','Times');
ticks=reps(1:2:end);
set(gca,'XTick',ticks);
set(gca,'YTick',-0.6:0.2:0);
hold on
plot(reps,rat(2,:),'color',[0.3 0.3 0.3],'linewidth',2)
plot(reps,rat(3,:),'color',[0.6 0.6 0.6],'linewidth',2)
fill(x,y,[.9 .9 .9],'linestyle','none')
plot(reps,rat(1,:),'k','linewidth',2)
plot(reps,rat(2,:),'color',[0.3 0.3 0.3],'linewidth',2)
plot(reps,rat(3,:),'color',[0.6 0.6 0.6],'linewidth',2)
%plot(100:4500,0,'b')
ylim([-0.7 0.1])
legend1=legend ('678Hz','1017Hz','2035Hz','Conf Int');
hy=ylabel('Ratio of Change in PSD');
hx=xlabel('N cycles');
set(legend1,'Position',[0.6 0.25 0.2 0.2],'box','off');
box off

load data/ratioYH
rat=squeeze(mean(ratio,3));
C=[];
sRate=1017.23;
sRates=[sRate*2/3 sRate sRate*2];
reps=[100 500 1000 1500 2000 2500 3000 3500 4000 4500];
x=[reps,fliplr(reps)];
for sRatei=1:length(sRates)
    for repi=1:length(reps)
        [~,p,c]=ttest(squeeze(ratio(sRatei,repi,:)));
        Cneg(sRatei,repi)=c(2);
        Cpos(sRatei,repi)=c(1);
    end
end
maxC=max([Cpos;Cneg]);
minC=min([Cpos;Cneg]);
y=[minC,fliplr(maxC)];
figure;
plot(reps,rat(1,:),'k','linewidth',2)
set(gca,'FontSize',16,'FontName','Times')
ticks=reps(1:2:end)
set(gca,'XTick',ticks);
set(gca,'YTick',-0.6:0.2:1);
hold on
plot(reps,rat(2,:),'color',[0.3 0.3 0.3],'linewidth',2)
plot(reps,rat(3,:),'color',[0.6 0.6 0.6],'linewidth',2)
fill(x,y,[.9 .9 .9],'linestyle','none')
plot(reps,rat(1,:),'k','linewidth',2)
plot(reps,rat(2,:),'color',[0.3 0.3 0.3],'linewidth',2)
plot(reps,rat(3,:),'color',[0.6 0.6 0.6],'linewidth',2)
%plot(100:4500,0,'b')
ylim([-0.8 1.2])
legend1=legend ('678Hz','1017Hz','2035Hz','Conf Int');
hy=ylabel('Ratio of Change in PSD');
hx=xlabel('N cycles');
set(legend1,'Position',[0.6 0.6 0.2 0.2],'box','off');
box off

%% empty room
cd /home/yuval/Data/emptyRoom2
load ratio35seg
rat=squeeze(mean(ratio,3));
Cpos=[];
Cneg=[];
% for chani=1:248
%     for repi=1:length(reps)
%         [~,p,c]=ttest(squeeze(ratio(chani,repi,:)));
%         Cneg(chani,repi)=c(1);
%         Cpos(chani,repi)=c(2);
%     end
% end
for chani=1:248
    for repi=1:length(reps)
        Cm(chani,repi)=mean(squeeze(ratio(chani,repi,:)));
    end
end
x=[reps,fliplr(reps)];
y=[min(Cm),fliplr(max(Cm))];
ticks=reps(1:2:end)
figure;
plot(reps,mean(rat),'k','linewidth',2)
set(gca,'FontSize',16,'FontName','Times')
set(gca,'XTick',ticks);
set(gca,'YTick',-1:2);
hold on
fill(x,y,[.9 .9 .9],'linestyle','none')
plot(reps,mean(rat),'k','linewidth',2)
load /home/yuval/Data/emptyRoom2/f.mat
mean(mean(f50./fBL,2))
max(mean(f50./fBL,2))



plot(reps,rat(1,:),'k','linewidth',2)
plot(reps,rat(2,:),'color',[0.3 0.3 0.3],'linewidth',2)
plot(reps,rat(3,:),'color',[0.6 0.6 0.6],'linewidth',2)
plot(100:4500,0,'b')
ylim([-1 0.2])
legend ('678Hz','1017Hz','2035Hz','Conf Int')
ylabel('PSD ratio: (Clean-Original)/Clean')
xlabel('N cycles')

%% Empty Room Global
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
