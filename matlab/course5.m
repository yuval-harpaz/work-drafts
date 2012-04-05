% somsens data



%% rejecy high frequency noise trials (muscle artifact)

% here we read the data with a 60Hz high pass filter 
% we take a large window because of the sliding windows for low freqs
fileName='xc,lf,hb_c,rfhp0.1Hz';
cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.5;
cfg.trialdef.poststim=1;
cfg.trialdef.offset=-0.5;
cfg.trialdef.visualtrig= 'visafter';
cfg.trialfun='BIUtrialfun';
cfg.trialdef.eventvalue= [222 230 240 250];
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




% use the previous cfg1 but now with no filter (so also no padding).
cfg1.hpfilter='no';
cfg1.padding=0;
cfg1.baselinewindow=[-0.5 0];
save cfg1 cfg1;
dataorig=ft_preprocessing(cfg1);


%% clean MOG by PCA
% first clear some memory
clear datahf datahfrv

trig=readTrig_BIU(fileName);
trig=clearTrig(trig);
% up-down eye movement
startt=find(trig==50,1)/1017.25; %877.4451
endt=find(trig==52,1)/1017.25; %886.3406
cfg2=[];
cfg2.dataset=fileName;
cfg2.trialdef.beginning=startt;
cfg2.trialdef.end=endt;
cfg2.trialfun='trialfun_raw'; % the other usefull trialfun we have are trialfun_beg and trialfun_BIU
cfg3=ft_definetrial(cfg2);
cfg3.demean='yes';% old version was: cfg1.blc='yes';
%cfg1.baselinewindow=[-0.1,0];
cfg3.lpfilter='yes';
cfg3.lpfreq=40;
cfg3.channel='MEG';
MOGud=ft_preprocessing(cfg3);
% left right eye movement
startt=find(trig==52,1)/1017.25;
endt=find(trig==54,1)/1017.25;
cfg2.trialdef.beginning=startt;
cfg2.trialdef.end=endt;
cfg4=ft_definetrial(cfg2);
cfg4.demean='yes';% old version was: cfg1.blc='yes';
%cfg1.baselinewindow=[-0.1,0];
cfg4.lpfilter='yes';
cfg4.lpfreq=40;
cfg4.channel='MEG';
MOGlr=ft_preprocessing(cfg4);

cfgc=[];
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
%% now you clean the data from MOG
% set the bad comps as the value for cfgrc.component.
cfgrc = [];
cfgrc.component = 1; % change
dataca = ft_rejectcomponent(cfgrc, compMOGud,dataorig);
cfgrc.component = 1; 
dataca = ft_rejectcomponent(cfgrc, compMOGlr,dataca);

% save dataca dataca
clear dataorig comp* MOG* trig

% clear the workspace a little.

%% check if there are bad trials left
cfg=[];
cfg.method='summary'; %trial
cfg.channel='MEG';
cfg.alim=1e-12;
datacln=ft_rejectvisual(cfg, dataca);

clear dataca
%% frequency analysis
cfgfr=[];
%cfgfr.trials=find(datacln.trialinfo==222);
cfgfr.output       = 'pow';
cfgfr.channel      = 'MEG';
cfgfr.method       = 'mtmfft';
cfgfr.taper        = 'hanning';
cfgfr.foi          = 1:100;
FrAll = ft_freqanalysis(cfgfr, datacln);

% plot results for alpha
cfgp = [];
cfgp.xlim = [9 11];         
cfgp.layout       = '4D248.lay';
cfgp.interactive='yes';
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
% cfgtfr.t_ftimwin    = ones(length(cfgtfr.foi),1).*0.5;  % length of time window fixed at 0.5 sec
cfgtfr.t_ftimwin    = 1./cfgtfr.foi;                       % 1 cycle per window
cfgtfr.toi          = -0.1:0.02:0.5;                    % time window "slides" from -0.1 to 0.5 sec in steps of 0.02 sec (20 ms)
TFrAll = ft_freqanalysis(cfgtfr, datacln);

cfgp = [];
cfg.ylim = [3 30];         
cfgp.layout       = '4D248.lay';
cfgp.interactive='yes';
ft_multiplotTFR(cfgp, TFrAll);
% a bit messy. needs some normalization.
figure;
cfgp.baseline=[-0.5 0];
cfgp.baselinetype = 'relative'; %or 'absolute'
ft_multiplotTFR(cfgp, TFrAll);