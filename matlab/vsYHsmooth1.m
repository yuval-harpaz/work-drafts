cd /home/yuval/Data/tel_hashomer/yuval
load VG
timeStep=20;
[vs,timeline,allInd]=VS_slice(VG,'SAM/VGerf,1-35Hz,VerbAa.wts',timeStep,[0 0.7]);
[vs,allInd]=inScalpVS(vs,allInd);
TR=num2str(timeStep/1017.25)
%% raw movie

vsSlice2afni(allInd,vs,'raw',true); % abs
!~/abin/3dTcat -prefix catRaw raw*.HEAD
!~/abin/3drefit -TR 0.01966 catRaw+orig
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
!~/abin/3dTcat -prefix catZ Z*.HEAD
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
!~/abin/3dTcat -prefix catPZ PZ*.HEAD
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
% kurmap20=kurtosis(vs',0)';
% 

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

%% weights based normalization: RMS + Max
cd /home/yuval/Data/tel_hashomer/yuval
load VG
timeStep=20;
[vs,timeline,allInd]=VS_slice(VG,'SAM/VGerf,1-35Hz,VerbAa.wts',timeStep,[0 0.7]);
[vs,allInd]=inScalpVS(vs,allInd);
TR=num2str(timeStep/1017.25)
%
load('/home/yuval/Data/tel_hashomer/yuval/SAM/VGerf,1-35Hz,VerbAa.mat')
boxSize=[-12 12 -9 9 -2 15];
step=0.5;
AP=-12:0.5:12;LR=-9:0.5:9;IS=-2:0.5:15;
rmsi=0;
for voxi=AP
    for voxj=LR
        for voxk=IS
            [ind,~]=voxIndex([voxi,voxj,voxk],boxSize,step);
            wts=ActWgts(ind,:);
            rmsi=rmsi+1;
            rmsWts(rmsi)=sqrt(mean(wts.^2));
            maxWts(rmsi)=max(abs(wts));
        end
    end
end
figure;plot(rmsWts)
RMS=rmsWts(find(rmsWts>0));
RMS=RMS';
RMS=vec2mat(RMS,36);
vsRMS=vs./RMS;
vsSlice2afni(allInd,vsRMS,'rms'); % abs
!~/abin/3dTcat -prefix catRms rms*.HEAD
!~/abin/3drefit -TR 0.01966 catRms+orig
% rescale, values too small for AFNI graphs
!~/abin/3dcalc -a catRms+orig -expr 'a*1e+13' -prefix catRmsSc

%figure;plot(LR,maxWts)

% Max=maxWts(find(rmsWts>0));
% Max=Max';
% Max=vec2mat(Max,36);
% vsMax=vs./Max;
% vsSlice2afni(allInd,vsMax,'max'); % abs
% !~/abin/3dTcat -prefix catMax max*.HEAD
% eval(['!~/abin/3drefit -TR ',TR,' catMax+orig'])
% 
%% kurtosis mask
kur=g2(vs);
vsSlice2afni(allInd,kur,'KurMask');
cd RMS
!~/abin/3dcalc -a catRmsSc+orig -b ../KurMask001+orig -expr 'a*ispositive(b-3)' -prefix catRmsKmsk
!~/abin/3dcalc -a catRmsSc+orig -b ../KurMask001+orig -expr 'a*ispositive(a-3)*ispositive(b-3)+3*ispositive(a)' -prefix catRms_Kur3Amp3

%% high temp res
cd /home/yuval/Data/tel_hashomer/yuval/RMShr
load ../VG
load rmsWts
timeStep=2;
[vs,timeline,allInd]=VS_slice(VG,'../SAM/VGerf,1-35Hz,VerbAa.wts',timeStep,[0 0.5]);
[vs,allInd]=inScalpVS(vs,allInd);
TR=num2str(timeStep/1017.25)
RMS=rmsWts(find(rmsWts>0));
RMS=RMS';
RMS=vec2mat(RMS,size(vs,2));
vsRMS=vs./RMS;
vsSlice2afni(allInd,vsRMS,'rms'); % abs
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




!~/abin/3dcalc -a catRmsSc+orig -b KurMask001+orig -expr 'a*ispositive(a-3)*ispositive(b-3.5)+3*ispositive(a)*ispositive(3-a)' -prefix catRms_Kur3Amp3
