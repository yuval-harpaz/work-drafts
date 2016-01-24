cd /media/yuval/YuvalExtDrive/Data/Aviva/MRI/Subjects/Controls_Anatomy
DIR=dir('*na*');
for subi=1:length(DIR)
    Subs{subi,1}=DIR(subi).name
end

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
!3dSkullStrip -input ortho+orig -prefix mask -mask_vol -skulls -o_ply ortho
!meshnorm ortho_brainhull.ply > hull.shape
!cp hull.shape ../1/
afni % edit tagset
[~,w]=unix('3dTagalign -master /home/yuval/brainhull/master+orig -prefix ortho anat+orig ');
!cp ../1/hs_file ./
hs2afni
afni % Nudge
!@auto_tlrc -base ~/SAM_BIU/docs/temp+tlrc -input ortho+orig -no_ss
pri=tlrc2orig(coords)

grid2t(pri./10);
if ~exist('SAM','dir')
    mkdir SAM
end
!cp pnt.txt SAM/pnt.txt
load dataRejectIcaEye
trl2mark(dataRejectIcaEye);
cd ..
!cp ~/SAM_BIU/docs/SuDi0811.rtw 1/1.rtw


!SAMcov64 -r 1 -d xc,hb,lf_c,rfhp0.1Hz -m general -v
!SAMwts64 -r 1 -d xc,hb,lf_c,rfhp0.1Hz -m general -c Alla -t pnt.txt -v

 [~, ~, wts]=readWeights('1/SAM/pnt.txt.wts');
 for triali=1:length(dataRejectIcaEye.trial)
     f=fftBasic(dataRejectIcaEye.trial{triali},dataRejectIcaEye.fsample);
     ff(1:6,1:100,triali)=abs(wts*f(:,1:100));
 end
for freqi=1:100
    rr(1:6,1:6,freqi)=corr(squeeze(ff(:,freqi,:))');
end
rAlpha=mean(rr(:,:,8:12),3)