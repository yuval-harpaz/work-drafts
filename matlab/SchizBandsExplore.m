cd /media/yuval/Elements/SchizoRestMaor
load bands
load distances
mask=distances>16;
for subi=1:19
    temp=cohCo26to70(:,:,subi);
    resCo(subi)=mean(temp(mask));
end
for subi=1:29
    temp=cohSc26to70(:,:,subi);
    resSc(subi)=mean(temp(mask));
end
[~,p]=ttest2(resSc,resCo)

for subi=1:19
    temp=cohCo9to12(:,:,subi);
    resCo(subi)=mean(temp(mask));
end
for subi=1:29
    temp=cohSc9to12(:,:,subi);
    resSc(subi)=mean(temp(mask));
end
[~,p]=ttest2(resSc,resCo)

for subi=1:19
    temp=cohCo26to70(:,:,subi);
    for chani=1:248
        mapCoh(chani)=sum(temp(chani,mask(chani,:)))./sum(mask(chani,:));
        %resCo(subi)=mean(temp(mask));
    end
        
end
topoplot248(mapCoh,[],1)

condCo=cohlrCo20to25;
condSc=cohlrSc20to25;
[~,p]=ttest2(condCo',condSc');
cfg=[];
cfg.highlight='labels';
cfg.highlightchannel=find(p<0.05);
cfg.zlim=[0 1];
figure;topoplot248(mean(condSc,2),cfg);title('Sciz')
figure;topoplot248(mean(condCo,2),cfg);title('Cont')


condCo=powCo5to8;
condSc=powSc5to8;
[~,p]=ttest2(condCo',condSc');
cfg=[];
cfg.highlight='labels';
cfg.highlightchannel=find(p<0.05);
%cfg.zlim=[0 1];
figure;topoplot248(mean(condSc,2),cfg);title('Sciz')
figure;topoplot248(mean(condCo,2),cfg);title('Cont')
MAKE IMAGES FOR AVI
for bandi=1:6
    gr