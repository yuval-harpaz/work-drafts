function aliceAlphaB2(cond,Afreq)
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
for sfi=1:8
    cd /home/yuval/Data/alice
    cd(sf{sfi})
    LSclean=ls('*lf*');
    megFNc=LSclean(1:end-1);
    load LRpairsEEG
    LRpairsEEG=LRpairs;
    load LRpairs
    load files/triggers
    load files/evt
    resti=cond;
    % MEG
    sampBeg=trigS(find(trigV==resti));
    sampEnd=sampBeg+60*1017.23;
    samps1s=sampBeg:1017:sampEnd-100;
    trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
    meg=pow(trl,LRpairs);
    % title(num2str(resti))
    % clear eegFr eegLR eegCoh megFr megLR megCoh
    % save fr eegFr* eegLR* eegCoh* megFr* megLR* megCoh*
    % end
    %% resample and run component analysis
    cfg=[];
    cfg.output       = 'pow';
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = Afreq;
    cfg.feedback='no';
    cfg.keeptrials='yes';
    megFr = ft_freqanalysis(cfg, meg);
    maxfri=1;
    [~,maxch]=max(mean(megFr.powspctrm(:,:,maxfri),1));
    maxfr=megFr.freq(maxfri);
    cfg=[];
    cfg.layout='4D248.lay';
    cfg.highlight='labels';
    cfg.xlim=[maxfr maxfr];
    cfg.highlightchannel=megFr.label(maxch);
    figure;
    ft_topoplotER(cfg,megFr);
    title(sf{sfi})
end

% % % correlation between max alpha MEG channel and each EEG channel
% % for chi=1:length(eegRS.label)
% %     rt=0;
% %     for triali=1:length(eegRS.trial)
% %         rt=rt+corr(eegRS.trial{1,triali}(chi,:)',megRS.trial{1,triali}(maxch,:)');
% %     end
% %     R(chi)=rt/length(eegRS.trial);
% % end
% % R=abs(R);
% % [~,i]=max(R);
% % maxR=eeg.label{i};
% % r=R;
% % clear R
% % % correlation between max alpha MEG and EEG fft
% % for chi=1:length(eegRS.label)
% %     R(chi)=corr(eegFr.powspctrm(:,chi,maxfri),megFr.powspctrm(:,maxch,maxfri));
% % end
% % R(R<0)=0;
% % [v,i]=max(abs(R));
% % maxRf=eeg.label{i};
% % eegR=eegFr;
% % eegR.powspctrm=mean(eegFr.powspctrm,1);
% % R(isnan(R))=0;
% % eegR.powspctrm(1,:,maxfri)=R;
% % cfg=[];
% % cfg.layout='WG32.lay';
% % cfg.highlight='labels';
% % cfg.xlim=[maxfr maxfr];
% % cfg.zlim=[0 1];
% % cfg.highlightchannel=maxRf;
% % figure;
% % ft_topoplotER(cfg,eegR);
% % colorbar
% % title('fft corr')
% %
% % figure;
% % cfg.highlightchannel=maxR;
% % r(isnan(r))=0;
% % eegR.powspctrm(1,:,maxfri)=r;
% % ft_topoplotER(cfg,eegR);
% % colorbar
% % title('raw corr')
% %cfg.method='fastica';
% %cfg.method='pca';
% %cfg.numcomponent=40;
% megCA=ft_componentanalysis([],megRS);
% cfg=[];
% cfg.layout='4D248.lay';
% cfg.channel = {megCA.label{1:5}};
% cfg=ft_databrowser(cfg,megCA);
% %FrCA = ft_freqanalysis(cfg, megCA);
%
%
%
% eegRSm=eegRS;
% eegRSm.label{end+1,1}='MEGcomp';
% for triali=1:length(megCA.trial)
%     eegRSm.trial{1,triali}(end+1,:)=megCA.trial{1,triali}(2,:);
% end
%
% cfg=[];
% cfg.method='pca';
% eegPCA=ft_componentanalysis(cfg,eegRSm);
% eegICA=ft_componentanalysis([],eegRSm);
% cfg.method='fastica';
% eegFICA=ft_componentanalysis(cfg,eegRSm);
%
% cfg=[];
% cfg.layout='WG32.lay';
% cfg.channel = {eegFICA.label{7}};
% cfg=ft_databrowser(cfg,eegFICA);
%
%
% for triali=4 %1:length(megCA.trial)
%     X=real(eegFICA.trial{1,4}(:,:)');
%     Y=megCA.trial{1,4}(2,:)';
%     cr=corr(X,Y);
%     [~,compi]=max(cr);
%
% end
%
% plot(eegPCA.time{1,1},eegPCA.trial{1,4}(33,:))
%
%




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





