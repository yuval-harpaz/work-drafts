
% previous versions had MOG artifact, here I clean it. rest and read, 60sec
sf={'idan','inbal','liron','maor','mark','odelia','ohad','yoni'};
cfg=[];

for subi=1:8
    cd /home/yuval/Copy/MEGdata/alice
    cd (sf{subi})
    load freqD 
%     alphaRead(subi,1:248)=squeeze(mean(Fread(:,9:11),2));
%     alphaRest(subi,1:248)=squeeze(mean(Frest(:,9:11),2));
    alphaRead(subi,1:248)=squeeze(mean(Fread(:,9:11),2));
    alphaRest(subi,1:248)=squeeze(mean(Frest(:,9:11),2));
end
cd ../
cfg=[];
cfg.zlim=[0 5e-11];
figure;topoplot248(mean(alphaRead),cfg);
title READ
figure;topoplot248(mean(alphaRest),cfg);
title REST

load alphaD
load LRpairs
load ~/ft_BIU/matlab/plotwts
[~,Li]=ismember(LRpairs(:,1),wts.label);
[~,Ri]=ismember(LRpairs(:,2),wts.label);
readL=mean(alphaRead(:,Li),2);
readR=mean(alphaRead(:,Ri),2);
restL=mean(alphaRest(:,Li),2);
restR=mean(alphaRest(:,Ri),2);
rest=mean(alphaRest,2);
read=mean(alphaRead,2);
[~,p]=ttest(readL,restL)
[~,p]=ttest(readR,restR)
[~,p]=ttest(read,rest)
% sig better with max
readL=max(alphaRead(:,Li),[],2);
readR=max(alphaRead(:,Ri),[],2);
restL=max(alphaRest(:,Li),[],2);
restR=max(alphaRest(:,Ri),[],2);
rest=max(alphaRest,[],2);
read=max(alphaRead,[],2);
[~,p]=ttest(readL,restL)
[~,p]=ttest(readR,restR)
[~,p]=ttest(read,rest)
