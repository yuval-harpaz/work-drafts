
cd /media/Elements/MEG/talResults/pow/norm/dif


freq=10;
stat=statPlot('pow_rest_pre_v1_D','pow_rest_pre_v1_CQ',[freq freq],[-0.3 0.3],'ttest2');
stat=statPlot('pow_rest_pre_v2_D','pow_rest_pre_v2_CQ',[freq freq],[-0.3 0.3],'ttest2');
stat=statPlot('pow_rest_post_v1_D','pow_rest_pre_v1_D',[freq freq],[-0.3 0.3],'paired-ttest');
stat=statPlot('pow_rest_pre_v2_D','pow_rest_pre_v1_D',[freq freq],[-0.3 0.3],'paired-ttest');
stat=statPlot('pow_W_v1_D','pow_NW_v1_D',[freq freq],[-0.3 0.3],'paired-ttest');
stat=statPlot('pow_W_v1_CQ','pow_NW_v1_CQ',[freq freq],[-0.3 0.3],'paired-ttest');


stat=statPlot('pow_rest_pre_v1_CQ','pow_W_v1_CQ',[freq freq],[-0.3 0.3],'paired-ttest');






freq=4;
stat=statPlot('pow_NW_v1_D','pow_NW_v1_CQ',[freq freq],[0 1],'ttest2')
stat=statPlot('pow_rest_post_v1_D','pow_rest_pre_v1_D',[freq freq],[0 1e-26],'paired-ttest');

freq=10;
stat=statPlot('pow_rest_pre_v1_D','pow_rest_pre_v1_CQ',[freq freq],[0 1e-26],'ttest2');
stat=statPlot('pow_rest_pre_v2_D','pow_rest_pre_v2_CQ',[freq freq],[0 1e-26],'ttest2');

stat=statPlot('pow_rest_post_v1_D','pow_rest_pre_v1_D',[freq freq],[],'paired-ttest');
stat=statPlot('pow_rest_post_v1_D','pow_rest_post_v1_CQ',[freq freq],[],'ttest2')
stat=statPlot('pow_NW_v1_D','pow_NW_v1_CQ',[freq freq],[],'ttest2')
stat=statPlot('pow_rest_pre_v1_D','pow_NW_v1_D',[freq freq],[0 1e-26],'paired-ttest')

% words non-words
stat=statPlot('pow_NW_v1_D','pow_W_v1_D',[freq freq],[0 1e-26],'paired-ttest')
stat=statPlot('pow_NW_v1_CQ','pow_W_v1_CQ',[freq freq],[0 1e-26],'paired-ttest')
stat=statPlot('pow_NW_v1_CV','pow_W_v1_CV',[freq freq],[0 1e-26],'paired-ttest')
stat=statPlot('pow_NW_v2_D','pow_W_v2_D',[freq freq],[0 1e-26],'paired-ttest')
stat=statPlot('pow_NW_v2_CQ','pow_W_v2_CQ',[freq freq],[0 1e-26],'paired-ttest')
stat=statPlot('pow_NW_v2_CV','pow_W_v2_CV',[freq freq],[0 1e-26],'paired-ttest')

% 


