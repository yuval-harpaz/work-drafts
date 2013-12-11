function biasCent(sub,wtsFN)
% [distsVec,Vvec]=biasCent('/home/yuval/Copy/MEGdata/alice/idan','alpha,7-13Hz,alla.wts')
% inbalClust1(5,'S',271);
if exist('sub','var')
    if ~isempty(sub)
        cd (num2str(sub))
    end
end
if ~exist('wtsFN','var')
    wtsFN='';
end
cd SAM
if isempty(wtsFN)
    try
        wtsFN=ls('*.wts')
        wtsFN=wtsFN(1:end-1);
    catch
        error('did not find wts file')
    end
end

if length(findstr('.wts',wtsFN))>1
    error('more than 1 wts file found')
end
[~, ~, ActWgts]=readWeights(wtsFN);
cd ..
try
    fn=ls('*_c,*');
catch
    try
        fn=ls('c,*');
    catch
        error('did not find MEG data')
    end
end
fn=fn(1:end-1);
dashi=findstr('-',wtsFN);
filti=regexp(wtsFN(1:dashi),'\d');
filt1=str2num(wtsFN(filti));
filti=regexp(wtsFN(dashi:end),'\d');
filt2=str2num(wtsFN(dashi+filti-1));


cfg=[];
cfg.trl=[1 10172 0];
cfg.dataset=fn;
cfg.bpfreq=[filt1 filt2];
cfg.bpfilter='yes';
cfg.channel='MEG';
cfg.demean='yes';
data=ft_preprocessing(cfg);


%vs=ActWgts*data.trial{1,1};
mWts=mean(abs(ActWgts),2);
mWts=mWts(find(ActWgts(:,1)>0));
scale=mean(log10(mWts));
if ~exist('10sRaw+orig.BRIK','file')
    intensity=mean(abs(ActWgts*data.trial{1,1}),2);
    cfg=[];
    cfg.step=5;
    cfg.boxSize=[-120 120 -90 90 -20 150];
    cfg.prefix='10sRaw';
    VS2Brik(cfg,intensity)
end
if ~exist('10sMeanAbs+orig.BRIK','file')
    intensity=mean(abs(ActWgts*data.trial{1,1}),2)./mean(abs(ActWgts),2);
    cfg=[];
    cfg.step=5;
    cfg.boxSize=[-120 120 -90 90 -20 150];
    cfg.prefix='10sMeanAbs';
    VS2Brik(cfg,intensity)
end
if ~exist('10sMeanSq+orig.BRIK','file')
    intensity=mean(abs(ActWgts*data.trial{1,1}./repmat(mean(ActWgts.^2,2),1,size(data.trial{1,1},2))),2);
    cfg=[];
    cfg.step=5;
    cfg.boxSize=[-120 120 -90 90 -20 150];
    cfg.prefix='10sMeanSq';
    VS2Brik(cfg,intensity)
end
if ~exist('10sRMS+orig.BRIK','file')
    intensity=mean(abs(ActWgts*data.trial{1,1}),2)./sqrt(mean(ActWgts.^2,2));
    cfg=[];
    cfg.step=5;
    cfg.boxSize=[-120 120 -90 90 -20 150];
    cfg.prefix='10sRMS';
    VS2Brik(cfg,intensity)
end
clear intensity data
[~, V, ~, ~] = BrikLoad ('10sRaw+orig');
Vvec=V(:);
if exist('distance.mat','file')
    load distance
else
    !3dExtrema -volume 10sRaw+orig > scrap
    !awk '/---/{getline; print}' scrap > scrap1
    txt=importdata('scrap1');
    originRAI=txt(3:5);
    originPRI=[-originRAI(2),originRAI(1),originRAI(3)];
    xc=0;
    yc=0;
    zc=0;
    disp('calculating distances')
    dists=zeros(size(V));
    for xi=-120:5:120
        xc=xc+1;
        %disp(num2str(xc))
        for yi=-90:5:90
            yc=yc+1;
            if yc==38
                yc=1;
            end
            
            for zi=-20:5:150
                
                zc=zc+1;
                if zc==36
                    zc=1;
                end
                if ~V(xc,yc,zc)==0
                    dists(xc,yc,zc)=sqrt((xi-originPRI(1))^2+(yi-originPRI(2))^2+(zi-originPRI(3))^2);
                end
            end
        end
    end
    distsVec=dists(:);
    inside=find(Vvec>0);
    distsVec=distsVec(inside);
    save distance distsVec inside
end
Vvec=Vvec(inside);
figure;
scatter(distsVec,Vvec,'r.') %
title('Raw')

[~, V, ~, ~] = BrikLoad ('10sMeanAbs+orig');
Vvec=V(:);
Vvec=Vvec(inside)*10^scale;
figure;
scatter(distsVec,Vvec,'r.') %
title('Mean Absolute')
[~, V, ~, ~] = BrikLoad ('10sMeanSq+orig');
Vvec=V(:);
Vvec=Vvec(inside)*10^(2*scale);
figure;
scatter(distsVec,Vvec,'r.') %
title('Mean Square')
[~, V, ~, ~] = BrikLoad ('10sRMS+orig');
Vvec=V(:);
Vvec=Vvec(inside)*10^scale;
figure;
scatter(distsVec,Vvec,'r.') %
title('RMS')
end
% if exist('distance.mat','file')
%     load distance
%     [~, V, ~, ~] = BrikLoad ([fn,'+orig']);
%     V=mean(V(:,:,:,1:203),4);
%     V=V/max(V(:));
%     Vvec=V(:);
% else
%     eval(['!3dcalc -a ',fn,'+orig''','[0]''',' -exp "a*1" -prefix orig',experiment,'BL']);
%     [~, ~, Info, ~] = BrikLoad (['orig',experiment,'BL+orig']);
%     [~, V, ~, ~] = BrikLoad ([fn,'+orig']);
%     V=mean(V(:,:,:,1:203),4);
%     V=V/max(V(:));
%     Vvec=V(:);
%     eval(['!rm orig',experiment,'BL*']);
%     OptTSOut.Scale = 1;
%     OptTSOut.Prefix = ['orig',experiment,'BL'];
%     OptTSOut.verbose = 1;
%     WriteBrik (V, Info, OptTSOut);
%     eval(['!3dExtrema -volume -data_thr 0.9 orig',experiment,'BL+orig > scrap'])
%     !awk '/---/{getline; print}' scrap > scrap1
% 
% 
% covVec=getBL(experiment,'cov',inside);
% figure;
% scatter(distsVec,covVec,'r.')
% title('COV')
% 
% svdVec=getBL(experiment,'svd',inside);
% figure;
% scatter(distsVec,svdVec,'r.')
% title('SVD')
% 
% emptyVec=getBL(experiment,'empty',inside);
% figure;
% scatter(distsVec,emptyVec,'r.')
% title('EMPTY')
% 
% 
% function vec=getBL(experiment,nType,inside)
% if strcmp('empty',nType)
%     fn=['New_Rs_EmptyRoom_',experiment];
% else
%     fn=['New_N',nType,'_',experiment];
% end
% [~, V, ~, ~] = BrikLoad ([fn,'+orig']);
% V=mean(V(:,:,:,1:203),4);
% V=V/max(V(:));
% V=V(:);
% vec=V(inside);

%


% %!3dcalc -a New_Ncov_S+orig'[250]' -b New_Nsvd_S+orig'[250]' -c New_Rs_EmptyRoom_S+orig'[250]' -exp "(a/3.43+b/14.86+c/725.8)/2" -prefix allSom
% eval(['!3dclust -savemask mask',experiment,' -1Dformat -nosum -1dindex 0 -1tindex 0 -2thresh -0.60 0.60 -dxyz=1 1.01 55 all',experiment,'+orig.HEAD'])
% eval(['!3dcalc -a mask',experiment,'+orig -b ',fnCov,'+orig -exp "b-b*a/a" -prefix cov',experiment,'_noise'])
% eval(['!3dcalc -a mask',experiment,'+orig -b ',fnSvd,'+orig -exp "b-b*a/a" -prefix svd',experiment,'_noise'])
% eval(['!3dcalc -a mask',experiment,'+orig -b ',fnEmpty,'+orig -exp "b-b*a/a" -prefix empty',experiment,'_noise'])
% !3dcalc -a mask+orig -b svd250+orig -exp "b-b*a" -prefix svd_noise
% !3dcalc -a mask+orig -b empty250+orig -exp "b-b*a" -prefix empty_noise

% function maxVal=getMax(prefix,timeInd)
% eval(['!3dBrickStat -max ',prefix,'+orig','''[',num2str(timeInd),']''', ' > scrap'])
% % txt=importdata('scrap');
% txt=textread('scrap','%s');
% maxVal=txt{1,1};
