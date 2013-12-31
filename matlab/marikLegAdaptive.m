function marikLegAdaptive(cond,t)
% t=0.05112;
% cond=1;
fold=num2str(cond);
fn={'lToeIn','lToeOut2','lToeOut3'};
fn=fn{cond};
        


%% dipole fit
cd /home/yuval/Data/marik/4fingers
load adaptive
load (fn)
eval(['raw=',fn])
cd (fold)
cfg                        = [];
cfg.feedback               = 'no';
cfg.grad = raw.grad;
cfg.headshape='hs_file';
cfg.singlesphere='yes';
vol  = ft_prepare_localspheres_BIU(cfg);
showHeadInGrad([],'m');
hold on;
ft_plot_vol(vol);
title(['origin = ',num2str(vol.o)]);

hs=ft_read_headshape('hs_file');

cd ..
dn=raw;
dn.avg=zeros(size(raw.avg));
eval(['matSize=size(',fn,'DN);'])
nRow=num2str(matSize(1));
nCol=num2str(matSize(2));
eval(['dn.avg(1:',nRow,',1:',nCol,')=',fn,'DN;']);
cfg=[];
cfg.lpfilter='yes';
cfg.lpfreq=40;
rawLp=ft_preprocessing(cfg,raw);
dnLp=ft_preprocessing(cfg,dn);
dnLp=correctBL(dnLp,[-0.2 0]);
rawLp=correctBL(rawLp,[-0.2 0]);
cfg=[];
cfg.layout='4D248.lay';

cfg.xlim=[t t]; %0.06488 0.08454
cfg.zlim=[-5e-14 5e-14];
cfg.interactive='yes';
figure;


ft_topoplotER(cfg,raw,rawLp,dn,dnLp);



%li2Avg.grad=ft_convert_units(li2Avg.grad,'mm');

cfg = [];
cfg.latency = [t t];  % specify latency window around M50 peak
cfg.numdipoles = 1;
cfg.vol=vol;
cfg.feedback = 'textbar';
cfg.gridsearch='yes';
dip = ft_dipolefitting(cfg, raw);
hs=ft_read_headshape('1/hs_file');
figure;
plot3pnt(hs.pnt,'.k')
hold on
ft_plot_dipole(dip.dip.pos,dip.dip.mom,'units','m','color','green');
dipDN = ft_dipolefitting(cfg, dn);
ft_plot_dipole(dipDN.dip.pos,dipDN.dip.mom,'units','m','color','blue');
dipLp = ft_dipolefitting(cfg, rawLp);
ft_plot_dipole(dipLp.dip.pos,dipLp.dip.mom,'units','m','color','red');
dipDNLp = ft_dipolefitting(cfg, dnLp);
ft_plot_dipole(dipDNLp.dip.pos,dipDNLp.dip.mom,'units','m','color','w');
title('raw = green, dn = blue, filt = red, dn+filt = white')








