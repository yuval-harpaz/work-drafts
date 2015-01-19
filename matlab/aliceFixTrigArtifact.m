function aliceFixTrigArtifact
% fix trigger artifact
cd /home/yuval/Data/alice/maor
load files/evt
load files/triggers
megFNc=ls('*lf*');
megFNc=megFNc(1:end-1);
%trig=readTrig_BIU(megFNc);
load files/indEOG.mat
load files/topoEOG
load files/topoMOG
topoHmeg=topoH;
topoVmeg=topoV;
clear topoH topoV
load files/triggersWbW
trlMEG=trigS';%(1:50)';
trlMEG=trlMEG-203;
trlMEG(:,2)=trlMEG+814;
trlMEG(:,3)=-203;

BLlength=0.5;
BLm=round(1017.25*BLlength);
trlMEG2=trigS';
trlMEG2=trlMEG2-BLm;
trlMEG2(:,2)=trlMEG2+BLm+814;
trlMEG2(:,3)=-BLm;
% 50 trials
cfg=[];
cfg.demean='yes';
cfg.baselainewindow=[-0.2 0];
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.padding=2;
cfg.trl=trlMEG;
cfg.dataset=megFNc;
cfg.channel='MEG';
meg=ft_preprocessing(cfg);
cfg.trl=trlMEG2;
meg2=ft_preprocessing(cfg);
% cfg.channel='TRIGGER';
% trig=ft_preprocessing(cfg);
cfg = [];
cfg.topo      = [topoHmeg(1:248,1),topoVmeg(1:248,1)];
cfg.topolabel = meg.label(1:248);
comp     = ft_componentanalysis(cfg, meg);
cfg = [];
cfg.component = [1,2];
megpca = ft_rejectcomponent(cfg, comp,meg);

cfg=[];
cfg.channel='MEG';
%cfg.trials=1:50;
avgWbWmeg=ft_timelockanalysis(cfg,megpca);
avgWbWmeg=correctBL(avgWbWmeg,[-0.2,0]);
% cfg=[];
% cfg.layout='4D248.lay';
% cfg.interactive='yes';
% figure;
% ft_multiplotER(cfg,avgWbWmeg)
%    save avgWbW avgWbWeeg avgWbWmeg
trigTopo=mean(avgWbWmeg.avg(:,nearest(avgWbWmeg.time,0.01):nearest(avgWbWmeg.time,0.04)),2);
cfg = [];
cfg.topo      = [topoHmeg(1:248,1),topoVmeg(1:248,1),trigTopo];
cfg.topolabel = meg.label(1:248);
comp     = ft_componentanalysis(cfg, meg);
comp2     = ft_componentanalysis(cfg, meg2);

cfg = [];
cfg.component = [1,2,3];
megpca = ft_rejectcomponent(cfg, comp,meg);
megpca2 = ft_rejectcomponent(cfg, comp2,meg2);

cfg=[];
cfg.channel='MEG';
cfg.trials=1:50;
avgWbWmeg=ft_timelockanalysis(cfg,megpca);
avgWbWmeg=correctBL(avgWbWmeg,[-0.2,0]);
%save avgWbWfixedArtifact avgWbWmeg megpca
cfg=[];
cfg.channel='MEG';
%cfg.trials=1:50;
avgWbWmeg=ft_timelockanalysis(cfg,megpca2);
avgWbWmeg=correctBL(avgWbWmeg,[-0.2,0]);
megpca=megpca2;
save avgWbW2fixedArtifact avgWbWmeg megpca

% cfg=[];
% cfg.layout='4D248.lay';
% cfg.interactive='yes';
% figure;
% ft_multiplotER(cfg,avgWbWmeg)


% comp1=comp;
% for triali=1:50
%     comp1.trial{triali}(3,:)=trig.trial{triali};
% end
% cfg = [];
% cfg.component = [1,2,3];
% megpca1 = ft_rejectcomponent(cfg, comp1,meg);
% cfg=[];
% cfg.channel='MEG';
% cfg.trials=1:50;
% avgWbWmeg1=ft_timelockanalysis(cfg,megpca1);
% avgWbWmeg1=correctBL(avgWbWmeg1,[-0.2,0]);
% cfg=[];
% cfg.layout='4D248.lay';
% cfg.interactive='yes';
% figure;
% ft_multiplotER(cfg,avgWbWmeg1,avgWbWmeg1)