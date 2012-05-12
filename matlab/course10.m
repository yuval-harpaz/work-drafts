cd somsens

% load or make a head model with local spheres
if exist('headmodel.mat','file')
    load headmodel
else
    [vol,grid,mesh,M1]=headmodel_BIU([],[],[],[],'localspheres');
    save headmodel vol grid mesh M1
end

% read raw data, eyes open.
fileName='xc,hb,lf_c,rfhp0.1Hz';
cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0;
cfg.trialdef.poststim=120;
cfg.trialdef.offset=0;
cfg.trialfun='BIUtrialfun';
cfg.trialdef.eventvalue= 90; %left index finger
cfg=ft_definetrial(cfg);
cfg.padding=0.5;
cfg.bpfilter='yes';
cfg.bpfreq=[1 90];
cfg.demean='yes';
cfg.continuous='yes';
cfg.channel='MEG';
eyesOpen=ft_preprocessing(cfg);
eyesOpen.grad=ft_convert_units(eyesOpen.grad,'mm');

% eyesOpenIca=ft_componentanalysis([],eyesOpen);

%% compute covariance for the 2min epoch
cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'yes';
%cfg.keeptrials='yes';
cov=timelockanalysis(cfg, eyesOpen);
%% beamform
cfg        = [];
cfg.method = 'sam';
cfg.grid= grid;
cfg.vol    = vol;
cfg.lambda = 0.05;
%cfg.channel={'MEG','MEGREF'};
cfg.keepfilter='yes';
source = ft_sourceanalysis(cfg, cov);

%% plot power
% set a realigned MRI
load ~/ft_BIU/matlab/files/sMRI.mat
mri_realign=sMRI;
mri_realign.transform=inv(M1)*sMRI.transform;
% interpolate the source on the MRI
cfg = [];
cfg.parameter = 'avg.pow';
ipow = sourceinterpolate(cfg, source,mri_realign);
powAlpha=source.avg.pow;
filter=source.avg.filter;
%source.avg=rmfield(source.avg,'mom');
clear source
% plot
cfg = [];
cfg.interactive = 'yes';
cfg.funparameter = 'avg.pow';
cfg.method='ortho';
%cfg.funcolorlim = [0 50];
figure;ft_sourceplot(cfg,ipow);
%% normalize
% make virtual sensors (moment)
% compare alpha to other freqs
cfg=[];
cfg.bsfilter='yes';
cfg.demean='yes';
cfg.bsfreq=[7 13];
eyesOpenNoAlpha=ft_preprocessing(cfg,eyesOpen);
mom=[];pow=[];
for i=1:size(grid.inside,1)
    m = grid.inside(i);
    if ~isempty(filter{m})
        mom = filter{m}*eyesOpenNoAlpha.trial{1,1};
        pow(m) =mean(mom.^2);
    end
end
s=grid;
s.avg.pow=pow;
pow(1,(end+1):size(grid.pos,1))=0;
s.avg.nai=(powAlpha-pow)./pow;
cfg=[];
cfg.parameter = 'avg.nai';
ipowAlpha = sourceinterpolate(cfg, s,mri_realign);

cfg = [];
cfg.interactive = 'yes';
cfg.funparameter = 'avg.nai';
cfg.method='ortho';
%cfg.funcolorlim = [0 50];
figure;ft_sourceplot(cfg,ipowAlpha);

% we take location 8,-50.5,88.5 (RH) and it's opposite (y positive)


