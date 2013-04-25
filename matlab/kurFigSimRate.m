function figure1=kurFigSimRate
load /home/yuval/Data/kurtosis/table1
YMatrix1=table1(2:end,2:end-1)./table1(2:end,3:end);
X1=1:size(YMatrix1,1);
%CREATEFIGURE(X1,YMATRIX1)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 27-Jan-2013 15:12:36

% Create figure
figure1 = figure('XVisual',...
    '0x29 (TrueColor, depth 24, RGB mask 0xff0000 0xff00 0x00ff)',...
    'Position',[1,1,1000,600]);

% Create axes
axes1 = axes('Parent',figure1,'YTickLabel',{'','1','','2','','3'},...
    'XTick',X1,...
    'XTickLabel',{'0.125','0.25','0.5','1','2','4','8','16','32'},...
    'FontName','Times',...
    'LineWidth',2,...
    'FontSize',20);
box(axes1,'on');
hold(axes1,'all');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'Parent',axes1,'MarkerFaceColor',[0 0 0],...
    'LineWidth',2,...
    'Color',[0 0 0]);
set(plot1(1),'LineStyle','-','DisplayName',' 4s / 8s');
set(plot1(2),'LineStyle','--','DisplayName',' 8s / 16s');
set(plot1(3),'LineStyle',':','DisplayName','16s / 32s');

% Create legend
legend1=legend(axes1,'show');
set(legend1,'EdgeColor',[1 1 1]);
xlim([0,10])
title('g2 ratio for sparse spikes as a function of window length')
xlabel('Window length (Seconds)')
ylabel({'Ratio between g2 values','for adjacent spike rates'})
box off

