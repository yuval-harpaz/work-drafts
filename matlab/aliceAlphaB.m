function aliceAlphaB(subFold)
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
    %FIXME change the pow function to component analysis or something
    eeg=pow(trl,LRpairsEEG); %#ok<ASGLU>
    % title(num2str(piskai))
    %        eval(['eegFr',num2str(piskai),'=eegFr'])
    %         eval(['eegLR',num2str(piskai),'=eegLR'])
    %         eval(['eegCoh',num2str(piskai),'=eegCoh'])
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
    meg=pow(trlMEG,LRpairs);
    %         eval(['megFr',num2str(piskai),'=megFr'])
    %         eval(['megLR',num2str(piskai),'=megLR'])
    %         eval(['megCoh',num2str(piskai),'=megCoh'])
    if piskai==2
        EEG=eeg;
        MEG=meg;
    else
        prevTrl=length(EEG.trial);
        moreTrl=length(eeg.trial);
        EEG.trial(1,prevTrl+1:prevTrl+moreTrl)=eeg.trial;
        EEG.time(1,prevTrl+1:prevTrl+moreTrl)=eeg.time;
        MEG.trial(1,prevTrl+1:prevTrl+moreTrl)=meg.trial;
        MEG.time(1,prevTrl+1:prevTrl+moreTrl)=meg.time;
    end
end
load files/evt
for resti=[100,102];
    % EEG
    sampBeg=round(evt(find(evt(:,3)==resti),1)*1024);
    sampEnd=sampBeg+60*1024;
    samps1s=sampBeg:1024:sampEnd-1;
    trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
    eeg=pow(trl,LRpairsEEG);
    % title(num2str(resti))
    % MEG
    sampBeg=trigS(find(trigV==resti));
    sampEnd=sampBeg+60*1017.23;
    samps1s=sampBeg:1017:sampEnd-100;
    trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
    meg=pow(trl,LRpairs);
    % title(num2str(resti))
    prevTrl=length(EEG.trial);
    moreTrl=length(eeg.trial);
    EEG.trial(1,prevTrl+1:prevTrl+moreTrl)=eeg.trial;
    EEG.time(1,prevTrl+1:prevTrl+moreTrl)=eeg.time;
    MEG.trial(1,prevTrl+1:prevTrl+moreTrl)=meg.trial;
    MEG.time(1,prevTrl+1:prevTrl+moreTrl)=meg.time;
end


% clear eegFr eegLR eegCoh megFr megLR megCoh
% save fr eegFr* eegLR* eegCoh* megFr* megLR* megCoh*
% end
%% resample and run component analysis
cfg=[];
cfg.detrend='no';
eegRS=ft_resampledata(cfg,EEG);
megRS=ft_resampledata(cfg,MEG);
cfg=[];
cfg.method='fastica';
cfg.numcomponent=40;
% look for mu in MEG
megCA=ft_componentanalysis(cfg,megRS);
cfg=[];
cfg.output       = 'pow';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = [9:11,120];
cfg.feedback='no';
cfg.keeptrials='yes';
Fr = ft_freqanalysis(cfg, megCA);
alpha=max(Fr.powspctrm(:,:,1:3),[],3)./Fr.powspctrm(:,:,4);
alphaTrials=max(alpha,[],2);
FIXME find alpha trials, components or something
[aP,aF]=max(Fr.powspctrm(:,9:11)');
aF=aF'+8;aP=aP'./max(aP);
cfg=[];
cfg.layout='4D248.lay';
cfg.channel = {megCA.label{1:5}};
cfg=ft_databrowser(cfg,megCA);

eegRSm=eegRS;
eegRSm.label{end+1,1}='MEGcomp';
for triali=1:length(megCA.trial)
    eegRSm.trial{1,triali}(end+1,:)=megCA.trial{1,triali}(2,:);
end

cfg=[];
cfg.method='pca';
eegPCA=ft_componentanalysis(cfg,eegRSm);
eegICA=ft_componentanalysis([],eegRSm);
cfg.method='fastica';
eegFICA=ft_componentanalysis(cfg,eegRSm);

cfg=[];
cfg.layout='WG32.lay';
cfg.channel = {eegFICA.label{7}};
cfg=ft_databrowser(cfg,eegFICA);


for triali=4 %1:length(megCA.trial)
    X=real(eegFICA.trial{1,4}(:,:)');
    Y=megCA.trial{1,4}(2,:)';
    cr=corr(X,Y);
    [~,compi]=max(cr);
    
end

plot(eegPCA.time{1,1},eegPCA.trial{1,4}(33,:))






function data=pow(trl,LRpairs)
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





