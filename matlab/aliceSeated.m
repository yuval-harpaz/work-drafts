sub='yoni';
cd /media/YuvalExtDrive/alpha/SEATED
Afreq=[3 6 9 10 11 12 15 20 25 30 40 50 60 70 80 90 100];
cd(sub);

fileName='c,rfhp0.1Hz';
p=pdf4D(fileName);
cleanCoefs = createCleanFile(p, fileName,...
    'byLF',[] ,...
    'xClean',[4,5,6],...
    'byFFT',0,...
    'HeartBeat',[])
LS=ls('*_c,*');
LS=LS(1:end-1);
trl=[10000:1000:69000]';
trl(:,2)=trl+1000;
trl(:,3)=0;
cfg=[];
cfg.trl=trl;
cfg.demean='yes';
cfg.dataset=LS;
cfg.channel='MEG';
meg=ft_preprocessing(cfg);

cfg=[];
cfg.method='abs';
cfg.criterion='sd';
cfg.critval=3;
good=badTrials(cfg,meg,0);

cfg=[];
cfg.output       = 'pow';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.trials=good;
cfg.foi          = Afreq;
cfg.feedback='no';
cfg.keeptrials='yes';
megFr = ft_freqanalysis(cfg, meg);
cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
cfg.xlim=[10 10];
figure;
ft_topoplotER(cfg,megFr);
save megFr megFr
%% Sheraz
cd /home/yuval/Copy/MEGdata/alpha/sheraz

LS=ls('*.fif');
LS=LS(1:end-1);
hdr=ft_read_header(LS);
trl=[1,hdr.nSamples,0];
cfg=[];
cfg.trl=trl;
cfg.demean='yes';
cfg.dataset=LS;
cfg.channel='MEGMAG';
mag=ft_preprocessing(cfg);
meanMAG=mean(mag.trial{1,1});

% cfg.channel='MEGGRAD';
% grd=ft_preprocessing(cfg);
cfg.channel='MEG';
meg=ft_preprocessing(cfg);

figOptions.label=meg.label;
figOptions.layout='neuromag306mag.lay';
clear mag
[cleanMEG,tempMEG,periodMEG,mcgMEG,RtopoMEG]=correctHB(meg.trial{1,1},meg.fsample,figOptions,meanMAG);



