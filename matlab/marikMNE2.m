%% MNE, first run
cd /home/yuval/Data/camera/1;
load headmodel
load ../leftIndAvgs
load ../mesh
load leadfield
cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0.3];
cfg.channel='MEG';
cov=ft_timelockanalysis(cfg, liAvg);

cfg=[];
cfg.method = 'mne';
cfg.grid = leadfield;
cfg.vol = vol;
cfg.mne.lambda = 0.1;
cov.grad=liAvg.grad;
source = ft_sourceanalysis(cfg,cov);
figure;
bnd.pnt=mesh.tess_ctx.vert;
bnd.tri=mesh.tess_ctx.face;
ft_plot_mesh(bnd, 'vertexcolor', source.avg.pow(:,155));



%% mixed model
cd /home/yuval/Data/camera
load avgBoth

load vol
load grad496
cd 1
[~,~,mesh,~]=headmodel_BIU([],[],5,[],'localspheres');
cd ..
%plot3pnt(mesh.tess_ctx.vert,'.b')
cfg = [];
%cfg.grad = ft_convert_units(stdAvg.grad,'mm');
cfg.channel ='MEG';
cfg.grid.pos = mesh.tess_ctx.vert;
cfg.grid.inside = [1:size(mesh.tess_ctx.vert,1)]';
cfg.vol = vol;
cfg.grad=grad;
leadfield = ft_prepare_leadfield(cfg);
cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0.3];
cfg.channel='MEG';
cov=ft_timelockanalysis(cfg, avgBoth);

cfg=[];
cfg.method = 'mne';
cfg.grid = leadfield;
cfg.vol = vol;
cfg.mne.lambda = 1e8;
cov.grad=grad;
source = ft_sourceanalysis(cfg,cov);
figure;
bnd.pnt=mesh.tess_ctx.vert;
bnd.tri=mesh.tess_ctx.face;
ft_plot_mesh(bnd, 'vertexcolor', source.avg.pow(:,155));
