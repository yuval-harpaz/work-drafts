function LFfig1000

cd /home/yuval/Data/emptyRoom2
load ratio1000all
for parti=1:5
    [~,p(parti),C(1:2,parti)]=ttest(ratio(:,parti));
end
figure;
plot(mean(ratio),'k','linewidth',2)
hold on
errorbar(1:5,mean(ratio),mean(ratio)-C(2,:),mean(ratio)-C(1,:),'color','k')
set(gca,'FontSize',16,'FontName','Times')
title('50Hz notch for the first N cycles')
l1=legend('50Hz to baseline ratio','Confidence interval');
set(l1,'location','southeast','box','off');
xlabel({'Part of a segment',' '})
ylabel('Ratio')
xlim([0.5 5.5])
box off
