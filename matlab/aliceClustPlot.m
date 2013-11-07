function [stat,figure1,Ra,Rp,La,Lp]=aliceClustPlot(data1,xlim,zlim,ttype,method);
% independent sample ttest (two groups)
%  stat=statPlot('cohLRv1pre_DM','cohLRv1pre_CM',[10 10],[],'ttest2')
anterior = {'A54', 'A55', 'A81', 'A82', 'A83', 'A112', 'A113', 'A114', 'A115', 'A144', 'A145', 'A146', 'A171', 'A172', 'A173', 'A174', 'A175', 'A193', 'A194', 'A209', 'A210', 'A211', 'A227', 'A228', 'A244', 'A245', 'A246', 'A247', 'A248'};
posterior =  {'A51', 'A52', 'A77', 'A78', 'A79', 'A107', 'A108', 'A109', 'A110', 'A139', 'A140', 'A141', 'A142', 'A167', 'A168', 'A169', 'A170', 'A188', 'A189', 'A190', 'A191', 'A206', 'A207', 'A208', 'A225'};
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
[~,anti]=ismember(anterior,data1.label);
[~,posti]=ismember(posterior,data1.label);
freqi=nearest(data1.freq,xlim);

load LRpairs
data2=data1;
aCnt=0;
pCnt=0;
for pairi=1:length(LRpairs)
    chAb=0;
    [~,chAb]=ismember(LRpairs{pairi,2},anterior);
    if chAb>0
        aCnt=aCnt+1;
        [~,aLi(aCnt)]=ismember(LRpairs{pairi,1},data1.label);
    else
        chPb=0;
        [~,chPb]=ismember(LRpairs{pairi,2},posterior);
        if chPb>0
            pCnt=pCnt+1;
            [~,pLi(pCnt)]=ismember(LRpairs{pairi,1},data1.label);
        end
    end
end
switch method
    case 'mean'
        Ra=mean(data1.powspctrm(:,anti,freqi),2);
        Rp=mean(data1.powspctrm(:,posti,freqi),2);
        La=mean(data1.powspctrm(:,aLi,freqi),2);
        Lp=mean(data1.powspctrm(:,pLi,freqi),2);
    case 'max'
        Ra=max(data1.powspctrm(:,anti,freqi),[],2);
        Rp=max(data1.powspctrm(:,posti,freqi),[],2);
        La=max(data1.powspctrm(:,aLi,freqi),[],2);
        Lp=max(data1.powspctrm(:,pLi,freqi),[],2);
end
        
        
[h,p,ci,ant]=ttest(Ra,La);
ant.p=p;
[h,p,ci,post]=ttest(Rp,Lp);
post.p=p;
stat.ant=ant;
stat.post=post;

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
antpost=data1.label([anti,aLi,posti,pLi]);

cfg.xlim=[xlim xlim];;
cfg.layout = '4D248.lay';
cfg.highlight = 'on';
cfg.highlightchannel = antpost;
cfg.comment=['post p=',num2str(stat.post.p),' ant p=',num2str(stat.ant.p)];
figure1=figure;
ft_topoplotER(cfg,data1)
title(strrep(title1,'_',' '));
end
