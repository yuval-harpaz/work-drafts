freq=10;
% sig results
cd ('/media/My Passport/MEG/talResults')
stat=statPlot('oneBackCoh/W/cohLRv1pre_D','oneBackCoh/W/cohLRv1pre_C',[freq freq],[0 1],'ttest2')
stat=statPlot('oneBackCoh/NW/cohLRv1pre_D','oneBackCoh/NW/cohLRv1pre_C',[freq freq],[0 1],'ttest2')
stat=statPlot('oneBackCoh/W/cohLRv2pre_D','oneBackCoh/W/cohLRv2pre_C',[freq freq],[0 1],'ttest2')
stat=statPlot('oneBackCoh/NW/cohLRv2pre_D','oneBackCoh/NW/cohLRv2pre_C',[freq freq],[0 1],'ttest2')



stat=statPlot('oneBackCoh/W/cohLRv1pre_D','oneBackCoh/W/cohLRv1pre_CQ',[freq freq],[0 1],'ttest2')
stat=statPlot('oneBackCoh/W/cohLRv1pre_D','oneBackCoh/W/cohLRv1pre_CV',[freq freq],[0 1],'ttest2')

stat=statPlot('oneBackCoh/W/cohLRv2pre_D','oneBackCoh/W/cohLRv1pre_D',[freq freq],[0 1],'paired-ttest')
stat=statPlot('oneBackCoh/W/cohLRv2pre_C','oneBackCoh/W/cohLRv1pre_C',[freq freq],[0 1],'paired-ttest')


freq=40;
% sig results
% stat=statPlot('oneBackCoh/W/cohLRv2pre_D','oneBackCoh/W/cohLRv1pre_D',[freq freq],[0 1],'paired-ttest')


freq=4;
% sig results

% stat=statPlot('oneBackCoh/W/cohLRv1pre_D','oneBackCoh/W/cohLRv1pre_C',[freq freq],[0 1],'ttest2')

%% TP-BL
freq=10;
W='/media/My Passport/MEG/talResults/oneBackCoh/W/';
bl='/media/My Passport/MEG/talResults/Coh/';
NW='/media/My Passport/MEG/talResults/oneBackCoh/NW/';
stat=statPlotCoh([bl,'/cohLRv2pre_D'],[W,'/cohLRv2pre_D'],[freq freq],[0 1],'paired-ttest')


stat=statPlotCoh([bl,'/cohLRv1pre_D'],[W,'/cohLRv1pre_D'],[freq freq],[0 1],'paired-ttest')
stat=statPlotCoh([bl,'/cohLRv2pre_D'],[NW,'/cohLRv2pre_D'],[freq freq],[0 1],'paired-ttest')
stat=statPlotCoh([bl,'/cohLRv1pre_CQ'],[W,'/cohLRv1pre_CQ'],[freq freq],[0 1],'paired-ttest')
stat=statPlotCoh([W,'/cohLRv1pre_CQ'],[NW,'/cohLRv1pre_CQ'],[freq freq],[0 1],'paired-ttest')
stat=statPlotCoh([W,'/cohLRv1pre_D'],[NW,'/cohLRv1pre_D'],[freq freq],[0 1],'paired-ttest')

