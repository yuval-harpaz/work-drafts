% get subject name from MMnames.xls
% get coordinates from "participant DMN coo...xls"
coords=[-5 -53 28;3 -52 24; -48 -65 30; 39 -64 27; -10 53 17; 7 60 17];
labels={'L-Prc';'R-Prc';'L-IPL';'R-IPL';'L-mPFC';'R-mPFC'}


cd /media/yuval/YuvalExtDrive/Data/Aviva/MRI/Subjects/Controls_Anatomy/AG_anatomy
[~,w]=unix('to3d *.dcm');
cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG/MM1/
mkdir MRI
cd MRI
!cp /media/yuval/YuvalExtDrive/Data/Aviva/MRI/Subjects/Controls_Anatomy/AG_anatomy/anat+* ./
!cp ~/SAM_BIU/docs/MNI305.tag ./sub.tag

afni % edit tagset
[~,w]=unix('3dTagalign -master /home/yuval/brainhull/master+orig -prefix ortho anat+orig ');
!cp ../1/hs_file ./
hs2afni
afni % Nudge
!@auto_tlrc -base ~/SAM_BIU/docs/temp+tlrc -input ortho+orig -no_ss
pri=tlrc2orig(coords)

grid2t(pri./10);

!cp pnt.txt SAM/pnt.txt
cd ..
!SAMwts -r oddball -d c,rfhp0.1Hz -m allTrials -c Alla -t pnt.txt -v

