
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
cd /media/yuval/win_disk/Data/connectomeDB/MEG/191841/unprocessed/MEG/3-Restin/4D
p=pdf4D('c,rfDC');
dr=get(pdf,'dr');
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
comp=ft_componentanalysis(cfg,data);
cfg=[];
cfg.channel=comp.label(1:5);
cfg.layout='4D248.lay';
ft_databrowser(cfg,comp)