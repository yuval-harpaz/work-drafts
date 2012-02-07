%% reading the auditory signal
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
trigon=find(trigFixed);
trl=trigon'-203;
trl(:,2)=trl+1017;
trl(:,3)=(-203);
trl(:,4)=trigFixed(trigon);
% standard
trl=trl(find(trl(:,4)==128),:);
cfg.dataset=source;
cfg2=ft_definetrial(cfg);
cfg2.trl=trl;
cfg2.demean='yes';
cfg2.baselinewindow=[-0.2 0];
cfg2.bpfilter='yes';
cfg2.bpfreq=[3 30];
cfg2.channel='MEG';
data=ft_preprocessing(cfg2);
cfg4.latency=[-0.1 0.6];
standard=ft_timelockanalysis(cfg4,data);
save standard standard
[vol,grid]=headmodel;
sMRI = read_mri(fullfile(spm('dir'), 'canonical', 'single_subj_T1.nii'));
cfg5 = [];
cfg5.latency = [0.035 0.075];  % specify latency window around M50 peak
cfg5.numdipoles = 1;
%cfg.symmetry='x';
cfg5.vol=vol;
cfg5.feedback = 'textbar';
%cfg5.gridsearch='no';
%cfg5.resolution = 0.1;
% cfg5.grid.xgrid=-75:-30;
% cfg5.grid.ygrid=75:-1:-105;
% cfg5.grid.zgrid=90:-1:-50;
cfg5.grid=grid;
dip = ft_dipolefitting(cfg5, standard);


cfg6 = [];
cfg6.location = dip.dip.pos(1,:) * 10;   % convert from cm to mm
cfg6.interactive='yes';
figure; ft_sourceplot(cfg6, sMRI);
%% LCMV
cfg7                  = [];
cfg7.covariance       = 'yes';
cfg7.removemean       = 'no';
cfg7.covariancewindow = [-0.05 0];
cfg7.channel='MEG';
covpre=timelockanalysis(cfg7, standard);
cfg7.covariancewindow = [0.03 0.08];
covpst=timelockanalysis(cfg7, standard);
cfg        = [];
cfg.method = 'lcmv';
cfg.grid= grid;
cfg.vol    = vol;
cfg.lambda = '5%';
cfg.keepfilter='no';

spre = ft_sourceanalysis(cfg, covpre);
spst = ft_sourceanalysis(cfg, covpst);
spst.avg.nai=(spst.avg.pow-spre.avg.pow)./spre.avg.pow;
%spstest=spst;
% cfg = [];
% cfg.parameter = 'nai'; %'all' 'prob' 'stat' 'mask'
% ispst = sourceinterpolate(cfg, spst,sMRI)
%                 
% load ~/ft_BIU/matlab/LCMV/pos
cfg10 = [];
cfg10.parameter = 'avg.nai';
spst.pos=pos;
inai = sourceinterpolate(cfg10, spst,sMRI)
cfg10.parameter = 'avg.pow';
ipow = sourceinterpolate(cfg10, spst,sMRI)
cfg9 = [];
%cfg9.funcolorlim = [lowlim 1];
cfg9.interactive = 'yes';
cfg9.funparameter = 'avg.nai';
%cfg9.maskparameter= 'mask';
cfg9.method='ortho';
%cfg9.inputcoord='mni';
%cfg9.atlas='aal_MNI_V4.img';
%cfg9.roi='Frontal_Sup_L'
%cfg9.location=[-42 -58 -11];% wer= -50 -45 10 , broca= -50 25 0, fussiform = -42 -58 -11(cohen et al 2000), change x to positive for RH.
%cfg9.crosshair='no';
figure
ft_sourceplot(cfg9,inai)
figure;
cfg9.funparameter = 'avg.pow';
ft_sourceplot(cfg9,ipow)