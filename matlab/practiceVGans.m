%% 1.
fileName='c,rfhp0.1Hz';
p=pdf4D(fileName);
cleanCoefs = createCleanFile(p, fileName,...
    'byLF',256 ,'Method','Adaptive',...
    'xClean',[4,5,6],...
    'byFFT',0,...
    'HeartBeat',[]);

%% 2.
fileName='xc,hb,lf_c,rfhp0.1Hz';
cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.2;
cfg.trialdef.poststim=0.6;
cfg.trialdef.offset=-0.2;
cfg.trialdef.visualtrig= 'visafter';
cfg.trialfun='BIUtrialfun';
cfg.trialdef.eventvalue= 202;
cfg=ft_definetrial(cfg);

cfg.demean='yes';
cfg.baselinewindow=[-0.2 0];
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.channel='MEG';
data=ft_preprocessing(cfg);


VGavg=timelockanalysis([],data);
cfg.layout='4D248.lay';
cfg.interactive='yes';
cfg.zlim=[-2e-13 2e-13];
ft_multiplotER(cfg,VGavg)

% %% 
% % cfgp=[];
% % cfgc.method='fastica';
% % cfgc.numcomponent=20;
% % comp           = ft_componentanalysis(cfgc, data);
% % cfgb=[];
% % cfgb.layout='4D248.lay';
% % cfgb.channel = {comp.label{1:5}};
% % comppic=ft_databrowser(cfgb,comp);
% % 
% % cfg=[];
% % cfg.method='summary';
% % cfg.channel='MEG';
% % cfg.alim=1e-12;
% % datacln=ft_rejectvisual(cfg, data);
% 
% 
% %% read data with baseline correction
% cfg1.demean='yes';% old version was: cfg1.blc='yes';
% cfg1.baselinewindow=[-0.1,0];
% blc=ft_preprocessing(cfg1);
% % averaging
% blcAvg=ft_timelockanalysis([],blc);
% % now make an interactive multiplot and look for the evoked response
% cfg4.layout='4D248.lay';
% cfg4.interactive='yes';
% cfg4.zlim=[-2e-13 2e-13];
% ft_multiplotER(cfg4,blcAvg)