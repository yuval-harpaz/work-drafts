function aliceWbW2
%sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
sf={'maor'};
for sfi=1:length(sf)
    subFold=sf{sfi};
    % checks peak to peak alpha as percent of time
    
    %thr=3;
    %thr='%75';
    %thr='v0.55';
    
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
BLlength=0.5;
BLe=round(1024*BLlength);
BLm=round(1017.25*BLlength);
if strcmp(subFold,'maor')
    if exist ('files/triggersWbW.mat','file')
        load files/triggersWbW
    else
        trigS=find(clearTrig(trig)==50);
        save files/triggersWbW trigS
    end
    %trlMEG=trigS(1:50)';
    trlMEG=trigS';
    trlMEG=trlMEG-BLm;
    trlMEG(:,2)=trlMEG+BLm+814;
    trlMEG(:,3)=-BLm;
    time0=round(1024*evt(evt(:,3)==50,1));
    trlEEG=[time0-BLe,time0+819,-BLe*ones(length(time0),1)];
    %trlEEG=trlEEG(1:50,:); % trlEEG+BLe+819
    startSeeg=round(evt(find(evt(:,3)==50,1),1)*1024);
    endSeeg=round(evt(find(evt(:,3)==50,1)+1,1)*1024);
    startSmeg=trigS(find(trigV==50,1));
    endSmeg=trigS(find(trigV==50,1)+1);
    megSR=(endSmeg-startSmeg)/((endSeeg-startSeeg)/1024);
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
    %trlMEG=trigS(1:50)';
    trlMEG=trigS';
    trlEEG=round((trlMEG-startSmeg)/megSR*1024)+startSeeg;
    trlMEG=trlMEG-BLm;
    trlMEG(:,2)=trlMEG+BLm+814;
    trlMEG(:,3)=-BLm;
    trlEEG=trlEEG-BLe;
    trlEEG(:,2)=trlEEG+BLe+819;
    trlEEG(:,3)=-BLe;
end
%if ~exist('avgWbW2.mat','file')
    
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
    % cfg.trials=1:50;
    avgWbWeeg=ft_timelockanalysis(cfg,eegpca);
    avgWbWeeg=correctBL(avgWbWeeg,[-0.2,0])
%     cfg=[];
%     cfg.layout='WG32.lay';
%     cfg.interactive='yes';
%     figure;
%     ft_multiplotER(cfg,avgWbWeeg)
    
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
    %cfg.trials=1:50;
    avgWbWmeg=ft_timelockanalysis(cfg,megpca);
    avgWbWmeg=correctBL(avgWbWmeg,[-0.2,0])
%     cfg=[];
%     cfg.layout='4D248.lay';
%     cfg.interactive='yes';
%     figure;
%     ft_multiplotER(cfg,avgWbWmeg)
%    pause
    disp(['saving ',subFold])
    save avgWbW2 avgWbWeeg avgWbWmeg megpca eegpca
end




% %% alpha
% if ~exist('./frWBW.mat','file')
%     load LRpairsEEG
%     LRpairsEEG=LRpairs;
%     load LRpairs
%     % EEG
%     sampBeg=startSeeg;
%     sampEnd=sampBeg+60*1024;
%     samps1s=sampBeg:1024:sampEnd-1;
%     trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
%     [eegFrWBW,eegLRWBW,eegCohWBW]=pow(trl,LRpairsEEG);
%     % MEG
%     sampBeg=trigS(find(trigV==50,1));
%     sampEnd=sampBeg+60*1017.23;
%     samps1s=sampBeg:1017:sampEnd-100;
%     trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
%     [megFrWBW,megLRWBW,megCohWBW]=pow(trl,LRpairs);
%     save frWBW megFrWBW megLRWBW megCohWBW eegFrWBW eegLRWBW eegCohWBW
% end
% function [Fr,LR,coh]=pow(trl,LRpairs)
% EEG=true;
% if length(LRpairs)==115
%     EEG=false;
% end
% cfg=[];
% cfg.trl=trl;
% cfg.channel='MEG';
% if EEG
%     cfg.channel='EEG';
% end
% cfg.demean='yes';
% cfg.feedback='no';
% if EEG
%     data=readCNT(cfg);
% else
%     LSclean=ls('*lf*');
%     cfg.dataset=LSclean(1:end-1);
%     data=ft_preprocessing(cfg);
% end
% cfg=[];
% %cfg.trials=find(datacln.trialinfo==222);
% cfg.output       = 'pow';
% %    cfg.channel      = 'MEG';
% cfg.method       = 'mtmfft';
% cfg.taper        = 'hanning';
% cfg.foi          = 1:100;
% cfg.feedback='no';
% Fr = ft_freqanalysis(cfg, data);
% LR=Fr;
% LR.powspctrm=zeros(size(Fr.powspctrm));
% for pairi=1:length(LRpairs)
%     chL=find(ismember(LR.label,LRpairs(pairi,1)));
%     chR=find(ismember(LR.label,LRpairs(pairi,2)));
%     LR.powspctrm(chR,:)=Fr.powspctrm(chR,:)-Fr.powspctrm(chL,:);
%     LR.powspctrm(chL,:)=Fr.powspctrm(chL,:)-Fr.powspctrm(chR,:);
% end
% 
% cfg           = [];
% cfg.method    = 'mtmfft';
% cfg.output    = 'fourier';
% cfg.tapsmofrq = 1;
% cfg.foi=1:100;
% freq          = ft_freqanalysis(cfg, data);
% % coherence Left - Right
% %load ~/ft_BIU/matlab/files/LRpairs
% cfg=[];
% cfg.channelcmb=LRpairs;
% cfg.method    = 'coh';
% cohLR          = ft_connectivityanalysis(cfg, freq);
% % prepare for powspctrm display
% coh={};
% coh.label=data.label;
% coh.dimord='chan_freq';
% coh.freq=cohLR.freq;
% %coh.grad=data.grad;
% cohspctrm=ones(248, size(cohLR.cohspctrm,2));
% for cmbi=1:length(LRpairs);
%     chi=find(strcmp(cohLR.labelcmb{cmbi,1},data.label));
%     cohspctrm(chi,:)=cohLR.cohspctrm(cmbi,:);
%     chi=find(strcmp(cohLR.labelcmb{cmbi,2},data.label));
%     cohspctrm(chi,:)=cohLR.cohspctrm(cmbi,:);
% end
% coh.powspctrm=cohspctrm;
