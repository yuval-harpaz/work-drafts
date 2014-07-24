function figure1=kurFigBreakdown
cd /home/yuval/Dropbox/Kurtosis/matlab
load spikeTime2
%% SUB B
load b024
figure1=figure('position',[1,1,400,600]);
h1=subplot(2,1,2)
plot(time,g2far,'color',[.7 .7 .7]);
hold on;
plot(time,g2lesion,'k');
plot(time10,g2far10,'--','color',[.7 .7 .7]);
plot(time10,g2lesion10,'--k');
% spikesR=[1:6,8:16,18:19,21:32,34,36,38:44,47:52,54:64,70,72,81,83:90,93:94,96];
% spikesL=[5.5,12,14,17,31,49,52,53,55,58,61:63,93];
plot(timeline(spikesR),-6,'.k')
plot(timeline(spikesL),-4,'.','color',[.7 .7 .7])
legend1=legend(...
    'distant, 0.5s',...
    'lesion,  0.5s',...
    'distant,  10s',...
    'lesion,   10s')
set(legend1,'Position',[0.25 0.2 0.2 0.2],'box','off');
%set(legend1,)
box off
ylim([-10 60])
set (h1,'FontSize',15,'FontName','Times')
title('Sub. B')
ylabel('g2')
xlabel('Time (s)')
%% SUB A
load b028
h2=subplot(2,1,1)
plot(time,g2far,'color',[.7 .7 .7]);
hold on;
plot(time,g2lesion,'k');
plot(time10,g2far10,'--','color',[.7 .7 .7]);
plot(time10,g2lesion10,'--k');
% spikesF=[4:21,23:38,40:56,58,59,61:67,70,73:96,100];
% spikesP=[3,11:14,18,22,24:25,32:34,36,42,45,46,59,64,87,94,95];
plot(timeline(spikesF),-6,'.k')
plot(timeline(spikesP),-4,'.','color',[.7 .7 .7])
ylim([-10 50])
set (h2,'FontSize',15,'FontName','Times')
title('Sub. A')
box off
ylabel('g2')
xlabel('Time (s)')
cd /home/yuval/Dropbox/Kurtosis
