function aliceLR
cd /home/yuval/Copy/MEGdata/alice
load comps
load LRpairsEEG
LRpairsEEG=LRpairs;
load LRpairs
for subi=1:length(comps.C100)
    subFold=sf{1,subi};
    cd (['/home/yuval/Data/alice/',subFold])
    load avgReduced
    start100=comps.C100(subi,1);
    end100=comps.C100(subi,2);
    start170=comps.C170(subi,1);
    end170=comps.C170(subi,2);
    
    %if ~exist('./files/tablesWH.mat','file')
    for segi=[2:2:20] % 20 for WBW
        segStr=num2str(segi);
        if segi==20
            load avgWbW
            avgEEG=avgWbWeeg;
            avgMEG=avgWbWmeg;
        else
            eval(['avgEEG=avgE',segStr,';']);
            eval(['avgMEG=avgM',segStr,';']);
        end
        start100E=nearest(avgEEG.time,start100);
        start100M=nearest(avgMEG.time,start100);
        end100E=nearest(avgEEG.time,end100);
        end100M=nearest(avgMEG.time,end100);
        start170E=nearest(avgEEG.time,start170);
        start170M=nearest(avgMEG.time,start170);
        end170E=nearest(avgEEG.time,end170);
        end170M=nearest(avgMEG.time,end170);
        LRm=avgMEG;
        LRm.avg=zeros(size(avgMEG.avg));
        M=trapz(avgMEG.avg(:,start100M:end100M)'); %#ok<*UDIM>
        for pairi=1:length(LRpairs)
            chL=find(ismember(avgMEG.label,LRpairs(pairi,1)));
            chR=find(ismember(avgMEG.label,LRpairs(pairi,2)));
            LRm.avg(chR,1)=abs(M(chR))-abs(M(chL));
            LRm.avg(chL,1)=abs(M(chL))-abs(M(chR));
        end
        M=trapz(avgMEG.avg(:,start170M:end170M)');
        for pairi=1:length(LRpairs)
            chL=find(ismember(avgMEG.label,LRpairs(pairi,1)));
            chR=find(ismember(avgMEG.label,LRpairs(pairi,2)));
            LRm.avg(chR,2)=abs(M(chR))-abs(M(chL));
            LRm.avg(chL,2)=abs(M(chL))-abs(M(chR));
        end
        LRm.time=[0.1 0.17];
        LRe=avgEEG;
        LRe.avg=zeros(size(avgEEG.avg));
        E=trapz(avgEEG.avg(:,start100E:end100E)');
        for pairi=1:length(LRpairsEEG)
            chL=find(ismember(avgEEG.label,LRpairsEEG(pairi,1)));
            chR=find(ismember(avgEEG.label,LRpairsEEG(pairi,2)));
            LRe.avg(chR,1)=abs(E(chR))-abs(E(chL));
            LRe.avg(chL,1)=abs(E(chL))-abs(E(chR));
        end
        E=trapz(avgEEG.avg(:,start170E:end170E)');
        for pairi=1:length(LRpairsEEG)
            chL=find(ismember(avgEEG.label,LRpairsEEG(pairi,1)));
            chR=find(ismember(avgEEG.label,LRpairsEEG(pairi,2)));
            LRe.avg(chR,2)=abs(E(chR))-abs(E(chL));
            LRe.avg(chL,2)=abs(E(chL))-abs(E(chR));
        end
        LRe.time=[0.1 0.17];
        eval(['avgE',segStr,'LR=LRe;']);
        eval(['avgM',segStr,'LR=LRm;']);
%         figure;
%         subplot(2,2,1)
%         cfg=[];
%         cfg.xlim=[0.1 0.1];
%         cfg.layout='WG32.lay';
%         ft_topoplotER(cfg,LRe);
%         subplot(2,2,2)
%         cfg=[];
%         cfg.xlim=[0.17 0.17];
%         cfg.layout='WG32.lay';
%         ft_topoplotER(cfg,LRe);
%         subplot(2,2,3)
%         cfg=[];
%         cfg.xlim=[0.1 0.1];
%         cfg.layout='4D248.lay';
%         ft_topoplotER(cfg,LRm);
%         subplot(2,2,4)
%         cfg=[];
%         cfg.xlim=[0.17 0.17];
%         cfg.layout='4D248.lay';
%         ft_topoplotER(cfg,LRm);

    end
    save avgLR avgE*LR avgM*LR
end
