load domMskdp
load subMskdp
load ~/ft_BIU/matlab/LCMV/sMRI
subMskdp.anatomy=sMRI.anatomy;
cfg1 = [];
cfg1.funparameter = 'avg.pow';
cfg1.method='ortho';
figure
ft_sourceplot(cfg1,subMskdp)
%% compute subordinate to dominant ratio
sub_dom=subMskdp;
sub_dom.avg.nai=(subMskdp.avg.pow-domMskdp.avg.pow)./domMskdp.avg.pow;

cfg1.funparameter = 'avg.nai';
cfg1.interactive = 'yes';
cfg1.funcolorlim=[0 4];
ft_sourceplot(cfg1,sub_dom)

%% ttest one voxel

voxind=312631; %center of head
for subji=1:25
    sub(subji,1)=subMskdp.trial(1,subji).pow(voxind,1);
    dom(subji,1)=domMskdp.trial(1,subji).pow(voxind,1);   
end
[h,p]=ttest(sub,dom)
 
voxind=361828; %right temporal
for subji=1:25
    sub(subji,1)=subMskdp.trial(1,subji).pow(voxind,1);
    dom(subji,1)=domMskdp.trial(1,subji).pow(voxind,1);   
end
[h,p]=ttest(sub,dom)

%% cluster based permutation statistics
clear
[cfg1,probplot,cfg2,statplot]=ambMonteClust12('Cl05_M170masked_S_D','subMskdp','domMskdp',0.95,0.05);
[cfg1,probplot,cfg2,statplot]=ambMonteClust12('Cl01_M170masked_S_D','subMskdp','domMskdp',0.95,0.01);

ambPlotStat12('Cl01_M170masked_S_D',[0.95 0.98],'ortho',60); % RH
ambPlotStat12('Cl01_M170masked_S_D',[0.95 0.98],'surface',60); % RH
ambPlotStat12('Cl01_M170masked_S_D',[0.95 0.98],'slice',60); % RH
