cd /home/yuval/Dropbox/poster2012
load ~/Data/tel_hashomer/yuval/VG
load rmsWts
timeStep=2;
[VS,timeline,AllInd]=VS_slice(VG,'~/Data/tel_hashomer/yuval/SAM/VGerf,1-35Hz,VerbAa.wts',timeStep,[0 0.5]);
% [vs,allInd]=inScalpVS(VS,AllInd);
TR=num2str(timeStep/1017.25)
cfg=[];
cfg.func='KurMask001+orig';
cfg.TR=TR;
cfg.step=0.5;
cfg.boxSize=[-12 12 -9 9 -2 15];
vs2brik(cfg,VS)

RMS=rmsWts(find(rmsWts>0));
RMS=RMS';
RMS=vec2mat(RMS,size(vs,2));
vsRMS=vs./RMS;
vsSlice2afni(allInd,vsRMS(:,1),'funcTemp',false);



!~/abin/3dTcat -prefix catRms rms*.HEAD
eval(['!~/abin/3drefit -TR ',TR,' catRms+orig']);
kur=g2(vs);
vsSlice2afni(allInd,kur,'KurMask');
% rescale for AFNI graphs to work
!~/abin/3dcalc -a catRms+orig -expr 'a*1e+13' -prefix catRmsSc 
% apply g2 masks
!~/abin/3dcalc -a catRmsSc+orig -b KurMask001+orig -expr 'a*ispositive(b-3)+0.0001*ispositive(a)' -float -prefix catRmsKmsk3

!~/abin/3dcalc -a catRmsSc+orig -b KurMask001+orig -expr 'a*ispositive(b-3.5)+0.0001*ispositive(a)' -float -prefix catRmsKmsk3.5

!~/abin/3dcalc -a catRmsSc+orig -b KurMask001+orig -expr 'a*ispositive(b-4)+0.0001*ispositive(a)' -float -prefix catRmsKmsk4

!~/abin/3dcalc -a catRmsSc+orig -b KurMask001+orig -expr 'a*ispositive(b-4.5)+0.0001*ispositive(a)' -float -prefix catRmsKmsk4.5
