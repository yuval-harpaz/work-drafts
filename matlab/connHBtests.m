
cd /media/yuval/win_disk/Data/connectomeDB/MEG
%cfg.jobs=2;
%correctLF([],[],[],cfg);
correctHB;
[~,hbTimes,~,~,MCG,Rtopo]=correctHB;
trl=hbTimes'*2034.25-203;
trl(:,2)=hbTimes'*2034.25+203;
trl(:,3)=-203;
trl=round(trl(2:end-1,:));
cfg=[];
cfg.dataset='hb_c,rfDC';
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.demean='yes';
cfg.channel='MEG';
cfg.padding=0.5;
cfg.trl=trl;
data=ft_preprocessing(cfg);
cfg=[];
%cfg.method='pca';
comp=ft_componentanalysis(cfg,data);
cfg=[];
cfg.channel=comp.label(1:5);
cfg.layout='4D248.lay';
ft_databrowser(cfg,comp)

%%
cd /media/yuval/win_disk/Data/connectomeDB/MEG/233326/unprocessed/MEG/3-Restin/4D
p=pdf4D('c,rfDC');
dr=get(p,'dr');
chi=channel_index(p,'E1','name');
ECG=-read_data_block(p,[],chi);
% EEGlf=correctLF(EEG,dr);
% ECG=EEGlf(1,:);
% [~,~]=correctHB([],[],[],ECG);
correctHB([],[],[],ECG);

[~,hbTimes,~,~,MCG,Rtopo]=correctHB([],[],[],ECG);
trl=hbTimes'*2034.25-203;
trl(:,2)=hbTimes'*2034.25+203;
trl(:,3)=-203;
trl=round(trl(2:end-1,:));
cfg=[];
cfg.dataset='hb_c,rfDC';
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.demean='yes';
cfg.channel='MEG';
cfg.padding=0.5;
cfg.trl=trl;
data=ft_preprocessing(cfg);
cfg=[];
%cfg.method='pca';
cfg.channel={'MEG','-A2'};
comp=ft_componentanalysis(cfg,data);
cfg=[];
cfg.channel=comp.label(1:5);
cfg.layout='4D248.lay';
ft_databrowser(cfg,comp)
%% noa
% got residual HB after cleaning default way and also with cfg.ampLinThr=0;
cd /media/yuval/MEG_B1/Noa_nasty_HB/sub6
correctHB('c1,rfhp0.1Hz');
!mv hb_c1,rfhp0.1Hz hb5cat_c1,rfhp0.1Hz
[~,hbTimes,~,~,MCG,Rtopo]=correctHB('c1,rfhp0.1Hz');
trl=hbTimes'*1017.25-103;
trl(:,2)=hbTimes'*1017.25+103;
trl(:,3)=-103;
trl=round(trl(2:end-1,:));
cfg=[];
cfg.dataset='hbLabels_c1,rfhp0.1Hz';
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.demean='yes';
cfg.channel='MEG';
cfg.padding=0.5;
cfg.trl=trl;
data=ft_preprocessing(cfg);
cfg=[];
%cfg.method='pca';
cfg.channel={'MEG','-A74','-A204'};
comp=ft_componentanalysis(cfg,data);
cfg=[];
cfg.channel=comp.label(1:5);
cfg.layout='4D248.lay';
ft_databrowser(cfg,comp)

cfg=[];
cfg.ampLinThr=0;
correctHB('c1,rfhp0.1Hz',[],[],[],cfg);
cfg=[];
cfg.dataset='hb_c1,rfhp0.1Hz';
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.demean='yes';
cfg.channel='MEG';
cfg.padding=0.5;
cfg.trl=trl;
data=ft_preprocessing(cfg);
cfg=[];
%cfg.method='pca';
cfg.channel={'MEG','-A74','-A204'};
comp=ft_componentanalysis(cfg,data);
cfg=[];
cfg.channel=comp.label(1:5);
cfg.layout='4D248.lay';
ft_databrowser(cfg,comp)

% no 2Hz hp filter when testing R amp

cfg=[];
cfg.ampFiltFreq=[];
correctHB('c1,rfhp0.1Hz',[],[],[],cfg);
!mv hb_c1,rfhp0.1Hz hbAvgAmp_c1,rfhp0.1Hz
% more HPfreq?
cfg=[];
cfg.ampFiltFreq=5;
correctHB('c1,rfhp0.1Hz',[],[],[],cfg);
cfg=[];
cfg.dataset='hb_c1,rfhp0.1Hz';
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.demean='yes';
cfg.channel='MEG';
cfg.padding=0.5;
cfg.trl=trl;
data=ft_preprocessing(cfg);
cfg=[];
cfg.channel={'MEG','-A74','-A204'};
comp=ft_componentanalysis(cfg,data);
cfg=[];
cfg.channel=comp.label(1:5);
cfg.layout='4D248.lay';
ft_databrowser(cfg,comp)

%% raw data

cd /media/yuval/MEG_B1/Noa_nasty_HB/sub6
fn='c1,rfhp0.1Hz';
pref={'hbAvgAmp_','hbLabels_','hb5cat_'};
load HBtimes
for filei=1:3
cfg=[];
cfg.dataset=[pref{filei},fn];
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.demean='yes';
cfg.channel='MEG';
cfg.padding=0.5;
data=ft_preprocessing(cfg);
data=ft_resampledata([],data);
cfg=[];
cfg.channel={'MEG','-A74','-A204'};
comp=ft_componentanalysis(cfg,data);

cfg=[];
cfg.channel=comp.label(1:5);
cfg.layout='4D248.lay';
ft_databrowser(cfg,comp)