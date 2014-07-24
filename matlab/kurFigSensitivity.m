function figure1=kurFigSensitivity

cd /home/yuval/Dropbox/Kurtosis/matlab
load b024
neg=find(g2lesion025<0);
points=[0.4365,1.308,1.64,2.151,3.916,4.26,4.462,4.825,5.217,5.599,7.932,8.725,9.122,9.941];
figure1=figure('position',[1,1,400,600]);
h2=subplot(2,1,2)
plot(points,-40,'k.')
hold on
h1=fill([2,2.25,2.25,2],10*[-4 -4 4 4],[0.7 0.7 0.7])
plot(points,-40,'k.')
set(h1,'EdgeColor','None');
plot(timeline(1:6782),10^9*vsR(1:6782),'k')
set (h2,'FontSize',15,'FontName','Times')
% title('A Virtual Sensor','FontSize',20,'FontName','Times')
xlabel('Time (s)','FontSize',15,'FontName','Times')
ylabel('Moment (nA*m)','FontSize',20,'FontName','Times');
box off
ylim([-45 45])
legend1=legend('spike')
% title('g2 per Segment','FontSize',20)
set(legend1,'box','off')

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
legend2=legend('positive g2','negative g2')
% title('g2 per Segment','FontSize',20)
set(legend2,'box','off')

