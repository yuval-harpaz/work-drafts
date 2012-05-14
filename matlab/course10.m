cd somsens

% load or make a head model with local spheres
if exist('headmodel.mat','file')
    load headmodel
else
    [vol,grid,mesh,M1]=headmodel_BIU([],[],[],[],'localspheres');
    save headmodel vol grid mesh M1
end

%% find left and right somatosensory response

% read raw data, eyes open.
fileName='hb_c,rfhp0.1Hz';
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
% cfg.bpfreq=[7 13];
cfg.bpfreq=[1 90];
cfg.demean='yes';
cfg.continuous='yes';
cfg.channel='MEG';
eyesOpen=ft_preprocessing(cfg);
eyesOpen.grad=ft_convert_units(eyesOpen.grad,'mm');

% view the data, see the onset of alpha for A113, A114 and A115
cfgb=[];
cfgb.layout='4D248.lay';
cfgb.continuous='yes';
cfgb.event.type='';
cfgb.event.sample=1;
cfgb.blocksize=10;
cfgb.viewmode='vertical';
cfgb.ylim=[-3.5027e-13  3.5027e-13]
cfgb.channel={'A110','A111','A112','A113','A114','A115','A116','A117','A118','A119','A120','A121','A122','A123','A124','A125','A126','A127','A128','A129','A130','A131','A132','A133','A134','A135','A136','A137','A138','A139','A140'};
comppic=ft_databrowser(cfgb,eyesOpen);

cfg            = [];
cfg.resamplefs = 300;
cfg.detrend    = 'no';
dummy           = ft_resampledata(cfg, eyesOpen);

%run ica
cfg            = [];
comp_dummy           = ft_componentanalysis(cfg, dummy);

%cfg=[];
%cfg.method='fastica';
%cfg.numcomponent=20;
%comp=ft_componentanalysis(cfg,eyesOpen);

cfgb=[];
cfgb.layout='4D248.lay';
cfgb.channel = {comp_dummy.label{1:5}};
cfgb.continuous='yes';
cfgb.event.type='';
cfgb.event.sample=1;
cfgb.blocksize=3;
comppic=ft_databrowser(cfgb,comp_dummy);
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


