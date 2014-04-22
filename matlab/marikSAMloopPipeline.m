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

