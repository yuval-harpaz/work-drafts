% dipolefit for epilepsy data

% here we are going to do the simplest possible thing with regard to source
% localization. find a dipole for one epileptic spike, based on the
% headshape of the subject with a single sphere head model.

% so where is there a spike?
% see the traces
tracePlot_BIU(90,100,'c,rfhp1.0Hz');


% read the last 2 seconds (98-100s)
cfg.dataset='c,rfhp1.0Hz';
cfg.trialdef.beginning=98;
cfg.trialdef.end=100;
cfg.trialfun='trialfun_raw'; % the other usefull trialfun we have are trialfun_beg and trialfun_BIU
cfg1=ft_definetrial(cfg);
cfg1.bpfilter='yes';
cfg1.bpfreq=[3 90];
cfg1.demean='yes';
cfg1.channel={'MEG','-A74','-A204','MEGREF'};
data=ft_preprocessing(cfg1);


% now see the fields
% hear we cheat, we see the data as power spectrum. not our fault.
data1=ft_timelockanalysis([],data);
data1.powspctrm=data1.avg;

cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[99 99.2];
ft_movieplotTFR(cfg,data1);
% we choose the peak moment, 99.0917s
tSpike=99.0917;
% we may be able to choose better with an iteractive topoplot
cfg.xlim=[tSpike tSpike];
cfg.interactive='yes';
figure;
ft_topoplotER(cfg,data1);

% now that we know when the spike occurs we want to localize it.
%% make a single sphere model based on the head shape.
cfg                        = [];
cfg.feedback               = 'yes';
cfg.grad = data.grad;
cfg.headshape='hs_file';
cfg.channel={'MEG'};
cfg.singlesphere='yes';
vol  = ft_prepare_localspheres(cfg);
%% fit a dipole
cfg5 = [];
cfg5.latency = [tSpike tSpike];  % specify latency window around M50 peak
cfg5.numdipoles = 1;
cfg5.vol=vol;
cfg5.feedback = 'textbar';
cfg5.gridsearch='yes';
dip = ft_dipolefitting(cfg5, data);

%% show the dipole within the headshape
hs=ft_read_headshape('hs_file');
hsx=hs.pnt(:,1);hsy=hs.pnt(:,2);hsz=hs.pnt(:,3);
plot3(hsx,hsy,hsz,'rx');hold on;
plot3(dip.dip.pos(1,1),dip.dip.pos(1,2),dip.dip.pos(1,3),'bo')
% rotate the image to find the blue 'o'.

%% see results on the MRI.
% now to see the dipole on the MRI first the MRI has to be realigned to the
% MEG. this is tricky, you have to find the LPA RPA and nasion on the MRI
% which in this case is of bad quality. let me do it, load mri_realign.
mri=ft_read_mri('epi.nii');
cfg = [];
cfg.method = 'interactive';
cfg.coordsys='4d';
mri_realign = ft_volumerealign(cfg,mri);

load mri_realign

% mind, here Left = Left.
cfg6 = [];
cfg6.location = 1000*dip.dip.pos(1,:);
figure; ft_sourceplot(cfg6, mri_realign);

%% plot the timecourse of the dipole 
dipTimeCourse=dip.dip.pot'*data.trial{1,1}(:,:);
figure;plot(data.time{1,1},dipTimeCourse);

