

load /media/yuval/win_disk/Data/Amyg/8/avgHBh
f=abs(fftBasic(avgHBh.avg(:,408:end),1017));
X=avgHBh.time;
MEG=avgHBh.avg(1:246,:);
XC=avgHBh.avg(247:end,:);

Xf=1:50;
MEGf=f(1:246,1:50);
XCf=f(247:249,1:50);

figure;
set(gca, 'xcolor', 'w');
set(gcf,'color','w')
h1=subplot(1,2,1);
plot(X,MEG./max(max(MEG)),'k');
hold on
plot(X,XC./max(max(XC))./2,'linewidth',2)
% ylim([-0.1 0.3])
xlim([-0.4 1])
title('HB related response for MEG and Accelerometers')
xlabel('Time (s)')
ylabel('Normalised Amplitude')
box off
% set(h1,'color','none','YTick',0:0.1:0.3)
h2=subplot(1,2,2);
plot(Xf,MEGf(1,:)./max(max(MEGf)),'k')
hold on
plot(Xf,XCf./max(max(XCf)))
plot(Xf,MEGf./max(max(MEGf)),'k');
plot(Xf,XCf./max(max(XCf)),'linewidth',2)
xlim([1 50])
xlabel('Frequency (Hz)')
ylabel('Normalized PSD')
box off
l2=legend('MEG','accX','accY','accZ');
set(l2,'box','off')