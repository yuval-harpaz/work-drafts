%% dipole fit

cd /home/yuval/Data/camera/1;
load headmodel
load ../leftIndAvgs
t=0.252;
liAvg.grad=ft_convert_units(liAvg.grad,'mm');
cfg = [];
cfg.latency = [t t];  % specify latency window around M50 peak
cfg.numdipoles = 1;
cfg.vol=vol;
cfg.feedback = 'textbar';
cfg.gridsearch='yes';
dip = ft_dipolefitting(cfg, liAvg);

hs=ft_read_headshape('hs_file');
figure;plot3pnt(hs.pnt,'ro');
hold on;
ft_plot_dipole(dip.dip.pos/1000,dip.dip.mom/1000,'units','m')

cd /home/yuval/Data/camera/2;
load headmodel
li2Avg.grad=ft_convert_units(li2Avg.grad,'mm');
cfg = [];
cfg.latency = [t t];  % specify latency window around M50 peak
cfg.numdipoles = 1;
cfg.vol=vol;
cfg.feedback = 'textbar';
cfg.gridsearch='yes';
dip = ft_dipolefitting(cfg, li2Avg);

ft_plot_dipole(dip.dip.pos/1000,dip.dip.mom/1000,'units','m','color','green');

% hybrid model dipole fit
cd /home/yuval/Data/camera
load vol
load avgBoth
load grad496
t=0.252;
avgBoth.grad=grad;
cfg = [];
cfg.latency = [t t];  % specify latency window around M50 peak
cfg.numdipoles = 1;
cfg.vol=vol;
cfg.feedback = 'textbar';
cfg.gridsearch='yes';
cfg.channel     = avgBoth.label;
dip = ft_dipolefitting(cfg, avgBoth);
ft_plot_dipole(dip.dip.pos/1000,dip.dip.mom/1000,'units','m','color','blue');

