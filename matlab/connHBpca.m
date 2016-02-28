clear

%% ssp+ica by time window
% SSP is okay, not so much for the last subject

cd /media/yuval/win_disk/Data/connectomeDB/MEG
load Subs
fn='c,rfDC';
win0t=0:0.1:0.6;
win0=round(2034.5*win0t);
step=ceil((win0(2)-win0(1))./2);

for subi=[1,3:10]
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
    %     cfg.dataset=['hb5cat_',fn];
    %     datahb=ft_preprocessing(cfg);
    %     load comp
    %     Ncomp(subi)=length(compi);
    cfg=[];
    cfg.method='pca';
    comp=ft_componentanalysis(cfg,data);
    compg2=g2loop(comp.trial{1}(1:40,:),round(comp.fsample/4));
    [~,compi]=max(compg2);
    cfg=[];
    cfg.component=compi;
    datapca2=ft_rejectcomponent(cfg,comp);
    
    % %     cfg.component=compi(1);
    % %     datapca1=ft_rejectcomponent(cfg,comp);
    cfg=[];
    cfg.hpfilter='yes';
    cfg.hpfreq=25;
    cfg.demean='yes';
    datapca2=ft_preprocessing(cfg,datapca2);
    
    load Rtopo
    Rtopo(2)=[]; % remove A2
    
    cfg = [];
    cfg.unmixing=pinv(Rtopo);
    cfg.topolabel = data.label;
    comp     = ft_componentanalysis(cfg, data);
    % same as tc=Rtopo'*data.trial{1};
    cfg=[];
    cfg.component=1;
    datapca1=ft_rejectcomponent(cfg,comp,data);
    cfg=[];
    cfg.hpfilter='yes';
    cfg.hpfreq=25;
    cfg.demean='yes';
    datapca1=ft_preprocessing(cfg,datapca1);
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
            beg=round(sRate*HBtimes(HBi)+win0(wini)-step);
            sto=round(sRate*HBtimes(HBi)+win0(wini)+step);
            S=[S,beg:sto];
        end
        rrhb=corr(datapca2.trial{1}(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrPCAcont(subi,wini)=nanmean(nanmean(rrhb));
        rrhb=corr(datapca1.trial{1}(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrTopo(subi,wini)=nanmean(nanmean(rrhb));
        %         rrhb=corr(datapca1.trial{1}(:,S)');
        %         rrhb(logical(eye(length(rrhb))))=nan;
        %         posCorrICA1(subi,wini)=nanmean(nanmean(rrhb));
        
    end
    clear data*
    disp(['XXXXXXXXXXX ',num2str(subi),' XXXXXXXXXXXXXX'])
end
cd /media/yuval/win_disk/Data/connectomeDB/MEG
save posCorrPCA posCorr*
load posCorr70
posCorrHB(2,:)=[];
posCorrRaw(2,:)=[];
posCorrSSP(2,:)=[];
posCorrICA2(2,:)=[];
posCorrPCAcont(2,:)=[];
posCorrTopo(2,:)=[];
load HB100s
HB=mean(HBall);
HB=HB-HB(1);
time=-0.1:1/2034.5:0.65;

bars=[mean(posCorrSSP);mean(posCorrHB);mean(posCorrICA2);mean(posCorrRaw);mean(posCorrTopo);mean(posCorrPCAcont)];
figure;
plot(time,HB./max(HB).*max(mean(posCorrRaw(:,1))),'r')
hold on
bar(win0t,bars');
legend('timecourse','SSP','Template','ICA','Raw','topo','PCA')

%% omega 
clear
cd /home/yuval/Data/OMEGA
DIR=dir('MNI*');
win0t=0:0.1:0.6;
win0=round(2400*win0t);
step=ceil((win0(2)-win0(1))./2);
for subi=1:length(DIR)
    clear ctf Rtopo data
    cd /home/yuval/Data/OMEGA
    sub=DIR(subi).name;
    cd(sub)
    load Rtopo
    sign=Rtopo>0;
    sign=2*(sign-0.5);
    load HBdata
    HBdata.trial{1}=HBdata.trial{1}(:,1:HBdata.fsample*100);
    HBdata.time{1}=HBdata.time{1}(:,1:HBdata.fsample*100);
%     cfg=[];
%     cfg.demean='yes';
%     cfg.bpfilter='yes';
%     cfg.bpfreq=[1 70];
    %cfg.channel={'MEG','-A2'};
    %cfg.trl=[1,203450,0];
    cleaned=HBdata;
    load HBdata
    HBdata.trial{1}=[];
    data=HBdata;
    clear HBdata
    load ctf
    megi=ctf.sensor.index.meg;
    for triali=1:100
        data.trial{1}(1:length(data.label),[(triali-1)*data.fsample+1:triali*data.fsample])=ctf.data{triali}(:,megi)';
    end
    clear ctf
    data.time{1}=data.time{1}(1:data.fsample*100);

%     cfg=[];
%     cfg.method='pca';
%     comp=ft_componentanalysis(cfg,data);
%     compg2=g2loop(comp.trial{1}(1:40,:),round(comp.fsample/4));
%     This approach failed, PCA cannot reliably seperate the HB for ctf

        
        
        
    load Rtopo
    
    cfg = [];
    cfg.unmixing=pinv(Rtopo);
    cfg.topolabel = data.label;
    comp     = ft_componentanalysis(cfg, data);
    % same as tc=Rtopo'*data.trial{1};
    cfg=[];
    cfg.component=1;
    datapca1=ft_rejectcomponent(cfg,comp,data);
    cfg=[];
    cfg.hpfilter='yes';
    cfg.hpfreq=25;
    cfg.demean='yes';
    datapca1=ft_preprocessing(cfg,datapca1);
    
    
    %datapca2=data.trial{1}-comp.topo(:,compi)*comp.trial{1}(compi,:);
    sRate=data.fsample;
    load Ipeaks
    Ipeaks=Ipeaks(Ipeaks<98*sRate);
    %HBtimes=HBtimes(2:find(HBtimes>98,1));
    for chi=1:length(sign)
        datapca1.trial{1}(chi,:)=datapca1.trial{1}(chi,:).*sign(chi);
    end
    for wini=1:length(win0)
        S=[];
        for HBi=1:length(Ipeaks)
            beg=Ipeaks(HBi)+win0(wini)-step;
            sto=Ipeaks(HBi)+win0(wini)+step;
            S=[S,beg:sto];
        end
        rrhb=corr(datapca1.trial{1}(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrTopo(subi,wini)=nanmean(nanmean(rrhb));
    end
    Ncomp(subi)=length(compi);
    clear data*
    disp(['XXXXXXXXXXX ',num2str(subi),' XXXXXXXXXXXXXX'])
    clear compi compii
end
cd /home/yuval/Data/OMEGA
save posCorrTopo posCorrTopo

bars=[mean(posCorrSSP);mean(posCorrHB);mean(posCorrICA1);mean(posCorrRaw)];
figure;
% plot(time,HB./max(HB).*max(mean(posCorrRaw(1:8,1))),'r')
% hold on
bar(win0t,bars');
legend('SSP','Template','ICA','Raw')

