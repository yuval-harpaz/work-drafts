%% Group statistics, source level
% Here we analyze beamforming results for 25 subjects. Power was computed
% for each virtual sensor for the M170 window
% pow=mean(timecourse.*timecourse); the data was then interpolated over the
% template MRI.
%% Load data and display raw data
% the files to be loaded are output of ft_sourcegrandaverage, after masking
% voxels outside the brain.
cd amb
load domMskdp
load subMskdp
load ~/ft_BIU/matlab/LCMV/sMRI
subMskdp.anatomy=sMRI.anatomy;
cfg = [];
cfg.funparameter = 'avg.pow';
cfg.method='ortho';
figure
ft_sourceplot(cfg,subMskdp)
%% Neural Activity Index (NAI), compute subordinate to dominant ratio
sub_dom=subMskdp;
sub_dom.avg.nai=(subMskdp.avg.pow-domMskdp.avg.pow)./domMskdp.avg.pow;
cfg.funparameter = 'avg.nai';
%cfg.interactive = 'yes';
cfg.location=[55 -15 10]
cfg.funcolorlim=[0 4];
ft_sourceplot(cfg,sub_dom)

%% t-test for selected voxels

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

cfg=[];
cfg.dim = subMskdp.dim;
cfg.method      = 'montecarlo';
cfg.statistic   = 'depsamplesT';
cfg.parameter   = 'pow';
cfg.correctm    = 'cluster'; %  'no', 'max', 'cluster', 'bonferoni', 'holms', 'fdr'
cfg.numrandomization = 500;
cfg.alpha       = 0.05
cfg.clusteralpha= 0.05;
cfg.tail        = 0;
cfg.design(1,:) = [1:25 1:25];
cfg.design(2,:) = [ones(1,25) ones(1,25)*2];
cfg.uvar        = 1; % row of design matrix that contains unit variable (in this case: subjects)
cfg.ivar        = 2; % row of design matrix that contains independent variable (the conditions)
stat = ft_sourcestatistics(cfg,subMskdp,domMskdp);
save Cl05_M170masked_S_Dstat stat
%% Plot the significant clusters
probplot=stat;
probplot.prob1=1-probplot.prob;
lowlim=0.95;
probplot.mask=(probplot.prob1>=lowlim);
probplot.anatomy=sMRI.anatomy;
cfg = [];
cfg.funcolorlim = [lowlim 1];
cfg.interactive = 'yes';
cfg.funparameter = 'prob1';
cfg.maskparameter= 'mask';
cfg.method='ortho';
cfg.inputcoord='mni';
cfg.atlas='~/ft_BIU/matlab/files/aal_MNI_V4.nii';
cfg.coordsys='mni';
figure;
ft_sourceplot(cfg,probplot);

%% ROI mask
cfg.roi='Frontal_Sup_L'
cfg.location=[-20 -44 40];% wer= -50 -45 10 , broca= -50 25 0, fussiform = -42 -58 -11(cohen et al 2000), change x to positive for RH.
%cfg.crosshair='no';
figure;
ft_sourceplot(cfg,probplot);

%% Plot t distribution + Atlas
%cfg.parameter = 'stat';

statplot=stat;
statplot.anatomy=sMRI.anatomy;
cfg=[];
cfg=rmfield(cfg1,'funcolorlim');
cfg.funcolorlim = [-3.5 3.5];
cfg.funparameter = 'stat';
cfg.method='ortho';
cfg.inputcoord='mni';
cfg.atlas='aal_MNI_V4.img';
figure
ft_sourceplot(cfg2,statplot)
 
%% Change the cluster alpha
% I arranged the stats and plots in a function.
% what we did so far is similar to this:
% [cfg1,probplot,cfg2,statplot]=ambMonteClust12('Cl05_M170masked_S_D','subMskdp','domMskdp',0.95,0.05);
% Now we change cluster criterion for 0.05 to 0.01.
[cfg1,probplot,cfg2,statplot]=ambMonteClust12('Cl01_M170masked_S_D','subMskdp','domMskdp',0.95,0.01);

%% Plot methods: ortho (transparancy added)
ambPlotStat12('Cl01_M170masked_S_D',[0.95 0.98],'ortho',60); 
%% Plot methods: surface
ambPlotStat12('Cl01_M170masked_S_D',[0.95 0.98],'surface'); 
%% Plot slice:
ambPlotStat12('Cl01_M170masked_S_D',[0.95 0.98],'slice');

%% AFNI clustering and simulation

cd ../alpha
!~/abin/afni &