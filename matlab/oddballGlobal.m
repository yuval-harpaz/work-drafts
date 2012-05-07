

load trl % this was calculated in course6 (auditory data)
source='c,rfhp0.1Hz';
cfg=[];
cfg.dataset=source;
cfg.trialfun='trialfun_beg';
cfg2=ft_definetrial(cfg);
cfg2.trl=trl;
cfg2.demean='yes';
cfg2.baselinewindow=[-0.2 0];
cfg2.bpfilter='yes';
cfg2.bpfreq=[3 30];
cfg2.channel={'MEG'};
data=ft_preprocessing(cfg2);

cfg4.trials=find(data.trialinfo==128);
standard=ft_timelockanalysis(cfg4,data);
cfg4.trials=find(data.trialinfo==64);
oddball=ft_timelockanalysis(cfg4,data);

% choose time of interest
cfg=[];
cfg.interactive='yes';
cfg.layout='4D248.lay';
cfg.zlim=[-5e-14 5e-14];
figure;
ft_multiplotER(cfg,standard,oddball);

toi=[0.216 0.301];
close all

% for SAM we have to create a text file with the timing of the trials by
% condition,
% and we want a list of all the trials pulled together.
% trl=data.cfg.trl;
trigTime=(trl(:,1)-trl(:,3))./1017.25;
Trig2mark(...
    'All',trigTime',...
    'Standard',trigTime(find(trl(:,4)==128),1)',...
    'Oddball',trigTime(find(trl(:,4)==64),1)',...
    'Novel',trigTime(find(trl(:,4)==32),1)');

fitMRI2hs('c,rfhp0.1Hz')

hs2afni % for AFNI (required for nudging)
% hs2afni('small'); % for ft_sourceplot (view only)

% to see the headshape on top of the MRI:
hdsh=ft_read_mri('hds+ORIG.BRIK');
hs_points=hdsh.anatomy>0;
mri=ft_read_mri('warped+ORIG.BRIK');
mri.anatomy=mri.anatomy+hs_points;
cfg=[];cfg.interactive='yes';
figure, ft_sourceplot(cfg,mri);
% see that the headshape fits the MRI with AFNI
% if you have to nudge this is the time.

% for Nolte model proceed to these steps
!~/abin/3dSkullStrip -input warped+orig -prefix mask -mask_vol -skulls -o_ply ortho
!meshnorm ortho_brainhull.ply > hull.shape

%% param file
cd ..
createPARAM('allTrials','ERF','All',toi,'All',[(toi(1)-toi(2)) 0],[1 40],[-0.1 0.5],[],[],'MultiSphere');


% to run SAM you have to be one folder above the data
!SAMcov -r oddball -d c,rfhp0.1Hz -m allTrials -v
!SAMwts -r oddball -d c,rfhp0.1Hz -m allTrials -c Alla -v
!SAMerf -r oddball -d c,rfhp0.1Hz -m allTrials -v
!cp oddball/SAM/*svl oddball/all.svl

%% SAM by individual grid with a fixed number of points

[vol,grid,mesh,M1]=headmodel_BIU([],[],[],[],'localspheres');
grid2t(grid);
!mv pnt.txt oddball/SAM/
!SAMwts -r oddball -d c,rfhp0.1Hz -m allTrials -c Alla -t pnt.txt -v
cd oddball/SAM;
wtsNoSuf='pnt.txt';
[SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts');

filter=wts2filter(ActWgts,grid.inside,size(grid.outside,1));


% [vol,grid,mesh,M1]=headmodel1; % [vol,grid,mesh,M1]=headmodel1([],[],5);
% sMRI = read_mri(fullfile(spm('dir'), 'canonical', 'single_subj_T1.nii'));
load ~/ft_BIU/matlab/files/sMRI.mat
%load modelScalp
%load LRchans
MRIcr=sMRI;
MRIcr.transform=inv(M1)*sMRI.transform; %
standard.grad=ft_convert_units(standard.grad,'mm');
t1=0.03;t2=0.08;
cfg7                  = [];
cfg7.covariance       = 'yes';
cfg7.removemean       = 'no';
cfg7.covariancewindow = [(t1-t2) 0];
%makeing template sourceloc just to create a structure
covpre=ft_timelockanalysis(cfg7, standard);
cfg8        = [];
cfg8.method = 'sam';
cfg8.grid= grid;
cfg8.vol    = vol;
cfg8.lambda = 0.05;
cfg8.keepfilter='yes';
source = ft_sourceanalysis(cfg8, covpre);
source.avg.filter=filter;


% calculating NAI, dividing data of interest by noise
timewin=toi;
samp1=nearest(standard.time,timewin(1));
sampEnd=nearest(standard.time,timewin(2));
noise1=nearest(standard.time,timewin(1)-timewin(2));
noiseEnd=nearest(standard.time,0);
pow=zeros(1,length(source.pos));
noise=pow;
sourceAvg=struct;sourceAvg.mom={};
for i=1:size(grid.inside,1)
    m = grid.inside(i);
    if ~isempty(source.avg.filter{m})
        sourceAvg.mom{m} = source.avg.filter{m}*standard.avg;
        
    end
end

for i=1:size(grid.inside,1)
    m = source.inside(i);
    if ~isempty(source.avg.filter{m})
        pow(m) = mean((sourceAvg.mom{m}(1,samp1:sampEnd)).^2);
        noise(m) = mean((sourceAvg.mom{m}(1,noise1:noiseEnd)).^2);
    end
end
nai=(pow-noise)./noise;
source=source;source.avg.pow=pow;source.avg.nai=nai;source.avg.noise=noise;
%% interpolate and plot
% load ~/ft_BIU/matlab/LCMV/pos
cfg10 = [];
cfg10.parameter = 'avg.nai';
inai = sourceinterpolate(cfg10, source,MRIcr)

cfg9 = [];
cfg9.interactive = 'yes';
cfg9.funparameter = 'avg.nai';
cfg9.method='ortho';
figure;ft_sourceplot(cfg9,inai)

cfg10 = [];
cfg10.parameter = 'all';

naigi = ft_sourceinterpolate(cfg10, source,MRIcr)
figure;ft_sourceplot(cfg9,naigi);

wtsNoSuf='SAM/allTrials,1-40Hz,Alla';
for i=1:srcN,
    m = source.inside(i);
    if ~isempty(filter{m})
        %                sourceAvg.mom{m} = sourceGlobal.avg.filter{m}(1,ismeg)*EMSEdata;
        sourceAvg.mom{m} = filter{m}*standard.avg;
        
    end
end
[SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
cfg=[];cfg.channel='MEG';standard=ft_timelockanalysis(cfg,data); % here we use only 248 chans

timewin=toi;
samp1=nearest(standard.time,timewin(1));
sampEnd=nearest(standard.time,timewin(2));
noise1=nearest(standard.time,timewin(1)-timewin(2));
noiseEnd=nearest(standard.time,0);
pow=zeros(1,length(source.pos));
noise=pow;
for i=1:srcN,
    m = source.inside(i);
    if ~isempty(filter{m})
        pow(m) = mean((sourceAvg.mom{m}(1,samp1:sampEnd)).^2);
        noise(m) = mean((sourceAvg.mom{m}(1,noise1:noiseEnd)).^2);
    end
end
nai=(pow-noise)./noise;
source=source;source.avg.pow=pow;source.avg.nai=nai;source.avg.noise=noise;
cfg10 = [];
cfg10.parameter = 'avg.nai';

naigi = ft_sourceinterpolate(cfg10, source,MRIcr)
cfg9 = [];
cfg9.interactive = 'yes';
cfg9.funparameter = 'avg.nai';
cfg9.method='ortho';
figure;ft_sourceplot(cfg9,naigi);