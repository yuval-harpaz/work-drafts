function [pnt,lf,vol]=sphereGrid(N,inwardShift)
% N can be 12, 42, 162, 642, ... points. see GridSphere for more
% inwardShift is how much inward from hs sphere the brain is in cm
% hs_file and data (c,rf..) has to be present
if ~existAndFull('N')
    N=642;
end
if ~existAndFull('inwardShift')
    inwardShift=1;
end
hs=ft_read_headshape('hs_file');
[o,r] = fitsphere(hs.pnt);
vol=[];
vol.o=o*100;vol.r=r*100;
vol.unit='cm';
vol.type='singlesphere';
pnt = GridSphereYH(500);
pnt=pnt*(vol.r-inwardShift);
pnt=pnt+repmat(vol.o,length(pnt),1);
% 
% ft_plot_vol(vol)
% hold on
% plot3pnt(pnt1,'or')
% plot3pnt(hs.pnt*100,'.k')
%
hdr=ft_read_header(source);
grad=ft_convert_units(hdr.grad,'cm');
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