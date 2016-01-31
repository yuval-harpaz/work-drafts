% coherence

cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG/
load subCoor
load goodSubs
load ~/ft_BIU/matlab/plotwts
label=wts.label;
clear wts
first =true;
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
    coh=zeros(6);
    for triali=1:length(dataRejectIcaEye.trial)
        trial=wts(:,wtsi)*dataRejectIcaEye.trial{triali};
        for i=1:6
            j=6;
            while j>i
                [Cxy,F] = mscohere(trial(i,:),trial(j,:),[],[],size(trial,2),dataRejectIcaEye.fsample);
                coh(i,j)=coh(i,j)+max(Cxy(10:13)); % 9 to 12Hz
                j=j-1;
            end
        end
    end
    Coh(1:6,1:6,subi)=coh/triali;
    
    [~, ~, wts]=readWeights('SAM/alphaN.wts');
    % ns=mean(abs(wts),2);
    coh=zeros(6);
    for triali=1:length(dataRejectIcaEye.trial)
        trial=wts(:,wtsi)*dataRejectIcaEye.trial{triali};
        for i=1:6
            j=6;
            while j>i
                [Cxy,F] = mscohere(trial(i,:),trial(j,:),[],[],size(trial,2),dataRejectIcaEye.fsample);
                coh(i,j)=coh(i,j)+max(Cxy(10:13)); % 9 to 12Hz
                j=j-1;
            end
        end
        prog(triali);
    end
    CohN(1:6,1:6,subi)=coh/triali;
    
    disp(['XXXXXXXXXXXXXXX ',sub,' XXXXXXXXXXXXXX'])
end
cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG/
save coh Coh*

figure;imagesc(median(rr-ww,3));colorbar
figure;imagesc(median(rrN-wwN,3));colorbar

TT=ones(6);
conti=1:12;
medi=[13:20,22:26];
for i=1:6
    for j=1:6
        if i~=j
            [~,TT(i,j)]=ttest2(rr(i,j,conti)-ww(i,j,conti),rr(i,j,medi)-ww(i,j,medi));
        end
    end
end
min(min(TT))
figure;imagesc(1-TT,[0 1]);colorbar

TT=ones(6);
conti=1:12;
medi=[13:20,22:26];
for i=1:6
    for j=1:6
        if i~=j
            [~,TT(i,j)]=ttest2(rrN(i,j,conti)-wwN(i,j,conti),rrN(i,j,medi)-wwN(i,j,medi));
        end
    end
end
min(min(TT))
figure;imagesc(1-TT,[0 1]);colorbar

