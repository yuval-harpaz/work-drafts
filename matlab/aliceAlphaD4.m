
cd /home/yuval/Copy/MEGdata/alice
   
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


readL=max(alphaRead(:,Li),[],2);
readR=max(alphaRead(:,Ri),[],2);
restL=max(alphaRest(:,Li),[],2);
restR=max(alphaRest(:,Ri),[],2);
rest=max(alphaRest,[],2);
read=max(alphaRead,[],2);

[~,p]=ttest(readL,restL)
[~,p]=ttest(readR,restR)
[~,p]=ttest(read,rest)

