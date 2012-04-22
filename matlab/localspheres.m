cfg                        = [];
cfg.feedback               = 'yes';
cfg.grad = dataorig.grad;
cfg.headshape='hs_file';
%cfg.channel={'MEG'};
%cfg.singlesphere='yes';
cfg.radius                 = 0.45;
%cfg.maxradius              = 0.2;
vol  = ft_prepare_localspheres(cfg);

cfg                        = [];
cfg.feedback               = 'yes';
cfg.grad = ft_convert_units(dataorig.grad,'cm');
cfg.headshape='hs_file';
cfg.radius                 = 7;
cfg.headshape=ft_convert_units(hs,'cm');
vol  = ft_prepare_localspheres_BIU(cfg);
vol=ft_convert_units(vol,'m');
cfg5 = [];
cfg5.latency = [0.03 0.045];  % specify latency window around M50 peak
cfg5.numdipoles = 1;
cfg5.vol=vol;
cfg5.feedback = 'textbar';
cfg.res=2;
%cfg5.gridsearch='yes';
%cfg5.grid=grid;
dip = ft_dipolefitting(cfg5, leftIndSom);
%% show the dipole within the headshape
hs=ft_read_headshape('hs_file');
hsx=hs.pnt(:,1);hsy=hs.pnt(:,2);hsz=hs.pnt(:,3);
plot3(hsx,hsy,hsz,'rx');hold on;
plot3(dip.dip.pos(1,1),dip.dip.pos(1,2),dip.dip.pos(1,3),'bo')
% rotate the image to find the blue 'o'.
