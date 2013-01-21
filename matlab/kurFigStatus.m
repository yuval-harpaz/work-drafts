function figure1=kurFigStatus
load /home/yuval/Data/kurtosis/b024/vsLR
vsL=vsL/1e-2; % it was already divided by 1e-7. nano is -9
vsR=vsR/1e-2;
t=[2 6];s=round(678.17*t);
figure1=figure;
axes1 = axes('Parent',figure1,'FontSize',20,'FontName','Times','LineWidth',2);
box(axes1,'on');
hold(axes1,'all');
plot(timeline(s(1):s(2)),[vsR(:,s(1):s(2))+150;vsL(:,s(1):s(2))],'k','LineWidth',2)
ylabel('Source moment (nA/m^2)','FontSize',20,'FontName','Times');
xlabel('Time (Seconds)','FontSize',20,'FontName','Times');
title('Frequent versus Large Spikes','FontSize',20,'FontName','Times')
xlim([2,6]);
box off
end
