load cohLRv1pre_D
load cohLRv1pre_C
load neighbours
cfg=[];
cfg.neighbours = neighbours;
cfg.latency     = [0.2 0.2];
cfg.numrandomization = 1000;
cfg.correctm         = 'cluster';
%cfg.uvar        = 1; % row of design matrix that contains unit variable (in this case: subjects)
%cfg.ivar        = 2; %
cfg.method      = 'montecarlo';
cfg.statistic   = 'indepsamplesT';

cfg.design = [ones(1,size(cohLRv1pre_D.powspctrm,1)) ones(1,size(cohLRv1pre_C.powspctrm,1))*2];
% cfg.design = [1:25 1:25];
% cfg.design(2,:) = [ones(1,25) ones(1,25)*2];
cfg.frequency=[10 10];
[stat] = ft_freqstatistics(cfg,cohLRv1pre_D ,cohLRv1pre_C);

pos_cluster_pvals = [stat.posclusters(:).prob]
pos_signif_clust = find(pos_cluster_pvals < 0.05)
%%
load cohLRv2pre_D
load cohLRv2post_D

%cfg.uvar        = 1; % row of design matrix that contains unit variable (in this case: subjects)
%cfg.ivar        = 2; %
cfg.statistic   = 'depsamplesT';

cfg.design = [ones(1,size(cohLRv2post_D.powspctrm,1)) ones(1,size(cohLRv2pre_D.powspctrm,1))];
cfg.design(2,:) = [ones(1,size(cohLRv2post_D.powspctrm,1)) ones(1,size(cohLRv2pre_D.powspctrm,1))*2];
% cfg.design = [1:25 1:25];
% cfg.design(2,:) = [ones(1,25) ones(1,25)*2];
cfg.frequency=[10 10];
[stat] = ft_freqstatistics(cfg,cohLRv2post_D ,cohLRv2pre_D);

pos_cluster_pvals = [stat.posclusters(:).prob]
pos_signif_clust = find(pos_cluster_pvals < 0.05)