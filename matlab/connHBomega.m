%% correlations
% load the ft structure, 
% cut it to 60sec or so
% filter etc
% read around the peak etc, compute r
% load ctf data and plant it in the ft structure and do the same
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
    datars=ft_resampledata([],data);
    meanMEG=sign'*datars.trial{1};
    if exist('./comp.mat','file')
        load comp
    else
        comp=ft_componentanalysis([],datars);
        
        
        %     %load comp
        compg2=g2loop(comp.trial{1}(1:40,:),comp.fsample./4);
        compi=find(compg2(1:40)>median(compg2)*4);
        
        
        rm=corr(meanMEG',comp.trial{1}(1:40,:)');
        rm(compi);
        [comprv,compri]=max(abs(rm));
        if abs(comprv)<0.3
            warning('low corr with meanMEG')
        end
        if sum(abs(rm)>0.4)>1 && sum(ismember(find(abs(rm)>0.4),compi))~=length(compi)
            warning('more comps with correlatios!')
        end
        if ~ismember(compri,compi)
            warning('max corr not with high g2')
        end
        save comp comp compi
    end
    cfg=[];
    cfg.component=compi;
    datapca2=ft_rejectcomponent(cfg,comp,data);
    cfg=[];
    cfg.hpfilter='yes';
    cfg.hpfreq=25;
    cfg.demean='yes';
    datapca2=ft_preprocessing(cfg,datapca2);
    data=ft_preprocessing(cfg,data);
    cleaned=ft_preprocessing(cfg,cleaned);
    cleaned=cleaned.trial{1};
%     cleaned=cleaned+datapca2.trial{1};
%     data=ft_preprocessing(cfg,data);
    sRate=data.fsample;
    load Ipeaks
    Ipeaks=Ipeaks(Ipeaks<98*sRate);
    %HBtimes=HBtimes(2:find(HBtimes>98,1));
    dataRev=data;
    for chi=1:length(sign)
        dataRev.trial{1}(chi,:)=data.trial{1}(chi,:).*sign(chi);
    end
    for chi=1:length(sign)
        cleaned(chi,:)=cleaned(chi,:).*sign(chi);
    end
    for chi=1:length(sign)
        datapca2.trial{1}(chi,:)=datapca2.trial{1}(chi,:).*sign(chi);
    end
    for wini=1:length(win0)
        S=[];
        for HBi=1:length(Ipeaks)
            beg=Ipeaks(HBi)+win0(wini)-step;
            sto=Ipeaks(HBi)+win0(wini)+step;
            S=[S,beg:sto];
        end
        
        rrhb=corr(dataRev.trial{1}(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrRaw(subi,wini)=nanmean(nanmean(rrhb));
        
        rrhb=corr(cleaned(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrHB(subi,wini)=nanmean(nanmean(rrhb));
        
        rrhb=corr(datapca2.trial{1}(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrICA1(subi,wini)=nanmean(nanmean(rrhb));
        if wini==1
            [A]=princomp(data.trial{1}(:,S)');
            compg2=g2loop(A(:,1:40)'*data.trial{1},sRate);
            compii=find(compg2>median(compg2)*5);
            if length(compii)>1
                warning('more than one comp')
                [~,compii]=max(compg2);
            end
            if length(compii)==0
                [~,compii]=max(compg2);
            end
            datassp=data;
            datassp.trial{1}=data.trial{1}-A(:,compii)*(A(:,compii)'*data.trial{1});
            %data.trial{1}(:,:)=dataclean;
            datassp=ft_preprocessing(cfg,data);
            for chi=1:length(sign)
                datassp.trial{1}(chi,:)=datassp.trial{1}(chi,:).*sign(chi);
            end
        end
        rrhb=corr(datassp.trial{1}(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrSSP(subi,wini)=nanmean(nanmean(rrhb)); 
    end
    Ncomp(subi)=length(compi);
    clear data* cleaned
    disp(['XXXXXXXXXXX ',num2str(subi),' XXXXXXXXXXXXXX'])
    clear compi compii
end
cd /home/yuval/Data/OMEGA
save posCorr posCorr* Ncomp

bars=[mean(posCorrSSP);mean(posCorrHB);mean(posCorrICA1);mean(posCorrRaw)];
figure;
% plot(time,HB./max(HB).*max(mean(posCorrRaw(1:8,1))),'r')
% hold on
bar(win0t,bars');
legend('SSP','Template','ICA','Raw')

%% make avgHB
cd /home/yuval/Data/OMEGA
DIR=dir('MNI*');
for subi=1:length(DIR)
    cd /home/yuval/Data/OMEGA
    sub=DIR(subi).name;
    cd(sub)
    load Rtopo
    sign=Rtopo>0;
    sign=2*(sign-0.5);
    load HBdata
    HBdata.trial{1}=[];
    HBdata.time{1}=HBdata.time{1}(:,1:HBdata.fsample*100);
    load ctf
    megi=ctf.sensor.index.meg;
    for triali=1:100
        HBdata.trial{1}(1:length(HBdata.label),[(triali-1)*HBdata.fsample+1:triali*HBdata.fsample])=ctf.data{triali}(:,megi)';
    end
    clear ctf
    sRate=HBdata.fsample;
    BL=[0.45 0.65];% or -0.5 to -0.3
    BLs=round(BL*HBdata.fsample);
    Rs=[-240 240];
    load Ipeaks
    Ipeaks=Ipeaks(Ipeaks<98*sRate);
    BLi=[];
    Ri=[];
    for HBi=1:length(Ipeaks)
        beg=round(Ipeaks(HBi)+Rs(1));
        sto=round(Ipeaks(HBi)+BLs(2));
        BLi=[BLi,round(Ipeaks(HBi)+BLs(1)):sto];
        Ri=[Ri,beg:round(Ipeaks(HBi)+Rs(2))];
        if HBi==1
            HB=mean(HBdata.trial{1}(:,beg:sto));
        else
            HB=HB+mean(HBdata.trial{1}(:,beg:sto));
        end
    end
    HB=HB./HBi;
    HBall(subi,1:length(HB))=HB;
    disp(['XXXXXXXXXXX ',num2str(subi),' XXXXXXXXXXXXXX'])
end
bl=length(HB)-406:length(HB);
figure;plot(HBall','k');hold on;plot(HBall(:,1:406)','r');plot(bl,HBall(:,bl),'r');
time=-0.1+(1/sRate:1/sRate:length(HBall)/sRate);
cd /home/yuval/Data/OMEGA
save HB100s HBall time
plot(time,mean(HBall))
% cd /media/yuval/win_disk/Data/connectomeDB/MEG