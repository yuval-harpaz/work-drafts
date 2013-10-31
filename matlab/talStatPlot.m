function [stat,figure1]=talStatPlot(data1,data2,xlim,zlim,ttype,chans,midline);
% independent sample ttest (two groups)
%  stat=statPlot('cohLRv1pre_DM','cohLRv1pre_CM',[10 10],[],'ttest2')


if ~exist('ttype','var')
    ttype=[];
end
if isempty(ttype)
    ttype='paired-ttest';
end
cfg=[];
if exist('zlim','var')
    cfg.zlim=zlim;
else
    cfg.zlim=[];
end
if isempty(cfg.zlim)
    cfg.zlim='maxmin';
end
if ischar(data1)
    
    load(data1)
    if isempty(findstr('/',data1))
        path1=pwd;
    else
        [path1, data1] = fileparts(data1)
    end
    title1=[path1(end-7:end),'/',data1];
    eval(['data1=',data1])
    load(data2)
    if isempty(findstr('/',data2))
        path2=pwd;
    else
        [path2, data2] = fileparts(data2)
    end
    
    title2=[path2(end-7:end),'/',data2];
    eval(['data2=',data2])
else
    title1=inputname(1);
    title2=inputname(2);
end
if isfield(data1,'individual')
    dataMat='individual';
elseif isfield(data1,'powspctrm')
    dataMat='powspctrm';
else
    error('needs data.individual or data.powspctrm')
end
cfg.xlim=xlim;
cfg.layout = '4D248.lay';
if length(data1.label)<35
    cfg.layout = 'WG32.lay'
end
% deleting pairs of bad chans
data1.label=data1.label([1:132,134:246],1);
eval(['data1.',dataMat,'=data1.',dataMat,'(:,[1:132,134:246],:);'])
data2.label=data2.label([1:132,134:246],1);
eval(['data2.',dataMat,'=data2.',dataMat,'(:,[1:132,134:246],:);'])
data1.label=data1.label([1:68,70:245],1);
eval(['data1.',dataMat,'=data1.',dataMat,'(:,[1:68,70:245],:);'])
data2.label=data2.label([1:68,70:245],1);
eval(['data2.',dataMat,'=data2.',dataMat,'(:,[1:68,70:245],:);'])

if exist('midline','var')
    load LRpairs
    eval(['tmp=data1.',dataMat,';'])
    eval(['data1.',dataMat,'=ones(size(data1.',dataMat,'));'])
    [~,chi]=ismember(LRpairs(:,1),data1.label); %#ok<NODEF>
    chi=chi(chi>0); %#ok<*NASGU>
    eval(['data1.',dataMat,'(:,chi,:)=tmp(:,chi,:);']);
    [~,chi]=ismember(LRpairs(:,2),data1.label);
    chi=chi(chi>0); %#ok<*NASGU>
    eval(['data1.',dataMat,'(:,chi,:)=tmp(:,chi,:);']);
    
    eval(['tmp=data2.',dataMat,';'])
    eval(['data2.',dataMat,'=ones(size(data2.',dataMat,'));'])
    [~,chi]=ismember(LRpairs(:,1),data2.label);
    chi=chi(chi>0); %#ok<*NASGU>
    eval(['data2.',dataMat,'(:,chi,:)=tmp(:,chi,:);']);
    [~,chi]=ismember(LRpairs(:,2),data2.label);
    chi=chi(chi>0); %#ok<*NASGU>
    eval(['data2.',dataMat,'(:,chi,:)=tmp(:,chi,:);']);
    clear tmp
    % bad chans
end
    
cfgs=[];

cfgs.method='stats';
cfgs.statistic=ttype;
if strcmp(ttype,'paired-ttest')
    eval(['cfgs.design = [ones(1,size(data1.',dataMat,',1)) ones(1,size(data1.',dataMat,',1))*2];']);
else
    eval(['cfgs.design = [ones(1,size(data1.',dataMat,',1)) ones(1,size(data2.',dataMat,',1))*2];'])
end
if exist('chans','var')
    cfgs.channel=chans;
end
if isfield(data1,'powspctrm')
    cfgs.frequency=xlim;
    [stat] = ft_freqstatistics(cfgs, data1,data2);
else
    cfgs.latency=xlim;
    [stat] = ft_timelockstatistics(cfgs, data1,data2);
end

datadif=data1;
if isfield(data1,'powspctrm')
    if strcmp(ttype,'paired-ttest')
        datadif.powspctrm=data1.powspctrm-data2.powspctrm;
    else
        datadif.powspctrm=mean(data1.powspctrm,1)-mean(data2.powspctrm,1);
    end
else
    datadif.individual=data1.individual-data2.individual;
end
cfg.highlight = 'labels';
if exist('chans','var')
    cfg.highlightchannel=stat.label(find(stat.prob<0.05));
else
    cfg.highlightchannel = find(stat.prob<0.05);
end
figure1=figure('Units','normalized','Position',[0 0 1 1]);
subplot(1,2,1)
ft_topoplotER(cfg,data1)
title(strrep(title1,'_',' '));
subplot(1,2,2)
ft_topoplotER(cfg,data2)
title(strrep(title2,'_',' '));
cfg.interactive='yes';
end
