function plotPeakDist(post,posTri,negt,negTri)
[n1,x1]=hist(post,50);
[n2,x2]=hist(negt,50);
figure;
h1=bar(x1,n1,'hist');
hold on
h2=bar(x2,n2,'hist');
set(h2,'edgecolor','k')
set(h2,'facecolor','k')
set(h1,'edgecolor','k')
set(h1,'facecolor','w')
legend ('pos','neg')
ylim([0 75]);
title('Count of Peaks by time bins')
xlabel ('Latency')
ylabel('Number of Events')

figure;
h3=plot(post,posTri,'d','markerfacecolor','w','markeredgecolor','k');
hold on
h4=plot(negt,negTri,'d','markerfacecolor','k','markeredgecolor','k');
ylabel('Trial Number')
xlabel ('Latency')
xlim([-0.1 0.5])
ylim([0 max(negTri)])
legend ('pos','neg')
title('Distribution of Peaks by latency and trials')