function [p,t,pH,tH]=LFtestCycN(subi,N,trig,raw)
subs={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
sub=subs{subi};
lineSamp=[40:49 51:60];
cd /home/yuval/Copy/MEGdata/alice
cd (sub)
if ~exist('trig','var')
    trig=bitand(uint16(readTrig_BIU(source)),256);
end
if ~exist('raw','var')
    cfg=[];
    cfg.dataset=source;
    cfg.channel='MEG';
    cfg.demean='yes';
    raw=ft_preprocessing(cfg);
end
f=fftBasic(raw.trial{1,1},1017.23);
clear raw
%for cyci=1:length(cycT)
% cycNum=cycT(cyci);
%[fclT(cyci),~,fclT(cyci,:),f]=LFtestNcyc(A245,1:119,trig,cycNum,samp,1017.23,0.1);
lf=correctLF(source,1017.23,trig,N,50,4,0.1);
close;
[fcl,F]=fftBasic(lf,1017.23);
clear lf
meanPSDclean=zeros(1,508);
meanPSD=meanPSDclean;
freq=[50:226,228:300];
baselineFreq=setdiff(freq,[50:50:300]);
scale=mean(abs(f(:,baselineFreq)),2);
for chani=1:248
    meanPSDclean=meanPSDclean+abs(fcl(chani,:))/scale(chani);
    meanPSD=meanPSD+abs(f(chani,:))/scale(chani);
end
meanPSDclean=meanPSDclean/248;
meanPSD=meanPSD/248;
[~,pH,~,stat]=ttest2(meanPSDclean(baselineFreq),meanPSDclean(100:50:300));
tH=stat.tstat;
[~,p,~,stat]=ttest(meanPSDclean(baselineFreq),meanPSDclean(50));
t=stat.tstat;
figure;
plot(meanPSD,'r')
hold on
plot(meanPSDclean,'g')
if p<0.05
    plot(50,meanPSDclean(50),'b*')
else
    plot(50,meanPSDclean(50),'b.')
end
if pH<0.05
    plot(100:50:300,meanPSDclean(100:50:300),'k*')
else
    plot(100:50:300,meanPSDclean(100:50:300),'k.')
end
ylim([0 10*mean(meanPSD(baselineFreq))]);
title([sub,' ',num2str(N)])