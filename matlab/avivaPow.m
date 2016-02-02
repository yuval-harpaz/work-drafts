function [pow,powN]=avivaPow(wtsFN)
% compute power using a specific .wts file, wtsFN='alpha';

cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG/
load subCoor
load goodSubs
load ~/ft_BIU/matlab/plotwts
label=wts.label;
clear wts
count=0;
disp('')
disp('  Subjects:    ')
for subi=find(goodSubs)
    trials=[];
    cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG/
    sub=subCoor{subi,1};
    cd(sub);
    cd 1
    load dataRejectIcaEye.mat
    [~,wtsi]=ismember(dataRejectIcaEye.label,label);
    [~, ~, wts]=readWeights(['SAM/',wtsFN,'.wts']);
    ns=mean(abs(wts),2);
    for triali=1:length(dataRejectIcaEye.trial)
        trials(1:6,triali)=mean(abs((wts(:,wtsi)*dataRejectIcaEye.trial{triali})),2)./ns;
    end
    pow(1:6,subi)=mean(trials,2);
    
    [~, ~, wts]=readWeights(['SAM/',wtsFN,'N.wts']);
    ns=mean(abs(wts),2);
    for triali=1:length(dataRejectIcaEye.trial)
        trials(1:6,triali)=mean(abs((wts(:,wtsi)*dataRejectIcaEye.trial{triali})),2)./ns;
    end
    powN(1:6,subi)=mean(trials,2);
    count=count+1;
    prog(count)
end
cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG/
save(['pow_',wtsFN],'pow*')


conti=1:12;
medi=[13:20,22:26];
[~,TT]=ttest2(pow(:,conti)',pow(:,medi)');
disp('');
p=min(TT)

[~,TT]=ttest2(powN(:,conti)',powN(:,medi)');
pN=min(TT)



