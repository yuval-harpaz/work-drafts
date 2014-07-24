% b162b
% t=[121 681 596];
% matlabpool
% parfor runi=1:3
%     marikSAMloop2([t(runi)-30 t(runi)+15],num2str(runi));
% end
% parfor runi=1:3
%     marikSAMloop([t(runi)-30 t(runi)+15],num2str(runi));
% end

% b162b
t=121;
marikSAMloop([t-30 t+15],'1','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b162b');
marikSAMg2
runi=1;
time=[t(runi)-30 t(runi)+15];
% b022
t=63;
marikSAMloop2([t-30 t+15],'ictus','noECG_c,rfhp1.0Hz,ee,ee','/home/yuval/Data/epilepsy/b022');
marikSAMloop([t-30 t+15],'ictus','noECG_c,rfhp1.0Hz,ee,ee','/home/yuval/Data/epilepsy/b022');
marikSAMloop1([t-30 t+15],'ictus','noECG_c,rfhp1.0Hz,ee,ee','/home/yuval/Data/epilepsy/b022');
t=121;
marikSAMloop1([t-30 t+15],'1','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b162b');

cd /home/yuval/Data/epilepsy/p006/1
open scrap
marikPlotTrace;


t=681;
marikSAMloop2([t-30 t+15],'2','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b162b');
%% g2
t=63;
marikG2([t-30 t+15],'ictus','noECG_c,rfhp1.0Hz,ee,ee','/home/yuval/Data/epilepsy/b022');
marikG2sw([t-30 t+15],'ictus','noECG_c,rfhp1.0Hz,ee,ee','/home/yuval/Data/epilepsy/b022');
marikG2seg([t-30 t+15],'ictus','noECG_c,rfhp1.0Hz,ee,ee','/home/yuval/Data/epilepsy/b022');


t=121;
marikG2([t-30 t+15],'1','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b162b');

open marikSAMloopAvg

t=121;
marikG2sw([t-30 t+15],'1','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b162b');
t=681;
marikG2sw([t-30 t+15],'2','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b162b');
t=596;
marikG2sw([t-30 t+15],'3','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b162b');

t=121;
marikG2seg([t-30 t+15],'1','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b162b');
t=681;
marikG2seg([t-30 t+15],'2','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b162b');
t=596;
marikG2seg([t-30 t+15],'3','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b162b');

marikAvgPreIctal
marikAvg2
%% overlap
% see also overlap in marikSAMloopAvg.m
marikOverlap
% seg, runs 1-2 4vox, runs 2-3 2vox, runs 1-3 2vox, all runs 2vox
% sw, runs 1-2 6vox, runs 2-3 6vox, runs 1-3 5vox, all runs 4vox
% global runs 1-2 2vox, runs 2-3 2vox, runs 1-3 1vox, all runs 1vox

%% traces
%b162b voxel index [17 24 17]
marikTraces
marikTracesb022;
%% permutation test
marikPerm

%% Subject 3 (b023)
t=[2123.82,169.46,127.5]; 
marikSAMloop([t(1)-30 t(1)+10],'2','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b023');
marikSAMloop([t(2)-30 t(2)+23],'3','c,rfDC','/home/yuval/Data/epilepsy/b023');
marikSAMloop([t(3)-30 t(3)+15],'4','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b023');

marikG2sw([t(3)-30 t(3)+15],'4','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b023');
marikG2sw([t(1)-30 t(1)+10],'2','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b023');
marikG2sw([t(2)-30 t(2)+23],'3','c,rfDC','/home/yuval/Data/epilepsy/b023');

marikAvgSub3
marikTracesSub3
marikTracesSub2
marikTracesSub1

marikPlotTraceSub3;
marikPlotTraceSub3B; % for all 3 subjects

% for dipole fit, extracted 290-490s from analog data 11:33 run 2
t=42; % 332s in the original file
marikSAMloop([t(1)-30 t(1)+10],'5','c,rfhp1.0Hz,ee','/home/yuval/Data/epilepsy/b023');
marikG2sw([t(1)-30 t(1)+10],'5','c,rfhp1.0Hz,ee','/home/yuval/Data/epilepsy/b023');

%% 5 more datasets b023
% seiz 2 | 11:33 run2 2123.82  onst  end  
% seiz 3 | 12:45 run1 169.46
% seiz 4 | 12:54 run1 127.5
% seiz 5 | 11:33 run2 330
% seiz 6 | 11:33 run2 3188      40   53
% seiz 7 | 11:33 run2 2460      40   65
% seiz 8 | 11:33 run2 147       40   60
% seiz 9 | 12:45 run1 1         2.5  13
% seiz 10| 12:54 run1 1179      40   48

marikSAMloopB023last5


%%
% marikSAMg2
% runi=1;
% time=[t(runi)-30 t(runi)+15];
% % b022
% t=63;
% marikSAMloop2([t-30 t+15],'ictus','noECG_c,rfhp1.0Hz,ee,ee','/home/yuval/Data/epilepsy/b022');
% marikSAMloop([t-30 t+15],'ictus','noECG_c,rfhp1.0Hz,ee,ee','/home/yuval/Data/epilepsy/b022');
% marikSAMloop1([t-30 t+15],'ictus','noECG_c,rfhp1.0Hz,ee,ee','/home/yuval/Data/epilepsy/b022');
% t=121;
% marikSAMloop1([t-30 t+15],'1','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b162b');


