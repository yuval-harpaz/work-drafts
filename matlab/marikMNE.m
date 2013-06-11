%% MNE, first run

cd /home/yuval/Data/camera/1;
load headmodel
load ../leftIndAvgs
t=0.252;
liAvg.grad=ft_convert_units(liAvg.grad,'mm');


cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0.3];
cfg.channel='MEG';
cov=ft_timelockanalysis(cfg, liAvg);

cfg        = [];
cfg.method = 'mne';
cfg.grid= grid;
cfg.vol    = vol;
cfg.lambda = 0.05;
cfg.keepfilter='yes';
cfg.keepmoment='yes';
s = ft_sourceanalysis(cfg, cov);
% sN=length(s.avg.mom);
% s.avg.pow=zeros(1,sN);
% s.avg.norm=zeros(1,sN);
% for si=1:sN
%     if ~isempty(s.avg.mom{1,si})
%         s.avg.pow(1,si)=abs(s.avg.mom{1,si}(1,155));
%         s.avg.norm(1,si)=s.avg.pow(1,si)./mean(abs(s.avg.filter{1,si}));
%     end
% end
s.avg.pow052=s.avg.pow(:,155);
load sMRI
mri_realign=sMRI;
mri_realign.transform=inv(M1)*sMRI.transform;
% save s s
cfg = [];
cfg.parameter = 'avg.pow052';
smne = sourceinterpolate(cfg, s,mri_realign);
cfg = [];
cfg.interactive = 'yes';
cfg.funparameter = 'avg.pow052';
cfg.method='ortho';
%cfg.funcolorlim = [0 50];
figure;ft_sourceplot(cfg,smne);

%% temp cortex
% ctx=ft_read_headshape('~/ft_BIU/matlab/spm8/canonical/cortex_5124.surf.gii');
[vol,grid,mesh,M1]=headmodel_BIU([],[],5,[],'localspheres');
%plot3pnt(mesh.tess_ctx.vert,'.b')
cfg = [];
%cfg.grad = ft_convert_units(stdAvg.grad,'mm');
cfg.channel ='MEG';
cfg.grid.pos = mesh.tess_ctx.vert;
cfg.grid.inside = [1:size(mesh.tess_ctx.vert,1)]';
cfg.vol = vol;
cfg.grad=liAvg.grad;
leadfield = ft_prepare_leadfield(cfg);
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
cfg.mne.lambda = 1e8;
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
