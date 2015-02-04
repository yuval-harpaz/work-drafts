function aliceGAaliceNtrials

% 2 seg1.bmp
% 4 seg3.bmp	1
% 6 news.bmp	1
% 8 seg4.bmp	1
% 10 tamil.bmp	1
% 12 seg5.bmp	1
% 14 seg6.bmp	1
% 16 seg7.bmp	1
% 18 seg8.bmp	1 (loud)
% 20 break
% 50 words

cd /home/yuval/Copy/MEGdata/alice
load comps
segi=20; % 20 for WBW
strE='';strM='';
segStr=num2str(segi);
for subi=1:length(comps.C100)
    subStr=num2str(subi);
    subFold=sf{1,subi};
    cd (['/home/yuval/Data/alice/',subFold])
    load avgWbW2
    if subi==4
        load avgWbW2fixedArtifact
    end
    goodM=badTrials([],megpca,0);
    goodE=badTrials([],eegpca,0);
    i=ismember(goodM,goodE);
    good=goodM(i);
    cfg=[];
    cfg.trials=good;
    eval(['avgE',segStr,'_',subStr,'=ft_timelockanalysis(cfg,eegpca);']);
    eval(['avgM',segStr,'_',subStr,'=ft_timelockanalysis(cfg,megpca);']);
    N(subi)=length(good);
    sampE(subi,1:2)=[eegpca.sampleinfo(1,1),eegpca.sampleinfo(end,2)];
    sampM(subi,1:2)=[megpca.sampleinfo(1,1),megpca.sampleinfo(end,2)];
    strE=[strE,',avgE',segStr,'_',subStr];
    strM=[strM,',avgM',segStr,'_',subStr];
end
[avgMr,avgEr]=aliceChooseNtrials(N,sampE,sampM);
disp('');
cfg=[];
cfg.keepindividual='yes';
eval(['GavgE',segStr,'=ft_timelockgrandaverage(cfg',strE,');'])
eval(['GavgM',segStr,'=ft_timelockgrandaverage(cfg',strM,');'])
cd /home/yuval/Copy/MEGdata/alice/ga2015
save GavgEqTrl GavgE20 GavgM20 avgEr avgMr
