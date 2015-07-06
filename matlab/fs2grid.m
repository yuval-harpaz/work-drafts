function [Grid,ftLeadfield]=fs2grid(cfg)
% finds freesurfer surface in MEG space from MNE *fwd.fif file
% if there is more than one such file in the current directory give it
% cfg.fileName. cfg.subset = true to select only the surface points used
% if you want the ft leadfealds run the function from where the data is.
% for the fwd solution
if ~exist('cfg','var')
    Dir=dir('*fwd.fif');
    if length(Dir)==1;
        cfg.fileName=Dir(1).name;
    else
        error('got to give *fwd.fif as cfg.fileName')
    end
end
if ~isfield(cfg,'subset')
    cfg.subset=true;
end
fwd=mne_read_forward_solution(cfg.fileName);
%lh_pial=mne_read_surface('lh.pial');
if cfg.subset
    lh=fwd.src(1).rr(fwd.src(1).vertno,:);
    rh=fwd.src(2).rr(fwd.src(2).vertno,:);
else
    lh=fwd.src(1).rr;
    rh=fwd.src(2).rr;
end
priBrain=[lh;rh];
priBrain=priBrain(:,[2,1,3]);
priBrain(:,2)=-priBrain(:,2);
Grid.pos=priBrain;
clear priBrain lh rh
Grid.unit='m';
Grid.inside=true(length(Grid.pos),1);

if exist(source,'file') && nargout>1
    hdr=ft_read_header(source);
    hs=ft_read_headshape('hs_file');
    [cfgLF.vol.o,cfgLF.vol.r]=fitsphere(hs.pnt);
    cfgLF.grad=hdr.grad;
    cfgLF.grid=Grid;
    cfgLF.channel='MEG';
    lf=ft_prepare_leadfield(cfgLF);
else
    ftLeadfield=[];
end