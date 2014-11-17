%% Nov 2014
freq=10;
stat=statPlotCoh('/media/yuval/Elements/MEG/talResults/Coh/cohLRv1pre_C','/media/yuval/Elements/MEG/talResults/timeProdCoh/cohLRv1pre_C',[freq freq],[0 1],'paired-ttest')


%% older
freq=10;
% sig results
stat=statPlot('cohLRv1pre_D','cohLRv1pre_C',[freq freq],[0 1],'ttest2')
stat=statPlot('cohLRv1pre_D','cohLRv1pre_CQ',[freq freq],[0 1],'ttest2')
stat=statPlot('cohLRv1pre_D','cohLRv1pre_CV',[freq freq],[0 1],'ttest2')
stat=statPlot('cohLRv2post_D','cohLRv2pre_D',[freq freq],[0 1],'paired-ttest')

stat=statPlot('cohLRv1post_C','cohLRv1pre_C',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv1post_CQ','cohLRv1pre_CQ',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv1post_CV','cohLRv1pre_CV',[freq freq],[0 1],'paired-ttest')


stat=statPlot('cohLRv2post_CQ','cohLRv2pre_CQ',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv2post_CV','cohLRv2pre_CV',[freq freq],[0 1],'paired-ttest')


stat=statPlot('cohLRv1post_D','cohLRv1post_C',[freq freq],[0 1],'ttest2')
stat=statPlot('cohLRv2post_D','cohLRv2post_C',[freq freq],[0 1],'ttest2')
stat=statPlot('cohLRv2pre_D','cohLRv2pre_C',[freq freq],[0 1],'ttest2')

stat=statPlot('cohLRv1post_D','cohLRv1pre_D',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv2post_D','cohLRv2pre_D',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv1post_C','cohLRv1pre_C',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv2post_C','cohLRv2pre_C',[freq freq],[0 1],'paired-ttest')

stat=statPlot('cohLRv2pre_D','cohLRv1pre_D',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv2post_D','cohLRv1post_D',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv2pre_C','cohLRv1pre_C',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv2post_C','cohLRv1post_C',[freq freq],[0 1],'paired-ttest')



freq=40;
% sig results
stat=statPlot('cohLRv2post_D','cohLRv2pre_D',[freq freq],[0 1],'paired-ttest')


freq=4;
% sig results
stat=statPlot('cohLRv2post_D','cohLRv2pre_D',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv2post_CQ','cohLRv2pre_CQ',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv2post_CV','cohLRv2pre_CV',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv1post_D','cohLRv1pre_D',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv1post_CQ','cohLRv1pre_CQ',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv1post_CV','cohLRv1pre_CV',[freq freq],[0 1],'paired-ttest')

stat=statPlot('cohLRv1pre_D','cohLRv1pre_C',[freq freq],[0 1],'ttest2')
stat=statPlot('cohLRv1pre_D','cohLRv1pre_CQ',[freq freq],[0 1],'ttest2')
stat=statPlot('cohLRv1pre_D','cohLRv1pre_CV',[freq freq],[0 1],'ttest2')
stat=statPlot('cohLRv2pre_D','cohLRv2pre_CQ',[freq freq],[0 1],'ttest2')
stat=statPlot('cohLRv2post_D','cohLRv2post_CV',[freq freq],[0 1],'ttest2')

stat=statPlot('cohLRv1post_D','cohLRv1post_CQ',[freq freq],[0 1],'ttest2')
stat=statPlot('cohLRv1post_D','cohLRv1post_CV',[freq freq],[0 1],'ttest2')
stat=statPlot('cohLRv2post_D','cohLRv2post_CQ',[freq freq],[0 1],'ttest2')
stat=statPlot('cohLRv2post_D','cohLRv2post_CV',[freq freq],[0 1],'ttest2')

%% TP-BL
freq=10;
stat=statPlotCoh('/media/Elements/MEG/talResults/Coh/cohLRv1pre_D','/media/Elements/MEG/talResults/timeProdCoh/cohLRv1pre_D',[freq freq],[0 1],'paired-ttest')
stat=statPlotCoh('/media/Elements/MEG/talResults/Coh/cohLRv1pre_C','/media/Elements/MEG/talResults/timeProdCoh/cohLRv1pre_C',[freq freq],[0 1],'paired-ttest')
stat=statPlotCoh('/media/Elements/MEG/talResults/Coh/cohLRv2pre_D','/media/Elements/MEG/talResults/timeProdCoh/cohLRv2pre_D',[freq freq],[0 1],'paired-ttest')
stat=statPlotCoh('/media/Elements/MEG/talResults/Coh/cohLRv2pre_C','/media/Elements/MEG/talResults/timeProdCoh/cohLRv2pre_C',[freq freq],[0 1],'paired-ttest')
cd /media/Elements/MEG/talResults/timeProdCoh
stat=statPlotCoh('cohLRv1pre_D','cohLRv1pre_CQ',[freq freq],[0 1],'ttest2')
stat=statPlotCoh('cohLRv1pre_CQ','cohLRv2pre_CQ',[freq freq],[0 1],'paired-ttest')


stat=statPlotCoh('cohLRv1pre_D','cohLRv1pre_CV',[freq freq],[0 1],'ttest2')
stat=statPlotCoh('cohLRv2pre_D','cohLRv2pre_CQ',[freq freq],[0 1],'ttest2')
stat=statPlotCoh('cohLRv2pre_D','cohLRv2pre_CV',[freq freq],[0 1],'ttest2')

freq=4;
