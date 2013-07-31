function aliceLR1(method)
cd /home/yuval/Copy/MEGdata/alice
load comps
load LRpairsEEG
LRpairsEEG=LRpairs;
load LRpairs
switch method
    case 'alice'
        strE='';strM='';
        for subi=1:length(comps.C100)
            subStr=num2str(subi);
            subFold=sf{1,subi};
            cd (['/home/yuval/Data/alice/',subFold])
            load avgReduced
            avgEalice=avgE2;
            avgEalice.avg=zeros(size(avgE2.avg));
            avgMalice=avgM2;
            avgMalice.avg=zeros(size(avgM2.avg));
            for segi=[2 4 8 12 14 16] % 20 for WBW
                segStr=num2str(segi);
                eval(['avgEalice.avg=avgEalice.avg+avgE',segStr,'.avg']);
                eval(['avgMalice.avg=avgMalice.avg+avgM',segStr,'.avg']);
            end
            avgEalice.avg=avgEalice.avg./6;
            avgMalice.avg=avgMalice.avg./6;
            mAvg=zeros(size(avgMalice.avg));
            for pairi=1:length(LRpairs)
                %[~,i]=ismember(avgMalice.label,LRpairs);
                chL=find(ismember(avgMalice.label,LRpairs(pairi,1)));
                chR=find(ismember(avgMalice.label,LRpairs(pairi,2)));
                mAvg(chR,:)=abs(avgMalice.avg(chR,:))-abs(avgMalice.avg(chL,:));
                mAvg(chL,:)=abs(avgMalice.avg(chL,:))-abs(avgMalice.avg(chR,:));
            end
            avgMalice.avg=mAvg;
            
            eAvg=zeros(size(avgEalice.avg));
            for pairi=1:length(LRpairsEEG)
                %[~,i]=ismember(avgMalice.label,LRpairs);
                chL=find(ismember(avgEalice.label,LRpairsEEG(pairi,1)));
                chR=find(ismember(avgEalice.label,LRpairsEEG(pairi,2)));
                eAvg(chR,:)=abs(avgEalice.avg(chR,:))-abs(avgEalice.avg(chL,:));
                eAvg(chL,:)=abs(avgEalice.avg(chL,:))-abs(avgEalice.avg(chR,:));
            end
            avgEalice.avg=eAvg;
            
            eval(['avgEalice',subStr,'=avgEalice;'])
            eval(['avgMalice',subStr,'=avgMalice;'])
            strE=[strE,',avgEalice',subStr];
            strM=[strM,',avgMalice',subStr];
        end
        cfg=[];
        cfg.keepindividual='yes';
        eval(['GavgEaliceLR1=ft_timelockgrandaverage(cfg',strE,');'])
        eval(['GavgMaliceLR1=ft_timelockgrandaverage(cfg',strM,');'])
        save /home/yuval/Copy/MEGdata/alice/ga/GavgMaliceLR1 GavgMaliceLR1
        save /home/yuval/Copy/MEGdata/alice/ga/GavgEaliceLR1 GavgEaliceLR1
        
    case '6101820'
        strE='';strM='';
        for segi=[6 10 18 20] % 20 for WBW
            for subi=1:length(comps.C100)
                subStr=num2str(subi);
                subFold=sf{1,subi};
                cd (['/home/yuval/Data/alice/',subFold])
                segStr=num2str(segi);
                if segi==20
                    load avgWbW
                    avgEalice=avgWbWeeg;
                    %                avgEalice.avg=zeros(size(avgE2.avg));
                    avgMalice=avgWbWmeg;
                    %avgMalice.avg=zeros(size(avgM2.avg));
                    
                    
                else
                    
                    load avgReduced
                    avgEalice=avgE2;
                    %avgEalice.avg=zeros(size(avgE2.avg));
                    avgMalice=avgM2;
                    %avgMalice.avg=zeros(size(avgM2.avg));
                    
                    
                    eval(['avgEalice=avgE',segStr]);
                    eval(['avgMalice=avgM',segStr]);
                end
                
                %             avgEalice.avg=avgEalice.avg./6;
                %             avgMalice.avg=avgMalice.avg./6;
                mAvg=zeros(size(avgMalice.avg));
                for pairi=1:length(LRpairs)
                    %[~,i]=ismember(avgMalice.label,LRpairs);
                    chL=find(ismember(avgMalice.label,LRpairs(pairi,1)));
                    chR=find(ismember(avgMalice.label,LRpairs(pairi,2)));
                    mAvg(chR,:)=abs(avgMalice.avg(chR,:))-abs(avgMalice.avg(chL,:));
                    mAvg(chL,:)=abs(avgMalice.avg(chL,:))-abs(avgMalice.avg(chR,:));
                end
                avgMalice.avg=mAvg;
                
                eAvg=zeros(size(avgEalice.avg));
                for pairi=1:length(LRpairsEEG)
                    %[~,i]=ismember(avgMalice.label,LRpairs);
                    chL=find(ismember(avgEalice.label,LRpairsEEG(pairi,1)));
                    chR=find(ismember(avgEalice.label,LRpairsEEG(pairi,2)));
                    eAvg(chR,:)=abs(avgEalice.avg(chR,:))-abs(avgEalice.avg(chL,:));
                    eAvg(chL,:)=abs(avgEalice.avg(chL,:))-abs(avgEalice.avg(chR,:));
                end
                avgEalice.avg=eAvg;
                
                eval(['avgEalice',subStr,'=avgEalice;'])
                eval(['avgMalice',subStr,'=avgMalice;'])
                strE=[strE,',avgEalice',subStr];
                strM=[strM,',avgMalice',subStr];
                
            end
            cfg=[];
            cfg.keepindividual='yes';
            eval(['GavgE',segStr,'LR1=ft_timelockgrandaverage(cfg',strE,');'])
            eval(['GavgM',segStr,'LR1=ft_timelockgrandaverage(cfg',strM,');'])
            save (['/home/yuval/Copy/MEGdata/alice/ga/GavgM',segStr,'LR1'],['GavgM',segStr,'LR1'])
            save (['/home/yuval/Copy/MEGdata/alice/ga/GavgE',segStr,'LR1'],['GavgE',segStr,'LR1'])
        end
end
