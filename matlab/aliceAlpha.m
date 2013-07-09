function aliceAlpha(subFold)
cd /home/yuval/Data/alice
cd(subFold)
LSclean=ls('*lf*');
megFNc=LSclean(1:end-1);
load LRpairsEEG
LRpairsEEG=LRpairs;
load LRpairs
load files/triggers
load files/evt
for piskai=2:2:18
    % EEG
    load(['files/seg',num2str(piskai)])
    sampBeg=samps(find(samps(:,2)==1,1),1);
    sampEnd=samps(find(samps(:,2)==1,1,'last'),1);
    samps1s=sampBeg:1024:sampEnd;
    trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
    [eegFr,eegLR,eegCoh]=pow(trl,LRpairsEEG);
    % title(num2str(piskai))
    eval(['eegFr',num2str(piskai),'=eegFr'])
    eval(['eegLR',num2str(piskai),'=eegLR'])
    eval(['eegCoh',num2str(piskai),'=eegCoh'])
    % MEG
    startSeeg=round(evt(find(evt(:,3)==piskai),1)*1024);
    endSeeg=round(evt(find(evt(:,3)==piskai)+1,1)*1024);
    startSmeg=trigS(find(trigV==piskai));
    endSmeg=trigS(find(trigV==piskai)+1);
    megSR=(endSmeg-startSmeg)/((endSeeg-startSeeg)/1024);
    if round(megSR)~=1017
        error('problem detecting MEG sampling rate')
    end
    trlMEG=round((trl(:,1)-startSeeg)/1024*megSR)+startSmeg;
    trlMEG(:,2)=trlMEG+1017;
    trlMEG(:,3)=zeros(length(trl),1);
    [megFr,megLR,megCoh]=pow(trlMEG,LRpairs);
    eval(['megFr',num2str(piskai),'=megFr'])
    eval(['megLR',num2str(piskai),'=megLR'])
    eval(['megCoh',num2str(piskai),'=megCoh'])
end
load files/evt
for resti=[100,102];
    % EEG
    sampBeg=round(evt(find(evt(:,3)==resti),1)*1024);
    sampEnd=sampBeg+60*1024;
    samps1s=sampBeg:1024:sampEnd-1;
    trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
    [eegFr,eegLR,eegCoh]=pow(trl,LRpairsEEG);
    % title(num2str(resti))
    eval(['eegFr',num2str(resti),'=eegFr'])
    eval(['eegLR',num2str(resti),'=eegLR'])
    eval(['eegCoh',num2str(resti),'=eegCoh'])
    % MEG
    sampBeg=trigS(find(trigV==resti));
    sampEnd=sampBeg+60*1017.23;
    samps1s=sampBeg:1017:sampEnd-100;
    trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
    [megFr,megLR,megCoh]=pow(trl,LRpairs);
    % title(num2str(resti))
    eval(['megFr',num2str(resti),'=megFr'])
    eval(['megLR',num2str(resti),'=megLR'])
    eval(['megCoh',num2str(resti),'=megCoh'])  
end
clear eegFr eegLR eegCoh megFr megLR megCoh 
save fr eegFr* eegLR* eegCoh* megFr* megLR* megCoh*




function [Fr,LR,coh]=pow(trl,LRpairs)
EEG=true;
if length(LRpairs)==115
    EEG=false;
end
cfg=[];
cfg.trl=trl;
cfg.channel='MEG';
if EEG
    cfg.channel='EEG';
end
cfg.demean='yes';
cfg.feedback='no';
if EEG
    data=readCNT(cfg);
else
    LSclean=ls('*lf*');
    cfg.dataset=LSclean(1:end-1);
    data=ft_preprocessing(cfg);
end
cfg=[];
%cfg.trials=find(datacln.trialinfo==222);
cfg.output       = 'pow';
%    cfg.channel      = 'MEG';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = 1:100;
cfg.feedback='no';
Fr = ft_freqanalysis(cfg, data);
LR=Fr;
LR.powspctrm=zeros(size(Fr.powspctrm));
for pairi=1:length(LRpairs)
    chL=find(ismember(LR.label,LRpairs(pairi,1)));
    chR=find(ismember(LR.label,LRpairs(pairi,2)));
    LR.powspctrm(chR,:)=Fr.powspctrm(chR,:)-Fr.powspctrm(chL,:);
    LR.powspctrm(chL,:)=Fr.powspctrm(chL,:)-Fr.powspctrm(chR,:);
end

cfg           = [];
cfg.method    = 'mtmfft';
cfg.output    = 'fourier';
cfg.tapsmofrq = 1;
cfg.foi=1:100;
freq          = ft_freqanalysis(cfg, data);
% coherence Left - Right
%load ~/ft_BIU/matlab/files/LRpairs
cfg=[];
cfg.channelcmb=LRpairs;
cfg.method    = 'coh';
cohLR          = ft_connectivityanalysis(cfg, freq);
% prepare for powspctrm display
coh={};
coh.label=data.label;
coh.dimord='chan_freq';
coh.freq=cohLR.freq;
%coh.grad=data.grad;
cohspctrm=ones(248, size(cohLR.cohspctrm,2));
for cmbi=1:length(LRpairs);
    chi=find(strcmp(cohLR.labelcmb{cmbi,1},data.label));
    cohspctrm(chi,:)=cohLR.cohspctrm(cmbi,:);
    chi=find(strcmp(cohLR.labelcmb{cmbi,2},data.label));
    cohspctrm(chi,:)=cohLR.cohspctrm(cmbi,:);
end
coh.powspctrm=cohspctrm;
% cfg=[];
% cfg.xlim=[9 9];
% cfg.layout='WG32.lay';
% ft_topoplotER(cfg,coh);


% plot results for alpha
% figure;
% for freqi=9:12
%     subplot(1,4,freqi-8)
%     cfg = [];
%     cfg.xlim = [freqi freqi];
%     cfg.zlim=[-0.2 0.2];
%     cfg.layout='WG32.lay';
%     %cfg.layout       = '4D248.lay';
%     %cfg.interactive='yes';
%     ft_topoplotER(cfg, eegLR);
% end





