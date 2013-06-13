%% sam, first run
% ctx surface
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
cfg.method = 'sam';
cfg.grid = leadfield;
cfg.vol = vol;
cfg.sam.lambda = 0.05;
cov.grad=liAvg.grad;
s = ft_sourceanalysis(cfg, cov);
sN=length(s.avg.mom);
s.avg.pow=zeros(1,sN);
s.avg.norm=zeros(1,sN);
for si=1:sN
    if ~isempty(s.avg.mom{1,si})
        s.avg.pow(1,si)=abs(s.avg.mom{1,si}(1,155));
        s.avg.norm(1,si)=s.avg.pow(1,si)./mean(abs(s.avg.filter{1,si}));
    end
end
bnd.pnt=mesh.tess_ctx.vert;
bnd.tri=mesh.tess_ctx.face;
figure;
ft_plot_mesh(bnd, 'vertexcolor', (s.avg.pow./s.avg.noise)');
hold on;
%% dipole fit
cfg = [];
cfg.latency = [0.052 0.052];  % specify latency window around M50 peak
cfg.numdipoles = 1;
cfg.vol=vol;
cfg.feedback = 'textbar';
cfg.gridsearch='yes';
dip = ft_dipolefitting(cfg, liAvg);
ft_plot_dipole(dip.dip.pos,dip.dip.mom,'units','mm','color','black')

%% MNE 1
cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0];
cfg.channel='MEG';
cov=ft_timelockanalysis(cfg, liAvg);
cfg=[];
cfg.method = 'mne';
cfg.grid = leadfield;
cfg.vol = vol;
% cfg.mne.snr = 1e-20;
cfg.mne.lambda=1e9;
cov.grad=liAvg.grad;
source = ft_sourceanalysis(cfg,cov);
bnd.pnt=mesh.tess_ctx.vert;
bnd.tri=mesh.tess_ctx.face;
figure;
ft_plot_mesh(bnd, 'vertexcolor', source.avg.pow(:,155));

%% MNE 2
cd /home/yuval/Data/camera/2;
load headmodel
load leadfield

cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0];
cfg.channel='MEG';
cov=ft_timelockanalysis(cfg, li2Avg);
cfg=[];
cfg.method = 'mne';
cfg.grid = leadfield;
cfg.vol = vol;
% cfg.mne.snr = 1e-20;
cfg.mne.lambda=1e10;
cov.grad=liAvg.grad;
source = ft_sourceanalysis(cfg,cov);
bnd.pnt=mesh.tess_ctx.vert;
bnd.tri=mesh.tess_ctx.face;
figure;
ft_plot_mesh(bnd, 'vertexcolor', source.avg.pow(:,155));

%% mixed model MNE
cd ..
clear
load avgBoth
load grad496
load mesh
load vol
load leadfield

cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0];
cfg.channel='MEG';
cov=ft_timelockanalysis(cfg,avgBoth);
cfg=[];
cfg.method = 'mne';
cfg.grid = leadfield;
cfg.vol = vol;
% cfg.mne.snr = 1e-20;
cfg.mne.lambda=1e11;
cov.grad=grad;
source = ft_sourceanalysis(cfg,cov);
bnd.pnt=mesh.tess_ctx.vert;
bnd.tri=mesh.tess_ctx.face;
figure;
ft_plot_mesh(bnd, 'vertexcolor', source.avg.pow(:,155));

%% loreta?

cfg=[];
cfg.method = 'loreta';
cfg.grid = leadfield;
cfg.vol = vol;
%cfg.mne.snr = 5;
cfg.mne.lambda=0.05;
cov.grad=liAvg.grad;
source = ft_sourceanalysis(cfg,cov);
bnd.pnt=mesh.tess_ctx.vert;
bnd.tri=mesh.tess_ctx.face;
figure;
ft_plot_mesh(bnd, 'vertexcolor', source.avg.pow(:,155));




