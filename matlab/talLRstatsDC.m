freq=10;
stat=statPlot('cohLRv1pre_D','cohLRv1pre_C',[freq freq],[0 1],'ttest2')

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
