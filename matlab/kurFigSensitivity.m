function figure1=kurFigSensitivity

cd /home/yuval/Dropbox/Kurtosis/matlab
load b024
neg=find(g2lesion025<0);

figure1=figure('position',[1,1,400,600]);
h2=subplot(2,1,2)
h1=fill([2,2.25,2.25,2],(10^-8)*[-4 -4 4 4],[0.7 0.7 0.7])
set(h1,'EdgeColor','None');
hold on
plot(timeline(1:6782),vsR(1:6782),'k')
set (h2,'FontSize',15,'FontName','Times')
% title('A Virtual Sensor','FontSize',20,'FontName','Times')
xlabel('Time (s)','FontSize',15,'FontName','Times')
ylabel('Moment (nA*m)','FontSize',20,'FontName','Times');
box off
h3=subplot(2,1,1)
plot(time025,g2lesion025,'.','color',[0 0 0])
hold on
plot(time025(neg),g2lesion025(neg),'.','color',[0.8 0.8 0.8])
box off
ylim([-2 8])
set (h3,'FontSize',15,'FontName','Times')
%xlabel('Time (s)','FontSize',15,'FontName','Times')
set(gca,'xtick',[]);
set(gca,'xcolor',[1 1 1])
ylabel('g2','FontSize',20,'FontName','Times')
legend1=legend('positive g2','negative g2')
% title('g2 per Segment','FontSize',20)
set(legend1,'box','off')
