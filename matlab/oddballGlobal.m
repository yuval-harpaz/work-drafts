[vol,grid,mesh,M1]=headmodel_BIU([],[],[],[],'localspheres');
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

cfg9 = [];
cfg9.interactive = 'yes';
cfg9.funparameter = 'avg.nai';
cfg9.method='ortho';
figure;ft_sourceplot(cfg9,inai)
%% raw
cfg=[];
cfg.dataset=source;
cfg.trialfun='trialfun_beg';
cfg2=ft_definetrial(cfg);
cfg2.trl=trl;
cfg2.demean='yes';
cfg2.baselinewindow=[-0.2 0];
cfg2.bpfilter='yes';
cfg2.bpfreq=[3 30];
cfg2.channel={'MEG','MEGREF'};
data=ft_preprocessing(cfg2);

cfg7.keeptrials='yes';
cov=timelockanalysis(cfg7, data);
cov.grad=ft_convert_units(cov.grad,'mm');
cfg8        = [];
cfg8.method = 'sam';
cfg8.grid= grid;
cfg8.vol    = vol;
cfg8.sam.lambda = 0.05;
cfg8.keepfilter='no';
cfg8.keepfilter='yes';
%cfg8.rawtrial='yes';
%cfg8.fixedori='robert'; % 'stephen' doesn't work; default is spinning.
sourceGlobal = ft_sourceanalysis(cfg8, cov);
trialN     = size(data.trial,2);
[sensN tN] = size(data.trial{1});
srcN 	   = length(sourceGlobal.inside);
for i=1:srcN,
    m = sourceGlobal.inside(i);
    if ~isempty(sourceGlobal.avg.filter{m})
        %                sourceAvg.mom{m} = sourceGlobal.avg.filter{m}(1,ismeg)*EMSEdata;
        sourceAvg.mom{m} = sourceGlobal.avg.filter{m}*standard.avg;
        
    end
end

% calculating NAI, dividing data of interest by noise
timewin=toi;
samp1=nearest(standard.time,timewin(1));
sampEnd=nearest(standard.time,timewin(2));
noise1=nearest(standard.time,timewin(1)-timewin(2));
noiseEnd=nearest(standard.time,0);
pow=zeros(1,length(sourceGlobal.pos));
noise=pow;
for i=1:srcN,
    m = sourceGlobal.inside(i);
    if ~isempty(sourceGlobal.avg.filter{m})
        pow(m) = mean((sourceAvg.mom{m}(1,samp1:sampEnd)).^2);
        noise(m) = mean((sourceAvg.mom{m}(1,noise1:noiseEnd)).^2);
    end
end
nai=(pow-noise)./noise;
source=sourceGlobal;source.avg.pow=pow;source.avg.nai=nai;source.avg.noise=noise;
cfg10 = [];
cfg10.parameter = 'all';

naigi = ft_sourceinterpolate(cfg10, source,MRIcr)
figure;ft_sourceplot(cfg9,naigi);

wtsNoSuf='SAM/allTrials,1-40Hz,Alla';
[SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);