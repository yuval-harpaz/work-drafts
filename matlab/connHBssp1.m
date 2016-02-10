%% make average HB for all subjects, saved as HB100s.mat

cd /media/yuval/win_disk/Data/connectomeDB/MEG
load Subs
fn='c,rfDC';
for subi=[1,3:10]
    cd /media/yuval/win_disk/Data/connectomeDB/MEG
    cd(num2str(Subs(subi)))
    cd unprocessed/MEG/3-Restin/4D/
    cfg=[];
    cfg.dataset=fn;
    cfg.demean='yes';
    cfg.bpfilter='yes';
    cfg.bpfreq=[1 40];
    cfg.channel={'MEG','-A2'};
    cfg.trl=[1,203450,0];
    data=ft_preprocessing(cfg);
    sRate=data.fsample;
    BL=[0.45 0.65];% or -0.5 to -0.3
    BLs=round(BL*data.fsample);
    Rs=[-203 203];
    load HBtimes
    HBtimes=HBtimes(2:find(HBtimes>98,1));
    BLi=[];
    Ri=[];
    for HBi=1:length(HBtimes)
        beg=round(sRate*HBtimes(HBi)+Rs(1));
        sto=round(sRate*HBtimes(HBi)+BLs(2));
        BLi=[BLi,round(sRate*HBtimes(HBi)+BLs(1)):sto];
        Ri=[Ri,beg:round(sRate*HBtimes(HBi)+Rs(2))];
        if HBi==1
            HB=mean(data.trial{1}(:,beg:sto));
        else
            HB=HB+mean(data.trial{1}(:,beg:sto));
        end
    end
    HB=HB./HBi;
    HBall(subi,1:length(HB))=HB;
    
%     
%     [A]=princomp(data.trial{1}(:,Ri)');
%     compg2=g2loop(A(:,1:40)'*data.trial{1},sRate);
%     compi=find(compg2>median(compg2)*5);
%     
%     if length(compi)>1
%         error('more than one comp')
%     end
%     clean=data.trial{1}-A(:,compi)*(A(:,compi)'*data.trial{1});
%     
%     
%     rrhb=corr(clean(:,Ri)');
%     rrhb(logical(eye(length(rrhb))))=nan;
%     rrhbBL=corr(clean(:,BLi)');
%     rrhbBL(logical(eye(length(rrhbBL))))=nan;
%     hpb=nanmean(rrhbBL);
%     hpr=nanmean(rrhb);
% %     if subi>8
% %         badi=find(isnan(hpr));
% %         rpr(badi)=nan;
% %         rpb(badi)=nan;
% %         ppr(badi)=nan;
% %         ppb(badi)=nan;
% %     end
%     posCorrSSP(1:2,subi)=[nanmean(hpr),nanmean(hpb)];
    disp(['XXXXXXXXXXX ',num2str(subi),' XXXXXXXXXXXXXX'])
end
bl=length(HB)-406:length(HB);
HBall(2,:)=[];
figure;plot(HBall','k');hold on;plot(HBall(:,1:406)','r');plot(bl,HBall(:,bl),'r');
% cd /media/yuval/win_disk/Data/connectomeDB/MEG
% save posCorrSSP posCorrSSP
% 
% posCorrSSP(:,2)=[];
% figure;
% plot(squeeze(mean(posCorr,3))','linewidth',2)
% hold on
% plot(mean(posCorrSSP,2)','k','linewidth',2)
% set(gca, 'xtick',[1,2])
% set(gca, 'xticklabel', {'-0.1 to 0.1s','0.45 to 0.65s'})
% xlabel ('time window relative to R peak')
% xlim([0.5 2.5])
% ylabel('averaged correlation for 247x247 channels (r)')
% legend('Raw Data','Template Removal','ICA')
% 
% hold on
% 
% [~,pICAbl]=ttest(posCorr(3,2,:),posCorr(1,2,:)); % nine of ten positive
% [~,pHBbl]=ttest(posCorr(2,2,:),posCorr(1,2,:)); % nine of ten negative
% [~,pR]=ttest(posCorr(3,1,:),posCorr(2,1,:)); 
% maxCor=squeeze(posCorr(1,1,:));
% corRat=[];
% for subi=1:9
%     corRat(:,:,subi)=posCorr(:,:,subi)./maxCor(subi);
% end
% 
% for i=1:3
%     for j=1:2
%         err(i,j)=std(corRat(i,j,:))./sqrt(9);
%     end
% end
% 
% figure;
% plot(squeeze(mean(corRat,3))','linewidth',2)
% set(gca, 'xtick',[1,2])
% set(gca, 'xticklabel', {'-0.1 to 0.1s','0.45 to 0.65s'})
% xlabel ('time window relative to R peak')
% xlim([0.5 2.5])
% ylabel('averaged correlation for 247x247 channels (r)')
% legend('Raw Data','Template Removal','ICA')
% 
% hold on
% X=1:2;
% for ind=1:3
%     Y=squeeze(mean(corRat(ind,:,:),3));
%     L=-err(ind,:);
%     U=err(ind,:);
%     errorbar(X,Y,L,U,'k')
% end