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
for subi=1:length(DIR)
    clear ctf Rtopo data
    cd /home/yuval/Data/OMEGA
    sub=DIR(subi).name;
    cd(sub)
    
sign=Rtopo>0;
sign=2*(sign-0.5);
for chi=1:length(sign)
    data(:,chi)=data(:,chi).*sign(chi);
end
rr=corr(data);
rr(logical(eye(270)))=nan;
r=nanmean(nanmean(rr)); % 0.08
clear data
load HBdata HBdata
for chi=1:length(sign)
    HBdata.trial{1}(chi,:)=HBdata.trial{1}(chi,:).*sign(chi);
end



end