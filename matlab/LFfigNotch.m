function LFfigNotch 

%% random numbers, Tal and Abeles method
% Fig. 1
cd /home/yuval/Dropbox/LF
sRate=2034.5;
%data=rand(100,round(100*sRate))-0.5;
load data/rand2034
try
    matlabpool
end
cfg=[];
cfg.Ncycles=1000;
cfg.method='ADAPTIVE1';
cfg.Lfreq=50;
cfg.jobs=4;
lf=correctLF(data,sRate,'time',cfg);
close;
[f,F]=fftBasic(data,sRate);
f=abs(f);
fcl=abs(fftBasic(lf,sRate));
figure;
plot(F,mean(f),'k','linewidth',4)
set(gca,'fontsize',14,'fontname','times');
hold on
plot(F,mean(fcl),'color',[0.8 0.8 0.8],'linewidth',2)
ylim([0.5 1.4])
xlim([20 80])
xlabel('Frequency (Hz)')
ylabel('PSD')
legend('original','cleaned','location','east')

