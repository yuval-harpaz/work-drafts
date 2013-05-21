cd /media/YuvalExtDrive/VM/Data
%% compute tetrahedrons SAMNwts considering possible homolog correlations
SAMNwtsTetra3(boxSize,stepSize,outside,distance,SAMcfg);
%% Compute regular SAMwts
!SAMwts64 -r oddball -d xc,hb,lf_c,rfhp0.1Hz -m allTrials1S -c Alla -v
%% make ERF images
!~/abin/3dSkullStrip -input warped+orig -prefix mask -mask_vol -skulls -o_ply ortho
!~/abin/3dresample -dxyz 5 5 5 -prefix mask5 -inset mask+orig -rmode Cu
!~/abin/3dfractionize -template S1wts+orig -input mask5+orig -prefix maskGood
!~/abin/3dcalc -a maskGood+orig -exp "ispositive(a)" -prefix mask1
!rm mask+orig* mask5+orig* maskGood+orig*
!rm *.ply
cd oddball
load standard
%read weights
wtsNoSuf='SAM/allTrials1S,1-40Hz,Alla';
[SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
% make normalization factor
ns=ActWgts;
ns=ns-repmat(mean(ns,2),1,size(ns,2));
ns=abs(ns);
ns=mean(ns,2);


vsStS=ActWgts*standard.avg;
ns=repmat(ns,1,size(vsStS,2));
vsStS=vsStS./ns;
vsStS=vsStS./max(max(vsStS));
% load mask
% mask=repmat(mask,1,size(vsStS,2));
% vsStS=vsStS.*mask;
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='S1wts';
cfg.torig=-200;
cfg.TR=1/1.017;
VS2Brik(cfg,vsStS);
!~/abin/3dcalc -a S1wts+orig -b mask1+orig -exp "a*b" -prefix S1wtsM

load SAM/tetraWts
vsN=tetraWts*standard.avg;
vsN=vsN./ns;
vsN=vsN./max(max(vsN));
cfg.prefix='S1Nwts';
VS2Brik(cfg,vsN);
!~/abin/3dcalc -a S1Nwts+orig -b mask1+orig -exp "a*b" -prefix S1NwtsM


%% compute correlations
corrNWts=zeros(length(tetraWts),1);
corrWts=zeros(length(tetraWts),1);
time1=nearest(standard.time,-0.15);
time2=nearest(standard.time,0.1);
for Xi=-12:0.5:12
    for Yi=-9:0.5:-0.1
        for Zi=-2:0.5:15
            [indL,~]=voxIndex([Xi,Yi,Zi],cfg.boxSize./10,0.5,0);
            [indR,~]=voxIndex([Xi,-Yi,Zi],cfg.boxSize./10,0.5,0);
            if ~isnan(vsStS(indL,time1)) && ~isnan(vsStS(indR,time1))
                if ~vsStS(indL,time1)==0 && ~vsStS(indR,time1)==0
                    X1=vsStS(indL,time1:time2)';X2=vsStS(indR,time1:time2)';
                    r=corr([X1,X2]);
                    corrWts(indL,1)=abs(r(1,2));
                    corrWts(indR,1)=corrWts(indL,1);
                end
            end
            if ~isnan(vsN(indL,time1)) && ~isnan(vsN(indR,time1))
                if ~vsN(indL,time1)==0 && ~vsN(indR,time1)==0
                    X1=vsN(indL,time1:time2)';X2=vsN(indR,time1:time2)';
                    r=corr([X1,X2]);
                    corrNWts(indL,1)=abs(r(1,2));
                    corrNWts(indR,1)=corrNWts(indL,1);
                end
            end
        end
    end
    display(['X = ',num2str(Xi)])
end

cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='corrWtsBL';
VS2Brik(cfg,corrWts);
% cfg.prefix='corrNwtsBL';
% VS2Brik(cfg,corrNWts);
!~/abin/3dcalc -a corrWtsBL+orig -b mask1+orig -exp "a*b" -prefix corrBLM
!~/abin/3dcalc -a corrNwtsBL+orig -b mask1+orig -exp "a*b" -prefix corrNBLM

!~/abin/3dExtrema    -prefix maxCorr corrWtsBLM+orig

%
%filter?
% fs = 1017.25;                 % sampling rate
% F = [2 3 35 40];  % band limits
% A = [0 1 0];                % band type: 0='stop', 1='pass'
% dev = [0.0001 10^(0.1/20)-1 0.0001]; % ripple/attenuation spec
% [M,Wn,beta,typ] = kaiserord(F,A,dev,fs);  % window parameters
% b = fir1(M,Wn,typ,kaiser(M+1,beta),'noscale'); % filter design
%
%
% rng default;
% Fs = 1017.25;
% t = linspace(0,1,Fs);
% x = vsN(9568,:);
% % Using fir1
% fc = 150;
% Wn = (2/Fs)*fc;
% b = fir1(20,Wn,'low',kaiser(21,3));
% % Using fdesign.lowpass
% d = fdesign.lowpass('N,Fc',20,150,Fs);
% Hd = design(d,'window','Window',kaiser(21,3));
%
%
%
% Fs = 1017.25;  % Sampling Frequency
% N   = 10;  % Order
% Fc1 = 3;   % First Cutoff Frequency
% Fc2 = 35;  % Second Cutoff Frequency
% % Construct an FDESIGN object and call its BUTTER method.
% h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
% Hd = design(h, 'butter');
% xf=filter(Hd,x);
% plot([x',xf'])
% legend('raw','filt')


BandPassSpecObj=fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',...
    3,4,20,30,60,1,60,Fs);
BandPassFilt=design(BandPassSpecObj  ,'butter');
testFilt
filtData= yhFilt(vsN,BandPassFilt);

cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='S1Nwtsf';
cfg.torig=-200;
cfg.TR=1/1.017;
VS2Brik(cfg,filtData);
!~/abin/3dcalc -a S1Nwtsf+orig -b mask1+orig -exp "a*b" -prefix S1NwtsMf

%% OK, let's go for local maxima
% first wts, then focus on maxima for Nwts
corrWts=zeros(length(tetraWts),1);
time1=nearest(standard.time,-0.15);
time2=nearest(standard.time,0.1);
for Xi=-12:0.5:12
    for Yi=-9:0.5:0
        for Zi=-2:0.5:15
            if Yi==0;
                [ind0,~]=voxIndex([Xi,Yi,Zi],cfg.boxSize./10,0.5,0);
                corrWts(ind0,1)=1;
            else
                [indL,~]=voxIndex([Xi,Yi,Zi],cfg.boxSize./10,0.5,0);
                [indR,~]=voxIndex([Xi,-Yi,Zi],cfg.boxSize./10,0.5,0);
                if ~isnan(vsStS(indL,time1)) && ~isnan(vsStS(indR,time1))
                    if ~vsStS(indL,time1)==0 && ~vsStS(indR,time1)==0
                        X1=vsStS(indL,time1:time2)';X2=vsStS(indR,time1:time2)';
                        r=corr([X1,X2]);
                        % normalize by wts correlation
                        rw=corr([ActWgts(indL,:)',ActWgts(indR,:)']);
                        corrWts(indL,1)=abs(r(1,2))./abs(rw(1,2));
                        corrWts(indR,1)=corrWts(indL,1);
                    end
                end
            end
        end
    end
    display(['X = ',num2str(Xi)])
end

cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='corrWtsBL';
VS2Brik(cfg,corrWts);
% cfg.prefix='corrNwtsBL';
% VS2Brik(cfg,corrNWts);
!~/abin/3dcalc -a corrWtsBL+orig -b mask1+orig -exp "a*b" -prefix corrBLM
if exist('corrClst+orig.BRIK','file')
    !rm corrClst+*
end
% !~/linux_openmp_64/3dclust -1noneg  -savemask -prefix corrClst -1Dformat -1thresh 10 5 2000 corrBLM+orig
!~/abin/3dclust -noabs  -savemask -1Dformat -1thresh 10 5 2000 corrBLM+orig
movefile('-1Dformat+orig.BRIK','corrClst+orig.BRIK')
movefile('-1Dformat+orig.HEAD','corrClst+orig.HEAD')
!~/abin/3dmaskdump  -xyz -mask corrClst+orig -noijk corrClst+orig > mask.txt
%!~/abin/3dmaskdump  -xyz -mask corrClst+orig -mrange 1 1 corrClst+orig > mask1.txt
clust=importdata('mask.txt');
clust1=clust(clust(:,4)==1,:);
clustTemp=-clust1(:,2);
clustTemp(:,2:3)=clust1(:,[1,3]);
clustTemp=clustTemp./10; % mm to cm
save clustTemp clustTemp


time1=nearest(standard.time,0.035);
time2=nearest(standard.time,0.1);
vsN=tetraWts*standard.avg;
corrWts=zeros(size(clustTemp,1),size(clustTemp,1));
for vsi=1:size(clustTemp,1)
    Xi=clustTemp(vsi,1);
    Yi=clustTemp(vsi,2);
    Zi=clustTemp(vsi,3);
    [indL,~]=voxIndex([Xi,Yi,Zi],cfg.boxSize./10,0.5,0);
    for vsj=1:size(clustTemp,1)
        Xj=clustTemp(vsj,1);
        Yj=-clustTemp(vsj,2);
        Zj=clustTemp(vsj,3);
        [indR,~]=voxIndex([Xj,Yj,Zj],cfg.boxSize./10,0.5,0);
        try
        X1=vsN(indL,time1:time2)';X2=vsN(indR,time1:time2)'; % fixme - make SAMNwts
        r=corr([X1,X2]);
        corrWts(vsi,vsj)=abs(r(1,2));
        catch
            display('oops')
        end
    end
end
imagesc(corrWts)
[vi,j]=max(max(corrWts))
[vj,i]=max(max(corrWts'))
[mx,i]=max(v)



 

