%% check ica issues

cd /media/yuval/win_disk/Data/connectomeDB/MEG
load Subs
fn='c,rfDC';
for subi=5:10
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
        BLi=[BLi,round(sRate*HBtimes(HBi)+BLs(1)):round(sRate*HBtimes(HBi)+BLs(2))];
        Ri=[Ri,round(sRate*HBtimes(HBi)+Rs(1)):round(sRate*HBtimes(HBi)+Rs(2))];
    end
    
    rr=corr(data.trial{1}(:,Ri)');
    rr(logical(eye(length(rr))))=nan;
    rrBL=corr(data.trial{1}(:,BLi)');
    rrBL(logical(eye(length(rrBL))))=nan;
    rpb=nanmean(rrBL);
    rpr=nanmean(rr);
    
    cfg.dataset=['hb5cat_',fn];
    datahb=ft_preprocessing(cfg);
    rrhb=corr(datahb.trial{1}(:,Ri)');
    rrhb(logical(eye(length(rrhb))))=nan;
    rrhbBL=corr(datahb.trial{1}(:,BLi)');
    rrhbBL(logical(eye(length(rrhbBL))))=nan;
    hpb=nanmean(rrhbBL);
    hpr=nanmean(rrhb);
    
    if exist('comp.mat','file')
        load comp
    else
        cfg=[];
        comp=ft_componentanalysis(cfg,data);
%         cfg=[];
%         cfg.layout='4D248.lay';
%         cfg.blocksize = 1;
%         ft_databrowser(cfg,comp)
        G2=g2loop(comp.trial{1}(1:40,1:20345),2034);
        compi=find(G2>median(G2)*5);
        save comp comp compi
    end
    cfg=[];
    cfg.component=compi;
    datapca=ft_rejectcomponent(cfg,comp,data);
    rrpca=corr(datapca.trial{1}(:,Ri)');
    rrpca(logical(eye(length(rrpca))))=nan;
    rrpcaBL=corr(datapca.trial{1}(:,BLi)');
    rrpcaBL(logical(eye(length(rrpcaBL))))=nan;
    ppb=nanmean(rrpcaBL);
    ppr=nanmean(rrpca);
    if subi>8
        badi=find(isnan(hpr));
        rpr(badi)=nan;
        rpb(badi)=nan;
        ppr(badi)=nan;
        ppb(badi)=nan;
    end
    posCorr(1:3,1:2,subi)=[nanmean(rpr),nanmean(rpb);nanmean(hpr),nanmean(hpb);nanmean(ppr),nanmean(ppb)];
end
cd /media/yuval/win_disk/Data/connectomeDB/MEG
save posCorr posCorr
posCorr(:,:,2)=[];
figure;
plot(squeeze(mean(posCorr,3))','linewidth',2)
set(gca, 'xtick',[1,2])
set(gca, 'xticklabel', {'-0.1 to 0.1s','0.45 to 0.65s'})
xlabel ('time window relative to R peak')
xlim([0.5 2.5])
ylabel('averaged correlation for 247x247 channels (r)')
legend('Raw Data','Template Removal','ICA')

hold on

[~,pICAbl]=ttest(posCorr(3,2,:),posCorr(1,2,:)); % nine of ten positive
[~,pHBbl]=ttest(posCorr(2,2,:),posCorr(1,2,:)); % nine of ten negative
[~,pR]=ttest(posCorr(3,1,:),posCorr(2,1,:)); 
maxCor=squeeze(posCorr(1,1,:));
corRat=[];
for subi=1:9
    corRat(:,:,subi)=posCorr(:,:,subi)./maxCor(subi);
end

for i=1:3
    for j=1:2
        err(i,j)=std(corRat(i,j,:))./sqrt(9);
    end
end

figure;
plot(squeeze(mean(corRat,3))','linewidth',2)
set(gca, 'xtick',[1,2])
set(gca, 'xticklabel', {'-0.1 to 0.1s','0.45 to 0.65s'})
xlabel ('time window relative to R peak')
xlim([0.5 2.5])
ylabel('averaged correlation for 247x247 channels (r)')
legend('Raw Data','Template Removal','ICA')

hold on
X=1:2;
for ind=1:3
    Y=squeeze(mean(corRat(ind,:,:),3));
    L=-err(ind,:);
    U=err(ind,:);
    errorbar(X,Y,L,U,'k')
end