

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
    
    % ns=mean(abs(wts),2);
    for triali=1:length(dataRejectIcaEye.trial)
        trials(1:6,triali)=mean(abs((wts(:,wtsi)*dataRejectIcaEye.trial{triali})),2);%./ns;
    end
    rr(1:6,1:6,subi)=corr(trials');
    ww(1:6,1:6,subi)=corr(wts(:,wtsi)');
    [~, ~, wts]=readWeights('SAM/alphaN.wts');
    % ns=mean(abs(wts),2);
    for triali=1:length(dataRejectIcaEye.trial)
        trials(1:6,triali)=mean(abs((wts(:,wtsi)*dataRejectIcaEye.trial{triali})),2);%./ns;
    end
    rrN(1:6,1:6,subi)=corr(trials');
    wwN(1:6,1:6,subi)=corr(wts(:,wtsi)');
    disp(['XXXXXXXXXXXXXXX ',sub,' XXXXXXXXXXXXXX'])
end
cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG/
save rrww rr* ww*

