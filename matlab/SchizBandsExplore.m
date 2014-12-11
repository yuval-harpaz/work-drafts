cd /media/yuval/Elements/SchizoRestMaor

load PSD
figure;
plot(mean(PSDco))
hold on
plot(mean(PSDsc),'r')
legend('control','schizophrenia')
[~,p]=ttest2(PSDco,PSDsc);
find(p<0.05)
ylim([0.4 3.4]*1e-14)
xlim([6 45])
plot([11 12],(3.2*1e-14).*[1 1],'k*')


%%
cd /media/yuval/Elements/SchizoRestMaor
load PSD
sc=scLabel';
lpi=[10,11,26,22,23,21,14,18,1,2,16,24,15,19];
hpi=[25,27,17,5,8,6,7,4,29,3,28,13,12];
lni=[3,7,10,5,28,16,11,18,26,22,23,21,12];
hni=[8,6,29,1,24,19,2,15,25,17,14,27,13,4];
lowPos=scLabel(lpi)';
highPos=scLabel(hpi)';
lowNeg=scLabel(lni)';
highNeg=scLabel(hni)';
freq=11;
[~,pp]=ttest2(PSDsc(lpi,:),PSDsc(hpi,:));
[~,pn]=ttest2(PSDsc(lni,:),PSDsc(hni,:));
figure;
plot(mean(PSDsc(lpi,:)))
hold on
plot(mean(PSDsc(hpi,:)),'r')
plot(mean(PSDco),'k')
trend=find(pp<0.1);
ylim([0.4 3.4]*1e-14)
xlim([6 45])
plot(trend,(3.2*1e-14).*[1 1],'k*')
legend('low positive','high positive','control','p<0.1')
title('ttest for low and high positive symptoms')

figure;
plot(mean(PSDsc(lni,:)))
hold on
plot(mean(PSDsc(hni,:)),'r')
plot(mean(PSDco),'k')
sig=find(pn<0.05);
ylim([0.4 3.4]*1e-14)
xlim([6 45])
plot(trend,(3.2*1e-14).*ones(size(trend)),'k*')
legend('low negative','high negative','control','p<0.05')
title('ttest for low and high negative symptoms')

load PSDalphaMap

cfg=[];
cfg.zlim=[0 5e-14];
figure;
topoplot248(mean(PSDsc(lpi,:)),cfg)
title('low positive')
figure;
topoplot248(mean(PSDsc(hpi,:)),cfg)
title('high positive')

load('CohAlphaMap.mat');
cfg=[];
cfg.zlim=[0 0.8];
figure;
topoplot248(mean(COHsc(lpi,:)),cfg)
title('low positive')
figure;
topoplot248(mean(COHsc(hpi,:)),cfg)
title('high positive')

cd /media/yuval/Elements/MEG/talResults/Coh
load LRchans 
load ~/ft_BIU/matlab/plotwts
[~,chi]=ismember(Rchannel,wts.label);
low=mean(PSDsc(lpi,chi),2);
high=mean(PSDsc(hpi,chi),2);
[~,p]=ttest2(low,high)
%%
load bands
load distances
mask=distances>16;
for subi=1:19
    temp=cohCo26to70(:,:,subi);
    resCo(subi)=mean(temp(mask));
end
for subi=1:29
    temp=cohSc26to70(:,:,subi);
    resSc(subi)=mean(temp(mask));
end
[~,p]=ttest2(resSc,resCo)

for subi=1:19
    temp=cohCo9to12(:,:,subi);
    resCo(subi)=mean(temp(mask));
end
for subi=1:29
    temp=cohSc9to12(:,:,subi);
    resSc(subi)=mean(temp(mask));
end
[~,p]=ttest2(resSc,resCo)

for subi=1:19
    temp=cohCo26to70(:,:,subi);
    for chani=1:248
        mapCoh(chani)=sum(temp(chani,mask(chani,:)))./sum(mask(chani,:));
        %resCo(subi)=mean(temp(mask));
    end
        
end
topoplot248(mapCoh,[],1)

condCo=cohlrCo20to25;
condSc=cohlrSc20to25;
[~,p]=ttest2(condCo',condSc');
cfg=[];
cfg.highlight='labels';
cfg.highlightchannel=find(p<0.05);
cfg.zlim=[0 1];
figure;topoplot248(mean(condSc,2),cfg);title('Sciz')
figure;topoplot248(mean(condCo,2),cfg);title('Cont')


condCo=powCo5to8;
condSc=powSc5to8;
[~,p]=ttest2(condCo',condSc');
cfg=[];
cfg.highlight='labels';
cfg.highlightchannel=find(p<0.05);
%cfg.zlim=[0 1];
figure;topoplot248(mean(condSc,2),cfg);title('Sciz')
figure;topoplot248(mean(condCo,2),cfg);title('Cont')

condCo=powCo9to12;
condSc=powSc9to12;
[~,p]=ttest2(condCo',condSc');
cfg=[];
cfg.highlight='labels';
cfg.highlightchannel=find(p<0.05);
cfg.zlim=[0 5e-14];
figure;topoplot248(mean(condSc,2),cfg);title('Schizophrenia')
figure;topoplot248(mean(condCo,2),cfg);title('Control')


condCo=cohlrCo9to12;
condSc=cohlrSc9to12;
[~,p]=ttest2(condCo',condSc');
cfg=[];
cfg.highlight='labels';
sig=find(p<0.05);

load ~/ft_BIU/matlab/plotwts
[~,goodL]=ismember(Lchannel,wts.label)
good=sig(find(ismember(sig,goodL)));
[~,goodR]=ismember(Rchannel,wts.label)
good=[good,sig(find(ismember(sig,goodR)))];
cfg.highlightchannel=good;
cfg.zlim=[0 0.8];
figure;topoplot248(mean(condSc,2),cfg);title('Schizophrenia')
figure;topoplot248(mean(condCo,2),cfg);title('Control')
