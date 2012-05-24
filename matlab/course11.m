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
domstr='';
substr='';
for subi=1:25
    subjn=num2str(subi);
    load ([subjn,'/DOM/dom_ra.mat'])
    eval(['dom',subjn,'=dom_ra;']);
    domstr=[domstr,',dom',subjn];
    load ([subjn,'/SUB/sub_ra.mat'])
    eval(['sub',subjn,'=sub_ra;']);
    substr=[substr,',sub',subjn];
end

cfg=[];
cfg.channel='MEG';
cfg.keepindividual = 'yes';

eval(['gadom_ra=ft_timelockgrandaverage(cfg',domstr,');']);
eval(['gasub_ra=ft_timelockgrandaverage(cfg',substr,');']);
clear dom* sub*

% cfgp=[];
% cfgp.layout='4D248.lay';
% cfgp.interactive='yes';
% cfgp.xlim=[0.2 0.2];
% ft_topoplotER(cfgp,gadom,gadom_ra);
% 
% cfgs=[];
% cfgs.latency=[0.2 0.2];
% cfgs.method='stats';
% cfgs.statistic='paired-ttest';
% cfgs.design = [ones(1,25) ones(1,25)*2];
% [stat] = ft_timelockstatistics(cfgs, gasub, gadom)
% 
% ga_sub_dom=gasub;ga_sub_dom.individual=gasub.individual-gadom.individual;
% %ga_sub_dom.avg=squeeze(mean(gasub.individual,1)-mean(gadom.individual,1));
% cfgp = [];   
% cfgp.xlim=[0.2 0.2]; 
% cfgp.highlight = 'on';
% % Get the index of each significant channel
% cfgp.highlightchannel = find(stat.prob<0.05);
% cfgp.comment = 'xlim';
% cfgp.commentpos = 'title';
% cfgp.layout = '4D248.lay';
% ft_topoplotER(cfgp, ga_sub_dom);
% colorbar
% 
% [stat] = ft_timelockstatistics(cfgs, gasub_ra, gadom_ra)
% ga_sub_dom_ra=gasub_ra;ga_sub_dom_ra.individual=gasub_ra.individual-gadom_ra.individual;
% cfg.highlightchannel = find(stat.prob<0.05);
% figure;ft_topoplotER(cfg, ga_sub_dom_ra);

clear *ra

%% cluster based permutations statistics
load '25/DOM/dom.mat';
cfg=[];
cfg.method='distance';
cfg.grad=dom.grad;
cfg.neighbourdist = 0.04; % default is 0.04m
neighbours = ft_prepare_neighbours(cfg, dom);
neighbours=neighbours(1:248);
 % or load ~/work-drafts/matlab/neighbours
cfg=[];
cfg.neighbours = neighbours;
cfg.latency     = [0.2 0.2];
cfg.numrandomization = 1000;
cfg.correctm         = 'cluster';
% cfg.alpha            = critical value for rejecting the null-hypothesis per tail (default = 0.05)
% cfg.tail             = -1, 1 or 0 (default = 0)
% cfg.correcttail      = correct p-values or alpha-values when doing a two-sided test, 'alpha','prob' or 'no' (default = 'no')
cfg.uvar        = 1; % row of design matrix that contains unit variable (in this case: subjects)
cfg.ivar        = 2; %
%cfg.feedback         = 'gui', 'text', 'textbar' or 'no' (default = 'text')
% cfg.randomseed       = 'yes', 'no' or a number (default = 'yes')
cfg.method      = 'montecarlo';
cfg.statistic   = 'depsamplesT';
cfg.design = [1:25 1:25];
cfg.design(2,:) = [ones(1,25) ones(1,25)*2];
%cfg.design(1,:) = [ones(1,nsubj) ones(1,nsubj)*2];


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

cfgp.highlightchannel = find(neg);
ft_topoplotER(cfgp, ga_sub_dom);colorbar;

%% megplanar

cfg=[];
cfg.planarmethod   = 'orig';
cfg.neighbours     = neighbours;
[interp] = ft_megplanar(cfg, dom);
cfg=[];
cfg.combinegrad  = 'yes';
dom_cp = ft_combineplanar(cfg, interp)


domstr='';
substr='';
for subi=1:25
    subjn=num2str(subi);
    load ([subjn,'/DOM/dom.mat'])
    cfgmp=[];
    cfgmp.planarmethod   = 'orig';
    cfgmp.neighbours     = neighbours;
    [interp] = ft_megplanar(cfgmp, dom);
    cfgcp=[];
    cfgcp.combinegrad  = 'yes';
%     cfgcp.demean         = 'yes';
%     cfgcp.baselinewindow = [-0.2 0]; %didn't work, used correctBL instead
    dom = ft_combineplanar(cfgcp, interp)
    dom=correctBL(dom,[-0.2 0]);
    eval(['dom',subjn,'=dom;']);
    domstr=[domstr,',dom',subjn];
    load ([subjn,'/SUB/sub.mat'])
    [interp] = ft_megplanar(cfgmp, sub);
    sub = ft_combineplanar(cfgcp, interp)
    sub=correctBL(sub,[-0.2 0]);
    eval(['sub',subjn,'=sub;']);
    substr=[substr,',sub',subjn];
end

cfg=[];
cfg.channel='MEG';
cfg.keepindividual = 'yes';

eval(['gadom_cp=ft_timelockgrandaverage(cfg',domstr,');']);
eval(['gasub_cp=ft_timelockgrandaverage(cfg',substr,');']);
clear dom* sub*

load 1/DOM/dom
cfgp = [];
cfgp.xlim=[0.1 0.1];
cfgp.layout = '4D248.lay';
ft_topoplotER(cfgp,gadom_cp,gadom,dom)

statPlot11(gasub_cp,gadom_cp,0.2)
% cfgs=[];
% cfgs.latency=[0.2 0.2];
% cfgs.method='stats';
% cfgs.statistic='paired-ttest';
% cfgs.design = [ones(1,25) ones(1,25)*2];
% [stat] = ft_timelockstatistics(cfgs, gasub_cp,gadom_cp);
% 
% 
% ga_sub_dom_cp=gasub_cp;ga_sub_dom_cp.individual=gasub_cp.individual-gadom_cp.individual;
% cfgp = [];   
% cfgp.xlim=[0.2 0.2]; 
% cfgp.highlight = 'on';
% % Get the index of each significant channel
% cfgp.highlightchannel = find(stat.prob<0.05);
% cfgp.comment = 'xlim';
% cfgp.commentpos = 'title';
% cfgp.layout = '4D248.lay';
% ft_topoplotER(cfgp, ga_sub_dom_cp);colorbar

% cluster statistics doesn't work

%% RMS
% it is possible to calculate RMS for all the channels with clustData like this:
cfg=[];
cfg.method='RMS';
cfg.neighbours='all';
gadomRMSall=clustData(cfg,gadom);
gasubRMSall=clustData(cfg,gasub);


cfgs=[];
% cfgs.latency=[0.1956 0.1956]; ttest for one timepoint
cfgs.method='stats';
cfgs.statistic='paired-ttest';
cfgs.design = [ones(1,25) ones(1,25)*2];
[stat] = ft_timelockstatistics(cfgs, gasubRMSall, gadomRMSall)

plot(gadomRMSall.time,squeeze(mean(gadomRMSall.individual,1)),'k');
hold on
plot(gasubRMSall.time,squeeze(mean(gasubRMSall.individual,1)),'r');
plot(stat.time(find(stat.prob<0.05)),1.1*squeeze(max(mean(gasubRMSall.individual,1))),'k*');
legend('Dom','Sub','sig')

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



