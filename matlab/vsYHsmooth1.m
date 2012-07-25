cd /home/yuval/Data/tel_hashomer/yuval
load VG
timeStep=20;
[vs,timeline,allInd]=VS_slice(VG,'SAM/VGerf,1-35Hz,VerbAa.wts',timeStep,[0 0.7]);
[vs,allInd]=inScalpVS(vs,allInd);
TR=num2str(1000*timeStep/1017.25)
%% raw movie

vsSlice2afni(allInd,vs,'raw',true); % abs
!~/abin/3dTcat -prefix catRaw raw*
!~/abin/3drefit -TR 19.66 catRaw+orig
%% raw no absolute values
cd plusMinus
!cp ../ortho+orig.* ./
vsSlice2afni(allInd,vs,'rawPM',false) %plus minus, no abs
!~/abin/3dTcat -prefix catPM rawPM*.BRIK
!~/abin/3drefit -TR 0.01966 catPM+orig
%% z score
vsZ=zScoreVS(vs); %standardize channels to avoid bias to medial vs.
cd Z
!cp ../ortho+orig.* ./
vsSlice2afni(allInd,vsZ,'Z',true);
!~/abin/3dTcat -prefix catZ Z*
!~/abin/3drefit -TR 0.01966 catZ+orig
% -Torg 0 by default
%% Pseudo Z
[noise,timen,allIndn]=VS_slice(VG,'SAM/VGerf,1-35Hz,VerbAa.wts',timeStep,[-0.3 0]);
[noise,allIndn]=inScalpVS(noise,allIndn);

sdnoise=std(noise');
sdmat=vec2mat(sdnoise,size(vs,2))';
meanNoise=mean(noise,2);
meanmat=vec2mat(meanNoise,size(vs,2));
vsPZ=(vs-meanmat)./sdmat;

cd pseudoZ
!cp ../ortho+orig.* ./
vsSlice2afni(allInd,vsPZ,'PZ');
!~/abin/3dTcat -prefix catPZ PZ*
!~/abin/3drefit -TR 0.01966 catPZ+orig

mkdir press
!cp ortho+* press/
!cp Z/cat* press/
!cp pseudoZ/cat* press/
!cp plusMinus/cat* press/
!cp catR* press/
% vsZ=zScoreVS(vs); %standardize channels to avoid bias to medial vs.


vsPZmax=max(vsPZ')';
vsSlice2afni(allInd,vsPZmax,'vgPZmax');
% here you make images. it takes time!
vsMax=max(abs(vs)')';
noiseMax=max(abs(noise)')';
SNR=vsMax./noiseMax;
vsSlice2afni(allInd,SNR,'SNR');
vsSlice2afni(allInd,vsPZ,'vgPZ'); %making afni files starting with vgZ prefix

!~/abin/3dTcat -prefix CATvgPZ vgPZ*
for i=1:9;eval(['!cp vgPZ',num2str(i),'+orig.BRIK vgPZ0',num2str(i),'+orig.BRIK']);eval(['!cp vgPZ',num2str(i),'+orig.HEAD vgPZ0',num2str(i),'+orig.HEAD']);end
TR=num2str(20*1000/1017.25);
eval(['!~/abin/3drefit -TR ',TR,' CATvgPZ+orig'])
!cp CATvgPZ* tests/
kurmap20=kurtosis(vs',0)';


%Stephen's g2 for large samples, without reducing 3 to avoid neg values.
kur=g2(vs);
kurz=(kur-mean(kur))/std(kur);
SNRz=(SNR-mean(SNR))/std(SNR);
SnrKur=SNRz+kurz;

snrkurThr=SNR>2.5; snrkurThr=snrkurThr.*kur>4;
vsSlice2afni(allInd,SnrKur,'SnrKur');
vsSlice2afni(allInd,snrkurThr,'snrkurThr');
vsSlice2afni(allInd,kur,'kur');

vsSlice2afni(allInd,kurmap20,'kur20c');
!~/abin/3dcalc -a kur20c1+orig -b CatVGtr+orig -expr 'ispositive(a-4)*b' -prefix CatVGtrKur
!~/abin/3dcalc -a clust_mask+orig -b CATvgPZ+orig -expr 'b*ispositive(a)' -prefix CatKurSNR