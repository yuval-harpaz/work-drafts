cd /home/yuval/Data/OMEGA
DIR=dir('MNI*');
for subi=5:length(DIR)
    close all
    cd /home/yuval/Data/OMEGA
    sub=DIR(subi).name;
    cd(sub)
    if ~exist('hb2.fig','file')
        correctHB;
        saveas(1,'hb1.fig')
        saveas(2,'hb2.fig')
    end
    disp(['XXXXX ',num2str(subi),' XXXXX'])
    
end

%% Rtopo
% noise measurement
cd /home/yuval/Data/OMEGA/EmptyRoom/MNI0001_MEGs0003_noise_20130429_04.ds
load ctf
data=[];
for segi=1:60
    data=[data;ctf.data{segi}];
end
megi=ctf.sensor.index.meg;
data=data(:,megi);
rr=corr(data);
rr(logical(eye(270)))=nan;
rEmpty=nanmean(nanmean(rr)); % 0.0085
clear ctf data



Fp1=5;
Fst1=4;
ObjData=fdesign.bandpass(...
    'Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',...
    4,5,35,45,60,1,60,2400);
FiltData=design(ObjData ,'butter');

cd /home/yuval/Data/OMEGA
DIR=dir('MNI*');
for subi=1:length(DIR)
    clear ctf Rtopo data
    cd /home/yuval/Data/OMEGA
    sub=DIR(subi).name;
    cd(sub)
    if ~exist('./Rtopo.mat','file')
        load HBdata ECG
        ECG=ECG-median(ECG(1:240));
        ECG = myFilt(ECG,FiltData);
        figure;
        plot(ECG(1:24000));
        txt=input('upright?','s')
        if strcmp(txt,'n')
            ECG=-ECG;
        end
        [peaks,Ipeaks]=findPeaks(ECG,3,1500);
        figure;plot(ECG);hold on;plot(Ipeaks,peaks,'.r')
        title(sub(1:7))
        save Ipeaks Ipeaks
        clear ECG
        load ctf
        megi=ctf.sensor.index.meg;
        data=[];
        for segi=1:min(size(ctf.data,1),300)
            data=[data;ctf.data{segi}(:,megi)];
        end
        
        clear ctf
        avg=zeros(size(data,2),2400);
        count=0;
        for segi=2:(length(Ipeaks)-1)
            if (Ipeaks(segi)+1699)>size(data,1)
                break
            end
            count=count+1;
            avg=avg+data(Ipeaks(segi)-700:Ipeaks(segi)+1699,:)';
        end
        avg=avg./(length(Ipeaks)-2);
        avg=correctBL(avg,[1 240]);
        [~,maxi]=max(rms(avg(:,680:720)));
        if maxi==1 || maxi==41
            error('HB not near 700')
        end
        maxi=maxi+679;
        Rtopo=avg(:,maxi);
        save Rtopo Rtopo maxi
        
    end
    disp(['XXXXX ',num2str(subi),' XXXXX'])
end

%% correlations
% load the ft structure, 
% cut it to 60sec or so
% filter etc
% read around the peak etc, compute r
% load ctf data and plant it in the ft structure and do the same
cd /home/yuval/Data/OMEGA
DIR=dir('MNI*');
    win0t=0:0.1:0.6;
win0=round(2034.5*win0t);
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
    cleaned=cleaned.trial{1};
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
    comp=ft_componentanalysis([],datars);
    save comp comp
%     %load comp
    compg2=g2loop(comp.trial{1}(1:40,:),comp.fsample);
    compii=find(compg2(1:40)>median(compg2)*3);
    load Rtopo
    sign=Rtopo>0;
    sign=2*(sign-0.5);
    meanMEG=sign'*datars.trial{1};
    rm=corr(meanMEG',comp.trial{1}(1:40,:)');
%     [comprv,compri]=max(rm);
%     if abs(comprv)<0.4
%         error('low corr with meanMEG')
%     end
%     if sum(abs(rm)>0.4)>1 && sum(ismember(find(abs(rm)>0.4),compii))~=length(compii)
%         error('more comps with correlatios!')
%     end
%     if ~ismember(compri,compii)
%         error('max corr not with high g2')
%     end
%     cfg=[];
%     cfg.component=compii;
%     datapca2=ft_rejectcomponent(cfg,comp,data);
%     cfg=[];
%     cfg.hpfilter='yes';
%     cfg.hpfreq=25;
%     cfg.demean='yes';
%     datapca2=ft_preprocessing(cfg,datapca2);
%     cleaned=cleaned+datapca2.trial{1};
%     data=ft_preprocessing(cfg,data);
%     sRate=data.fsample;
    load Ipeaks
    Ipeaks=Ipeaks(Ipeaks<98*sRate);
    %HBtimes=HBtimes(2:find(HBtimes>98,1));
    for wini=1:length(win0)
        S=[];
        for HBi=1:length(HBtimes)
            beg=Ipeaks(HBi)+win0(wini)-step;
            sto=Ipeaks(HBi)+win0(wini)+step;
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