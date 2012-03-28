function ambPlotStat(prefix,lowlim,method)
if ~exist('method','var')
    method=[];
end
if isempty(method)
    method='ortho';
end
cfg1=[];probplot=[];cfg2=[];statplot=[];
load ([prefix,'stat.mat'])
cfg = [];
cfg.parameter = 'prob'; %'all' 'prob' 'stat' 'mask'
% cfg.downsample = 2;
load ~/ft_BIU/matlab/LCMV/sMRI
%read_mri('/home/meg/Documents/MATLAB/spm8/canonical/single_subj_T1.nii');
%probplot = sourceinterpolate(cfg, stat,sMRI)
probplot=stat;
probplot.prob1=1-probplot.prob;
if ~exist('lowlim','var')
    lowlim=[];
elseif isempty(lowlim)
    lowlim=0.95;
end


if ~exist('aal_MNI_V4.img','file')==2
    copyfile ~/ft_BIU/matlab/files/aal_MNI_V4.img ./
    copyfile ~/ft_BIU/matlab/files/aal_MNI_V4.hdr ./
end
if max(max(max(probplot.prob1>=lowlim)))==1;
    probplot.mask=(probplot.prob1>=lowlim);
    probplot.anatomy=sMRI.anatomy;
    cfg1 = [];
    cfg1.funcolorlim = [lowlim 1];
    cfg1.funparameter = 'prob1';
    cfg1.maskparameter= 'mask';
    cfg1.method=method;
    cfg1.inputcoord='mni';
    if strcmp(method,'ortho')
        cfg1.interactive = 'yes';
    elseif strcmp(method,'surface')
        cfg1.projmethod     = 'project';
        cfg1.surffile='~/ft_BIU/matlab/ft_files/single_subj_T1.mat';
    else % slice
        cfg1.nslices=3;
        cfg1.slicerange=[32 52];
    end
%    cfg1.atlas='aal_MNI_V4.img';
    %cfg1.roi='Frontal_Sup_L'
    %cfg1.location=[-42 -58 -11];% wer= -50 -45 10 , broca= -50 25 0, fussiform = -42 -58 -11(cohen et al 2000), change x to positive for RH.
    %cfg1.crosshair='no';
    figure
    ft_sourceplot(cfg1,probplot)
    %figure; YHsourceplot(cfg1,probplot); % requires roi
    cfg.parameter = 'stat';
    %statplot = sourceinterpolate(cfg, stat,sMRI)
    statplot=stat;
    statplot.anatomy=sMRI.anatomy;
    cfg2=rmfield(cfg1,'funcolorlim');
    cfg2.funcolorlim = [-3.5 3.5];
    cfg2.funparameter = 'stat';
    cfg2.method='ortho';
    cfg2.inputcoord='mni';
    
    %cfg2.atlas='aal_MNI_V4.img';
    figure
    ft_sourceplot(cfg2,statplot)
else warning('no significant results')
    %display('change lower p value limit to explore map by running: lowlim=0.9;')
    %display(['[cfg1,probplot,cfg2,statplot]=monteT(''',compt,''',','''',condA,''',','''',condB,''',lowlim);'])
end
end




