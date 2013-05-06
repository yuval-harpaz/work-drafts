cd /home/yuval/Copy/social_motor_study/204707
%% clean the heartbeat
FN='c,rfDC';
p=pdf4D(FN);
cleanCoefs = createCleanFile_fhb(p, FN,...
'byLF',0 ,...
'xClean',0,...
'chans2ignore',204,...
'byFFT',0,...
'HeartBeat',[])

%% make trl list
FN=['hb_',FN];
trialSamps=importdata('204707_conditions.csv');
samps=trialSamps.data(:,1);
samps(161:320,1)=trialSamps.data(:,2);
trl=samps-203; % 203 is baseline of 300ms
trl(:,2)=trl+678;
trl(:,3)=-203;
%% read raw data
cfg=[];
cfg.dataset=FN;
cfg.trl=trl;
cfg.bpfreq=[1 40];
cfg.bpfilter='yes';
cfg.demean='yes';
cfg.baselinewindow=[-0.2 0];
data=ft_preprocessing(cfg);
data.trialinfo(1:160,1)=1; % 1=con 2=inc
data.trialinfo(161:320,1)=2;
%% remove muscle artifact trials
cfg=[];
cfg.method='summary';
cfg.channel='MEG';
cfg.alim=1e-12;
cfg.hpfilter='yes';
cfg.hpfreq=60;
dataNoMscl=ft_rejectvisual(cfg, data);

%% remove blinks
cfg=[];
cfg.method='pca';
comp          = ft_componentanalysis(cfg, dataNoMscl);
cfg=[];
cfg.layout='4D248.lay';
cfg.channel = 1:5;
ft_databrowser(cfg,comp);

cfg = [];
cfg.component = 1; % change
dataPCA = ft_rejectcomponent(cfg, comp);
cfg=[];
cfg.demean='yes';
cfg.baselinewindow=[-0.1 0];
dataPCA=ft_preprocessing(cfg,dataPCA);
%% reject some other noisy trials
cfg=[];
cfg.method='summary';
cfg.channel='MEG';
cfg.alim=1e-12;
dataCln=ft_rejectvisual(cfg, dataPCA);
save dataCln dataCln
%% average
cfg=[];
cfg.trials=find(dataCln.trialinfo==1);
con=ft_timelockanalysis(cfg,dataCln);
cfg.trials=find(dataCln.trialinfo==2);
inc=ft_timelockanalysis(cfg,dataCln);
save con con
save inc inc
cfg=[];
cfg.xlim = [170 170];
cfg.layout       = '4D248.lay';
cfg.interactive='yes';
ft_topoplotER(cfg, con,inc);

%% make MarkerFile.mrk
samps=dataCln.sampleinfo;
samps=(samps+203)/678.17;
contrig=samps(find(dataCln.trialinfo==1));
inctrig=samps(find(dataCln.trialinfo==2));
all=samps(find(dataCln.trialinfo));
trig2mark('congruent',contrig','incongruent',inctrig','All',all');
%% making param file (one for all subjects)
createPARAM('AllTrials','SPM','All',[0.15 0.3],[],[],[3 35],[-0.1 0.7],'Pseudo-Z',0.5,'MultiSphere','Power',[60 90]);
% change the box size to fit Denis tilt
%% global c,rfhp1.0Hz,ee
cd /home/yuval/Copy/social_motor_study
!~/bin/SAMcov64 -r 204707 -d hb_c,rfDC -m AllTrials -v
!~/bin/SAMwts64 -r 204707 -d hb_c,rfDC -m AllTrials -c Alla -v
cd /home/yuval/Copy/social_motor_study204707
covDir='/home/yuval/Copy/social_motor_study/204707/SAM/AllTrials,3-35Hz';
wtsFile='/home/yuval/Copy/social_motor_study/204707/SAM/AllTrials,3-35Hz,Alla.wts';
normWts(covDir,wtsFile);

[SAMHeader, ActIndex, ActWgts]=readWeights(wtsFile);
boxSize=[...
SAMHeader.XStart SAMHeader.XEnd ...
SAMHeader.YStart SAMHeader.YEnd ...
SAMHeader.ZStart SAMHeader.ZEnd];

% fix when normWts gets stuch
load ('/home/yuval/Copy/social_motor_study/204707/SAM/AllTrials,3-35Hz/NoiseCovWts.mat')
cfg=[];
cfg.step=5;
cfg.boxSize=1000*boxSize;
cfg.prefix='NoiseCovWts';
VS2Brik(cfg,ns);

%% make images
wtsFile='/home/yuval/Copy/social_motor_study/204707/SAM/AllTrials,3-35Hz,Alla.wts';
[SAMHeader, ~, ActWgts]=readWeights(wtsFile);
boxSize=[...
SAMHeader.XStart SAMHeader.XEnd ...
SAMHeader.YStart SAMHeader.YEnd ...
SAMHeader.ZStart SAMHeader.ZEnd];

load /home/yuval/Copy/social_motor_study/204707/con
load /home/yuval/Copy/social_motor_study/204707/inc
incVS=ActWgts*inc.avg;
conVS=ActWgts*con.avg;
time=[0.15 0.3];
samp=[nearest(inc.time,time(1)),nearest(inc.time,time(2))];
inc250=mean((incVS(:,samp(1):samp(2))).^2,2);
con250=mean((conVS(:,samp(1):samp(2))).^2,2);

cd /home/yuval/Copy/social_motor_study/204707
cfg=[];
cfg.step=5;
cfg.boxSize=1000*boxSize;
cfg.prefix='con250';
VS2Brik(cfg,con250);
cfg.prefix='inc250';
VS2Brik(cfg,inc250);


ns=ActWgts;
ns=ns-repmat(mean(ns,2),1,size(ns,2));
ns=ns.*ns;
ns=mean(ns,2);

%% movie
cd /home/yuval/Copy/social_motor_study/204707
% load ('SAM/AllTrials,3-35Hz/NoiseCovWts.mat');
wtsFile='/home/yuval/Copy/social_motor_study/204707/SAM/AllTrials,3-35Hz,Alla.wts';
[SAMHeader, ~, ActWgts]=readWeights(wtsFile);
boxSize=[...
    SAMHeader.XStart SAMHeader.XEnd ...
    SAMHeader.YStart SAMHeader.YEnd ...
    SAMHeader.ZStart SAMHeader.ZEnd];
%load con

load inc
ns=mean(abs(ActWgts),2);
ns=repmat(ns,1,length(inc.time));
incVS=ActWgts*inc.avg;
%conVS=ActWgts*con.avg;
incVSabs=abs(incVS)./ns;
fac=round(log10(max(max(abs(incVSabs)))));
incVSabs=incVSabs*10^-fac;

cfg=[];
cfg.step=5;
cfg.boxSize=1000*boxSize;
cfg.torig=-299.335; % beginning of VS in ms
cfg.TR=num2str(1000/678.17);
cfg.prefix='incVSabs';
if exist([cfg.prefix,'+orig.BRIK'],'file')
    eval(['!rm ',cfg.prefix,'+orig.*'])
end
VS2Brik(cfg,incVSabs);

% cfg.prefix='con250';
% VS2Brik(cfg,con250);

%% SAM with fieldtrip
% make single sphere
cd /home/yuval/Copy/social_motor_study/204707
hs=ft_read_headshape('hs_file');
[o,r]=fitsphere(hs.pnt);
vol=[];
vol.r=r+0.01;
vol.o=o;
ft_plot_vol(vol);
hold on
plot3pnt(hs.pnt,'.')
% make grid
wtsFile='/home/yuval/Copy/social_motor_study/204707/SAM/AllTrials,3-35Hz,Alla.wts';
[SAMHeader, ~, ActWgts]=readWeights(wtsFile);
boxSize=[...
    SAMHeader.XStart SAMHeader.XEnd ...
    SAMHeader.YStart SAMHeader.YEnd ...
    SAMHeader.ZStart SAMHeader.ZEnd];
[~,allInd]=voxIndex([0,0,0],100.*boxSize,100.*SAMHeader.StepSize,1);
grid.outside=find(ActWgts(:,1)==0);
grid.inside=find(ActWgts(:,1)~=0);
grid.dim=[length(SAMHeader.XStart:SAMHeader.StepSize:SAMHeader.XEnd), ...
    length(SAMHeader.YStart:SAMHeader.StepSize:SAMHeader.YEnd), ...
    length(SAMHeader.ZStart:SAMHeader.StepSize:SAMHeader.ZEnd)];
grid.pos=allInd;

% cov
load dataCln

cfg7                  = [];
cfg7.covariance       = 'yes';
cfg7.removemean       = 'yes';
cfg7.channel='MEG';
cfg7.keeptrials='yes';
cov=timelockanalysis(cfg7, dataCln);

% hdr=read_4d_hdr_BIU(fileName);
cov.grad=ft_convert_units(cov.grad,'mm');
cfg=[];
cfg.vol=ft_convert_units(vol,'mm');
cfg.grid=ft_convert_units(grid,'mm');
cfg.method = 'sam'; % 'mne'
cfg.lambda = 0.05;
cfg.keepfilter='yes';
%cfg.rawtrial='yes';
%cfg8.fixedori='robert'; % 'stephen' doesn't work; default is spinning.
sourceGlobal = ft_sourceanalysis(cfg, cov);
save sourceGlobal sourceGlobal
wts=filter2wts(sourceGlobal.avg.filter);
save wts wts
load inc
% reconstructing source trace
ns=mean(abs(wts),2);
ns=repmat(ns,1,length(inc.time));
incVS=wts*inc.avg;
%conVS=ActWgts*con.avg;
incVSabs=abs(incVS)./ns;
fac=round(log10(max(max(abs(incVSabs)))));
incVSabs=incVSabs*10^-fac;

cfg=[];
cfg.step=5;
cfg.boxSize=1000*boxSize;
cfg.torig=-299.335; % beginning of VS in ms
cfg.TR=num2str(1000/678.17);
cfg.prefix='incFTabs';
if exist([cfg.prefix,'+orig.BRIK'],'file')
    eval(['!rm ',cfg.prefix,'+orig.*'])
end
VS2Brik(cfg,incVSabs);

load con
conVS=wts*con.avg;
%conVS=ActWgts*con.avg;
conVSabs=abs(conVS)./ns;
conVSabs=conVSabs*10^-fac;
cfg.prefix='conFTabs';
if exist([cfg.prefix,'+orig.BRIK'],'file')
    eval(['!rm ',cfg.prefix,'+orig.*'])
end
VS2Brik(cfg,conVSabs);

 !~/abin/3dcalc -a incFTabs+orig -b conFTabs+orig -exp 'a/b-b' -prefix incDivCon
 !~/abin/3dcalc -a incFTabs+orig -b conFTabs+orig -exp 'a-b' -prefix incMinCon
 
 %% concatenate trials

% load dataCln
% allIn1=rmfield(dataCln,'trial');
% allIn1=rmfield(allIn1,'time');
% allIn1.time{1,1}=dataCln.time{1,1};
% allIn1.trial{1,1}=dataCln.trial{1,1};
% 
% 
% 
% for triali=2:length(dataCln.trial)
%     allIn1.trial{1,1}=[allIn1.trial{1,1},dataCln.trial{1,triali}];
% end
% 
% tdif=allIn1.time{1,1}(1,2)-allIn1.time{1,1}(1,1);
% allIn1.time{1,1}=0:tdif:tdif*296*679;
% allIn1.time{1,1}=allIn1.time{1,1}(2:end);
% save allIn1 allIn1;
% cd /home/yuval/Copy/social_motor_study/204707
% hs=ft_read_headshape('hs_file');
% [o,r]=fitsphere(hs.pnt);
% vol=[];
% vol.r=r+0.01;
% vol.o=o;
% ft_plot_vol(vol);
% hold on
% plot3pnt(hs.pnt,'.')
% [SAMHeader, ~, ActWgts]=readWeights(wtsFile);
% boxSize=[...
% SAMHeader.XStart SAMHeader.XEnd ...
% SAMHeader.YStart SAMHeader.YEnd ...
% SAMHeader.ZStart SAMHeader.ZEnd];
% [~,allInd]=voxIndex([0,0,0],100.*boxSize,100.*SAMHeader.StepSize,1);
% grid.outside=find(ActWgts(:,1)==0);
% grid.inside=find(ActWgts(:,1)~=0);
% grid.dim=[length(SAMHeader.XStart:SAMHeader.StepSize:SAMHeader.XEnd), ...
% length(SAMHeader.YStart:SAMHeader.StepSize:SAMHeader.YEnd), ...
% length(SAMHeader.ZStart:SAMHeader.StepSize:SAMHeader.ZEnd)];
% grid.pos=allInd;
cd /home/yuval/Copy/social_motor_study/204707 
load allIn1
load headmodel
cfg7                  = [];
cfg7.covariance       = 'yes';
cfg7.removemean       = 'yes';
cfg7.channel='MEG';
cfg7.keeptrials='yes';
cov=timelockanalysis(cfg7, allIn1);
cov.grad=ft_convert_units(cov.grad,'mm');
cfg=[];
cfg.vol=ft_convert_units(vol,'mm');
cfg.grid=ft_convert_units(grid,'mm');
cfg.method = 'sam'; % 'mne'
cfg.sam.lambda = 0.05;

cfg.sam.keepmom       = 'no';
cfg.sam.keeptrials    = 'no'; 
cfg.sam.keepleadfield = 'no';
cfg.sam.projectnoise  = 'no';
cfg.sam.keepfilter    = 'yes';
%cfg.keepcsd       = 'no';
%cfg.rawtrial='yes';
%cfg8.fixedori='robert'; % 'stephen' doesn't work; default is spinning.
sourceRaw = ft_sourceanalysis(cfg, cov);
save sourceRaw sourceRaw
%% concatenate trials, divided grid
cd /home/yuval/Copy/social_motor_study/204707
load allIn1
load headmodel
cfg7                  = [];
cfg7.covariance       = 'yes';
cfg7.removemean       = 'yes';
cfg7.channel='MEG';
cfg7.keeptrials='yes';
cov=timelockanalysis(cfg7, allIn1);
cov.grad=ft_convert_units(cov.grad,'mm');
cfg=[];
cfg.vol=ft_convert_units(vol,'mm');
cfg.method = 'sam'; % 'mne'
cfg.sam.lambda = 0.05;
cfg.keepfilter='yes';
gridpart=grid;
cfg.grid=ft_convert_units(gridpart,'mm');
%gridpart=rmfield(grid,'dim');
filter=cell(1,length(grid.pos));
start1000=floor(grid.inside(1)/1000)*1000;
for i1000=start1000:1000:length(grid.pos)
    INmin=i1000;
    INmax=INmin+999;
    inmin=find(grid.inside>=INmin,1);
    inmax=find(grid.inside>INmax,1);
    if isempty(inmax)
        inmax=length(grid.inside);
    else
        inmax=inmax-1;
    end
    gridpart.inside=grid.inside(inmin:inmax);
    cfg.grid=gridpart;
    sourceRaw = ft_sourceanalysis(cfg, cov);
    filter(1,gridpart.inside)=sourceRaw.avg.filter(1,gridpart.inside);
end
save filter filter
%% sam on common filter
cd /home/yuval/Copy/social_motor_study/204707
load allIn1
load headmodel
%load filter
load sourceRaw
wts=filter2wts(sourceRaw.avg.filter);
boxSize=[-0.120	0.160 -0.0900 0.0900 -0.0500 0.150];

load inc
% reconstructing source trace
ns=mean(abs(wts),2);
ns=repmat(ns,1,length(inc.time));
incVS=wts*inc.avg;
%conVS=ActWgts*con.avg;
incVSabs=abs(incVS)./ns;
fac=round(log10(max(max(abs(incVSabs)))));
incVSabs=incVSabs*10^-fac;

cfg=[];
cfg.step=5;
cfg.boxSize=1000*boxSize;
cfg.torig=-299.335; % beginning of VS in ms
cfg.TR=num2str(1000/678.17);
cfg.prefix='incFTabs';
if exist([cfg.prefix,'+orig.BRIK'],'file')
    eval(['!rm ',cfg.prefix,'+orig.*'])
end
VS2Brik(cfg,incVSabs);

load con
conVS=wts*con.avg;
%conVS=ActWgts*con.avg;
conVSabs=abs(conVS)./ns;
conVSabs=conVSabs*10^-fac;
cfg.prefix='conFTabs';
if exist([cfg.prefix,'+orig.BRIK'],'file')
    eval(['!rm ',cfg.prefix,'+orig.*'])
end
VS2Brik(cfg,conVSabs);

!~/abin/3dcalc -a incFTabs+orig -b conFTabs+orig -exp 'a/b-b' -prefix incDivCon
!~/abin/3dcalc -a incFTabs+orig -b conFTabs+orig -exp 'a-b' -prefix incMinCon
 
 