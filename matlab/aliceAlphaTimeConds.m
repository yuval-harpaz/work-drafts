function aliceAlphaTimeConds(thrSig,thrSNR) %(subFold)
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
conditions={'8' '10' '12' '20' '100' '102';'read' 'tamil' 'read' 'loud' 'rest1' 'rest2'};
%sf={'mark'};
if ~exist('thrSig','var')
    thrSig=1;
end
if ~exist('thrSNR','var')
    thrSNR=1;
end
for sfi=1:length(sf)
    subFold=sf{sfi};
    % checks peak to peak alpha as percent of time
    
    %thr=3;
    %thr='%75';
    %thr='v0.55';
    
    cd /home/yuval/Data/alice
    cd(subFold)
    %if ~exist('./fr.mat','file')
    LSclean=ls('*lf*');
    megFNc=LSclean(1:end-1);
    load LRpairsEEG
    LRpairsEEG=LRpairs;
    load LRpairs
    load files/triggers
    load files/evt
    load files/indEOG.mat
    load files/topoEOG
    topoHeeg=topoH;
    topoVeeg=topoV;
    load files/topoMOG
    load files/eog
    topoHmeg=topoH;
    topoVmeg=topoV;
    clear topoH topoV
    condCount=1;
    
    for condi=[8 10 12 18 100 102];%;
        %% EEG
        sampBeg=round(evt(find(evt(:,3)==condi),1)*1024);
        sampEnd=sampBeg+60*1024;
        %samps1s=sampBeg:1024:sampEnd-1;
        %trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
        
        cfg=[];
        cfg.trl=[sampBeg,sampEnd,0];
        cfg.channel='EEG';% {'EEG','-M1','-M2'};
        %cfg.channel={'EEG',eog.label{indH}};
        cfg.demean='yes';
        cfg.feedback='no';
        cfg.hpfilter='yes';
        cfg.hpfreq=6;
        eeg=readCNT(cfg);
        cfg.channel=eog.label{indH};
        eogH=readCNT(cfg);
        cfg.channel=eog.label{indV};
        eogV=readCNT(cfg);
        chans=[1:12,14:18,20:32];% exclude EOG and M
        f=abs(fftBasic(eeg.trial{1,1}(chans,:),1024,1));
        
        hf=max(squeeze(mean(f(:,60:190,:),2)));
        thr=median(hf)*1.75;
        badSec=hf>=thr;
        goodSec=hf<thr;
        
        badSamp=[];
        for seci=1:60
            if badSec(seci)
                badSamp=[badSamp,(seci-1)*1024+1:seci*1024];
            end
        end
        eeg.label{33}='HEOG';
        eeg.trial{1,1}(33,:)=eogH.trial{1,1};
        cfg = [];
        cfg.unmixing = topoHeeg';
        %cfg.topo      = topoHeeg;%(1:32,1);
        cfg.topolabel = eeg.label;%(1:32);
        compH     = ft_componentanalysis(cfg, eeg);
        cfg = [];
        cfg.component = 1;
        eegpca = ft_rejectcomponent(cfg, compH,eeg);
        eegpca.label{33}='VEOG';
        eegpca.trial{1,1}(33,:)=eogV.trial{1,1};
        cfg = [];
        %cfg.topo      = topoVeeg;%(1:32,1);
        cfg.unmixing = topoVeeg';
        cfg.topolabel = eegpca.label;%(1:32);
        compV     = ft_componentanalysis(cfg, eegpca);
        cfg = [];
        cfg.component = 1;
        eegpca = ft_rejectcomponent(cfg, compV,eegpca);
        
        eegpca.label=eegpca.label(chans);
        eegpca.trial{1,1}=eegpca.trial{1,1}(chans,:);
        %     f=abs(fftBasic(eeg.trial{1,1},eeg.fsample));
        %     i9=find(f(:,9)>1.5*median(f(:,9)))
        %     i10=find(f(:,10)>1.5*median(f(:,10)))
        %     i11=find(f(:,11)>1.5*median(f(:,11)))
        %timeEEG=eeg.time{1,1};
        %sRate=1024;
        %eeg.label{24}
        temp=[-25:25 24:-1:-25];
        blank=[];
        for chi=1:30
            str=[subFold,' ',conditions{condCount},' EEG ',num2str(chi)];
            %str=['processed ',num2str(chi),' of 30 channels'];
            samps=getAlphaSamps(eegpca.trial{1,1}(chi,:),temp,thrSig,thrSNR);
            %samps(badSamps
            s=false(1,length(eegpca.time{1,1}));
            s(samps)=true;
            s(badSamp)=false;
            timeTopoEEG(chi,condCount)=100*sum(s)./(length(s)-length(badSamp)); %#ok<AGROW>
            %timeTopoEEG(chi,condCount)=100*length(samps)./(length(s)-length(samps)); %#ok<AGROW>
            disp([blank,str]);
            blank=repmat(sprintf('\b'), 1, length(str)+1);
        end
        f=abs(fftBasic(eegpca.trial{1,1},1024,1));
        fftTopoEEG(1:30,condCount)=mean(mean(abs(f(:,9:11,goodSec)),3),2);
        %% MEG
        restS=find(trigV==condi);
        restS=restS(end);
        startSmeg=trigS(restS);
        endSmeg=round(startSmeg+60*1017.23);
        cfg=[];
        cfg.trl=[startSmeg,endSmeg,0];
        cfg.channel='MEG';
        cfg.demean='yes';
        cfg.feedback='no';
        cfg.hpfilter='yes';
        cfg.hpfreq=6;
        cfg.dataset=ls('*lf*');
        cfg.dataset=cfg.dataset(1:end-1);
        meg=ft_preprocessing(cfg);
        f=abs(fftBasic(meg.trial{1,1}(1:248,:),1017.25,1));
        fftTopoMEG(1:248,condCount)=mean(mean(abs(f(:,9:11,goodSec)),3),2);
        display('resampling EOG')
        for timei=1:length(meg.time{1,1})
            resampi(timei)=nearest(eeg.time{1,1},meg.time{1,1}(timei));
        end
        meg.trial{1,1}(249,:)=eogH.trial{1,1}(resampi);
        meg.label{249}='HEOG';
        cfg = [];
        cfg.unmixing = topoHmeg';
        % cfg.topo      = topoHmeg;%(1:32,1);
        cfg.topolabel = meg.label;%(1:32);
        compH     = ft_componentanalysis(cfg, meg);
        cfg = [];
        cfg.component = 1;
        megpca = ft_rejectcomponent(cfg, compH,meg);
        megpca.trial{1,1}(249,:)=eogV.trial{1,1}(resampi);
        megpca.label{249}='VEOG';
        cfg = [];
        cfg.unmixing = topoVmeg';
        %cfg.topo      = topoVmeg;%(1:32,1);
        cfg.topolabel = megpca.label;%(1:32);
        compV     = ft_componentanalysis(cfg, megpca);
        cfg = [];
        cfg.component = 1;
        megpca = ft_rejectcomponent(cfg, compV,megpca);
        
        megpca.label=megpca.label(1:248);
        megpca.trial{1,1}=megpca.trial{1,1}(1:248,:);
        % 119 - 88 window size
        badSampRS=find(ismember(resampi,badSamp));
        blank=[];
        for chi=1:248
            str=[subFold,' ',conditions{condCount},' MEG ',num2str(chi)];
            samps=getAlphaSamps(megpca.trial{1,1}(chi,:),temp,thrSig,thrSNR);
            s=false(1,length(megpca.time{1,1}));
            s(samps)=true;
            s(badSampRS)=false;
            timeTopoMEG(chi,condCount)=100*sum(s)./(length(s)-length(badSampRS)); %#ok<NASGU>
            %timeTopoMEG(chi,condCount)=100*length(samps)./length(meg.time{1,1}); %#ok<AGROW>
            disp([blank,str]);
            blank=repmat(sprintf('\b'), 1, length(str)+1);
        end
        condCount=condCount+1;
        
        
        f=fftBasic(megpca.trial{1}(1:248,:),1017.25);
        fftTopoMEG(1:248,condCount)=mean(abs(f(:,9:11)),2);
        save timeTopoCond *Topo* conditions
    end
    % cfg=[];
    % %cfg.zlim=[0 75];
    % figure;
    % topoplot30(timeTopoEEG,cfg);
    % title(['sig thr = ',num2str(thrSig),' snr thr = ',num2str(thrSNR)])
    % colorbar;
    % figure;
    % f=fftBasic(eeg.trial{1},1024);
    % topoplot30(mean(abs(f(:,9:11)),2));
    % title('fft')
    % figure;
    % topoplot248(timeTopoMEG);
    % title(['sig thr = ',num2str(thrSig),' snr thr = ',num2str(thrSNR)])
    % colorbar;
    % figure;
    % f=fftBasic(meg.trial{1},1024);
    % topoplot248(mean(abs(f(:,9:11)),2));
    % title('fft')
end

function samps=getAlphaSamps(data,temp,thrSig,thrSNR)
[snr,signal]=match_temp(data,temp,51);
[~,sigI]=findPeaks(signal,thrSig,50);
[~,snrI]=findPeaks(snr,thrSNR,50);
if isempty(sigI) || isempty(snrI)
    samps=[];
else
    % check signal peaks
    sigDif=diff(sigI);
    [~,difI]=find((sigDif>88).*(sigDif<121));
    alphaIpos=unique([sigI(difI) sigI(difI+1)]);
    [~,sigI]=findPeaks(-signal,thrSig,50);
    sigDif=diff(sigI);
    [~,difI]=find((sigDif>88).*(sigDif<121));
    alphaIneg=unique([sigI(difI) sigI(difI+1)]);
    alphaI=sort([alphaIpos alphaIneg]);
    samps=[];
    for alphai=1:length(alphaI)
        samps=unique([samps (alphaI(alphai)-61):(alphaI(alphai)+61)]);
    end
    samps=samps(samps>0);
    sampsSig=samps(samps<size(data,2));
    % check SNR peaks
    snrDif=diff(snrI);
    [~,difI]=find((snrDif>88).*(snrDif<121));
    alphaIpos=unique([snrI(difI) snrI(difI+1)]);
    [~,snrI]=findPeaks(-snr,thrSNR,50);
    snrDif=diff(snrI);
    [~,difI]=find((snrDif>88).*(snrDif<121));
    alphaIneg=unique([snrI(difI) snrI(difI+1)]);
    alphaI=sort([alphaIpos alphaIneg]);
    samps=[];
    for alphai=1:length(alphaI)
        samps=unique([samps (alphaI(alphai)-61):(alphaI(alphai)+61)]);
    end
    samps=samps(samps>0);
    sampsSNR=samps(samps<size(data,2));
    samps=sampsSNR(ismember(sampsSNR,sampsSig));
end
% figure;
% plot(signal,'r')
% hold on
% %plot(timeEEG,snr/10,'k')
% %plot(timeEEG(sigI),sigP,'xc')
% plot(sampsSig,signal(sampsSig),'r.')
% plot(sampsSNR,snr(sampsSNR),'k.')
% plot(data/10)
% plot(samps,0,'.y')




%     cfgp=[];
%     cfgp.zlim=[0 100];
%     cfgp.interpolate='linear';
%     cfgp.interactive='yes';
%     figure;
%     topoplot30(f(:,10),cfgp)
%     plot(eeg.time{1,1},eeg.trial{1,1}(30,:),'r')
%     hold on
%     plot(eeg.time{1,1},eeg.trial{1,1}(7,:),'k')
%     legend('O1','F4')
%
%
%     [eegFr,eegLR,eegCoh]=pow(trl,LRpairsEEG);
%     % title(num2str(resti))
%     eval(['eegFr',num2str(resti),'=eegFr'])
%     eval(['eegLR',num2str(resti),'=eegLR'])
%     eval(['eegCoh',num2str(resti),'=eegCoh'])
%     % MEG
%     sampBeg=trigS(find(trigV==resti));
%     sampEnd=sampBeg+60*1017.23;
%     samps1s=sampBeg:1017:sampEnd-100;
%     trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
%     [megFr,megLR,megCoh]=pow(trl,LRpairs);
%     % title(num2str(resti))
%     eval(['megFr',num2str(resti),'=megFr'])
%     eval(['megLR',num2str(resti),'=megLR'])
%     eval(['megCoh',num2str(resti),'=megCoh'])
% end








%
% for piskai=2:2:18
%     % EEG
%     load(['files/seg',num2str(piskai)])
%     sampBeg=samps(find(samps(:,2)==1,1),1);
%     sampEnd=samps(find(samps(:,2)==1,1,'last'),1);
%     cfg=[];
%     cfg.trl=[sampBeg,sampEnd,0];
%     cfg.channel='EEG';
%     cfg.demean='yes';
%     cfg.feedback='no';
%     cfg.hpfilter='yes';
%     cfg.hpfreq=6;
%     eeg=readCNT(cfg);
%     f=fftBasic(eeg.trial{1,1},eeg.fsample);
%     figure;
%     plot(eeg.time{1,1},eeg.trial{1,1}(30,:),'r')
%     hold on
%     plot(eeg.time{1,1},eeg.trial{1,1}(7,:),'k')
%     legend('O1','F4')
%
%     [eegFr,eegLR,eegCoh]=pow(trl,LRpairsEEG);
%     % title(num2str(piskai))
%     eval(['eegFr',num2str(piskai),'=eegFr'])
%     eval(['eegLR',num2str(piskai),'=eegLR'])
%     eval(['eegCoh',num2str(piskai),'=eegCoh'])
%     % MEG
%     startSeeg=round(evt(find(evt(:,3)==piskai),1)*1024);
%     endSeeg=round(evt(find(evt(:,3)==piskai)+1,1)*1024);
%     startSmeg=trigS(find(trigV==piskai));
%     endSmeg=trigS(find(trigV==piskai)+1);
%     megSR=(endSmeg-startSmeg)/((endSeeg-startSeeg)/1024);
%     if round(megSR)~=1017
%         error('problem detecting MEG sampling rate')
%     end
%     trlMEG=round((trl(:,1)-startSeeg)/1024*megSR)+startSmeg;
%     trlMEG(:,2)=trlMEG+1017;
%     trlMEG(:,3)=zeros(length(trl),1);
%     [megFr,megLR,megCoh]=pow(trlMEG,LRpairs);
%     eval(['megFr',num2str(piskai),'=megFr'])
%     eval(['megLR',num2str(piskai),'=megLR'])
%     eval(['megCoh',num2str(piskai),'=megCoh'])
% end

% clear eegFr eegLR eegCoh megFr megLR megCoh
% save fr eegFr* eegLR* eegCoh* megFr* megLR* megCoh*




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





