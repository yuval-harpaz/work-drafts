clear
cd /home/yuval/Desktop/ctf
load data
start=0;
stop=100;
MEG=data(1200*start+1:1200*stop);
clear data
load('ECG.mat')
ECG=ECG-median(ECG);
ECG=ECG(1200*start+1:1200*stop);
load('dt.mat')
%load('frequency.mat')
dataout=test_drifter_yh(MEG,ECG,dt,-0.1);
xlim([13 43])
% noise=squeeze(dataout.noise)-median(squeeze(dataout.noise));
% estimate=squeeze(dataout.estimate)-median(squeeze(dataout.estimate));
% time=dt:dt:length(ECG)*dt;
% figure;
% plot(time,MEG-median(MEG),'k')
% hold on
% plot(time,noise,'r')
% plot(time,estimate,'g')

