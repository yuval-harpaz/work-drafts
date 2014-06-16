cd /home/yuval/Data/Izhar
fileName='NPX-Top-DP-10-2014-05-11-10-07-45-14-0001';
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
[CRAW_LF,~,~,Artifact]=correctLF(double(CRAW(15,:)),sRate,[],'FITSIZE',50,1,[],'samp',[]);
save chan15 CRAW_LF Artifact
figure;
h=plot(CRAW(15,1:44000),'r');
hold on
plot(CRAW_LF(1:44000),'g')
plot(Artifact(1:44000),'k')
saveas(h,'ch15.fig')
[CRAW_LF,~,~,Artifact]=correctLF(double(CRAW(16,:)),sRate,[],'FITSIZE',50,1,[],'samp',[]);
save chan16 CRAW_LF Artifact
figure;
h=plot(CRAW(16,1:44000),'r');
hold on
plot(CRAW_LF(1:44000),'g')
plot(Artifact(1:44000),'k')
saveas(h,'ch16.fig')
% %[CRAW_LF,~,~,Artifact]=correctLF(double(CRAW),sRate,[],'GLOBAL',50,1,[],[],true);
% figure('units','normalized','outerposition',[0 0 1 1])
% for chani=1:16
%     plot(time,CRAW(chani,:)-4000*(chani-1),'r');
%     if chani==1
%         hold on
%     end
%     plot(time,CRAW_LF(chani,:)-4000*(chani-1),'g');
% end
% set(gca,'ytick',[0 1000]);
% ylabel('Time (s)')
% save ([fileName,'-LF.mat'],'CRAW_LF')
data=CRAW(16,:);
clear CRAW*
fObj=fdesign.notch('N,F0,Q,Ap',6,50,10,1,sRate);%
    Filt=design(fObj ,'iir');
    dataNotch = myFilt(data,Filt);
[f,F]=fftBasic(double(data),44000);
f=abs(f);
fNotch=abs(fftBasic(double(dataNotch),44000));
plot(F,f,'r')
hold on
plot(F,fNotch)
