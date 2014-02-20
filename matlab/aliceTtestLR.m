function aliceTtestLR(gaData,xlim,pThr)
try
    if isempty(pThr)
        pThr=0.05;
    end
catch
    pThr=0.05;
end
if ischar(gaData)
    load (gaData)
    eval(['gaData=',gaData,';']);
end
load LRpairs
[Llog,Li]=ismember(LRpairs(:,1),gaData.label); %#ok<NODEF>
[Rlog,Ri]=ismember(LRpairs(:,2),gaData.label);
chans=Llog+Rlog==2;% in case there are missing chans;
Li=Li(chans);
Ri=Ri(chans);
dataLR=gaData;
if isfield(gaData,'time')
    dataLR.individual(:,Li,:)=gaData.individual(:,Li,:)-gaData.individual(:,Ri,:);
    dataLR.individual(:,Ri,:)=gaData.individual(:,Ri,:)-gaData.individual(:,Li,:);
    xSamp=nearest(gaData.time,xlim);
    [~,p] = ttest(dataLR.individual(:,:,xSamp));
else

    dataLR.powspctrm(:,Li,:)=gaData.powspctrm(:,Li,:)-gaData.powspctrm(:,Ri,:);
    dataLR.powspctrm(:,Ri,:)=gaData.powspctrm(:,Ri,:)-gaData.powspctrm(:,Li,:);
    xSamp=nearest(gaData.freq,xlim);
    [~,p] = ttest(dataLR.powspctrm(:,:,xSamp));
end

cfg=[];
if strcmp(gaData.label{1,1},'Fp1')
    cfg.layout='WG32.lay';
else
    cfg.layout='4D248.lay';
end
%hlc=gaData.label(
cfg.xlim=[xlim xlim];
% cfg.marker  =  'labels';
cfg.highlight          = 'marker';
cfg.highlightchannel   =  gaData.label(p<pThr);
cfg.interactive='yes';
figure;
ft_topoplotER(cfg,gaData)
figure;
ft_topoplotER(cfg,dataLR)

