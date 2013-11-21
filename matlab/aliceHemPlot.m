function [stat,figure1,R,L]=aliceClustPlot(data1,xlim,zlim,ttype,method);
% independent sample ttest (two groups)
%  stat=statPlot('cohLRv1pre_DM','cohLRv1pre_CM',[10 10],[],'ttest2')
if ~exist('ttype','var')
    ttype=[];
end
if isempty(ttype)
    ttype='paired-ttest';
end
if ~exist('method','var')
    ttype=[];
end
if isempty(method)
    method='mean';
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
else
    title1=inputname(1);
end
if isfield(data1,'individual')
    dataMat='individual';
elseif isfield(data1,'powspctrm')
    dataMat='powspctrm';
else
    error('needs data.individual or data.powspctrm')
end

freqi=nearest(data1.freq,xlim);

load LRpairs
data2=data1;
aCnt=0;
pCnt=0;
for pairi=1:length(LRpairs)
    if ismember(LRpairs{pairi,1},data1.label) && ismember(LRpairs{pairi,2},data1.label)
       pair(pairi)=true;
    end
end
[~,Li]=ismember(LRpairs(find(pair),1),data1.label);
[~,Ri]=ismember(LRpairs(find(pair),2),data1.label);
switch method
    case 'mean'
        R=mean(data1.powspctrm(:,Ri,freqi),2);
        L=mean(data1.powspctrm(:,Li,freqi),2);
    case 'max'
        R=max(data1.powspctrm(:,Ri,freqi),[],2);
        L=max(data1.powspctrm(:,Li,freqi),[],2);
end
        
        
[h,p,ci,ant]=ttest(R,L);
ant.p=p;

stat.hem=ant;

cfg=[];
if exist('zlim','var')
    cfg.zlim=zlim;
else
    cfg.zlim=[];
end
if isempty(cfg.zlim)
    cfg.zlim='maxmin';
end
cfg.marker='off';
%antpost=anterior;
%antpost(1,30:54)=posterior;
antpost=data1.label([Ri,Li]);

cfg.xlim=[xlim xlim];;
cfg.layout = '4D248.lay';
cfg.highlight = 'on';
cfg.highlightchannel = antpost;
cfg.comment=['p=',num2str(stat.hem.p)];
figure1=figure;
ft_topoplotER(cfg,data1)
title(strrep(title1,'_',' '));
end
