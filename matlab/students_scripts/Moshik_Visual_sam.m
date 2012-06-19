% Moshik


% Loading data and filtering Band Filtering between 1 to 35
% (Taken from course 5)
fileName='hb_c,rfhp0.1Hz';
cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.5;
cfg.trialdef.poststim=1;
cfg.trialdef.offset=-0.5; %NOTE large baseline to measure low freq
cfg.trialdef.visualtrig= 'visafter';
cfg.trialfun='BIUtrialfun';
cfg.trialdef.eventvalue= [222 230 240 250];
cfg=ft_definetrial(cfg);

cfg.demean='yes';
cfg.baselinewindow=[-0.5 0];
cfg.channel='MEG';
cfg.padding=0.1;
cfg.bpfilter='yes';
cfg.bpfreq=[1 35];
dataorig=ft_preprocessing(cfg);

% Averaging
% (Taken from course2)
avg=ft_timelockanalysis([],dataorig);

% Plotting to define time of interest
cfg1=[];
cfg1.layout='4D248.lay';
cfg1.interactive='yes';
cfg1.marker = 'labels';
ft_multiplotER(cfg1,avg);


%load headmodel % it was created in course8 (and 7)
[vol,grid,mesh,M1,single]=headmodel_BIU([],[],[],[],'localspheres');
load ~/ft_BIU/matlab/files/sMRI.mat
mri_realign=sMRI;
mri_realign.transform=inv(M1)*sMRI.transform;
toi=[0.0821 0.127];

% cov for raw data
source=OBbeamform(dataorig,toi,'sam',mri_realign);
cfg2 = [];
cfg2.parameter = 'avg.nai';
inai = sourceinterpolate(cfg2, source,mri_realign);
cfg3 = [];
cfg3.interactive = 'yes';
cfg3.funparameter = 'avg.nai';
cfg3.method='ortho';
cfg3.funcolorlim = [0 50];
figure;ft_sourceplot(cfg3,inai);

