cd /home/yuval/Data/Izhar
fileName='NPX-Top-DP-10-2014-05-11-10-07-45-14-0001';
%fileName='NPX-Top-DP-10-2014-05-11-09-45-34-3-0001'; 'NPX-Top-DP-10-2014-05-11-10-07-45-14-0001' 'NPX-Top-DP-10-2014-05-13-14-26-44-4-0001' 'NPX-Top-DP-9-2014-05-07-11-17-36-6-0001'
if strcmp(fileName(end-3:end),'.mat')
    fileName=fileName(1:end-4);
end
load('chan16.mat')
data=load ('NPX-Top-DP-10-2014-05-11-10-07-45-14-0001.mat','CRAW_016');
data=data.CRAW_016;
sRate=44000;
load('chan16.mat')
time=1/sRate:1/sRate:(length(CRAW_LF)/sRate);
dataNotch=data;
for fi=50:50:300
    fObj=fdesign.notch('N,F0,Q,Ap',6,fi,10,1,sRate);%
    Filt=design(fObj ,'iir');
    dataNotch = myFilt(dataNotch,Filt);
end
[f,F]=fftBasic(double(data),44000);
f=abs(f);
fcl=abs(fftBasic(CRAW_LF,44000));
fNotch=abs(fftBasic(double(dataNotch),44000));
fArt=abs(fftBasic(Artifact,sRate));



figure;
plot(F,f,'r')
hold on
plot(F,fNotch,'b')
plot(F,fcl,'g')
legend('ORIG','Notch','remove artifact')
%plot(F,fArt,'k')

figure;
plot(time(1:44000),data(1:44000),'r');
hold on
plot(time(1:44000),dataNotch(1:44000),'b')
plot(time(1:44000),CRAW_LF(1:44000),'g')
plot(time(1:44000),Artifact(1:44000),'k')
legend('ORIG','Notch','remove artifact','artifact')