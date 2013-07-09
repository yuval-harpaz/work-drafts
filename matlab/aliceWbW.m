function aliceWbW(subFold)
cd /home/yuval/Data/alice
cd(subFold)
load files/evt
load files/triggers
megFNc=ls('*lf*');
megFNc=megFNc(1:end-1);
trig=readTrig_BIU(megFNc);
load files/indEOG.mat
load files/topoEOG
topoHeeg=topoH;
topoVeeg=topoV;
load files/topoMOG
topoHmeg=topoH;
topoVmeg=topoV;
clear topoH topoV
if strcmp(subFold,'maor')
    if exist ('files/triggersWbW.mat','file')
        load files/triggersWbW
    else
        trigS=find(clearTrig(trig)==50);
        save files/triggersWbW trigS
    end
    trlMEG=trigS(1:50)';
    trlMEG=trlMEG-203;
    trlMEG(:,2)=trlMEG+814;
    trlMEG(:,3)=-203;
    time0=round(1024*evt(evt(:,3)==50,1));
    trlEEG=[time0-205,time0+614,-205*ones(length(time0),1)];
    trlEEG=trlEEG(1:50,:);
else
    startSeeg=round(evt(find(evt(:,3)==50,1),1)*1024);
    endSeeg=round(evt(find(evt(:,3)==50,1)+1,1)*1024);
    startSmeg=trigS(find(trigV==50,1));
    endSmeg=trigS(find(trigV==50,1)+1);
    megSR=(endSmeg-startSmeg)/((endSeeg-startSeeg)/1024);
    if round(megSR)~=1017
        error('problem detecting MEG sampling rate')
    end
    if exist ('files/triggersWbW.mat','file')
        load files/triggersWbW
    else
        
        trVis=bitand(uint16(trig),2048);
        visDif=zeros(size(trig));
        visDif(2:end)=diff(trVis);
        trigS=find(visDif==2048);
        trigS=trigS(find(trigS>startSmeg));
        trigS=trigS(find(trigS<endSmeg));
        save files/triggersWbW trigS
    end
    trlMEG=trigS(1:50)';
    trlEEG=round((trlMEG-startSmeg)/megSR*1024)+startSeeg;
    trlMEG=trlMEG-203;
    trlMEG(:,2)=trlMEG+814;
    trlMEG(:,3)=-203;
    trlEEG=trlEEG-205;
    trlEEG(:,2)=trlEEG+819;
    trlEEG(:,3)=-205;
end





% EEG
cfg=[];
% cfg.channel='EEG';%{'HEOG','VEOG'};
cfg.demean='yes';
cfg.baselainewindow=[-0.2 0];
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.padding=0.7;
cfg.trl=trlEEG;
eeg=readCNT(cfg);

cfg=[];
% cfg.channel='EEG';%{'HEOG','VEOG'};
cfg = [];
cfg.topo      = [topoHeeg(1:32,1),topoVeeg(1:32,1)];
cfg.topolabel = eeg.label(1:32);
comp     = ft_componentanalysis(cfg, eeg);
cfg = [];
cfg.component = [1,2];
eegpca = ft_rejectcomponent(cfg, comp,eeg);
cfg=[];
cfg.channel='EEG';
cfg.trials=1:50;
avgWbWeeg=ft_timelockanalysis(cfg,eegpca);
avgWbWeeg=correctBL(avgWbWeeg,[-0.2,0])
cfg=[];
cfg.layout='WG32.lay';
cfg.interactive='yes';
figure;
ft_multiplotER(cfg,avgWbWeeg)

% MEG
cfg=[];
cfg.demean='yes';
cfg.baselainewindow=[-0.2 0];
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.padding=0.7;
cfg.trl=trlMEG;
cfg.dataset=megFNc;
cfg.channel='MEG';
meg=ft_preprocessing(cfg);

cfg = [];
cfg.topo      = [topoHmeg(1:248,1),topoVmeg(1:248,1)];
cfg.topolabel = meg.label(1:248);
comp     = ft_componentanalysis(cfg, meg);
cfg = [];
cfg.component = [1,2];
megpca = ft_rejectcomponent(cfg, comp,meg);


cfg=[];
cfg.channel='MEG';
cfg.trials=1:50;
avgWbWmeg=ft_timelockanalysis(cfg,megpca);
avgWbWmeg=correctBL(avgWbWmeg,[-0.2,0])
cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
figure;
ft_multiplotER(cfg,avgWbWmeg)
pause
save avgWbW avgWbWeeg avgWbWmeg
%FIXME - correct for diode;