function [stat,figure1,minp,critP]=statPermDepLR(data1,xlim,zlim,ttype,alpha);
% independent sample ttest (two groups)
%  stat=statPlot('cohLRv1pre_DM','cohLRv1pre_CM',[10 10],[],'ttest2')

if ~exist('alpha','var')
    alpha=[];
end
if isempty(alpha)
    alpha=0.05;
end
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
%     load(data2)
%     if isempty(findstr('/',data2))
%         path2=pwd;
%     else
%         [path2, data2] = fileparts(data2)
%     end
%     
%     title2=[path2(end-7:end),'/',data2];
%     eval(['data2=',data2])
else
    title1=inputname(1);
%    title2=inputname(2);
end
if isfield(data1,'individual')
    dataMat='individual';
elseif isfield(data1,'powspctrm')
    dataMat='powspctrm';
else
    error('needs data.individual or data.powspctrm')
end
cfg.xlim=[xlim xlim];;
cfg.layout = '4D248.lay';
if length(data1.label)<35
    cfg.layout = 'WG32.lay'
end
data2=data1;
load LRpairs
for pairi=1:length(LRpairs)
    chLi=0;chRi=0;
    [~,chLi]=ismember(LRpairs{pairi,1},data1.label);
    [~,chRi]=ismember(LRpairs{pairi,2},data1.label);
    if chLi>0 && chRi>0
        try
            data2.powspctrm(:,chLi,:)=data1.powspctrm(:,chRi,:);
            data2.powspctrm(:,chRi,:)=data1.powspctrm(:,chLi,:);
        catch
           data2.individual(:,chLi,:)=data1.powspctrm(:,chRi,:);
           data2.individual(:,chRi,:)=data1.powspctrm(:,chLi,:);
        end
    end
end
cfgs=[];

cfgs.method='stats';
cfgs.statistic=ttype;
if strcmp(ttype,'paired-ttest')
    eval(['cfgs.design = [ones(1,size(data1.',dataMat,',1)) ones(1,size(data1.',dataMat,',1))*2];']);
else
    eval(['cfgs.design = [ones(1,size(data1.',dataMat,',1)) ones(1,size(data2.',dataMat,',1))*2];'])
end
%% permutations
cfgs.feedback='no';
if isfield(data1,'powspctrm')
    cfgs.frequency=[xlim xlim];
    for permi=1:1000
        DATA1=data1;
        DATA2=data2;
        switchsub=find(round(rand(1,size(DATA1.powspctrm,1))));
        DATA1.powspctrm(switchsub,:,:)=data2.powspctrm(switchsub,:,:);
        DATA2.powspctrm(switchsub,:,:)=data1.powspctrm(switchsub,:,:);
        [stat] = ft_freqstatistics(cfgs, DATA1,DATA2);
        minp(permi)=min(stat.prob);
        disp(['permutation no. ',num2str(permi)])
    end
    [stat] = ft_freqstatistics(cfgs, data1,data2);
else
    cfgs.latency=[xlim xlim];
    for permi=1:1000
        DATA1=data1;
        DATA2=data2;
        switchsub=find(round(rand(1,size(DATA1.individual,1))));
        DATA1.individual(switchsub,:,:)=data2.individual(switchsub,:,:);
        DATA2.individual(switchsub,:,:)=data1.individual(switchsub,:,:);
        [stat] = ft_timelockstatistics(cfgs, DATA1,DATA2);
        minp(permi)=min(stat.prob);
        disp(['permutation no. ',num2str(permi)])
    end
    [stat] = ft_timelockstatistics(cfgs, data1,data2);
end

minp=sort(minp);

critP=minp(1000*alpha); 

cfg.highlight = 'labels';
cfg.highlightchannel = find(stat.prob<critP);

figure1=figure;
ft_topoplotER(cfg,data1)
title(strrep(title1,'_',' '));
end
