cd /home/yuval/Copy/MEGdata/alice

load alphaD2
load alphaD3
load LRpairs
load ~/ft_BIU/matlab/plotwts
[~,Li]=ismember(LRpairs(:,1),wts.label);
[~,Ri]=ismember(LRpairs(:,2),wts.label);
restL=mean(alphaRest(:,Li),2);
restR=mean(alphaRest(:,Ri),2);

L=mean(alphaRead(:,Li),2);
R=mean(alphaRead(:,Ri),2);
[~,p]=ttest(L,restL)
[~,p]=ttest(R,restR)

S=[1:8,1:8,1:8,1:8]';
F1=[ones(16,1);2*ones(16,1)]; % 1 = rest, 2 = news
F2=[ones(8,1);2*ones(8,1)];   % 1 = L   , 2 = R
F2=[F2;F2];
Y=[restL;restR;L;R];
stats = rm_anova2(Y,S,F1,F2,{'cond','side'})

L=mean(alphaNews(:,Li),2);
R=mean(alphaNews(:,Ri),2);
[~,p]=ttest(L,restL)
[~,p]=ttest(R,restR)
Y=[restL;restR;L;R];
stats = rm_anova2(Y,S,F1,F2,{'cond','side'})

L=mean(alphaThamil(:,Li),2);
R=mean(alphaThamil(:,Ri),2);
[~,p]=ttest(L,restL)
[~,p]=ttest(R,restR)
Y=[restL;restR;L;R];
stats = rm_anova2(Y,S,F1,F2,{'cond','side'})

L=mean(alphaLoud(:,Li),2);
R=mean(alphaLoud(:,Ri),2);
[~,p]=ttest(L,restL)
[~,p]=ttest(R,restR)
Y=[restL;restR;L;R];
stats = rm_anova2(Y,S,F1,F2,{'cond','side'})


