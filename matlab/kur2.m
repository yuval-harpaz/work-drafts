

% simaulated data to show g2 basics
figure1=kurFigSimulation;
% MEG channel versus two virtual sensors
figure2=KurFigA22vs;
% ictal or magnetographic seizure
load ~/Data/kurtosis/b044/vsFro
plot(timeline,vsFro)
t10=nearest(timeline,10);
t20=nearest(timeline,20);
t60=nearest(timeline,60);
G2(vsFro(t10:t20))
G2(vsFro(t10:t60))
% 
% load ~/Data/kurtosis/b093/Rfro
% 
% plot(timeline(6000:10000),Rfro(6000:10000))

% status
load /home/yuval/Data/kurtosis/b024/vsLR
t=[2 6];s=round(678.17*t);
plot(timeline(s(1):s(2)),[vsR(:,s(1):s(2))+1.5;vsL(:,s(1):s(2))],'k','LineWidth',2)

ylabel('Source moment (e-7 Amp per divition)');
xlabel('Time (Seconds)');
title('Frequent versus Large Spikes')

kurFigWindows