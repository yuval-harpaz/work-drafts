% script: reuma

%% read the data

fileName='c,rfhp0.1Hz';
cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.2;
cfg.trialdef.poststim=0.7;
cfg.trialdef.offset=-0.2;
cfg.trialdef.visualtrig= 'visafter';
cfg.trialdef.visualtrigwin=0.3;
cfg.trialfun='BIUtrialfun';
cfg.trialdef.eventvalue= [20 40]; %angry
cfg1=ft_definetrial(cfg);
cfg1.demean='yes';% old version was: cfg1.blc='yes';
cfg1.baselinewindow=[-0.2,0];
cfg1.channel='MEG';
cfg1.bpfilter='yes';
cfg1.bpfreq=[1 40];
raw=ft_preprocessing(cfg1);

cfg=[];
cfg.method='summary'; %trial
datacln=ft_rejectvisual(cfg, raw);
trl=datacln.sampleinfo;
trl(:,3)=-203;
save trl trl

%avearaging
rawAvg=ft_timelockanalysis([],raw);
cfg4.layout='4D248.lay';
cfg4.interactive='yes';
cfg4.zlim=[-2e-13 2e-13];
ft_multiplotER(cfg4,rawAvg)

figure;
cfg5=[];
cfg5.interactive='yes';
cfg5.layout='butterfly';
cfg5.zlim=[-2e-13 2e-13];
ft_multiplotER(cfg5,rawAvg)

save rawAvg rawAvg

%% now averaging the clean file
load trl
fileName='hb,lf_c,rfhp0.1Hz';
cfg1=[];
cfg1.dataset=fileName;
cfg1.trl=trl;
cfg1.demean='yes';% old version was: cfg1.blc='yes';
cfg1.baselinewindow=[-0.2,0];
cfg1.channel='MEG';
cfg1.bpfilter='yes';
cfg1.bpfreq=[1 40];
clean=ft_preprocessing(cfg1);

% cfg=[];
% cfg.method='summary'; %trial
% datacln=ft_rejectvisual(cfg, clean);
% trl=datacln.sampleinfo;
% trl(:,3)=-203;
% save trl trl


%avearaging
cleanAvg=ft_timelockanalysis([],clean);
save cleanAvg cleanAvg
load rawAvg
cfg4.layout='4D248.lay';
cfg4.interactive='yes';
cfg4.zlim=[-2e-13 2e-13];
ft_multiplotER(cfg4,cleanAvg,rawAvg)

