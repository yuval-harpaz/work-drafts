freq=10;
stat=statPlot('cohLRv1pre_DM','cohLRv1pre_CM',[freq freq],[0 1],'ttest2')
stat=statPlot('cohLRv1post_DM','cohLRv1post_CM',[freq freq],[0 1],'ttest2')
stat=statPlot('cohLRv2post_DM','cohLRv2post_CM',[freq freq],[0 1],'ttest2')
stat=statPlot('cohLRv2pre_DM','cohLRv2pre_CM',[freq freq],[0 1],'ttest2')

stat=statPlot('cohLRv1post_DM','cohLRv1pre_DM',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv2post_DM','cohLRv2pre_DM',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv1post_CM','cohLRv1pre_CM',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv2post_CM','cohLRv2pre_CM',[freq freq],[0 1],'paired-ttest')

stat=statPlot('cohLRv2pre_DM','cohLRv1pre_DM',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv2post_DM','cohLRv1post_DM',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv2pre_CM','cohLRv1pre_CM',[freq freq],[0 1],'paired-ttest')
stat=statPlot('cohLRv2post_CM','cohLRv1post_CM',[freq freq],[0 1],'paired-ttest')
