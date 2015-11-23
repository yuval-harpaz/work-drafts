function aliceAlphaD2max

sf={'idan','inbal','liron','maor','mark','odelia','ohad','yoni'};

for subi=1:8
    cd /home/yuval/Copy/MEGdata/alice
    cd (sf{subi})
    load freqD
    alphaRead(subi,1:248)=squeeze(max(Fread(:,9:11),[],2));
    alphaRest(subi,1:248)=squeeze(max(Frest(:,9:11),[],2));
    %         [megFr,megLR,megCoh]=pow(trlMEG,LRpairs);
    %         eval(['megFr',num2str(piskai),'=megFr'])
    %         eval(['megLR',num2str(piskai),'=megLR'])
    %         eval(['megCoh',num2str(piskai),'=megCoh'])
end
cd ../
%save alphaD alpha*
cfg.zlim=[0 4e-11];
figure;topoplot248(mean(alphaRead),cfg,1);
title READ

figure;topoplot248(mean(alphaRest),cfg,1);
title REST