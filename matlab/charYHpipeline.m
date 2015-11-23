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
charYH8

