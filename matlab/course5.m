% somsens data

%% clean MOG by PCA
fileName='xc,lf,hb_c,rfhp0.1Hz';
trig=readTrig_BIU(fileName);
trig=clearTrig(trig);
% up-down eye movement
startt=find(trig==50,1)/1017.25;
endt=find(trig==52,1)/1017.25;
cfg=[];
cfg.dataset=fileName;
cfg.trialdef.beginning=startt;
cfg.trialdef.end=endt;
cfg.trialfun='trialfun_raw'; % the other usefull trialfun we have are trialfun_beg and trialfun_BIU
cfg1=ft_definetrial(cfg);
cfg1.demean='yes';% old version was: cfg1.blc='yes';
%cfg1.baselinewindow=[-0.1,0];
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
%cfg1.baselinewindow=[-0.1,0];
cfg1.lpfilter='yes';
cfg1.lpfreq=40;
cfg1.channel='MEG';
MOGlr=ft_preprocessing(cfg1);

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
% remember the component number for up-down and for left-right MOG. we'll
% use it later after rejecting high freq noise.

%% rejecy high frequency noise trials (muscle artifact)

% here we read the data with a 60Hz high pass filter 

cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.1;
cfg.trialdef.poststim=0.5;
cfg.trialdef.offset=-0.1;
cfg.trialdef.visualtrig= 'visafter';
cfg.trialfun='BIUtrialfun';
cfg.trialdef.eventvalue=  [222 230 240 250];
cfg1=ft_definetrial(cfg);
cfg1.demean='yes';
cfg1.baselinewindow='all';
cfg1.hpfilter='yes';
cfg1.hpfreq=60; %SEE?
cfg1.channel='MEG';
cfg1.padding=0.1;
datahf=ft_preprocessing(cfg1); % data high freq
cfg=[];
cfg.method='summary';
cfg.channel='MEG';
cfg.alim=1e-12;
datahfrv=ft_rejectvisual(cfg, datahf); % data high freq reject visual
% reject bad trials

% here we take only good trials from cfg1.trl
trl=[];trlCount=1;
for trli=1:length(cfg1.trl)
    if ~ismember(cfg1.trl(trli,1),datahfrv.cfg.artifact)
        trl(trlCount,1:6)=cfg1.trl(trli,1:6);
        trlCount=trlCount+1;
    end
end
cfg1.trl=trl;
%cfg1.trl=reindex(datahf.cfg.trl,datahfrv.cfg.trl); % doesn't work with new FieldTrip

% clear the workspace a little.
clear data* MOG* trig trl*



% use the previous cfg1 but now with no filter (so also no padding).
cfg1.hpfilter='no';
cfg1.padding=0;
dataorig=ft_preprocessing(cfg1);

%% now you clean the data from MOG
% set the bad comps as the value for cfgrc.component.
cfgrc = [];
cfgrc.component = 1; % change
dataca = ft_rejectcomponent(cfgrc, compMOGud,dataorig);
cfgrc.component = 1; 
dataca = ft_rejectcomponent(cfgrc, compMOGlr,dataca);

% save dataca dataca
%% check if there are bad trials left
cfg=[];
cfg.method='summary'; %trial
cfg.channel='MEG';
cfg.alim=1e-12;
datacln=ft_rejectvisual(cfg, dataca);

%% frequency analysis
cfgfr=[];
%cfgfr.trials=find(datacln.trialinfo==222);
cfgfr.output       = 'pow';
cfgfr.channel      = 'MEG';
cfgfr.method       = 'mtmfft';
cfgfr.taper        = 'hanning';
cfgfr.foi          = 1:100;                         % analysis 4 to 90 Hz in steps of 2 Hz
%cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;   % length of time window = 0.3 sec
%cfg.toi          = -0.5:0.05:1;                  % time window "slides" from -0.5 to 1 sec in steps of 0.05 sec (50 ms)
FrAll = ft_freqanalysis(cfgfr, datacln);

% plot results for alpha
cfgp = [];
cfg.xlim = [8 13];         
cfgp.layout       = '4D248.lay';
cfg.interactive='yes';
ft_topoplotER(cfgp, FrAll);

% cfg.xlim = [1 40];    
% ft_multiplotER(cfg, FrAll);

%% time-frequency analysis
cfgtfr              = [];
cfgtfr.output       = 'pow';
cfgtfr.channel      = 'MEG';
cfgtfr.method       = 'mtmconvol';
cfgtfr.taper        = 'hanning';
cfgtfr.foi          = 3:100;                            % freq of interest 3 to 100Hz
cfgtfr.t_ftimwin    = ones(length(cfgtfr.foi),1).*0.5;   % length of time window = 0.5 sec
cfgtfr.toi          = -0.1:0.01:0.5;                  % time window "slides" from -0.1 to 0.5 sec in steps of 0.01 sec (10 ms)
TFrAll = ft_freqanalysis(cfgtfr, datacln);