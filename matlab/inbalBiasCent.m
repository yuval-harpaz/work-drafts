function [distsVec,Vvec]=inbalBiasCent(sub,experiment)
% inbalClust1(5,'S',271);

cd /media/YuvalExtDrive/Inbal_Yuval_project
cd (num2str(sub))
fn=['New_orig_',experiment];
%maxOrig=getMax(fn,0);


if exist('distance.mat','file')
    load distance
    [~, V, ~, ~] = BrikLoad ([fn,'+orig']);
    V=mean(V(:,:,:,1:203),4);
    V=V/max(V(:));
    Vvec=V(:);
else
    
    
    eval(['!3dcalc -a ',fn,'+orig''','[0]''',' -exp "a*1" -prefix orig',experiment,'BL']);
    [~, ~, Info, ~] = BrikLoad (['orig',experiment,'BL+orig']);
    [~, V, ~, ~] = BrikLoad ([fn,'+orig']);
    V=mean(V(:,:,:,1:203),4);
    V=V/max(V(:));
    Vvec=V(:);
    eval(['!rm orig',experiment,'BL*']);
    OptTSOut.Scale = 1;
    OptTSOut.Prefix = ['orig',experiment,'BL'];
    OptTSOut.verbose = 1;
    WriteBrik (V, Info, OptTSOut);
    eval(['!3dExtrema -volume -data_thr 0.9 orig',experiment,'BL+orig > scrap'])
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
end
Vvec=Vvec(inside);
figure;
scatter(distsVec,Vvec,'r.') %
title('ORIG')

covVec=getBL(experiment,'cov',inside);
figure;
scatter(distsVec,covVec,'r.')
title('COV')

svdVec=getBL(experiment,'svd',inside);
figure;
scatter(distsVec,svdVec,'r.')
title('SVD')

emptyVec=getBL(experiment,'empty',inside);
figure;
scatter(distsVec,emptyVec,'r.')
title('EMPTY')


function vec=getBL(experiment,nType,inside)
if strcmp('empty',nType)
    fn=['New_Rs_EmptyRoom_',experiment];
else
    fn=['New_N',nType,'_',experiment];
end
[~, V, ~, ~] = BrikLoad ([fn,'+orig']);
V=mean(V(:,:,:,1:203),4);
V=V/max(V(:));
V=V(:);
vec=V(inside);

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
