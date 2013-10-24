function [p,x,labels]=aliceTtest0B(gaData,plt)
cd /home/yuval/Copy/MEGdata/alice/ga
if ~ exist('plt','var')
    plt=true;
end
if ischar(gaData)
    load (gaData)
    eval(['gaData=',gaData,';']);
end
if isfield(gaData,'time')
    xSize=length(gaData.time);
    x=gaData.time;
    for xi=1:xSize
        [~,p(xi,1:length(gaData.label))] = ttest(gaData.individual(:,:,xi));
    end
else
    xSize=length(gaData.freq);
    x=gaData.freq;
    for xi=1:xSize
        [~,p(xi,1:length(gaData.label))] = ttest(gaData.powspctrm(:,:,xi));
    end
end
p(isnan(p))=1;
p=1-p;
p=p';
if isfield(gaData,'individual')
    data=ft_timelockanalysis([],gaData);
    data.powspctrm=data.avg;
    data.dimord='chan_freq';
else
    data=gaData;
    data.powspctrm=squeeze(mean(gaData.powspctrm,1));
    data.dimord='chan_time';
    data.time=data.freq;
    data=rmfield(data,'freq');
end
cfg=[];
if strcmp(gaData.label{1,1},'Fp1')
    cfg.layout='WG32.lay';
else
    cfg.layout='4D248.lay';
end
%cfg.xlim=[99 99.2];
neg=data.powspctrm<0;
if plt
    figure;
    ft_movieplotTFR(cfg,data);
    data.powspctrm=p;
    data.powspctrm(neg)=0;
    figure;
    cfg.zlim=[0.95 1];
    ft_movieplotTFR(cfg,data);
end
p=1-p;
p(neg)=-p(neg);
labels=gaData.label;