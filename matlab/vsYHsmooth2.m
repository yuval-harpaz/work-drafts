cd /home/yuval/Data/tel_hashomer/yuval
load ~/Data/tel_hashomer/yuval/VG
load rmsWts
timeStep=1; %in samples
torig=-0.1; %beginning of VS in sec
[VS,timeline,AllInd]=VS_slice(VG,'~/Data/tel_hashomer/yuval/SAM/VGerf,1-35Hz,VerbAa.wts',timeStep,[torig 0.5]);
% [vs,allInd]=inScalpVS(VS,AllInd);
TR=num2str(1000*timeStep/1017.25); % time of requisition, time gap between samples
cfg=[];
cfg.func='funcTemp+orig';
cfg.step=0.5;
cfg.boxSize=[-12 12 -9 9 -2 15];
cfg.prefix='rmsWts';
vs2brik(cfg,rmsWts')

cfg.prefix='raw';
cfg.TR=TR;
cfg.torig=torig*1000;
vs2brik4D(cfg,VS)
!~/abin/3dcalc -a raw+orig -expr '1e+9*a' -prefix sc_raw

!~/abin/3dcalc -a raw+orig -b rmsWts+orig -expr '1e+13*abs(a/b)' -prefix sc_abs_wts

sdNoise=std(VS(:,1:102)');
%sdmat=vec2mat(sdnoise,size(VS,2))';
meanNoise=mean(VS(:,1:102),2);
cfg=[];
cfg.func='funcTemp+orig';
cfg.step=0.5;
cfg.boxSize=[-12 12 -9 9 -2 15];
cfg.prefix='BLmean';
vs2brik(cfg,meanNoise)
cfg.prefix='BLsd';
vs2brik(cfg,sdNoise')

!~/abin/3dcalc -a raw+orig -b BLmean+orig -c BLsd+orig -expr 'abs((a-b)/c)' -prefix abs_pseudoZ


kur=g2(VS(:,103:end));
cfg=[];
cfg.func='funcTemp+orig';
cfg.step=0.5;
cfg.boxSize=[-12 12 -9 9 -2 15];
cfg.prefix='kur';
vs2brik(cfg,kur)


% apply g2 masks
!~/abin/3dcalc -a sc_abs_wts+orig -b kur+orig -expr 'a*ispositive(b-3)+0.0001*ispositive(a)' -float -prefix kurMsk3