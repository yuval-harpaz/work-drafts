function inbalClust1(sub,experiment,timeInd)
% inbalClust1(5,'S',271);

cd /media/YuvalExtDrive/Inbal_Yuval_project
cd (num2str(sub))
fnCov=['New_Ncov_',experiment];
maxCov=getMax(fnCov,timeInd);
fnSvd=['New_Nsvd_',experiment];
maxSvd=getMax(fnSvd,timeInd);
fnEmpty=['New_Rs_EmptyRoom_',experiment];
maxEmpty=getMax(fnEmpty,timeInd);


eval(['!3dcalc -a ',fnCov,'+orig''','[',num2str(timeInd),']''',' -exp "a/',maxCov,'" -prefix cov',experiment]);
eval(['!3dcalc -a ',fnSvd,'+orig''','[',num2str(timeInd),']''',' -exp "a/',maxSvd,'" -prefix svd',experiment]);
eval(['!3dcalc -a ',fnEmpty,'+orig''','[',num2str(timeInd),']''',' -exp "a/',maxEmpty,'" -prefix empty',experiment]);


eval(['!3dcalc -a cov',experiment,'+orig -b svd',experiment,'+orig -c empty',experiment,'+orig -exp "(a+b+c)/3" -prefix all',experiment]);
%!3dcalc -a New_Ncov_S+orig'[250]' -b New_Nsvd_S+orig'[250]' -c New_Rs_EmptyRoom_S+orig'[250]' -exp "(a/3.43+b/14.86+c/725.8)/2" -prefix allSom
eval(['!3dclust -savemask mask',experiment,' -1Dformat -nosum -1dindex 0 -1tindex 0 -2thresh -0.60 0.60 -dxyz=1 1.01 55 all',experiment,'+orig.HEAD'])
eval(['!3dcalc -a mask',experiment,'+orig -b ',fnCov,'+orig -exp "b-b*a/a" -prefix cov',experiment,'_noise'])
eval(['!3dcalc -a mask',experiment,'+orig -b ',fnSvd,'+orig -exp "b-b*a/a" -prefix svd',experiment,'_noise'])
eval(['!3dcalc -a mask',experiment,'+orig -b ',fnEmpty,'+orig -exp "b-b*a/a" -prefix empty',experiment,'_noise'])
% !3dcalc -a mask+orig -b svd250+orig -exp "b-b*a" -prefix svd_noise
% !3dcalc -a mask+orig -b empty250+orig -exp "b-b*a" -prefix empty_noise

function maxVal=getMax(prefix,timeInd)
eval(['!3dBrickStat -max ',prefix,'+orig','''[',num2str(timeInd),']''', ' > scrap'])
% txt=importdata('scrap');
txt=textread('scrap','%s');
maxVal=txt{1,1};
