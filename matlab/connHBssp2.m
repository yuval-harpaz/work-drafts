function connHBssp2

%% ssp+ica by time window

cd /media/yuval/win_disk/Data/connectomeDB/MEG
load Subs
fn='c,rfDC';
win0=round(2034.5*(0:0.1:0.6));
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
    cfg.dataset=['hb5cat_',fn];
    datahb=ft_preprocessing(cfg);
    load comp
    Ncomp(subi)=length(compi);
    cfg=[];
    cfg.component=compi;
    datapca2=ft_rejectcomponent(cfg,comp);
    cfg.component=compi(1);
    datapca1=ft_rejectcomponent(cfg,comp);
    %datapca2=data.trial{1}-comp.topo(:,compi)*comp.trial{1}(compi,:);
    sRate=data.fsample;
    BL=[0.45 0.65];% or -0.5 to -0.3
    BLs=round(BL*data.fsample);
    Rs=[-203 203];
    load HBtimes
    HBtimes=HBtimes(2:find(HBtimes>98,1));
    for wini=1:length(win0)
        S=[];
        for HBi=1:length(HBtimes)
            beg=round(sRate*HBtimes(HBi)+win0(wini)-102);
            sto=round(sRate*HBtimes(HBi)+win0(wini)+102);
            S=[S,beg:sto];
        end
        rrhb=corr(data.trial{1}(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrRaw(subi,wini)=nanmean(nanmean(rrhb));
        rrhb=corr(datahb.trial{1}(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrHB(subi,wini)=nanmean(nanmean(rrhb));
        if wini==1
            [A]=princomp(data.trial{1}(:,S)');
            compg2=g2loop(A(:,1:40)'*data.trial{1},sRate);
            compii=find(compg2>median(compg2)*5);
            if length(compii)>1
                error('more than one comp')
            end
            dataclean=data.trial{1}-A(:,compii)*(A(:,compii)'*data.trial{1});
        end
        
        rrhb=corr(dataclean(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrSSP(subi,wini)=nanmean(nanmean(rrhb));
        
        rrhb=corr(datapca2.trial{1}(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrICA2(subi,wini)=nanmean(nanmean(rrhb));
        
        rrhb=corr(datapca1.trial{1}(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrICA1(subi,wini)=nanmean(nanmean(rrhb));
        
    end
    clear data*
    disp(['XXXXXXXXXXX ',num2str(subi),' XXXXXXXXXXXXXX'])
end
Ncomp
cd /media/yuval/win_disk/Data/connectomeDB/MEG
save posCorr2 posCorr* Ncomp
posCorrHB(2,:)=[];
posCorrRaw(2,:)=[];
posCorrSSP(2,:)=[];
posCorrICA1(2,:)=[];
posCorrICA2(2,:)=[];
load HB100s
HB=mean(HBall);
HB=HB-HB(1);
time=-0.1:1/2034.5:0.65;
bars=[mean(posCorrSSP);mean(posCorrHB);mean(posCorrICA2);mean(posCorrRaw)];
figure;
plot(time,HB./max(HB).*max(mean(posCorrRaw(:,1))),'r')
hold on
bar(0:0.1:0.6,bars');

legend('timecourse','SSP','Template','ICA','Raw')

figure;
plot(time,HB./max(HB).*25,'r')
hold on
bars=100.*[mean(posCorrHB./posCorrRaw);mean(posCorrSSP./posCorrRaw);mean(posCorrICA2./posCorrRaw)]-100;
bar(0:0.1:0.6,bars')
legend('timecourse','SSP','Template','ICA')

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