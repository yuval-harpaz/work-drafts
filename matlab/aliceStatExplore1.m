cd /home/yuval/Copy/MEGdata/alice/ga

alicePlotLR1(0.09,'alice','figs/')
alicePlotLR1(0.09,'10','figs/')
alicePlotLR1(0.09,'20','figs/')

alicePlotLR1(0.19,'alice','figs/')
alicePlotLR1(0.19,'10','figs/')
alicePlotLR1(0.19,'20','figs/')

alicePlotLR1(0.21,'alice','figs/')
alicePlotLR1(0.21,'10','figs/')
alicePlotLR1(0.21,'20','figs/')

alicePlotLR1(0.3,'alice','figs/')
alicePlotLR1(0.3,'10','figs/')
alicePlotLR1(0.3,'20','figs/')

alicePlotLR1(0.36,'alice','figs/')
alicePlotLR1(0.36,'10','figs/')
alicePlotLR1(0.36,'20','figs/')
% alicePlotLR(0.09)
% figure;aliceTtest0('GavgM20LR1',0.09,1);

%% freq


alicePlotFrLR1(6,'alice','figs/')
alicePlotFrLR1(10,'alice','figs/')
alicePlotFrLR1(32,'alice','figs/')

alicePlotFrLR1(6,'rest','figs/')
alicePlotFrLR1(10,'rest','figs/')
alicePlotFrLR1(32,'rest','figs/')

statPlot('GavgFrMaliceLR','GavgFrMrestLR',[9 9],[-3e-27 3e-27],'paired-ttest') 
statPlot('GavgFrMaliceLR','GavgFrMrestLR',[10 10],[-3e-27 3e-27],'paired-ttest')
statPlot('GavgFrMaliceLR','GavgFrM10LR',[10 10],[-3e-27 3e-27],'paired-ttest')


%% coh
% alicePlotCohLR1(6,'alice','figs/')
% alicePlotCohLR1(10,'alice','figs/')
% alicePlotCohLR1(32,'alice','figs/')

[~,figure1]=statPlot('GavgCohMalice','GavgCohMrest',[2 6],[0 1],'paired-ttest') % res
saveas(figure1,'figs/Alice_Rest_Coh2Hz.png')
[~,figure1]=statPlot('GavgCohMalice','GavgCohMrest',[6 6],[0 1],'paired-ttest') % res
saveas(figure1,'figs/Alice_Rest_Coh6Hz.png')
[~,figure1]=statPlot('GavgCohMalice','GavgCohMrest',[9 9],[0 1],'paired-ttest') % res
saveas(figure1,'figs/Alice_Rest_Coh9Hz.png')
[~,figure1]=statPlot('GavgCohMalice','GavgCohMrest',[32 32],[0 1],'paired-ttest') % res
saveas(figure1,'figs/Alice_Rest_Coh32Hz.png')

[~,figure1]=statPlot('GavgCohMalice','GavgCohM10',[9 9],[0 1],'paired-ttest') % res
saveas(figure1,'figs/Alice_Tamil_Coh9Hz.png')





