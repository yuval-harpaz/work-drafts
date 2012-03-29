function ambPlotStat1(prefix,lims,method,loc)
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
if ~exist('lims','var')
    lims=[];
elseif isempty(lims)
    lims=[0.95 1];
end


if ~exist('aal_MNI_V4.img','file')==2
    copyfile ~/ft_BIU/matlab/files/aal_MNI_V4.img ./
    copyfile ~/ft_BIU/matlab/files/aal_MNI_V4.hdr ./
end
if max(max(max(probplot.prob1>=lims(1))))==1;
    probplot.mask(probplot.prob1>=lims(1))=0.5;
    probplot.anatomy=sMRI.anatomy;
    cfg1 = [];
    cfg1.funcolorlim = [lims(1) lims(2)];
    cfg1.funparameter = 'prob1';
    cfg1.maskparameter= cfg1.funparameter;
    cfg1.method=method;
    cfg1.inputcoord='mni';
    %cfg1.opacitylim=    [0.998 1];% 'maxabs' 'zeromax' 'minzero' 'auto'
    if strcmp(method,'ortho')
        % cfg1.interactive = 'yes';
        cfg1.crosshair='no';
        % find location of maximum value in the t map
        [maxval, maxindx] = max(stat.stat(:));
        [xi, yi, zi] = ind2sub(stat.dim, maxindx);
        ijk = [xi yi zi 1]';
        xyz = stat.transform * ijk;
        cfg1.location=[xyz(1), xyz(2), xyz(3)];
        cfg1.colorbar='no';
        %cfg1.maskparameter='0.5';
        if exist('loc','var')
            if ~isempty(loc)
                for locaxi=1:length(loc)
                    cfg1.location(1,locaxi)=loc(1,locaxi);
                end
            end
        end
    elseif strcmp(method,'surface')
        cfg1.projmethod     = 'project';
        cfg1.surffile='~/ft_BIU/matlab/ft_files/single_subj_T1.mat';
    else % slice
        cfg1.nslices=3;
        cfg1.slicerange=[32 52];
        % cfg1.slicedim=1; not supported
    end
%    cfg1.atlas='aal_MNI_V4.img';
    %cfg1.roi='Frontal_Sup_L'
    %cfg1.location=[-42 -58 -11];% wer= -50 -45 10 , broca= -50 25 0, fussiform = -42 -58 -11(cohen et al 2000), change x to positive for RH.
    
    figure
    ft_sourceplot(cfg1,probplot)
    %figure; YHsourceplot(cfg1,probplot); % requires roi
    %statplot = sourceinterpolate(cfg, stat,sMRI)
    statplot=stat;
    statplot.anatomy=sMRI.anatomy;
    cfg2=rmfield(cfg1,'funcolorlim');
    cfg2.colorbar='yes';
    cfg2.funcolorlim = [-3.5 3.5];
    cfg2.funparameter = 'stat';
    cfg2.method='ortho';
    cfg2.inputcoord='mni';
    
    %cfg2.atlas='aal_MNI_V4.img';
    figure
    ft_sourceplot(cfg2,statplot)
else warning('no significant results')
end
end




