function aliceTables
cd /home/yuval/Copy/MEGdata/alice
load comps
for subi=1:length(comps.C100)
    subFold=sf{1,subi};
    cd (['/home/yuval/Data/alice/',subFold])
    load avgReduced
    table=zeros(9,4);
    start100=comps.C100(subi,1);
    start100E=nearest(avgE2.time,start100);
    start100M=nearest(avgM2.time,start100);
    end100=comps.C100(subi,2);
    end100E=nearest(avgE2.time,end100);
    end100M=nearest(avgM2.time,end100);
    start170=comps.C170(subi,1);
    start170E=nearest(avgE2.time,start170);
    start170M=nearest(avgM2.time,start170);
    end170=comps.C170(subi,2);
    end170E=nearest(avgE2.time,end170);
    end170M=nearest(avgM2.time,end170);
    %if ~exist('./files/tablesWH.mat','file')
        for segi=2:2:18
            segStr=num2str(segi);
            eval(['avgEEG=avgE',segStr,';']);
            eval(['avgMEG=avgM',segStr,';']);
            % calculate area for whole head RMS
            rmsE=sqrt(mean(avgEEG.avg.*avgEEG.avg,1));
            rmsM=sqrt(mean(avgMEG.avg.*avgMEG.avg,1));
            table(segi/2,1)=trapz(rmsE(start100E:end100E));
            table(segi/2,2)=trapz(rmsE(start170E:end170E));
            table(segi/2,3)=trapz(rmsM(start100M:end100M));
            table(segi/2,4)=trapz(rmsM(start170M:end170M));
        end
        save files/tablesWH table
    %end
end
% legend('1','2','4','6','7','8','3 news','5 tamil','9 loud')
for subi=1:length(comps.C100)
    subFold=sf{1,subi};
    cd (['/home/yuval/Data/alice/',subFold])
    load files/tablesWH
    X(subi,1)=table(5,2);
    X(subi,2)=(table(4,4)+table(6,4))/2;
end
[~,p,~,stats] = ttest2(X(:,1),X(:,2))   

