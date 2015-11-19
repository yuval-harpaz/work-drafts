%% averaged power over time
powMed=charYH2('max','max');
load('/media/yuval/YuvalExtDrive/Data/Hilla_Rotem/powMed_max_max.mat')
charYHbars(powMed);

%% timecourse, sensor space
R=charYH3('max','max');

[R,P]=charYH4(freqMethod, chanMethod, 1, false);

%% SAM
charYHtlrc
% make Brik time series
charYH5;
% make Brik R per subject
charYH6;
% ttest one cond
charYH7('closed','Delta')
% permutations one condition
permuteBriks1('closed_Delta_R+tlrc',0,'Char_',[],[],[]);
!mv perm/realTest+tlrc.BRIK ./closed_Delta_R_TT+tlrc.BRIK
!mv perm/realTest+tlrc.HEAD ./closed_Delta_R_TT+tlrc.HEAD
!mv perm/permResults* ./closed_Delta_R_TT.mat

permuteBriks1('closed_Theta_R+tlrc',0,'Char_');
!mv perm/realTest+tlrc.BRIK ./closed_Theta_R_TT+tlrc.BRIK
!mv perm/realTest+tlrc.HEAD ./closed_Theta_R_TT+tlrc.HEAD
!mv perm/permResults* ./closed_Theta_R_TT.mat

