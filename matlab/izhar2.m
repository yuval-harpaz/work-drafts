function CRAW_LF=izhar2(fileName)
cd /home/yuval/Data/Izhar
%fileName='NPX-Top-DP-10-2014-05-11-09-45-34-3-0001'; 'NPX-Top-DP-10-2014-05-11-10-07-45-14-0001' 'NPX-Top-DP-10-2014-05-13-14-26-44-4-0001' 'NPX-Top-DP-9-2014-05-07-11-17-36-6-0001'
if strcmp(fileName(end-3:end),'.mat')
    fileName=fileName(1:end-4);
end
sRate=44000;
% if ~exist([fileName,'-LF.mat'],'file')
for ii=1:9
    CRAW_x=load (fileName,['CRAW_00',num2str(ii)]);
    if ii==1
        eval(['CRAW=CRAW_x.CRAW_00',num2str(ii),';']);
    else
        eval(['CRAW(ii,:)=CRAW_x.CRAW_00',num2str(ii),';']);
    end
end
for ii=10:16
    CRAW_x=load (fileName,['CRAW_0',num2str(ii)]);
    eval(['CRAW(ii,:)=CRAW_x.CRAW_0',num2str(ii),';']);
end

time=1/sRate:1/sRate:(length(CRAW)/sRate);
[CRAW_LF,~,~,Artifact]=correctLF(double(CRAW),sRate,[],'GLOBAL',50,1,[],[],true);
figure('units','normalized','outerposition',[0 0 1 1])
for chani=1:16
    plot(time,CRAW(chani,:)-4000*(chani-1),'r');
    if chani==1
        hold on
    end
    plot(time,CRAW_LF(chani,:)-4000*(chani-1),'g');
end
set(gca,'ytick',[0 1000]);
ylabel('Time (s)')
% save ([fileName,'-LF.mat'],'CRAW_LF')
% else
%     warning ('cleaned file exists')
%     load ([fileName,'-LF.mat'])
%     [fcl,F]=fftBasic(double(CRAW_LF),sRate);
%     figure;
%     plot(F(1:110),mean(abs(fcl(:,1:110))),'g')
%     xlabel ('Hz')
%     ylabel('PSD')
%     title ('mean PSD for 16 channels')
% end