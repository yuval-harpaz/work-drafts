% Power

cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG/
load subCoor
load goodSubs
load ~/ft_BIU/matlab/plotwts
label=wts.label;
clear wts
for subi=find(goodSubs)
    trials=[];
    cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG/
    sub=subCoor{subi,1};
    cd(sub);
    cd 1
    load dataRejectIcaEye.mat
    [~,wtsi]=ismember(dataRejectIcaEye.label,label);
    [~, ~, wts]=readWeights('SAM/alpha.wts');
    ns=mean(abs(wts),2);
    for triali=1:length(dataRejectIcaEye.trial)
        trials(1:6,triali)=mean(abs((wts(:,wtsi)*dataRejectIcaEye.trial{triali})),2)./ns;
    end
    pow(1:6,subi)=mean(trials,2);
    
    [~, ~, wts]=readWeights('SAM/alphaN.wts');
    ns=mean(abs(wts),2);
    for triali=1:length(dataRejectIcaEye.trial)
        trials(1:6,triali)=mean(abs((wts(:,wtsi)*dataRejectIcaEye.trial{triali})),2)./ns;
    end
    powN(1:6,subi)=mean(trials,2);
    
    disp(['XXXXXXXXXXXXXXX ',sub,' XXXXXXXXXXXXXX'])
end
cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG/
save pow pow*


conti=1:12;
medi=[13:20,22:26];
[~,TT]=ttest2(pow(:,conti)',pow(:,medi)')
min(TT)

[~,TT]=ttest2(powN(:,conti)',powN(:,medi)')
min(TT)
figure;


