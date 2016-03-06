
cd /media/yuval/win_disk/Data/connectomeDB/MEG
load Subs
fn='c,rfDC';
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
    sRate=data.fsample;
    BL=[0.45 0.65];% or -0.5 to -0.3
    BLs=round(BL*data.fsample);
    %Rs=[-203 203];
    load HBtimes
    HBtimes=HBtimes(2:find(HBtimes>98,1));
    BLi=[];
    Ri=[];
    HB=zeros(1,4071);
    for HBi=2:length(HBtimes)
        beg=floor(HBtimes(HBi)*sRate-sRate);
        sto=ceil(HBtimes(HBi)*sRate+sRate);
        %BLi=[BLi,round(sRate*HBtimes(HBi)+BLs(1)):sto];
        %Ri=[Ri,beg:round(sRate*HBtimes(HBi)+Rs(2))];
        if HBi==1
            HB=mean(data.trial{1}(:,beg:sto));
        else
            HB=HB+mean(data.trial{1}(:,beg:sto));
        end
    end
    HB=HB./(HBi-1);
    HBall(subi,1:length(HB))=HB;
    disp(['XXXXXXXXXXX ',num2str(subi),' XXXXXXXXXXXXXX'])
end
cd /media/yuval/win_disk/Data/connectomeDB/MEG
[f4D,F4D]=fftBasic(HBall(:,1200:3235),sRate);

save HBlong HBall f4D
tfr=dftfr(HBall(:,1200:3254),sRate);
figure;imagesc(flipud(squeeze(mean(tfr,1))'));
% tfr=dftfr(mean(HBall(:,1200:3254)),sRate);
% figure;imagesc(flipud(squeeze(mean(tfr,1))'));

% clear
% cd /home/yuval/Data/OMEGA
% DIR=dir('MNI*');
% for subi=1:length(DIR)
%     cd /home/yuval/Data/OMEGA
%     sub=DIR(subi).name;
%     cd(sub)
%     load Rtopo
%     sign=Rtopo>0;
%     sign=2*(sign-0.5);
%     load ctf
%     sRate=ctf.setup.sample_rate;
%     data=[];
%     megi=ctf.sensor.index.meg;
%     for triali=1:100
%         data(1:length(megi),[(triali-1)*sRate+1:triali*sRate])=ctf.data{triali}(:,megi)';
%     end
%     clear ctf
%     BL=[0.45 0.65];% or -0.5 to -0.3
%     BLs=round(BL*sRate);
%     Rs=[-240 240];
%     load Ipeaks
%     Ipeaks=Ipeaks(Ipeaks<98*sRate);
%     BLi=[];
%     Ri=[];
%     for HBi=2:length(Ipeaks)
%         beg=round(Ipeaks(HBi)+Rs(1));
%         sto=round(Ipeaks(HBi)+BLs(2));
%         %BLi=[BLi,round(Ipeaks(HBi)+BLs(1)):sto];
%         %Ri=[Ri,beg:round(Ipeaks(HBi)+Rs(2))];
%         if HBi==1
%             HB=mean(HBdata.trial{1}(:,beg:sto));
%         else
%             HB=HB+mean(HBdata.trial{1}(:,beg:sto));
%         end
%     end
%     HB=HB./HBi;
%     HBall(subi,1:length(HB))=HB;
%     disp(['XXXXXXXXXXX ',num2str(subi),' XXXXXXXXXXXXXX'])
% end
% bl=length(HB)-406:length(HB);
% figure;plot(HBall','k');hold on;plot(HBall(:,1:406)','r');plot(bl,HBall(:,bl),'r');
% time=-0.1+(1/sRate:1/sRate:length(HBall)/sRate);
% cd /home/yuval/Data/OMEGA
% save HB100s HBall time
% plot(time,mean(HBall))
% 
% 
