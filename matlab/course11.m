cd amb

%% grand average
% number the average structures and make a string of names.
domstr='';
substr='';
for subi=1:25
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

cfgp=[];
cfgp.layout='4D248.lay';
cfgp.interactive='yes';
cfgp.xlim=[0.1 0.1];
ft_topoplotER(cfgp,gadom);

statPlot11(gasub,gadom,0.2)

load 1/DOM/dom
figure;ft_topoplotER(cfgp,dom);
load 2/DOM/dom
figure;ft_topoplotER(cfgp,dom);
load 8/DOM/dom
figure;ft_topoplotER(cfgp,dom);

close all;

%% meg realign
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

close all

% grand average all realigned data
% here we load grandaverage files after realignment
load gadom_ra
load gasub_ra
% now statistics for 0.2ms
statPlot11(gasub_ra,gadom_ra,0.2)

clear *ra

%% cluster based permutations statistics
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
neg_cluster_pvals = [stat.negclusters(:).prob]
pos_cluster_pvals = [stat.posclusters(:).prob]

% [stat_ra] = ft_timelockstatistics(cfg, gasub_ra, gadom_ra);
% neg_cluster_pvals = [stat_ra.negclusters(:).prob]
% pos_cluster_pvals = [stat_ra.posclusters(:).prob] % prob was about the
% same

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

%% megplanar
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
ft_topoplotER(cfgp,dom_cp,dom)

load gadom_cp
load gasub_cp

statPlot11(gasub_cp,gadom_cp,0.2)

statPlot11(gasub_cp,gadom_cp,0.1)

% it could make sense to do megrealign after meg planar but It is
% impossible with fieldtrip now.
%% RMS
% it is possible to calculate RMS for all the channels with clustData like this:
cfg=[];
cfg.method='RMS';
cfg.neighbours='all';
gadomRMSall=clustData(cfg,gadom);
gasubRMSall=clustData(cfg,gasub);


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


% you can also calculate RMS without clustData in less moves:
% subRMS=squeeze(sqrt(mean(gasub.individual.^2,2)));
% domRMS=squeeze(sqrt(mean(gadom.individual.^2,2)));
%% area under curve
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
%% now RMS for left and right sensors
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
legend('SUB_L','DOM_L','SUB_R','DOM_R')
ylim([0 1e-13]);

%% RMS for clusters
cfg=[];
cfg.neighbours=neighbours;
cfg.method='RMS';
gadomRMS=clustData(cfg,gadom);
gasubRMS=clustData(cfg,gasub);
statPlot11(gasubRMS,gadomRMS,0.2)

%% mean cluster value
cfg.method='mean';
gadomMC=clustData(cfg,gadom);
gasubMC=clustData(cfg,gasub);
statPlot11(gasubMC,gadomMC,0.2,[-1e-13 1e-13])



