clear

%% ssp+ica by time window
% SSP is okay, not so much for the last subject


win0t=0:0.1:0.6;
win0=round(2034.5*win0t);
step=ceil((win0(2)-win0(1))./2);

cd /media/yuval/win_disk/Data/connectomeDB/MEG/917255/unprocessed/MEG/3-Restin/4D

cfg=[];
cfg.dataset='917255_raw.fif';
cfg.demean='yes';
cfg.bpfilter='yes';
cfg.bpfreq=[25 70];
cfg.channel={'MEG','-A2'};
cfg.trl=[1,203450,0];
data=ft_preprocessing(cfg);
cfg.dataset='917255_proj_raw.fif';
dataProj=ft_preprocessing(cfg);
sRate=data.fsample;
BL=[0.45 0.65];% or -0.5 to -0.3
BLs=round(BL*data.fsample);
Rs=[-203 203];
load HBtimes
HBtimes=HBtimes(2:find(HBtimes>98,1));
subi=1;

for wini=1:length(win0)
    S=[];
    for HBi=1:length(HBtimes)
        beg=round(sRate*HBtimes(HBi)+win0(wini)-step);
        sto=round(sRate*HBtimes(HBi)+win0(wini)+step);
        S=[S,beg:sto];
    end
    rrhb=corr(data.trial{1}(:,S)');
    rrhb(logical(eye(length(rrhb))))=nan;
    posCorrRaw(subi,wini)=nanmean(nanmean(rrhb));
    rrhb=corr(dataProj.trial{1}(:,S)');
    rrhb(logical(eye(length(rrhb))))=nan;
    posCorrProj(subi,wini)=nanmean(nanmean(rrhb));
    %         rrhb=corr(datapca1.trial{1}(:,S)');
        %         rrhb(logical(eye(length(rrhb))))=nan;
        %         posCorrICA1(subi,wini)=nanmean(nanmean(rrhb));
        
end
save posCorrMNE posCorr* 