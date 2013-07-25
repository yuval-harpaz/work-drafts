function aliceTtest0(gaData,xlim,mirror)
if ischar(gaData)
    load (gaData)
    eval(['gaData=',gaData,';']);
end
xSamp=nearest(gaData.time,xlim)
[~,p] = ttest(gaData.individual(:,:,xSamp));
cfg=[];
if strcmp(gaData.label{1,1},'Fp1')
    cfg.layout='WG32.lay';
else
    cfg.layout='4D248.lay';
end
cfg.xlim=[xlim xlim];
% cfg.marker  =  'labels';
cfg.highlight          = 'labels';                
cfg.highlightchannel   =  gaData.label(p<0.05);
if ~mirror
    avg=mean(gaData.individual(:,:,xSamp));
    gaData.individual(:,avg<0,xSamp)=0;
    cfg.zlim=[-max(avg) max(avg)];
end
figure;
ft_topoplotER(cfg,gaData)