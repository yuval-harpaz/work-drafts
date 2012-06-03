load domp
load subp
load ~/ft_BIU/matlab/LCMV/sMRI
subp.anatomy=sMRI.anatomy;
cfg1 = [];
cfg1.funparameter = 'avg.pow';
cfg1.method='ortho';
figure
ft_sourceplot(cfg1,subp)
%% compute subordinate to dominant ratio
sub_dom=subp;
sub_dom.avg.nai=(subp.avg.pow-domp.avg.pow)./domp.avg.pow;

cfg1.funparameter = 'avg.nai';
cfg1.interactive = 'yes';
cfg1.funcolorlim=[0 4];
ft_sourceplot(cfg1,sub_dom)

%% ttest one voxel

voxind=312631; %center of head
for subji=1:25
    sub(subji,1)=subp.trial(1,subji).pow(voxind,1);
    dom(subji,1)=domp.trial(1,subji).pow(voxind,1);   
end
[h,p]=ttest(sub,dom)
 
voxind=361828; %right temporal
for subji=1:25
    sub(subji,1)=subp.trial(1,subji).pow(voxind,1);
    dom(subji,1)=domp.trial(1,subji).pow(voxind,1);   
end
[h,p]=ttest(sub,dom)

%% cluster based permutation statistics
clear
[cfg1,probplot,cfg2,statplot]=ambMonteClust12('Cl05_M170masked_S_D','subMskdp','domMskdp',0.95,0.05);
[cfg1,probplot,cfg2,statplot]=ambMonteClust12('Cl01_M170masked_S_D','subMskdp','domMskdp',0.95,0.01);

ambPlotStat12('Cl01_M170masked_S_D',[0.95 0.98],'ortho',60); % RH
ambPlotStat12('Cl01_M170masked_S_D',[0.95 0.98],'surface',60); % RH
ambPlotStat12('Cl01_M170masked_S_D',[0.95 0.98],'slice',60); % RH
