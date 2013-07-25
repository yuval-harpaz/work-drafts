function aliceTables(method)
cd /home/yuval/Copy/MEGdata/alice
load comps
for subi=1:length(comps.C100)
    subFold=sf{1,subi};
    cd (['/home/yuval/Data/alice/',subFold])
    load avgReduced
    table=zeros(10,4);
    
    start100=comps.C100(subi,1);
    end100=comps.C100(subi,2);
    start170=comps.C170(subi,1);
    end170=comps.C170(subi,2);
    
    %if ~exist('./files/tablesWH.mat','file')
    for segi=[2:2:20] % 20 for WBW
        if segi==20
            load avgWbW
            avgEEG=avgWbWeeg;
            avgMEG=avgWbWmeg;
        else
            segStr=num2str(segi);
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
        switch method
            case 'WH'
                % calculate area for whole head RMS
                rmsE=sqrt(mean(avgEEG.avg.*avgEEG.avg,1));
                rmsM=sqrt(mean(avgMEG.avg.*avgMEG.avg,1));
                table(segi/2,1)=trapz(rmsE(start100E:end100E));
                table(segi/2,2)=trapz(rmsE(start170E:end170E));
                table(segi/2,3)=trapz(rmsM(start100M:end100M));
                table(segi/2,4)=trapz(rmsM(start170M:end170M));
                save (['files/tables',method],'table')
            case 'LR'
                load LRpairsEEG
                LRpairsEEG=LRpairs;
                load LRpairs
                % EEG
                chL=zeros(1,length(LRpairsEEG));
                chR=chL;
                for pairi=1:length(LRpairsEEG)
                    chL(pairi)=find(ismember(avgEEG.label,LRpairsEEG(pairi,1)));
                    chR(pairi)=find(ismember(avgEEG.label,LRpairsEEG(pairi,2)));
                end
                LrmsE=sqrt(mean(avgEEG.avg(chL,:).*avgEEG.avg(chL,:),1));
                RrmsE=sqrt(mean(avgEEG.avg(chR,:).*avgEEG.avg(chR,:),1));
                % MEG
                chL=zeros(1,length(LRpairs));
                chR=chL;
                for pairi=1:length(LRpairs)
                    chL(pairi)=find(ismember(avgMEG.label,LRpairs(pairi,1)));
                    chR(pairi)=find(ismember(avgMEG.label,LRpairs(pairi,2)));
                end
                LrmsM=sqrt(mean(avgMEG.avg(chL,:).*avgMEG.avg(chL,:),1));
                RrmsM=sqrt(mean(avgMEG.avg(chR,:).*avgMEG.avg(chR,:),1));
                table(segi/2,1)=trapz(LrmsE(start100E:end100E));
                table(segi/2,2)=trapz(LrmsE(start170E:end170E));
                table(segi/2,3)=trapz(LrmsM(start100M:end100M));
                table(segi/2,4)=trapz(LrmsM(start170M:end170M));
                save ('files/tablesL','table')
                table(segi/2,1)=trapz(RrmsE(start100E:end100E));
                table(segi/2,2)=trapz(RrmsE(start170E:end170E));
                table(segi/2,3)=trapz(RrmsM(start100M:end100M));
                table(segi/2,4)=trapz(RrmsM(start170M:end170M));
                save ('files/tablesR','table')
                table(segi/2,1)=trapz(LrmsE(start100E:end100E))-trapz(RrmsE(start100E:end100E));
                table(segi/2,2)=trapz(LrmsE(start170E:end170E))-trapz(RrmsE(start170E:end170E));
                table(segi/2,3)=trapz(LrmsM(start100M:end100M))-trapz(RrmsM(start100M:end100M));
                table(segi/2,4)=trapz(LrmsM(start170M:end170M))-trapz(RrmsM(start170M:end170M));
                save ('files/tablesLR','table')
            case 'Post'
                load ./files/postChans
                ch=zeros(1,length(postChans));
                for chi=1:length(postChans)
                    ch(chi)=find(ismember(avgMEG.label,postChans(1,chi)));
                end
                rmsM=sqrt(mean(avgMEG.avg(ch,:).*avgMEG.avg(ch,:),1));
                postChans={'FC1', 'FC2', 'Cz', 'CP1', 'CP2', 'Pz', 'O1', 'Oz', 'O2'};
                ch=zeros(1,length(postChans));
                for chi=1:length(postChans)
                    ch(chi)=find(ismember(avgEEG.label,postChans(1,chi)));
                end
                rmsE=sqrt(mean(avgEEG.avg(ch,:).*avgEEG.avg(ch,:),1));
                table(segi/2,1)=trapz(rmsE(start100E:end100E));
                table(segi/2,2)=trapz(rmsE(start170E:end170E));
                table(segi/2,3)=trapz(rmsM(start100M:end100M));
                table(segi/2,4)=trapz(rmsM(start170M:end170M));
                save ('files/tablesPost','table')
            case 'PostLR'
                load ./files/postChans
                load LRpairsEEG
                LRpairsEEG=LRpairs;
                load LRpairs
                % MEG
                chLogicP=ismember(avgMEG.label,postChans);
                chLogicL=ismember(avgMEG.label,LRpairs(:,1));
                chLogicR=ismember(avgMEG.label,LRpairs(:,2));
                chL=find(chLogicP.*chLogicL);
                chR=find(chLogicP.*chLogicR);
                LrmsM=sqrt(mean(avgMEG.avg(chL,:).*avgMEG.avg(chL,:),1));
                RrmsM=sqrt(mean(avgMEG.avg(chR,:).*avgMEG.avg(chR,:),1));
                
                % EEG
                postChans={'FC1', 'FC2', 'Cz', 'CP1', 'CP2', 'Pz', 'O1', 'Oz', 'O2'};
                chLogicP=ismember(avgEEG.label,postChans);
                chLogicL=ismember(avgEEG.label,LRpairsEEG(:,1));
                chLogicR=ismember(avgEEG.label,LRpairsEEG(:,2));
                chL=find(chLogicP.*chLogicL);
                chR=find(chLogicP.*chLogicR);
                LrmsE=sqrt(mean(avgEEG.avg(chL,:).*avgEEG.avg(chL,:),1));
                RrmsE=sqrt(mean(avgEEG.avg(chR,:).*avgEEG.avg(chR,:),1));
                
                table(segi/2,1)=trapz(LrmsE(start100E:end100E));
                table(segi/2,2)=trapz(LrmsE(start170E:end170E));
                table(segi/2,3)=trapz(LrmsM(start100M:end100M));
                table(segi/2,4)=trapz(LrmsM(start170M:end170M));
                save ('files/tablesPostL','table')
                table(segi/2,1)=trapz(RrmsE(start100E:end100E));
                table(segi/2,2)=trapz(RrmsE(start170E:end170E));
                table(segi/2,3)=trapz(RrmsM(start100M:end100M));
                table(segi/2,4)=trapz(RrmsM(start170M:end170M));
                save ('files/tablesPostR','table')
                table(segi/2,1)=trapz(LrmsE(start100E:end100E))-trapz(RrmsE(start100E:end100E));
                table(segi/2,2)=trapz(LrmsE(start170E:end170E))-trapz(RrmsE(start170E:end170E));
                table(segi/2,3)=trapz(LrmsM(start100M:end100M))-trapz(RrmsM(start100M:end100M));
                table(segi/2,4)=trapz(LrmsM(start170M:end170M))-trapz(RrmsM(start170M:end170M));
                save ('files/tablesPostLR','table')
                %ch(chi)=find(ismember(avgMEG.label,postChans(1,chi)));
        end
    end
end

%end
end
% legend('1','2','4','6','7','8','3 news','5 tamil','9 loud')
% for subi=1:length(comps.C100)
%     subFold=sf{1,subi};
%     cd (['/home/yuval/Data/alice/',subFold])
%     load files/tablesWH
%     X(subi,1)=table(5,4);
%     X(subi,2)=(table(4,4)+table(6,4))/2;
% end
% [~,p,~,stats] = ttest2(X(:,1),X(:,2))

