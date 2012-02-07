cd /home/yuval/Data/tel_hashomer/yuval
load VG
timeStep=20;
[vs,timeline,allInd]=VS_slice(VG,'SAM/VGerf,1-35Hz,VerbAa.wts',timeStep,[0 0.7]);
[vs,allInd]=inScalpVS(vs,allInd);
% vsZ=zScoreVS(vs); %standardize channels to avoid bias to medial vs.
[noise,timen,allIndn]=VS_slice(VG,'SAM/VGerf,1-35Hz,VerbAa.wts',timeStep,[-0.3 0]);
[noise,allIndn]=inScalpVS(noise,allIndn);
sdnoise=std(noise');
sdmat=vec2mat(sdnoise,size(vs,2))';
meanNoise=mean(noise,2);
meanmat=vec2mat(meanNoise,size(vs,2));
vsPZ=(vs-meanmat)./sdmat;
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