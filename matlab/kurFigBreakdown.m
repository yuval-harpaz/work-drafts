function figure1=kurFigBreakdown
cd /home/yuval/Dropbox/Kurtosis/matlab
load b024
figure1=figure('position',[1,1,400,600]);
h1=subplot(2,1,2)
plot(time,g2far,'color',[.7 .7 .7],'LineWidth',2);
hold on;
plot(time,g2lesion,'k','LineWidth',2);
plot(time10,g2far10,'color',[.7 .7 .7]);
plot(time10,g2lesion10,'k');
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
load b028
h2=subplot(2,1,1)
plot(time,g2far,'color',[.7 .7 .7],'LineWidth',2);
hold on;
plot(time,g2lesion,'k','LineWidth',2);
plot(time10,g2far10,'color',[.7 .7 .7]);
plot(time10,g2lesion10,'k');
ylim([-10 50])
set (h2,'FontSize',15,'FontName','Times')
title('Sub. A')
box off
ylabel('g2')
xlabel('Time (s)')

