cd /media/yuval/Elements/SchizoRestMaor
load WPLImean

lpi=[10,11,26,22,23,21,14,18,1,2,16,24,15,19];
hpi=[25,27,17,5,8,6,7,4,29,3,28,13,12];

cfg=[];
cfg.zlim=[0 0.1];
figure;
topoplot248(mean(mean(pliSc(lpi,:,1:2)),3),cfg)
title('low positive')
figure;
topoplot248(mean(mean(pliSc(hpi,:,1:2)),3),cfg)
title('high positive')
figure
topoplot248(mean(mean(pliCo(:,:,1:2)),3),cfg)
title('control')

for freq=9:12
    %freq=10;
    fi=find(freq==foi);
    [~,p]=ttest2(pliCo(:,:,fi),pliSc(:,:,fi));
    cfg=[];
    cfg.highlight='labels';
    cfg.highlightchannel=find(p<0.05);
    cfg.zlim=[0 0.1];
    figure;
    topoplot248(mean(pliCo(:,:,fi)),cfg)
    title(['CONTROL ',num2str(freq),'Hz'])
    figure;
    topoplot248(mean(pliSc(:,:,fi)),cfg)
    title(['SCHIZOPHRENIA ',num2str(freq),'Hz'])
end
p=[];for freq=9:12;fi=find(freq==foi);[~,p(fi)]=ttest2(mean(pliCo(:,:,fi),2),mean(pliSc(:,:,fi),2));end
[~,p]=ttest2(mean(pliCo,3),mean(pliSc,3));
cfg=[];
cfg.highlight='labels';
cfg.highlightchannel=find(p<0.05);
cfg.zlim=[0 0.1];
figure;
topoplot248(squeeze(mean(mean(pliCo),3)),cfg)
title(['CONTROL alpha'])
figure;
topoplot248(squeeze(mean(mean(pliSc),3)),cfg)
title(['SCHIZOPHRENIA alpha'])

clear
load WPLI
cfg=[];
cfg.highlight='labels';
cfg.zlim=[0 0.5];    
for freq=9:12
    %freq=10;
    fi=find(freq==foi);
    [~,p]=ttest2(pliCo(:,:,fi),pliSc(:,:,fi));
    cfg.highlightchannel=find(p<0.05);
    figure;
    topoplot248(mean(pliCo(:,:,fi)),cfg,1)
    title(['CONTROL ',num2str(freq),'Hz'])
    figure;
    topoplot248(mean(pliSc(:,:,fi)),cfg,1)
    title(['SCHIZOPHRENIA ',num2str(freq),'Hz'])
end

[~,p]=ttest2(mean(pliCo,3),mean(pliSc,3));
cfg=[];
cfg.highlight='labels';
cfg.highlightchannel=find(p<0.05);
cfg.zlim=[0 0.5];
figure;
topoplot248(squeeze(mean(mean(pliCo),3)),cfg,1)
title(['CONTROL alpha'])
figure;
topoplot248(squeeze(mean(mean(pliSc),3)),cfg,1)
title(['SCHIZOPHRENIA alpha'])

