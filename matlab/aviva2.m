% make anat
cd /media/yuval/YuvalExtDrive/Data/Aviva/MRI
load SubsCon
for subi=4:length(Subs);
    cd /media/yuval/YuvalExtDrive/Data/Aviva/MRI/Subjects/Controls_Anatomy
    cd(Subs{subi})
    [~,w]=unix('to3d -prefix anat *.dcm');
end

cd /media/yuval/YuvalExtDrive/Data/Aviva/MRI
load SubsMed
for subi=1:length(Subs);
    cd /media/yuval/YuvalExtDrive/Data/Aviva/MRI/Subjects/Meditators_Anatomy
    cd(Subs{subi})
    [~,w]=unix('to3d -prefix anat *.dcm');
end

cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG/
load contNames
for subi=1:length(contNames)
    initials=contNames{subi,1}(1);
    sep=findstr(contNames{subi,1},' ');
    initials(2)=contNames{subi,1}(sep(1)+1);
    p2a=['/media/yuval/YuvalExtDrive/Data/Aviva/MRI/Subjects/Controls_Anatomy/',initials,'_anatomy'];
    p2m=[contNames{subi,2},'/MRI'];
    if strcmp(p2m(end-5),'0')
        p2m(end-5)='';
    end
    if exist(p2a,'dir')
        if ~exist(p2m,'dir')
            mkdir (p2m)
        end
        if ~exist([p2m,'/anat+orig.HEAD'],'file')
            [~,w]=unix(['cp ',p2a,'/anat+orig* ',p2m,'/'])
        end
    else
        warning(['no anatomy for sub ',num2str(subi),' (',contNames{subi,1},'=',initials,')'])
    end
end
% no anatomy for sub 13 (Anita Tamari=AT)

cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG/
load medNames
for subi=1:length(medNames)
    initials=medNames{subi,1}(1);
    sep=findstr(medNames{subi,1},' ');
    initials(2)=medNames{subi,1}(sep(1)+1);
    if strcmp(initials,'YG')
        initials='JG';
    elseif strcmp(initials,'RV')
        initials='VI';
    end
    p2a=['/media/yuval/YuvalExtDrive/Data/Aviva/MRI/Subjects/Meditators_Anatomy/',initials,'_anatomy'];
    p2m=['MM',num2str(subi),'/MRI'];
    if exist(p2a,'dir')
        if ~exist(p2m,'dir')
            mkdir (p2m)
        end
        if ~exist([p2m,'/anat+orig.HEAD'],'file')
            [~,w]=unix(['cp ',p2a,'/anat+orig* ',p2m,'/'])
        end
    else
        warning(['no anatomy for sub ',num2str(subi),' (',medNames{subi,1},'=',initials,')'])
    end
end
% no anatomy for sub 3 (Avi Peer=AP) 
% no anatomy for sub 15 (Yonathan Harrison=YH)
%% 
cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG

% DIR=dir('MM*');
% for subi=1:length(DIR)
%     Subs{subi,1}=DIR(subi).name
% end
% save Subs Subs
load Subs
for subi=4:length(Subs)
%subi=3
    cd /media/yuval/YuvalExtDrive/Data/Aviva/MEG
    cd(Subs{subi})
    cd MRI
    if ~exist('../1/hs_file','file')
        disp('')
        disp(['no headshape for ',Subs{subi}])
%     if ~exist('./sub.tag','file')
%         !cp ~/SAM_BIU/docs/MNI305.tag ./sub.tag
%         !cp ../1/hs_file ./
    end
   % prog (subi)
end


afni % edit tagset
[~,w]=unix('3dTagalign -master /home/yuval/brainhull/master+orig -prefix ortho anat+orig ')

hs2afni
afni % Nudge
!3dSkullStrip -input ortho+orig -prefix mask -mask_vol -skulls -o_ply ortho
!meshnorm ortho_brainhull.ply > hull.shape
!cp hull.shape ../1/
!@auto_tlrc -base ~/SAM_BIU/docs/temp+tlrc -input ortho+orig -no_ss
%%
% get subject name from MMnames.xls
% get coordinates from "participant DMN coo...xls"
% coords=[-5 -53 28;3 -52 24; -48 -65 30; 39 -64 27; -10 53 17; 7 60 17];
% labels={'L-Prc';'R-Prc';'L-IPL';'R-IPL';'L-mPFC';'R-mPFC'}
pri=tlrc2orig(coords)

grid2t(pri./10);
if ~exist('SAM','dir')
    mkdir SAM
end
!cp pnt.txt SAM/pnt.txt
load dataRejectIcaEye
trl2mark(dataRejectIcaEye);
cd ..
!cp ~/SAM_BIU/docs/SuDi0811.rtw 1/1.rtw


!SAMcov64 -r 1 -d xc,hb,lf_c,rfhp0.1Hz -m general -v
!SAMwts64 -r 1 -d xc,hb,lf_c,rfhp0.1Hz -m general -c Alla -t pnt.txt -v

 [~, ~, wts]=readWeights('1/SAM/pnt.txt.wts');
 for triali=1:length(dataRejectIcaEye.trial)
     f=fftBasic(dataRejectIcaEye.trial{triali},dataRejectIcaEye.fsample);
     ff(1:6,1:100,triali)=abs(wts*f(:,1:100));
 end
for freqi=1:100
    rr(1:6,1:6,freqi)=corr(squeeze(ff(:,freqi,:))');
end
rAlpha=mean(rr(:,:,8:12),3)