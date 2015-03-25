function [src]=marikViMNE(data,cfg,t)
% This function calculate the source by MNE
try
    s1=nearest(data.data1.time,t(1));
    s2=nearest(data.data1.time,t(2));
catch
    s1=nearest(data.data1.time{1},t(1));
    s2=nearest(data.data1.time{1},t(2));
end
load('./1/headmodel_1');
for i=1:(size(fieldnames(data),1)-1)
    cfg_tl=[];
    cfg_tl.covariance       = 'yes';
    cfg_tl.removemean       = 'no';
    cfg_tl.covariancewindow = [-0.1 0];
    eval(['cov',num2str(i),'=ft_timelockanalysis(cfg_tl, data.data',num2str(i),');']);

    eval(['cfg',num2str(i),'=cfg.cfg',num2str(i),';']);
    eval(['cfg',num2str(i),'.method = ''mne'';']); %% !!
    eval(['cfg',num2str(i),'.mne.lambda = 1e9;']);
    eval(['source',num2str(i),' = ft_sourceanalysis(cfg',num2str(i),',cov',num2str(i),');']); % performs beamformer dipole analysis on EEG or MEG data after preprocessing and a timelocked or frequency analysis
    
    eval(['src',num2str(i),'=mean(source',num2str(i),'.avg.pow(:,s1:s2),2);']);
    if i==1
       eval(['sum_src=src',num2str(i),';']); 
    else
        eval(['sum_src=sum_src+src',num2str(i),';']);
    end
end
src_mean=sum_src./(size(fieldnames(data),1)-1);

%% srcU
cfg_tl=[];
cfg_tl.covariance       = 'yes';
cfg_tl.removemean       = 'no';
cfg_tl.covariancewindow = [-0.1 0];
covU=ft_timelockanalysis(cfg_tl, data.dataU);

cfgU=cfg.cfgU;
cfgU.method = 'mne';
cfgU.mne.lambda = 1e9;
sourceU=ft_sourceanalysis(cfgU,covU); % performs beamformer dipole analysis on EEG or MEG data after preprocessing and a timelocked or frequency analysis
srcU=mean(sourceU.avg.pow(:,s1:s2),2);

src={};
src.srcU=srcU;
src.src_mean=src_mean;
for i=1:(size(fieldnames(data),1)-1)
    eval(['src.src',num2str(i),'=src',num2str(i),';']);
end

% plots
bnd.pnt=mesh.tess_ctx.vert;
bnd.tri=mesh.tess_ctx.face;

c=minmax([src_mean;srcU]');

figure('name','mean of 3 positions')
ft_plot_mesh(bnd, 'vertexcolor', src_mean);
caxis(c);
colorbar;
view(-90,90)
rotate3d on
figure('name','virtual helmet');
ft_plot_mesh(bnd, 'vertexcolor', srcU);
caxis(c);
colorbar;
view(-90,90)
rotate3d on


% source.tri=bnd.tri;
% ft_sourcemovie([],source);
