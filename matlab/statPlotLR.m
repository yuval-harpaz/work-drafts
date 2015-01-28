function statPlotLR(data,timepoints,pow,zlim);
% tests left - right ttest. requires ft_timelockgrandaverage output with
% data.individual, and timepoints. assumes right and left activity are in
% opposite colors. specify pow=true if all activity is positive (RMS,
% planar...)
if ismember('A1',data.label)
    meg=true;
    load LRpairs
else
    meg=false;
    load LRpairsEEG
end
if existAndFull('zlim')
    cfg.zlim=zlim;
else
    cfg.zlim='maxmin';
end
if ~existAndFull('pow')
    pow=false;
end
if isequal(data.individual,abs(data.individual))
    pow=true;
end
Pval=ones(size(data.label));
samples=nearest(data.time,timepoints(1)):nearest(data.time,timepoints(end));
for chani=1:length(LRpairs)
    [l,i]=ismember(LRpairs(chani,:),data.label);
    if sum(l)==2
        L=squeeze(mean(data.individual(:,i(1),samples),3));
        R=squeeze(mean(data.individual(:,i(2),samples),3));
        if pow
            [~,p]=ttest(L,R);
        else
            [~,p]=ttest(L,-R);
        end
        Pval(i(1))=p;
        Pval(i(2))=p;
    end
end

cfg.xlim=[timepoints(1) timepoints(end)];
if meg
    cfg.layout = '4D248.lay';
else
    cfg.layout = 'WG30.lay';
end
cfg.highlight = 'on';
cfg.highlightchannel = find(Pval<0.05);
figure;
ft_topoplotER(cfg,data);
title(inputname(1))
%
% cfgs=[];
% cfgs.latency=[timepoint timepoint];
% cfgs.method='stats';
% cfgs.statistic='paired-ttest';
% cfgs.design = [ones(1,25) ones(1,25)*2];
% [stat] = ft_timelockstatistics(cfgs, data1,data2);
%
% datadif=data1;
% datadif.individual=data1.individual-data2.individual;
% cfg.highlight = 'on';
% cfg.highlightchannel = find(stat.prob<0.05);
% cfg.zlim='maxmin';
% figure;ft_topoplotER(cfg, datadif);
% colorbar;
% title([inputname(1),'-',inputname(2)])

end
