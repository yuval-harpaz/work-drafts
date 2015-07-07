function [Grid,ftLeadfield,ori]=fs2grid(cfg)
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
if cfg.subset %some 8000 points
    lh=fwd.src(1).rr(fwd.src(1).vertno,:); % same as fwd.source_nn
    rh=fwd.src(2).rr(fwd.src(2).vertno,:);
    lhori=fwd.src(1).nn(fwd.src(1).vertno,:); % same as fwd.source_nn
    rhori=fwd.src(2).nn(fwd.src(2).vertno,:);
else
    lh=fwd.src(1).rr;
    rh=fwd.src(2).rr;
    lhori=fwd.src(1).nn; % same as fwd.source_nn
    rhori=fwd.src(2).nn;
end

Grid.pos=[lh;rh]; % from LPI to PRI
Grid.pos=Grid.pos(:,[2,1,3]);
Grid.pos(:,2)=-Grid.pos(:,2);
Grid.unit='m';
Grid.inside=true(length(Grid.pos),1);

if nargout>2
    ori=[lhori;rhori];
    ori=ori(:,[2,1,3]);
    ori(:,2)=-ori(:,2);
else
    ori=[];
end
clear lh* rh*

if size(fwd.sol.data,2)==fwd.nsource
    for posi=1:length(Grid.pos)
        Grid.leadfield{1,posi}=fwd.sol.data(:,posi);
    end
elseif size(fwd.sol.data,2)==fwd.nsource*3
    colCount=0;
    for posi=1:length(Grid.pos)
        for axisi=1:3
            colCount=colCount+1;
            Grid.leadfield{1,posi}(1:fwd.nchan,axisi)=fwd.sol.data(:,colCount);
        end
        Grid.leadfield{1,posi}=Grid.leadfield{1,posi}(:,[2,1,3]);
        Grid.leadfield{1,posi}(:,2)=-Grid.leadfield{1,posi}(:,2);
    end
else
    error('something didnt match with the size of the leadfield matrix wd.sol.data')
end
for chani=1:fwd.nchan;
    Grid.label{chani,1}=['A',num2str(chani)];
end

if exist(source,'file') && nargout>1
    hdr=ft_read_header(source);
    hs=ft_read_headshape('hs_file');
    [cfgLF.vol.o,cfgLF.vol.r]=fitsphere(hs.pnt);
    cfgLF.grad=hdr.grad;
    cfgLF.grid=Grid;
    cfgLF.channel='MEG';
    ftLeadfield=ft_prepare_leadfield(cfgLF);
else
    ftLeadfield=[];
end