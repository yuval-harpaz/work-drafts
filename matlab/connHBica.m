

%% got to run ICA 10 times on resampled data and average them
% averaging 10 ICA runs did not reduce much the artifact added
clear
cd /media/yuval/win_disk/Data/connectomeDB/MEG
load Subs
fn='c,rfDC';
win0t=0:0.1:0.6;
win0=round(2034.5*win0t);
step=ceil((win0(2)-win0(1))./2);

for subi=3:10
    cd /media/yuval/win_disk/Data/connectomeDB/MEG
    cd(num2str(Subs(subi)))
    cd unprocessed/MEG/3-Restin/4D/
    cfg=[];
    cfg.dataset=fn;
    cfg.demean='yes';
    cfg.bpfilter='yes';
    cfg.bpfreq=[1 70];
    cfg.channel={'MEG','-A2'};
    cfg.trl=[1,203450,0];
    data=ft_preprocessing(cfg);
    datars=ft_resampledata([],data);
    meanMEG=mean(datars.trial{1})';
    cleaned=zeros(size(data.trial{1}));
    for runi=1:10
        comp=ft_componentanalysis([],datars);
        %load comp
        compg2=g2loop(comp.trial{1}(1:40,:),comp.fsample);
        compii=find(compg2(1:40)>median(compg2)*5);
        rm=corr(meanMEG,comp.trial{1}(1:40,:)');
        [comprv,compri]=max(rm);
        if abs(comprv)<0.4
            error('low corr with meanMEG')
        end
        if sum(abs(rm)>0.4)>1 && sum(ismember(find(abs(rm)>0.4),compii))~=length(compii)
            error('more comps with correlatios!')
        end
        if ~ismember(compri,compii)
            error('max corr not with high g2')
        end
        cfg=[];
        cfg.component=compii;
        datapca2=ft_rejectcomponent(cfg,comp,data);
        cfg=[];
        cfg.hpfilter='yes';
        cfg.hpfreq=25;
        cfg.demean='yes';
        datapca2=ft_preprocessing(cfg,datapca2);
        cleaned=cleaned+datapca2.trial{1};
    end
    data=ft_preprocessing(cfg,data);
    sRate=data.fsample;
    load HBtimes
    HBtimes=HBtimes(2:find(HBtimes>98,1));
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
        rrhb=corr(cleaned(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrICA10(subi,wini)=nanmean(nanmean(rrhb));
        rrhb=corr(datapca2.trial{1}(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrICA1(subi,wini)=nanmean(nanmean(rrhb));
    end
    clear data*
    disp(['XXXXXXXXXXX ',num2str(subi),' XXXXXXXXXXXXXX'])
end
cd /media/yuval/win_disk/Data/connectomeDB/MEG
save posCorrICA10 posCorr*
posCorrRaw(2,:)=[];
posCorrICA10(2,:)=[];
posCorrICA1(2,:)=[];
load HB100s
HB=mean(HBall);
HB=HB-HB(1);
time=-0.1:1/2034.5:0.65;

bars=[mean(posCorrICA1);mean(posCorrICA10);mean(posCorrRaw)];
figure;
plot(time,HB./max(HB).*max(mean(posCorrRaw(:,1))),'r')
hold on
bar(win0t,bars');
legend('timecourse','ICA1','ICA10','Raw')


[~,p]=ttest(mean(posCorrRaw(:,3:end)'),mean(posCorrICA1(:,3:end)'))
