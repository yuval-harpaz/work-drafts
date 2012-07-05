% animalsCln
fi=2;
cd /home/yuval/Data/Amyg
fldr=num2str(fi);
cd(fldr)
fileName='c,rfhp0.1Hz';
hdr=ft_read_header(fileName);
cfg=[];
%cfg.trl=[1,hdr.nSamples,0];
cfg.trl=[1,101725,0];
cfg.dataset=fileName;
cfg.demean='yes';
cfg.baselinewindow=[0 10];
cfg.channel={'MEG','-A74','-A204'};
cfg.bpfilter='yes';
cfg.bpfreq=[6:40];
raw=ft_preprocessing(cfg);
cfg=[];
cfg.method='pca';
comp=ft_componentanalysis(cfg,raw);
cfgb=[];
cfgb.layout='4D248.lay';
cfgb.channel = {comp.label{1:5}};
cfgb.continuous='yes';
cfgb.event.type='';
cfgb.event.sample=1;
cfgb.blocksize=3;
comppic=ft_databrowser(cfgb,comp);
save comp comp

cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventvalue=[100,102,104,106,108];
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.2;
cfg.trialdef.poststim=0.7;
cfg.trialdef.offset=-0.2;
cfg=ft_definetrial(cfg);
cfg.channel={'MEG','-A74','-A204'};
cfg.demean='yes';
cfg.baselinewindow=[-0.2 0];
% cfg.bpfilter='yes';
% cfg.bpfreq=[3 50];
cfg.hpfilter='yes';
cfg.hpfreq=1;
cfg.baselinewindow=[-0.15 0];
data=ft_preprocessing(cfg);

cfg = [];
cfg.topo      = comp.topo;
cfg.topolabel = comp.topolabel;
comp     = ft_componentanalysis(cfg, data);
cfg = [];
cfg.component = [1]; % change
data = ft_rejectcomponent(cfg, comp);
save data data
% 
% 
% cfg=[];
% cfg.trl=[1,hdr.nSamples,0];
% %cfg.trl=[1,101725,0];
% cfg.dataset=fileName;
% cfg.demean='yes';
% cfg.baselinewindow=[0 10];
% cfg.channel={'MEG','-A74','-A204'};
% cfg.bpfilter='yes';
% cfg.bpfreq=[6:40];
% raw=ft_preprocessing(cfg);
% 
% ECG=raw.trial{1,1}'*comp.topo(:,1);
% ECG=ECG';
% plot(ECG(1:10172))
% clear raw
% clear com*
% p=pdf4D(fileName);
% cleanCoefs = createCleanFile(p, fileName,'byLF',0,'byFFT',0,'HeartBeat',[],'ECG',ECG);
% title(['sub ',fldr])
% cd ..
% 
