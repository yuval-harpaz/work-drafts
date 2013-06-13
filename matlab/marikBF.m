%% sam, first run

cd /home/yuval/Data/camera/1;
load headmodel
load ../leftIndAvgs
%t=0.052;
liAvg.grad=ft_convert_units(liAvg.grad,'mm');


cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0.3];
cfg.channel='MEG';
cov=ft_timelockanalysis(cfg, liAvg);

cfg        = [];
cfg.method = 'sam';
cfg.grid= grid;
cfg.vol    = vol;
cfg.lambda = 0.05;
cfg.keepfilter='yes';
cfg.keepmoment='yes';
s = ft_sourceanalysis(cfg, cov);
sN=length(s.avg.mom);
s.avg.pow=zeros(1,sN);
%s.avg.norm=zeros(1,sN);
for si=1:sN
    if ~isempty(s.avg.mom{1,si})
        s.avg.pow(1,si)=abs(s.avg.mom{1,si}(1,155));
%        s.avg.norm(1,si)=s.avg.pow(1,si)./mean(abs(s.avg.filter{1,si}));
    end
end
s.avg.norm=10^21*s.avg.pow./s.avg.noise;
load sMRI
mri_realign=sMRI;
mri_realign.transform=inv(M1)*sMRI.transform;
% save s s
cfg = [];
cfg.parameter = 'avg.norm';
si = sourceinterpolate(cfg, s,mri_realign);
cfg = [];
cfg.interactive = 'yes';
cfg.funparameter = 'avg.norm';
cfg.method='ortho';
%cfg.funcolorlim = [0 50];
figure;ft_sourceplot(cfg,si);

%% second run
cd /home/yuval/Data/camera/2;
load headmodel
%load ../leftIndAvgs
%t=0.252;
li2Avg.grad=ft_convert_units(li2Avg.grad,'mm');


cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0.3];
cfg.channel='MEG';
cov=ft_timelockanalysis(cfg, li2Avg);

cfg        = [];
cfg.method = 'sam';
cfg.grid= grid;
cfg.vol    = vol;
cfg.lambda = 0.05;
cfg.keepfilter='yes';
cfg.keepmoment='yes';
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

load sMRI
mri_realign=sMRI;
mri_realign.transform=inv(M1)*sMRI.transform;
save s s
cfg = [];
cfg.parameter = 'avg.norm';
swts = sourceinterpolate(cfg, s,mri_realign);
cfg = [];
cfg.interactive = 'yes';
cfg.funparameter = 'avg.norm';
cfg.method='ortho';
%cfg.funcolorlim = [0 50];
figure;ft_sourceplot(cfg,swts);
%% avg both runs
cd ..
clear s
load 1/s
s1=s;
load 2/s;
s.avg.norm=(s.avg.norm+s1.avg.norm)/2;
cfg = [];
cfg.parameter = 'avg.norm';
swts = sourceinterpolate(cfg, s,mri_realign);
cfg = [];
cfg.interactive = 'yes';
cfg.funparameter = 'avg.norm';
cfg.method='ortho';
%cfg.funcolorlim = [0 50];
figure;ft_sourceplot(cfg,swts);


%% mixed model
cd /home/yuval/Data/camera
load avgBoth

load vol
load grad496

cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0.3];
cfg.channel='MEG';
cov=ft_timelockanalysis(cfg, avgBoth);

cfg        = [];
cfg.method = 'sam';
cfg.grid= grid;
cfg.grad=grad;
cfg.vol    = vol;
cfg.lambda = 0.05;
cfg.keepfilter='yes';
cfg.keepmoment='yes';
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

load sMRI
mri_realign=sMRI;
mri_realign.transform=inv(M1)*sMRI.transform;
cfg = [];
cfg.parameter = 'avg.norm';
swts = sourceinterpolate(cfg, s,mri_realign);
cfg = [];
cfg.interactive = 'yes';
cfg.funparameter = 'avg.norm';
cfg.method='ortho';
%cfg.funcolorlim = [0 50];
figure;ft_sourceplot(cfg,swts);

%% ctx surface
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
        %s.avg.norm(1,si)=s.avg.pow(1,si)./mean(abs(s.avg.filter{1,si}));
    end
end

bnd.pnt=mesh.tess_ctx.vert;
bnd.tri=mesh.tess_ctx.face;
figure;
ft_plot_mesh(bnd, 'vertexcolor', (s.avg.pow./s.avg.noise)');
title(['lambda = ',num2str(cfg.sam.lambda)])

cd /home/yuval/Data/camera/2;
load headmodel
%load ../leftIndAvgs
%load ../mesh
load leadfield
cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0.3];
cfg.channel='MEG';
cov=ft_timelockanalysis(cfg, li2Avg);
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
        %s.avg.norm(1,si)=s.avg.pow(1,si)./mean(abs(s.avg.filter{1,si}));
    end
end

bnd.pnt=mesh.tess_ctx.vert;
bnd.tri=mesh.tess_ctx.face;
figure;
ft_plot_mesh(bnd, 'vertexcolor', (s.avg.pow./s.avg.noise)');
title(['lambda = ',num2str(cfg.sam.lambda)])

cd /home/yuval/Data/camera;
load grad496
load vol
load avgBoth
load leadfield
cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0.3];
cfg.channel='MEG';
cov=ft_timelockanalysis(cfg, avgBoth);
cfg=[];
cfg.method = 'sam';
cfg.grid = leadfield;
cfg.vol = vol;
cfg.sam.lambda = 0.05;
cov.grad=grad;
s = ft_sourceanalysis(cfg, cov);
sN=length(s.avg.mom);
s.avg.pow=zeros(1,sN);
s.avg.norm=zeros(1,sN);
for si=1:sN
    if ~isempty(s.avg.mom{1,si})
        s.avg.pow(1,si)=abs(s.avg.mom{1,si}(1,155));
        %s.avg.norm(1,si)=s.avg.pow(1,si)./mean(abs(s.avg.filter{1,si}));
    end
end

bnd.pnt=mesh.tess_ctx.vert;
bnd.tri=mesh.tess_ctx.face;
figure;
ft_plot_mesh(bnd, 'vertexcolor', (s.avg.pow./s.avg.noise)');

%% LCMV volume

cd /home/yuval/Data/camera/1;
load headmodel
load ../leftIndAvgs
%t=0.052;
liAvg.grad=ft_convert_units(liAvg.grad,'mm');


cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0.3];
cfg.channel='MEG';
cov=ft_timelockanalysis(cfg, liAvg);

cfg        = [];
cfg.method = 'lcmv';
cfg.grid= grid;
cfg.vol    = vol;
cfg.lcmv.lambda = 0.05;
cfg.keepfilter='yes';
cfg.keepmoment='yes';
s = ft_sourceanalysis(cfg, cov);
sN=length(s.avg.mom);
s.avg.pow=zeros(1,sN);
s.avg.norm=zeros(1,sN);
for srci=1:sN
    if ~isempty(s.avg.mom{1,srci})
        s.avg.pow(1,srci)=sqrt(sum(s.avg.mom{1,srci}(:,155).^2));
        s.avg.norm(1,srci)=s.avg.pow(1,srci)./mean(mean(abs(s.avg.filter{1,srci})));
    end
end
%s.avg.norm=10^21*s.avg.pow./s.avg.noise;
load sMRI
mri_realign=sMRI;
mri_realign.transform=inv(M1)*sMRI.transform;
% save s s
cfg = [];
cfg.parameter = 'avg.norm';
si = sourceinterpolate(cfg, s,mri_realign);
cfg = [];
cfg.interactive = 'yes';
cfg.funparameter = 'avg.norm';
cfg.method='ortho';
%cfg.funcolorlim = [0 50];
figure;ft_sourceplot(cfg,si);

%% LCMV surface
load leadfield
cfg=[];
cfg.method = 'lcmv';
cfg.grid = leadfield;
cfg.vol = vol;
cfg.lcmv.lambda = 1e8;
cfg.keepfilter='yes';
cov.grad=liAvg.grad;
s = ft_sourceanalysis(cfg, cov);
sN=length(s.avg.mom);
s.avg.pow=zeros(1,sN);
s.avg.norm=zeros(1,sN);
for srci=1:sN
    if ~isempty(s.avg.mom{1,srci})
        s.avg.pow(1,srci)=sqrt(sum(s.avg.mom{1,srci}(:,155).^2));
        s.avg.norm(1,srci)=s.avg.pow(1,srci)./mean(mean(abs(s.avg.filter{1,srci})));
    end
end

bnd.pnt=mesh.tess_ctx.vert;
bnd.tri=mesh.tess_ctx.face;
figure;
ft_plot_mesh(bnd, 'vertexcolor', s.avg.norm');
