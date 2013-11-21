cd /media/YuvalExtDrive/Inbal_Yuval_project
cd 1
!3dBrickStat -max New_Ncov_S+orig'[250]' 
% 3.43
!3dBrickStat -max New_Nsvd_S+orig'[250]' 
% 14.86
!3dBrickStat -max New_Rs_EmptyRoom_S+orig'[250]' 
% 725.8
!3dcalc -a New_Ncov_S+orig'[250]' -exp "a/3.43" -prefix cov250
!3dcalc -a New_Nsvd_S+orig'[250]' -exp "a/14.86" -prefix svd250
!3dcalc -a New_Rs_EmptyRoom_S+orig'[250]' -exp "a/725.8" -prefix empty250

!3dcalc -a cov250+orig -b svd250+orig -c empty250+orig -exp "(a+b+c)/3" -prefix allSom
%!3dcalc -a New_Ncov_S+orig'[250]' -b New_Nsvd_S+orig'[250]' -c New_Rs_EmptyRoom_S+orig'[250]' -exp "(a/3.43+b/14.86+c/725.8)/2" -prefix allSom
!3dclust -savemask mask -1Dformat -nosum -1dindex 0 -1tindex 0 -2thresh -0.60 0.60 -dxyz=1 1.01 20 allSom+orig.HEAD
!3dcalc -a mask+orig -b cov250+orig -exp "b-b*a" -prefix cov_noise
!3dcalc -a mask+orig -b svd250+orig -exp "b-b*a" -prefix svd_noise
!3dcalc -a mask+orig -b empty250+orig -exp "b-b*a" -prefix empty_noise

!3dBrickStat -var cov_noise+orig
% 0.00402752
!3dBrickStat -mean cov_noise+orig
% 0.024162
CV=sqrt(0.00402752)/0.024162; % 2.6266

!3dBrickStat -var svd_noise+orig
% 0.0042077
!3dBrickStat -mean svd_noise+orig
% 0.0247276
CV=sqrt(0.0042077)/0.0247276; % 2.6233

!3dBrickStat -var empty_noise+orig
% 0.004422
!3dBrickStat -mean empty_noise+orig
% 0.0259527
CV=sqrt(0.004422)/0.0259527; % 2.5623

cd ../2

!3dBrickStat -max New_Ncov_S+orig'[250]' 
% 3.15221
!3dBrickStat -max New_Nsvd_S+orig'[250]' 
% 13.5354
!3dBrickStat -max New_Rs_EmptyRoom_S+orig'[250]' 
% 599.874
!3dcalc -a New_Ncov_S+orig'[250]' -exp "a/3.15221" -prefix cov250
!3dcalc -a New_Nsvd_S+orig'[250]' -exp "a/13.5354" -prefix svd250
!3dcalc -a New_Rs_EmptyRoom_S+orig'[250]' -exp "a/599.874" -prefix empty250

!3dcalc -a cov250+orig -b svd250+orig -c empty250+orig -exp "(a+b+c)/3" -prefix allSom
%!3dcalc -a New_Ncov_S+orig'[250]' -b New_Nsvd_S+orig'[250]' -c New_Rs_EmptyRoom_S+orig'[250]' -exp "(a/3.43+b/14.86+c/725.8)/2" -prefix allSom
!3dclust -savemask mask -1Dformat -nosum -1dindex 0 -1tindex 0 -2thresh -0.60 0.60 -dxyz=1 1.01 20 allSom+orig.HEAD
!3dcalc -a mask+orig -b cov250+orig -exp "b-b*a" -prefix cov_noise
!3dcalc -a mask+orig -b svd250+orig -exp "b-b*a" -prefix svd_noise
!3dcalc -a mask+orig -b empty250+orig -exp "b-b*a" -prefix empty_noise

!3dBrickStat -var cov_noise+orig
% 0.00699927
!3dBrickStat -mean cov_noise+orig
% 0.0352474
CV=sqrt(0.00699927)/0.0352474; % 2.3736

!3dBrickStat -var svd_noise+orig
% 0.00582939
!3dBrickStat -mean svd_noise+orig
% 0.0318236
CV=sqrt(0.00582939)/0.0318236; % 2.3992

!3dBrickStat -var empty_noise+orig
% 0.0076405
!3dBrickStat -mean empty_noise+orig
% 0.0368611 
CV=sqrt(0.0076405)/0.0368611 ; % 2.3713


cd ../3

!3dBrickStat -max New_Ncov_S+orig'[278]' 
% 0.642229
!3dBrickStat -max New_Nsvd_S+orig'[278]' 
% 2.27998
!3dBrickStat -max New_Rs_EmptyRoom_S+orig'[278]' 
% 147.289
!3dcalc -a New_Ncov_S+orig'[278]' -exp "a/0.642229" -prefix cov278
!3dcalc -a New_Nsvd_S+orig'[278]' -exp "a/2.27998" -prefix svd278
!3dcalc -a New_Rs_EmptyRoom_S+orig'[278]' -exp "a/147.289" -prefix empty278

!3dcalc -a cov278+orig -b svd278+orig -c empty278+orig -exp "(a+b+c)/3" -prefix allSom
%!3dcalc -a New_Ncov_S+orig'[278]' -b New_Nsvd_S+orig'[278]' -c New_Rs_EmptyRoom_S+orig'[278]' -exp "(a/3.43+b/14.86+c/725.8)/2" -prefix allSom
!3dclust -savemask mask -1Dformat -nosum -1dindex 0 -1tindex 0 -2thresh -0.60 0.60 -dxyz=1 1.01 50 allSom+orig.HEAD
!3dcalc -a mask+orig -b cov278+orig -exp "b-b*a" -prefix cov_noise
!3dcalc -a mask+orig -b svd278+orig -exp "b-b*a" -prefix svd_noise
!3dcalc -a mask+orig -b empty278+orig -exp "b-b*a" -prefix empty_noise

!3dBrickStat -var cov_noise+orig
% 0.00954827
!3dBrickStat -mean cov_noise+orig
% 0.0382574
CV=sqrt(0.00954827)/0.0382574; % 2.5542

!3dBrickStat -var svd_noise+orig
% 0.0109628
!3dBrickStat -mean svd_noise+orig
% 0.0410037
CV=sqrt(0.0109628)/0.0410037; % 2.5535

!3dBrickStat -var empty_noise+orig
% 0.0101193
!3dBrickStat -mean empty_noise+orig
% 0.0395854 
CV=sqrt(0.0101193)/0.0395854 ; % 2.5412

cd ../4

!3dBrickStat -max New_Ncov_S+orig'[243]' 
% 1.0786
!3dBrickStat -max New_Nsvd_S+orig'[243]' 
% 3.704
!3dBrickStat -max New_Rs_EmptyRoom_S+orig'[243]' 
% 213.325
!3dcalc -a New_Ncov_S+orig'[243]' -exp "a/1.0786" -prefix cov243
!3dcalc -a New_Nsvd_S+orig'[243]' -exp "a/3.704" -prefix svd243
!3dcalc -a New_Rs_EmptyRoom_S+orig'[243]' -exp "a/213.325" -prefix empty243

!3dcalc -a cov243+orig -b svd243+orig -c empty243+orig -exp "(a+b+c)/3" -prefix allSom
%!3dcalc -a New_Ncov_S+orig'[243]' -b New_Nsvd_S+orig'[243]' -c New_Rs_EmptyRoom_S+orig'[243]' -exp "(a/3.43+b/14.86+c/725.8)/2" -prefix allSom
!3dclust -savemask mask -1Dformat -nosum -1dindex 0 -1tindex 0 -2thresh -0.60 0.60 -dxyz=1 1.01 50 allSom+orig.HEAD
!3dcalc -a mask+orig -b cov243+orig -exp "b-b*a" -prefix cov_noise
!3dcalc -a mask+orig -b svd243+orig -exp "b-b*a" -prefix svd_noise
!3dcalc -a mask+orig -b empty243+orig -exp "b-b*a" -prefix empty_noise

!3dBrickStat -var cov_noise+orig
% 0.00819448
!3dBrickStat -mean cov_noise+orig
% 0.0409746
CV=sqrt(0.00819448)/0.0409746; % 2.2093

!3dBrickStat -var svd_noise+orig
% 0.00950265
!3dBrickStat -mean svd_noise+orig
% 0.043911
CV=sqrt(0.00950265)/0.043911; % 2.2200

!3dBrickStat -var empty_noise+orig
% 0.00946687
!3dBrickStat -mean empty_noise+orig
% 0.0440468 
CV=sqrt(0.00946687)/0.0440468 ; % 2.2090


!3dBrickStat -max New_orig_S+orig'[243]' 
!3dcalc -a New_orig_S+orig'[243]' -exp "a/1.91755e-07" -prefix raw243
!3dcalc -a mask+orig -b raw243+orig -exp "b-b*a" -prefix raw_noise

!3dBrickStat -var raw_noise+orig
% 0.00406326
!3dBrickStat -mean raw_noise+orig
% 0.020344
CV=sqrt(0.00406326)/0.020344; % 3.1333