%% Dipolefit for epilepsy data
% Here we are going to do the simplest possible thing with regard to source
% localization. find a dipole for one epileptic spike, based on the
% headshape of the subject with a single sphere head model.

%% Find a spike on raw data
% So where is there a spike?
% See some MEG channels between 90 and 100s. We will later take the one at
% 99s.
cd epilepsy
tracePlot_BIU(90,100,'c,rfhp1.0Hz');

%% View a movie of the field
% We read the last 2 seconds (98-100s). We then pretend the data is power
% spectrum and use ft_movieplotTFR. Then we make a movie of 90 to 90.2s
% (200ms movie).
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
% Here we cheat, we see the data as power spectrum. not our fault.
data1=ft_timelockanalysis([],data);
data1.powspctrm=data1.avg;
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[99 99.2];
figure;
ft_movieplotTFR(cfg,data1);

%% Choose an exact moment for dipole fit
% It has to look like a field of a
% dipole. From watching the movie we choose the peak moment, 99.0917s.
% Alternatively we can use interactive plot to choose the peak amplitude
% but let's start with 99.0917.
tSpike=99.0917;
cfg.xlim=[tSpike tSpike];
cfg.zlim=[-1.5e-12 1.5e-12];
cfg.interactive='yes';
figure;
ft_topoplotER(cfg,data1);

% now that we know when the spike occurs we want to localize it.
%% Make a single sphere model based on the head shape.
cfg                        = [];
cfg.feedback               = 'no';
cfg.grad = data.grad;
cfg.headshape='hs_file';
cfg.singlesphere='yes';
vol  = ft_prepare_localspheres_BIU(cfg);
showHeadInGrad([],'m');
hold on;
ft_plot_vol(vol);
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
figure;plot3(hsx,hsy,hsz,'rx');hold on;
ft_plot_dipole(dip.dip.pos,dip.dip.mom,'units','m')

%% Realign the MRI to our MEG
% Now to see the dipole on the MRI first the MRI has to be realigned to the
% MEG. this is tricky, you have to find the LPA RPA and nasion on the MRI
% which in this case is of bad quality. let me do it, load mri_realign.
mri=ft_read_mri('epi.nii');
cfg = [];
cfg.method = 'interactive';
cfg.coordsys='4d';
mri_realign = ft_volumerealign(cfg,mri);
%note here Left is Left!

%% see results on the MRI.
load mri_realign
% mind, here Left = Left.
cfg6 = [];
cfg6.location = 1000*dip.dip.pos(1,:);
figure; ft_sourceplot(cfg6, mri_realign);

%% plot the timecourse and "field" of the dipole 
dipTimeCourse=dip.dip.pot'*data.trial{1,1}(:,:);
figure;plot(data.time{1,1},dipTimeCourse);
dipWts=data1;
dipWts.avg=dip.dip.pot;
dipWts.time=dip.time;
figure;ft_topoplotER([],dipWts);


%% auditory

cd ../oddball
source='c,rfhp0.1Hz';
trig=readTrig_BIU(source);
trig=clearTrig(trig);
cfg=[];
cfg.dataset=source;
cfg.trialfun='trialfun_beg';
cfg1=ft_definetrial(cfg);
cfg1.channel='X3';
cfg1.hpfilter='yes';
cfg1.hpfreq=110;
Aud=ft_preprocessing(cfg1);
trigFixed=fixAudTrig(trig,Aud.trial{1,1},[],0.002);
% here we enlarge to see that the auditory onsets where correctly detected.

trigon=find(trigFixed);
trl=trigon'-203;
trl(:,2)=trl+1017;
trl(:,3)=(-203);
trl(:,4)=trigFixed(trigon);
% standard
%trl=trl(find(trl(:,4)==128),:);
cfg.dataset=source;
cfg2=ft_definetrial(cfg);
cfg2.trl=trl;
cfg2.demean='yes';
cfg2.baselinewindow=[-0.2 0];
cfg2.bpfilter='yes';
cfg2.bpfreq=[3 30];
cfg2.channel={'MEG','MEGREF'};
cfg2.feedback='no';
data=ft_preprocessing(cfg2);
cfg4.latency=[-0.1 0.6];
cfg4.trials=find(data.trialinfo==128);
cfg4.feedback='no';
standard=ft_timelockanalysis(cfg4,data);
cfg4.trials=find(data.trialinfo==64);
oddball=ft_timelockanalysis(cfg4,data);
% save oddball_data oddball standard data
%% Now see the fields in a movie
standard.powspctrm=standard.avg;
cfg=[];
cfg.layout='4D248.lay';
%cfg.xlim=[99 99.2];
figure;
ft_movieplotTFR(cfg,standard);
% we choose the peak 0.058s
t=0.058;

%% We may be able to choose better with an iteractive topoplot
cfg.xlim=[t t];
cfg.interactive='yes';
figure;
ft_topoplotER(cfg,standard);

%% Select channels
%we have to select channels because there are two dipoles.
% last click, choose pos and neg channels over the left side of the helmet
%then copy the output channels: cfg.channel = {'A1', 'A2',...};
%here, I did it for you.
channelSelection = {'A11', 'A26', 'A27', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A46', 'A47', 'A48', 'A64', 'A65', 'A66', 'A67', 'A68', 'A69', 'A70', 'A71', 'A72', 'A73', 'A74', 'A92', 'A93', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'A100', 'A101', 'A102', 'A103', 'A104', 'A125', 'A126', 'A127', 'A128', 'A129', 'A130', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A153', 'A154', 'A155', 'A156', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A178', 'A179', 'A180', 'A181', 'A182', 'A183', 'A184', 'A196', 'A197', 'A198', 'A199', 'A200', 'A201', 'A213', 'A214', 'A215', 'A216', 'A217', 'A229', 'A230', 'A231', 'A232', 'A233', 'A234', 'A235'};



%% make a local spheres model based on the head shape.
[vol,grid,mesh,M1]=headmodel_BIU([],[],[],[],'localspheres');
% save headmodel vol grid mesh M1
% note the units, here we work in mm.
%% fit a dipole
cfg5 = [];
cfg5.latency = [t t];  % specify latency window around M50 peak
cfg5.numdipoles = 1;
%cfg.symmetry='x';
cfg5.vol=vol;
cfg5.feedback = 'textbar';
cfg5.gridsearch='yes';
cfg5.grad=ft_convert_units(standard.grad,'mm');
%cfg5.resolution = 0.1;
% cfg5.grid.xgrid=-75:-30;
% cfg5.grid.ygrid=75:-1:-105;
% cfg5.grid.zgrid=90:-1:-50;
cfg5.grid=grid;
cfg5.channel=channelSelection;
dip = ft_dipolefitting(cfg5, standard);

%% show the dipole within the headshape
hs=ft_read_headshape('hs_file');
hs=ft_convert_units(hs,'mm');
hsx=hs.pnt(:,1);hsy=hs.pnt(:,2);hsz=hs.pnt(:,3);
figure;plot3(hsx,hsy,hsz,'rx');hold on;
ft_plot_dipole(dip.dip.pos,dip.dip.mom,'units','mm')

%% see results on the MRI.
% here we load a template MRI and reorient it according to the headshape.
load ~/ft_BIU/matlab/files/sMRI.mat
mri_realign=sMRI;
mri_realign.transform=inv(M1)*sMRI.transform;

% mind, here Left = Right.
cfg6 = [];
cfg6.location = dip.dip.pos(1,:);
figure; ft_sourceplot(cfg6, mri_realign);

%% make timecourses for standard and oddball
% we first create new avg only with the relevant channels (L for Left)
cfg4.channel=channelSelection;
cfg4.trials=find(data.trialinfo==128);
stL=ft_timelockanalysis(cfg4,data);
cfg4.trials=find(data.trialinfo==64);
oddL=ft_timelockanalysis(cfg4,data);
TCstandard=dip.dip.pot'*stL.avg;
TCoddball=dip.dip.pot'*oddL.avg;
figure;
plot(data.time{1,1},TCstandard);
hold on;
plot(data.time{1,1},TCoddball,'r');
legend('Standard','Oddball');