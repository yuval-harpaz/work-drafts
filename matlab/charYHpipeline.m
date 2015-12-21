%% averaged power over time
powMed=charYH2('max','max');
load('/media/yuval/YuvalExtDrive/Data/Hilla_Rotem/powMed_max_max.mat')
charYHbars(powMed);

%% timecourse, sensor space
R=charYH13('max','max');
% audio
[R,P]=charYH4('max', 'max', 1, false);
% concatenated
charYH14(300);
%% SAM
charYHtlrc
% make Brik time series
charYH5;
% make Brik R per subject
charYH6;
% ttest one cond
charYH7('closed','Delta')
% permutations one condition
charYH8
% permutations 2 conditions
charYH9
% correlate each subject with the audio
charYH10;
% permutations
charYH11
% average subject R
charYH12


%% improve r, sensor level
powMed=charYH2('sum','sum');
R=charYH13('sum','sum');
[R,P]=charYH4('sum', 'sum', 1, false);

%% average power, source level
charYH15
