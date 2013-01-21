function figure1=kurFigSimulation1

alphaSim=[4,5,6,7,6,5,4,3,2,1,2,3,4,5,6,7,6,5,4,3,2,1,2,3,4,5,6,7,6,5,4];
spikeSim=[4,4,4,4,4,4,4,4,4,4,4,4,4,5,6,7,6,5,4,4,4,4,4,4,4,4,4,4,4,4,4];
spikeSim2=[4,4,4,4,4,4,5,6,7,6,5,4,4,4,4,4,4,4,4,4,5,6,7,6,5,4,4,4,4,4,4];
spikeSim=spikeSim+8;
spikeSim2=spikeSim2+4;
noiseSim=   [2 8 3 5 2 6 3 7 7 7 5 1 2 9 2 8 5 10 1 4 1 10 0 8 8 9 1 4 3 8 4]; % round(10*rand(1,length(spikeSim)));
noiseSim=noiseSim-10;

YMatrix1=[spikeSim;spikeSim2;alphaSim;noiseSim];
YMatrix1=YMatrix1';


figure1 = figure('XVisual',...
    '0x29 (TrueColor, depth 24, RGB mask 0xff0000 0xff00 0x00ff)');

% Create axes
axes1 = axes('Visible','off','Parent',figure1,'LineWidth',2);
xlim(axes1,[0 45]);
ylim([-12 20]);
box(axes1,'off');
hold(axes1,'all');

% Create multiple lines using matrix input to plot
plot(YMatrix1,'LineWidth',2,'Color',[0 0 0],'Parent',axes1);

% Create title

annotation(figure1,'textbox',...
    [0.2 0.2 0.6 0.75],...
    'string',{'g2 values for simulated traces'},...
    'FontSize',20,...
    'FontName','Times',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.71 0.41 0.20 0.40],...
    'String',{'4.75','','0.34','','-1.06','','','-1.42'},...
    'FontSize',20,...
    'FontName','Times',...
    'FitBoxToText','on',...
    'LineStyle','none',...
    'LineWidth',2);

