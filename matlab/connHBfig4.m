% fileName=source;
% p=pdf4D(fileName);
% cleanCoefs = createCleanFile(p, fileName,...
%     'byLF',0 ,...
%     'xClean',0,...
%     'byFFT',0,...
%     'HeartBeat',[])
cd /media/yuval/win_disk/Data/connectomeDB/MEG/133019/unprocessed/MEG/3-Restin/4D
load avgHB
sRate=cleanCoefs.samplingRate;
HBtimes=[cleanCoefs(1).HBparams.whereisHB,cleanCoefs(2).HBparams.whereisHB].*sRate;
fig1=figure('position',[1151 397 257 394])
axes('ytick',[0, 0.1, 0.2],'fontsize',12,'fontweight','bold')
set(gcf,'color','w')
set(gca,'color',[0.7 0.7 0.7])
hold on
plot(times,smooth(10^12*mean(avgHB),20),'k')
plot(times,smooth(10^12*mean(avgHBc),20),'w','linewidth',3)
plot(times,smooth(10^12*mean(avgHBa),20),'k','linewidth',3)

xlim([-0.25 0.45])
ylim([1.1*min(10^12*mean(avgHB)) 1.1*max(10^12*mean(avgHB))])
xlabel('Time (s)');
ylabel('Amplitude (pT)');
l1=legend('raw','xcorr','max amplitude')
set(l1,'box','off')
