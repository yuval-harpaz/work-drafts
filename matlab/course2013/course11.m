%% Group statistics, sensor level
% here we run sensor level statistics for reading data where biased ambiguous
% words were coupled with subordinate and dominant associations (see
% Harpaz, Lavidor and Goldstein, accepted). we found RH activity for
% subordinate meanings around 200ms from target word onset.

cd amb

%% grand average
% number the average structures and make a string of names.
domstr='';
substr='';
for subi=1:25
    display(['loading subject ',num2str(subi)])
    subjn=num2str(subi);
    load ([subjn,'/DOM/dom.mat'])
    eval(['dom',subjn,'=dom;']);
    domstr=[domstr,',dom',subjn];
    load ([subjn,'/SUB/sub.mat'])
    eval(['sub',subjn,'=sub;']);
    substr=[substr,',sub',subjn];
end

cfg=[];
cfg.channel='MEG';
cfg.keepindividual = 'yes';

eval(['gadom=ft_timelockgrandaverage(cfg',domstr,');']);
eval(['gasub=ft_timelockgrandaverage(cfg',substr,');']);
clear dom* sub*


%% plot the fields
timepoint=0.2;
cfg=[];
cfg.zlim='maxmin';
cfg.xlim=[timepoint timepoint];
cfg.layout = '4D248.lay';
figure;
ft_topoplotER(cfg,gasub)
title ('Subordinate Meanings')
figure;
ft_topoplotER(cfg,gadom)
title ('Dominant Meanings')
%% t-test per channel for one time point
cfgs=[];
cfgs.latency=[timepoint timepoint];
cfgs.method='stats';
cfgs.statistic='paired-ttest';
cfgs.design = [ones(1,25) ones(1,25)*2];
[stat] = ft_timelockstatistics(cfgs, gasub,gadom);

datadif=gadom;
datadif.individual=gasub.individual-gadom.individual;  
cfg.highlight = 'on';
cfg.highlightchannel = find(stat.prob<0.05);
cfg.zlim='maxmin';
figure;ft_topoplotER(cfg, datadif);
colorbar;
title('Sub - Dom')
% I arranged the above script in a function 'statPlot11' to save space
% below. run as statPlot11(gasub,gadom,0.2)

%% Similarity and differences between subjects in 100ms field
cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
cfg.xlim=[0.1 0.1];
load 1/DOM/dom
figure;ft_topoplotER(cfg,dom);
title('SUBJECT 1')
load 2/DOM/dom
figure;ft_topoplotER(cfg,dom);
title('SUBJECT 2')
load 8/DOM/dom
figure;ft_topoplotER(cfg,dom);
title('SUBJECT 8')


%% Realign subjects correct fields for head position and size
subjn='2';
load '25/DOM/dom.mat';
cfg=[];
cfg.template={dom.grad};
hs=ft_read_headshape([subjn,'/DOM/hs_file']);
[o,r]=fitsphere(hs.pnt);
load([subjn,'/DOM/dom.mat']);
cfg.inwardshift=0.025;
cfg.vol.r=r;cfg.vol.o=o;
cfg.trials=1;
dom_ra=ft_megrealign(cfg,dom);
%% t-test per channel for one time point, realigned data

% here we load grandaverage files after realignment
load gadom_ra
gadomra=gadom_ra;
load gasub_ra
gasubra=gasub_ra;
% now statistics for 0.2ms
statPlot11(gasubra,gadomra,0.2)

clear *ra

%% cluster based permutations statistics
% Check which neghbouring channels are significantly greater / smaller for
% sub compared to dom. Then taking clusters of neighbours we run a
% permutation test to check if deviding the trials by condition is
% different than divide trials randomly.
% WHY? clustering means less comparisons, permutations means data doesn't
% have to be normal disyribution.

load ~/work-drafts/matlab/neighbours

%    I calculated "neighbourhood" like this:
% load '25/DOM/dom.mat';
% cfg=[];
% cfg.method='distance';
% cfg.grad=dom.grad;
% cfg.neighbourdist = 0.04; % default is 0.04m
% neighbours = ft_prepare_neighbours(cfg, dom);
% neighbours=neighbours(1:248);

cfg=[];
cfg.neighbours = neighbours;
cfg.latency     = [0.2 0.2];
cfg.numrandomization = 1000;
cfg.correctm         = 'cluster';
cfg.uvar        = 1; % row of design matrix that contains unit variable (in this case: subjects)
cfg.ivar        = 2; %
cfg.method      = 'montecarlo';
cfg.statistic   = 'depsamplesT';
cfg.design = [1:25 1:25];
cfg.design(2,:) = [ones(1,25) ones(1,25)*2];



[stat] = ft_timelockstatistics(cfg, gasub, gadom);
neg_cluster_pvals = [stat.negclusters(:).prob];
pos_cluster_pvals = [stat.posclusters(:).prob];

% realignment improve statistics? I ran:
% [stat_ra] = ft_timelockstatistics(cfg, gasub_ra, gadom_ra);
% neg_cluster_pvals = [stat_ra.negclusters(:).prob]
% pos_cluster_pvals = [stat_ra.posclusters(:).prob]
% prob was about the same

% here we select channels of significant clusters for display
neg_signif_clust = find(neg_cluster_pvals < stat.cfg.alpha);
neg = ismember(stat.negclusterslabelmat, neg_signif_clust);
%neg=ismember(neg_signif_clust,stat.negclusterslabelmat)
datadif=gasub;
datadif.individual=gasub.individual-gadom.individual;
cfgp=[];
cfgp.layout='4D248.lay';
cfgp.interactive='yes';
cfgp.xlim=[0.2 0.2];
cfgp.highlight = 'on';
cfgp.highlightchannel = find(neg);
ft_topoplotER(cfgp, datadif);colorbar;
title(['Sub - Dom significant neg cluster (p=',num2str(neg_cluster_pvals),')']);

%% Compute planar gradient (megplanar) to reduce noise.
% Relies on dipole topography. One subject, M100.
% 
load 1/DOM/dom
cfg=[];
cfg.planarmethod   = 'orig';
cfg.neighbours     = neighbours;
[interp] = ft_megplanar(cfg, dom);
cfg=[];
cfg.combinegrad  = 'yes';
dom_cp = ft_combineplanar(cfg, interp)
cfgp = [];
cfgp.xlim=[0.1 0.1];
cfgp.layout = '4D248.lay';
figure;
ft_topoplotER(cfgp,dom_cp)
title('planar')
figure;
ft_topoplotER(cfgp,dom)
title('raw')
%% MEG planar statistics for M170
load gadom_cp
load gasub_cp

statPlot11(gasub_cp,gadom_cp,0.2)

% you can also try for M100 statPlot11(gasub_cp,gadom_cp,0.1)
% it could make sense to do megrealign after meg planar but It is
% impossible with fieldtrip now.
%% RMS for all the MEG channels
% It is possible to calculate RMS for all the channels with clustData.
% Here we end up with one trace per condition, easy to run a ttest for each
% time point. We can also calculate the area between the curves.
cfg=[];
cfg.method='RMS';
cfg.neighbours='all';
gadomRMSall=clustData(cfg,gadom);
gasubRMSall=clustData(cfg,gasub);
% you can also calculate RMS without clustData in less moves:
% subRMS=squeeze(sqrt(mean(gasub.individual.^2,2)));
% domRMS=squeeze(sqrt(mean(gadom.individual.^2,2)));

cfgs=[];
cfgs.method='stats';
cfgs.statistic='paired-ttest';
cfgs.design = [ones(1,25) ones(1,25)*2];
[stat] = ft_timelockstatistics(cfgs, gasubRMSall, gadomRMSall)

plot(gadomRMSall.time,squeeze(mean(gadomRMSall.individual,1)),'k');
hold on
plot(gasubRMSall.time,squeeze(mean(gasubRMSall.individual,1)),'r');
plot(stat.time(find(stat.prob<0.05)),1.1*squeeze(max(mean(gasubRMSall.individual,1))),'k*');
legend('Dom','Sub','sig')
% don't close the figure

% area under curve
timelim=[0.17 0.2];
samp1=nearest(gadomRMSall.time,timelim(1));
samp2=nearest(gadomRMSall.time,timelim(2));
timeline=gadomRMSall.time(1,samp1:samp2);
domcurve=squeeze(gadomRMSall.individual(:,1,samp1:samp2))';
subcurve=squeeze(gasubRMSall.individual(:,1,samp1:samp2))';
domArea=trapz(timeline,domcurve);
subArea=trapz(timeline,subcurve);
[~,b]=ttest(domArea,subArea)
hsub=area(timeline,mean(subcurve,2));
set(hsub,'FaceColor','r','EdgeColor','r')
hdom=area(timeline,mean(domcurve,2));
set(hdom,'FaceColor','w','EdgeColor','w')
%% RMS for left and right sensors
cfg=[];
cfg.method='RMS';
cfg.neighbours='LR';
gadomRMS_LR=clustData(cfg,gadom);
gasubRMS_LR=clustData(cfg,gasub);

subRMS_L=squeeze(mean(gasubRMS_LR.individual(:,1,:),1));
domRMS_L=squeeze(mean(gadomRMS_LR.individual(:,1,:),1));
subRMS_R=squeeze(mean(gasubRMS_LR.individual(:,2,:),1));
domRMS_R=squeeze(mean(gadomRMS_LR.individual(:,2,:),1));

figure;
plot(gasub.time,subRMS_L,'r')
hold on
plot(gasub.time,domRMS_L,'b')
ylim([0 1e-13]);
plot(gasub.time,subRMS_R,'m')
hold on
plot(gasub.time,domRMS_R,'c')
legend('SUB L','DOM L','SUB R','DOM R')
ylim([-1e-14 1e-13]);

% right bias requires baseline correction [-0.2 0] for the RMS traces
blsamps=[nearest(gadomRMS_LR.time,-0.2):nearest(gadomRMS_LR.time,0)];
BLleft=mean((domRMS_L(blsamps))+mean(subRMS_L(blsamps)))./2;
BLright=mean((domRMS_R(blsamps))+mean(subRMS_R(blsamps)))./2;
figure
plot(gasub.time,subRMS_L-BLleft,'r')
hold on
plot(gasub.time,domRMS_L-BLleft,'b')
ylim([0 1e-13]);
plot(gasub.time,subRMS_R-BLright,'m')
hold on
plot(gasub.time,domRMS_R-BLright,'c')
legend('SUB L','DOM L','SUB R','DOM R')
ylim([-1e-14 1e-13]);
title('RMS after baseline correction')
%% RMS for clusters
% Here each channel is replaced with the RMS of its neighbours. This is
% good for finding why the RMS was significant over hemisphere or globally.
cfg=[];
cfg.neighbours=neighbours;
cfg.method='RMS';
gadomRMS=clustData(cfg,gadom);
gasubRMS=clustData(cfg,gasub);
figure;
statPlot11(gasubRMS,gadomRMS,0.2)

%% Mean cluster value
% This is really smoothing of the raw signal, no RMS.
cfg.method='mean';
gadomMC=clustData(cfg,gadom);
gasubMC=clustData(cfg,gasub);
figure;
statPlot11(gasubMC,gadomMC,0.2,[-1e-13 1e-13])



