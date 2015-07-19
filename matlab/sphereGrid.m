function [pnt,lf,vol]=sphereGrid(N,inwardShift,symm,Nspheres)
% N can be 12, 42, 162, 642, 2562, 10242... points. see GridSphere for more
% inwardShift is how much inward from hs sphere the brain is in cm
% hs_file and data (c,rf..) has to be present
% when Nspheres > 1 there will be created this number of concentric spheres.
% step between spheres will be the distance between two points
if ~existAndFull('symm')
    symm=true;
end
if ~existAndFull('N')
    N=642;
end
if ~existAndFull('inwardShift')
    inwardShift=10;
end
if ~existAndFull('Nspheres')
    Nspheres=1;
end
hs=ft_read_headshape('hs_file');
[o,r] = fitsphere(hs.pnt);
vol=[];
vol.o=o*1000;vol.r=r*1000;
vol.unit='mm';
vol.type='singlesphere';
pntTemp = GridSphereYH(N,symm);
pnt=pntTemp*(vol.r-inwardShift)+repmat(vol.o,length(pntTemp),1);
insh=inwardShift;
dist=sqrt(sum([pnt(end,:)-pnt(end-1,:)].^2));
for inwardi=2:Nspheres
    insh=insh+dist;
    pnt=[pnt;pntTemp*(vol.r-insh)+repmat(vol.o,length(pntTemp),1)];
end
        
% pnt=pnt*(vol.r-inwardShift);
% pnt=pnt+repmat(vol.o,length(pnt),1);
% 
% ft_plot_vol(vol)
% hold on
% plot3pnt(pnt1,'or')
% plot3pnt(hs.pnt*100,'.k')
%

if exist ('./grad.mat','file')
    load ('./grad.mat')
    grad=ft_convert_units(grad,'mm');
else
    warning off
    hdr=ft_read_header(source);
    warning on
    grad=ft_convert_units(hdr.grad,'mm');
end

cfg = [];
cfg.grad = grad;
cfg.channel =grad.label(1:248);
cfg.grid.pos=pnt;
cfg.grid.inside=1:length(cfg.grid.pos);
cfg.vol = vol;
%cfg.reducerank      =  10;
cfg.normalize       = 'yes';
lf= ft_prepare_leadfield(cfg);
% leadfield_t.leadfield{1}(1,:)

% eval(['leadfield_',num2str(i),'= ft_prepare_leadfield(cfg);']);
% eval(['cfg.grad = data',num2str(i),'.grad;']);
% eval(['cfg.channel =data',num2str(i),'.label(1:chanN);']); %'MEG';
% cfg.grid.pos=mesh.tess_ctx.vert;
% cfg.grid.inside=1:length(cfg.grid.pos);
% vol.label=cfg.grad.label;