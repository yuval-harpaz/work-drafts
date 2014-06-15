cd ('/media/My Passport/IBG data')
% for ii=1:9
%     CRAW_x=load ('NPX-Top-DP-9-2014-05-07-11-17-36-6-0001',['CRAW_00',num2str(ii)]);
%     if ii==1
%         eval(['CRAW=CRAW_x.CRAW_00',num2str(ii),';']);
%     else
%         eval(['CRAW(ii,:)=CRAW_x.CRAW_00',num2str(ii),';']);
%     end
% end
% for ii=10:16
%     CRAW_x=load ('NPX-Top-DP-9-2014-05-07-11-17-36-6-0001',['CRAW_0',num2str(ii)]);
%     eval(['CRAW(ii,:)=CRAW_x.CRAW_0',num2str(ii),';']);
% end
load data
sRate=44000;
time=1/sRate:1/sRate:(length(CRAW)/sRate);
%CRAW_T=correctLF(double(CRAW),sRate,'time','GLOBAL',50);
%CRAW_Z=correctLF(double(CRAW),sRate,[],'GLOBAL',50);
% figure;
% plot(time,CRAW,'r');
% hold on
% plot(time,CRAW_T,'b');
% plot(time,CRAW_Z,'g');
figure;
plot(time(1:44000),CRAW(:,1:44000)','k');
hold on
%plot(time(1:44000),CRAW(1,1:44000)','b');
plot(time(1:44000),CRAW(16,1:44000)','r');

figure;
plot(time(1:44000),CRAW(16,1:44000)','r');
hold on
plot(time(1:44000),CRAW_Z(16,1:44000)','g');
%plot(time(1:44000),CRAW_T(16,1:44000)','b');
title('first second chan 16')
xlabel('time(s)')

figure;
plot(time(1:44000),CRAW(7,1:44000)','r');
hold on
plot(time(1:44000),CRAW_Z(7,1:44000)','g');
title('first second chan 7')
xlabel('time(s)')

[f,F]=fftBasic(double(CRAW),sRate);
fcl=fftBasic(double(CRAW_Z),sRate);
figure;
plot(F(1:110),mean(abs(f(:,1:110))),'r')
hold on
plot(F(1:110),mean(abs(fcl(:,1:110))),'g')
xlabel ('Hz')
ylabel('PSD')
title ('mean PSD for 16 channels')
