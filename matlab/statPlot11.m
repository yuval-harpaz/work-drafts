function statPlot11(data1,data2,timepoint,zlim);
cfg=[];
if exist('zlim','var')
    cfg.zlim=zlim;
else
    cfg.zlim=[];
end
if isempty(cfg.zlim)
    cfg.zlim='maxmin';
end
cfg.xlim=[timepoint timepoint];
cfg.layout = '4D248.lay';
figure;
ft_topoplotER(cfg,data1);
title(inputname(1))
figure;
ft_topoplotER(cfg,data2);
title(inputname(2))

cfgs=[];
cfgs.latency=[timepoint timepoint];
cfgs.method='stats';
cfgs.statistic='paired-ttest';
cfgs.design = [ones(1,25) ones(1,25)*2];
[stat] = ft_timelockstatistics(cfgs, data1,data2);

datadif=data1;
datadif.individual=data1.individual-data2.individual;  
cfg.highlight = 'on';
cfg.highlightchannel = find(stat.prob<0.05);
cfg.zlim='maxmin';
figure;ft_topoplotER(cfg, datadif);
colorbar;
title([inputname(1),'-',inputname(2)])

end
