function connHBomega1

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
    cfg=[];
    cfg.demean='yes';
    cfg.bpfilter='yes';
    cfg.bpfreq=[1 70];
    %cfg.channel={'MEG','-A2'};
    %cfg.trl=[1,203450,0];
    cleaned=ft_preprocessing(cfg,HBdata);
    %cleaned=HBdata;
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
    data=ft_preprocessing(cfg,data);
%     datars=ft_resampledata([],data);
%     meanMEG=sign'*datars.trial{1};
%     if exist('./comp.mat','file')
        load comp
%     else
%         comp=ft_componentanalysis([],datars);
%         
%         
%         %     %load comp
%         compg2=g2loop(comp.trial{1}(1:40,:),comp.fsample./4);
%         compi=find(compg2(1:40)>median(compg2)*4);
%         
%         
%         rm=corr(meanMEG',comp.trial{1}(1:40,:)');
%         rm(compi);
%         [comprv,compri]=max(abs(rm));
%         if abs(comprv)<0.3
%             warning('low corr with meanMEG')
%         end
%         if sum(abs(rm)>0.4)>1 && sum(ismember(find(abs(rm)>0.4),compi))~=length(compi)
%             warning('more comps with correlatios!')
%         end
%         if ~ismember(compri,compi)
%             warning('max corr not with high g2')
%         end
%         save comp comp compi
%     end
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
    %cleaned=cleaned.trial{1};
%     cleaned=cleaned+datapca2.trial{1};
%     data=ft_preprocessing(cfg,data);
    sRate=data.fsample;
    load Ipeaks
    Ipeaks=Ipeaks(Ipeaks<98*sRate);
    %HBtimes=HBtimes(2:find(HBtimes>98,1));
    dataRev=ft_preprocessing(cfg,data);
    for chi=1:length(sign)
        dataRev.trial{1}(chi,:)=data.trial{1}(chi,:).*sign(chi);
    end
    for chi=1:length(sign)
        cleaned.trial{1}(chi,:)=cleaned.trial{1}(chi,:).*sign(chi);
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
        
        rrhb=corr(cleaned.trial{1}(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrHB(subi,wini)=nanmean(nanmean(rrhb));
        
        rrhb=corr(datapca2.trial{1}(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrICA1(subi,wini)=nanmean(nanmean(rrhb));
        if wini==1
            [A]=princomp(data.trial{1}(:,S)');
            compg2=g2loop(A(:,1:40)'*data.trial{1},sRate./4);
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
            datassp=ft_preprocessing(cfg,datassp);
            for chi=1:length(sign)
                datassp.trial{1}(chi,:)=datassp.trial{1}(chi,:).*sign(chi);
            end
        end
        rrhb=corr(datassp.trial{1}(:,S)');
        rrhb(logical(eye(length(rrhb))))=nan;
        posCorrSSP(subi,wini)=nanmean(nanmean(rrhb));
    end
    clear data* cleaned
    disp(['XXXXXXXXXXX ',num2str(subi),' XXXXXXXXXXXXXX'])
    clear compi compii
end
cd /home/yuval/Data/OMEGA
save posCorr1 posCorr*

bars=[mean(posCorrSSP);mean(posCorrHB);mean(posCorrICA1);mean(posCorrRaw)];
figure;
% plot(time,HB./max(HB).*max(mean(posCorrRaw(1:8,1))),'r')
% hold on
bar(win0t,bars');
legend('SSP','Template','ICA','Raw')

