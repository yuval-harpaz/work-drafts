%% clean HB
megFN='c,rfhp0.1Hz';
p=pdf4D(megFN);
cleanCoefs = createCleanFile(p, megFN,...
    'byLF',256 ,'Method','Adaptive',...
    'xClean',[4,5,6],...
    'byFFT',0,...
    'HeartBeat',[]);
%% find saccades

eegFN=ls('*.cnt');
eegFN=eegFN(1:end-1);

cfg=[];
cfg.channel={'HEOG','VEOG'};
cfg.demean='yes';
cfg.lpfilter='yes';
cfg.lpfreq=40;
eog=readCNT(cfg);
evt=readTrg;
evt=evt(evt(:,3)>0,:);
startS=round(evt(find(evt(:,3)==2),1)*eog.fsample);
endS=round(evt(find(evt(:,3)==2)+1,1)*eog.fsample);
eogSeg=eog.trial{1,1}(:,startS:endS);
plot(eog.time{1,1}(startS:endS),eogSeg)
legend('HEOG','VEOG')
[wordS,rowS]=findSaccade(eogSeg(2,:),2,1.5);
samps=sortrows([wordS,rowS;ones(size(wordS)),3*ones(size(rowS))]');
samps(:,1)=samps(:,1)+startS-1;
cfg=[];
% cfg.channel='EEG';%{'HEOG','VEOG'};
cfg.demean='yes';
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.padding=0.7;
cfg.trl=[samps(:,1)-205,samps(:,1)+614,-205*ones(length(samps),1)];
eeg=readCNT(cfg);
eeg.trialinfo=samps(:,2);

%% pca
cfg=[];
cfg.method='pca';
comp           = ft_componentanalysis(cfg, eeg);
cfg=[];
cfg.layout='WG32.lay';
cfg.channel = {comp.label{1:5}};
cfgo=ft_databrowser(cfg,comp);
cfg=[];
cfg.trials=find(eeg.trialinfo==1);
avgComp=ft_timelockanalysis(cfg,comp);
plot(avgComp.time,avgComp.avg(1:5,:))
legend('1','2','3','4','5')
LRcomp=1;
[~,endSaccS]=max(abs(avgComp.avg(LRcomp,205:307)));

cfg = [];
cfg.component = LRcomp; % change
eegpca = ft_rejectcomponent(cfg, comp);


cfg=[];
cfg.channel='EEG';
avgEEG=ft_timelockanalysis(cfg,eegpca);
avgEEG.time=avgEEG.time-endSaccS/1024;
avgEEG=correctBL(avgEEG,[-0.1,0])
cfg=[];
cfg.layout='WG32.lay';
cfg.interactive='yes';
ft_multiplotER(cfg,avgEEG)
save seg1 avgEEG samps endSaccS


%% word by word
cfg=[];
% cfg.channel='EEG';%{'HEOG','VEOG'};
cfg.demean='yes';
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.padding=0.7;
time0=round(1024*evt(evt(:,3)==50,1));
cfg.trl=[time0-205,time0+614,-205*ones(length(time0),1)];
eeg=readCNT(cfg);
cfg=[];
cfg.channel='EEG';
avgWBW=ft_timelockanalysis(cfg,eeg);
avgWBW=correctBL(avgWBW,[-0.1,0])
cfg=[];
cfg.layout='WG32.lay';
cfg.interactive='yes';
figure;
ft_multiplotER(cfg,avgWBW)
save avgWBW avgWBW
% FIXME - correct for diode;
%% MEG

% see the components and find the HB and MOG artifact
% remember the numbers of the bad components and close the data browser
load ~/ft_BIU/matlab/plotwts
wts.avg=compMOG.topo(:,1);
figure;ft_topoplotER([],wts);
wts.avg=compMOG.topo(:,2);
figure;ft_topoplotER([],wts);

megFN='c,rfhp0.1Hz';
megFN=['xc,hb,lf_',megFN];



%trig=readTrig_BIU(megFN);
%trig=clearTrig(trig);

cfg=[];
cfg.trl=[starts,ends,starts];
cfg.demean='yes';
cfg.lpfilter='yes';
cfg.lpfreq=40;
cfg.channel={'MEG'};
cfg.dataset=['xc,hb,lf_',fileName];
MOG4pca=ft_preprocessing(cfg);

cfg.trl=[1,length(trig),0];
%cfg.lpfilter='no';
cfg.channel={'MEG','X1','X2'};
cfg.dataset=fileName;
MOGraw=ft_preprocessing(cfg);
% cfg=[];
% cfg.method='summary'; %trial
% cfg.channel='MEG';
% cfg.alim=1e-12;
% MOGcln=ft_rejectvisual(cfg, MOG);


cfg=[];
cfg.method='pca';
cfg.channel = 'MEG';
compMOG           = ft_componentanalysis(cfg, MOG4pca);
% see the components and find the HB and MOG artifact
% remember the numbers of the bad components and close the data browser
load ~/ft_BIU/matlab/plotwts
wts.avg=compMOG.topo(:,1);
figure;ft_topoplotER([],wts);
wts.avg=compMOG.topo(:,2);
figure;ft_topoplotER([],wts);
% red A154 blue A174

comp_V_H=[compMOG.topo(:,1),compMOG.topo(:,2)]';
save comp_V_H comp_V_H
mog_V_H=comp_V_H*MOGraw.trial{1,1}(1:248,:);

s=round(159*1017.25):round(169*1017.25);
t=MOGraw.time{1,1}(1,s);
figure;
plot(t,5e11*mog_V_H(2,s))
hold on
plot(t,MOGraw.trial{1,1}(249,s),'c')
%plot(t,MOGraw.trial{1,1}(1:249,s))

tRS=1.816e05;
plot(MOGraw.trial{1,1}(249,tRS:tRS+2*10172))
hold on
plot(trig(1,tRS:tRS+2*10172)./100,'y')
plot(5e11*mog_V_H(2,tRS:tRS+2*10172),'m')
plot(5e11*mog_V_H(1,tRS:tRS+2*10172),'r')

plot(MOGraw.time{1,1}(1,t),MOGraw.trial{1,1}(221,t),'c')
hold on
plot(MOGraw.time{1,1}(1,t),MOGraw.trial{1,1}(221,t),'b')

plot(MOGraw.time{1,1}(1,t),MOGraw.trial{1,1}(1:248,t))
