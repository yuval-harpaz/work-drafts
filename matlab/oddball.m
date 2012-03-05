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
cfg2.channel={'MEG','MEGREF'};
data=ft_preprocessing(cfg2);
cfg4.latency=[-0.1 0.6];
standard=ft_timelockanalysis(cfg4,data);
save standard standard

[vol,grid,mesh,M1]=headmodel1; % [vol,grid,mesh,M1]=headmodel1([],[],5);
% sMRI = read_mri(fullfile(spm('dir'), 'canonical', 'single_subj_T1.nii'));
load ~/ft_BIU/matlab/files/sMRI.mat
load modelScalp
load LRchans
MRIcr=sMRI;
MRIcr.transform=inv(M1)*sMRI.transform; %cr for corregistered MRI
cfg5 = [];
cfg5.latency = [0.055 0.055];  % specify latency window around M50 peak
cfg5.numdipoles = 1;
%cfg.symmetry='x';
cfg5.vol=vol;
cfg5.feedback = 'textbar';
cfg5.gridsearch='yes';
%cfg5.resolution = 0.1;
% cfg5.grid.xgrid=-75:-30;
% cfg5.grid.ygrid=75:-1:-105;
% cfg5.grid.zgrid=90:-1:-50;
cfg5.grid=grid;
cfg5.channel=Lchannel;
dip = ft_dipolefitting(cfg5, standard);
cfg6 = [];
cfg6.location = dip.dip.pos(1,:) %* 10;   % convert from cm to mm
figure; ft_sourceplot(cfg6, MRIcr);title('L')
cfg5.channel=Rchannel;
dip = ft_dipolefitting(cfg5, standard);
cfg6.location = dip.dip.pos(1,:)
figure; ft_sourceplot(cfg6, MRIcr);title('R');
%% LCMV
load modelScalp
load standard
hdr=ft_read_headerOLD('c,rfhp0.1Hz');
standard.grad=ft_convert_units(hdr.grad,'mm');
[vol,grid,mesh,M1]=headmodel_BIU([],[],[],[],'localspheres');
t1=0.03;t2=0.08;
cfg7                  = [];
cfg7.covariance       = 'yes';
cfg7.removemean       = 'no';
cfg7.covariancewindow = [(t1-t2) 0];
%cfg7.channel='MEG';
covpre=ft_timelockanalysis(cfg7, standard);
cfg7.covariancewindow = [t1 t2];
covpst=ft_timelockanalysis(cfg7, standard);
cfg8        = [];
cfg8.method = 'lcmv';
cfg8.grid= grid;
cfg8.vol    = vol;
cfg8.lambda = 0.05;
cfg8.keepfilter='no';

spre = ft_sourceanalysis(cfg8, covpre);
spst = ft_sourceanalysis(cfg8, covpst);
spst.avg.nai=(spst.avg.pow-spre.avg.pow)./spre.avg.pow;
%% interpolate and plot
% load ~/ft_BIU/matlab/LCMV/pos
cfg10 = [];
cfg10.parameter = 'avg.nai';
inai = sourceinterpolate(cfg10, spst,MRIcr)
% cfg10.parameter = 'avg.pow';
% ipow = sourceinterpolate(cfg10, spst,MRIcr)
cfg9 = [];
cfg9.interactive = 'yes';
cfg9.funparameter = 'avg.nai';
cfg9.method='ortho';
figure;ft_sourceplot(cfg9,inai)
% figure;cfg9.funparameter = 'avg.pow';
% ft_sourceplot(cfg9,ipow)