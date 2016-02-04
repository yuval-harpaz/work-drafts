%% check ica issues
cd /media/yuval/win_disk/Data/connectomeDB/MEG
load Subs
fn='c,rfDC';
cd /media/yuval/win_disk/Data/connectomeDB/MEG/133019/unprocessed/MEG/3-Restin/4D


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



cfg.dataset=['hb_',fn];
datahb=ft_preprocessing(cfg);
rrhb=corr(datahb.trial{1}(:,Ri)');
rrhb(logical(eye(length(rrhb))))=nan;
rrhbBL=corr(datahb.trial{1}(:,BLi)');
rrhbBL(logical(eye(length(rrhbBL))))=nan;
hpb=nanmean(rrhbBL);
hpr=nanmean(rrhb);


load comp
cfg=[];
cfg.component=compi;
datapca=ft_rejectcomponent(cfg,comp,data);
rrpca=corr(datapca.trial{1}(:,Ri)');
rrpca(logical(eye(length(rrpca))))=nan;
rrpcaBL=corr(datapca.trial{1}(:,BLi)');
rrpcaBL(logical(eye(length(rrpcaBL))))=nan;
ppb=nanmean(rrpcaBL);
ppr=nanmean(rrpca);

posCorr(1:3,1:2,subi)=[mean(rpr),mean(rpb);mean(hpr),mean(hpb);mean(ppr),mean(ppb)];

%%
r=rr(:);
nani=isnan(r);
r(nani)=[];


cfg.dataset=['hb_',fn];
datahb=ft_preprocessing(cfg);
rrhb=corr(datahb.trial{1}');
clear datahb

rr(logical(eye(length(rr))))=nan;
r=rr(:);
nani=isnan(r);
r(nani)=[];

rrhb(logical(eye(length(rrhb))))=nan;
rhb=rrhb(:);
rhb(nani)=[];

figure;
scatter(abs(r),abs(rhb),'.')
lims=[0 1];
xlim(lims)
ylim(lims)
hold on
line(lims,lims,'color','k')
xlabel('r raw data')
ylabel('r 5cat data')
load comp
cfg=[];
cfg.component=compi;
datapca=ft_rejectcomponent(cfg,comp,data);
clear data
clear comp
rrpca=corr(datapca.trial{1}');
clear datapca
rrpca(logical(eye(length(rr))))=nan;
rpca=rrpca(:);
rpca(nani)=[];

figure;
scatter(abs(r),abs(rpca),'.')
lims=[0 1];
xlim(lims)
ylim(lims)
hold on
line(lims,lims,'color','k')
xlabel('r raw data')
ylabel('r pca data')

rdif=abs(rr)-abs(rrhb);
topo=[];
topo([1,3:248],1)=nanmin(rdif);
%topo=nanmax(abs(rr));
topo(2)=(topo(46)+topo(186))./2;
figure;topoplot248(-topo)

Rtopo=nanmean(rr);
color=[];
for i=1:247
    for j=1:247
        color(i,j)=abs(Rtopo(i))+abs(Rtopo(j));
    end
end
color(logical(eye(247)))=nan;
color=color(:);
color(nani)=[];
color=color./max(color);

figure;
scatter(abs(r),abs(rhb),25,color,'.')
lims=[0 1];
xlim(lims)
ylim(lims)
hold on
line(lims,lims,'color','k')
xlabel('r raw data')
ylabel('r HB')

figure;
scatter(abs(r),abs(rpca),25,color,'.')
lims=[0 1];
xlim(lims)
ylim(lims)
hold on
line(lims,lims,'color','k')
xlabel('r raw data')
ylabel('r HB')

%% positive vs negative corr
rpp=nanmean(rrpca);
rph=nanmean(rrhb);
rpr=nanmean(rr);
[mean(rpr),mean(rpp),mean(rph)]

cfg=[];
cfg.hpfilter='yes';
cfg.hpfreq=21;
cfg.demean='yes';
pcahf=ft_preprocessing(cfg,datapca);
hbhf=ft_preprocessing(cfg,datahb);


rrhbhf=corr(hbhf.trial{1}');
rrpcahf=corr(pcahf.trial{1}');
clear data*

rrhbhf(logical(eye(length(rrhbhf))))=nan;
rhbhf=rrhbhf(:);
nani=isnan(rhbhf);
rhbhf(nani)=[];

rrpcahf(logical(eye(length(rrpcahf))))=nan;
rpcahf=rrpcahf(:);
nani=isnan(rpcahf);
rpcahf(nani)=[];

rpp=nanmean(rrpcahf);
rph=nanmean(rrhbhf);
[mean(rpp),mean(rph)]

figure;
scatter(abs(r),abs(rpcahf),25,color,'.')
lims=[0 1];
xlim(lims)
ylim(lims)
hold on
line(lims,lims,'color','k')
xlabel('r raw data')
ylabel('r PCA')

figure;
scatter(abs(r),abs(rhbhf),25,color,'.')
lims=[0 1];
xlim(lims)
ylim(lims)
hold on
line(lims,lims,'color','k')
xlabel('r raw data')
ylabel('r HB')
