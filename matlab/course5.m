% somsens data



trig=readTrig_BIU('c,rfhp0.1Hz');
trig=clearTrig(trig);
% up-down eye movement
startt=find(trig==50,1)/1017.25;
endt=find(trig==52,1)/1017.25;
cfg=[];
cfg.dataset='hb_c,rfhp0.1Hz';
cfg.trialdef.beginning=startt;
cfg.trialdef.end=endt;
cfg.trialfun='trialfun_raw'; % the other usefull trialfun we have are trialfun_beg and trialfun_BIU
cfg1=ft_definetrial(cfg);
cfg1.demean='yes';% old version was: cfg1.blc='yes';
cfg1.baselinewindow=[-0.1,0];
cfg1.lpfilter='yes';
cfg1.lpfreq=40;
cfg1.channel='MEG';
MOGud=ft_preprocessing(cfg1);
% left right eye movement
startt=find(trig==52,1)/1017.25;
endt=find(trig==54,1)/1017.25;
cfg.trialdef.beginning=startt;
cfg.trialdef.end=endt;
cfg1=ft_definetrial(cfg);
cfg1.demean='yes';% old version was: cfg1.blc='yes';
cfg1.baselinewindow=[-0.1,0];
cfg1.lpfilter='yes';
cfg1.lpfreq=40;
cfg1.channel='MEG';
MOGlr=ft_preprocessing(cfg1);


%% PCA
cfgp=[];
cfgc.method='pca';
compMOGud           = ft_componentanalysis(cfgc, MOGud);
compMOGlr           = ft_componentanalysis(cfgc, MOGlr);
% see the components and find the HB and MOG artifact
% remember the numbers of the bad components and close the data browser
cfgb=[];
cfgb.layout='4D248.lay';
cfgb.channel = 1:5;
cfgb.continuous='yes';
cfgb.event.type='';
cfgb.event.sample=1;
cfgb.blocksize=3;
ft_databrowser(cfgb,compMOGud);

ft_databrowser(cfgb,compMOGlr);


fileName='hb_c,rfhp0.1Hz'; % we read an uncleaned file so we can see HB as a component.
cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.1;
cfg.trialdef.poststim=0.5;
cfg.trialdef.offset=-0.1;
cfg.trialdef.visualtrig= 'visafter';
cfg.trialfun='BIUtrialfun';
cfg.trialdef.eventvalue=  [222 230 240 250]; %left index finger
cfg1=ft_definetrial(cfg);
cfg1.demean='yes';% old version was: cfg1.blc='yes';
cfg1.baselinewindow='all';
cfg1.bpfilter='yes';
cfg1.bpfreq=[1 140];
cfg1.channel='MEG';
dataorig=ft_preprocessing(cfg1);
% set the bad comps as the value for cfgrc.component.
cfgrc = [];
cfgrc.component = 1; % change
dataca = ft_rejectcomponent(cfgrc, compMOGud,dataorig);
cfgrc.component = 1; 
dataca = ft_rejectcomponent(cfgrc, compMOGlr,dataca);

save dataca dataca

cfg=[];
cfg.method='summary'; %trial
cfg.channel='MEG';
cfg.alim=1e-12;
datacln=ft_rejectvisual(cfg, dataca);

