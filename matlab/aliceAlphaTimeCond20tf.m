function aliceAlphaTimeCond20tf(thrSig,thrSNR) %(subFold)
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
conditions={'50';'WBW'};
%sf={'mark'};
if ~exist('thrSig','var')
    thrSig=1;
end
if ~exist('thrSNR','var')
    thrSNR='v1';
end
eegi=[1:12,14:18,20:32];
for sfi=1:length(sf)
    subFold=sf{sfi};
    % checks peak to peak alpha as percent of time
    
    %thr=3;
    %thr='%75';
    %thr='v0.55';
    
    cd /home/yuval/Data/alice
    cd(subFold)
    load avgWbW2
    for triali=1:length(megpca.trial)
        [f,F]=fftBasic(megpca.trial{1,triali}(:,1:510),1017.25);
        mfBL(1:248,triali)=f(:,5);
        [f,F]=fftBasic(megpca.trial{1,triali}(:,663:663+509),1017.25);
        mfTr(1:248,triali)=f(:,5);
        
        
        [f,F]=fftBasic(eegpca.trial{1,triali}(eegi,1:513),1024);
        efBL(1:30,triali)=f(:,5);
        [f,F]=fftBasic(eegpca.trial{1,triali}(eegi,667:667+512),1024);
        efTr(1:30,triali)=f(:,5);
    end
    megBL(1:248,sfi)=mean(abs(mfBL)');
    megTr(1:248,sfi)=mean(abs(mfTr)');
    eegBL(1:30,sfi)=mean(abs(efBL)');
    eegTr(1:30,sfi)=mean(abs(efTr)');
    
    %if ~exist('./fr.mat','file')
%     LSclean=ls('*lf*');
%     %% MEG
%     restS=find(trigV==condi);
%     restS=restS(end);
%     startSmeg=trigS(restS);
%     endSmeg=round(startSmeg+60*1017.23);
%     cfg=[];
%     cfg.trl=[startSmeg,endSmeg,0];
%     cfg.channel='MEG';
%     cfg.demean='yes';
%     cfg.feedback='no';
%     cfg.hpfilter='yes';
%     cfg.hpfreq=6;
%     cfg.dataset=ls('*lf*');
%     cfg.dataset=cfg.dataset(1:end-1);
%     meg=ft_preprocessing(cfg);
%     f=abs(fftBasic(meg.trial{1,1}(1:248,:),1017.25,1));
%     fftTopoMEG(1:248,condCount)=mean(mean(abs(f(:,9:11,goodSec)),3),2);
%     display('resampling EOG')
%     for timei=1:length(meg.time{1,1})
%         resampi(timei)=nearest(eeg.time{1,1},meg.time{1,1}(timei));
%     end
%     meg.trial{1,1}(249,:)=eogH.trial{1,1}(resampi);
%     meg.label{249}='HEOG';
%     cfg = [];
%     cfg.unmixing = topoHmeg';
%     % cfg.topo      = topoHmeg;%(1:32,1);
%     cfg.topolabel = meg.label;%(1:32);
%     compH     = ft_componentanalysis(cfg, meg);
%     cfg = [];
%     cfg.component = 1;
%     megpca = ft_rejectcomponent(cfg, compH,meg);
%     megpca.trial{1,1}(249,:)=eogV.trial{1,1}(resampi);
%     megpca.label{249}='VEOG';
%     cfg = [];
%     cfg.unmixing = topoVmeg';
%     %cfg.topo      = topoVmeg;%(1:32,1);
%     cfg.topolabel = megpca.label;%(1:32);
%     compV     = ft_componentanalysis(cfg, megpca);
%     cfg = [];
%     cfg.component = 1;
%     megpca = ft_rejectcomponent(cfg, compV,megpca);
%     
%     megpca.label=megpca.label(1:248);
%     megpca.trial{1,1}=megpca.trial{1,1}(1:248,:);
%     % 119 - 88 window size
%     badSampRS=find(ismember(resampi,badSamp));
%     blank=[];
%     for chi=1:248
%         str=[subFold,' ',conditions{condCount},' MEG ',num2str(chi)];
%         samps=getAlphaSamps(megpca.trial{1,1}(chi,:),temp,thrSig,thrSNR);
%         s=false(1,length(megpca.time{1,1}));
%         s(samps)=true;
%         s(badSampRS)=false;
%         timeTopoMEG(chi,condCount)=100*sum(s)./(length(s)-length(badSampRS)); %#ok<NASGU>
%         %timeTopoMEG(chi,condCount)=100*length(samps)./length(meg.time{1,1}); %#ok<AGROW>
%         disp([blank,str]);
%         blank=repmat(sprintf('\b'), 1, length(str)+1);
%     end
%     condCount=condCount+1;
%     
%     
%     f=fftBasic(megpca.trial{1}(1:248,:),1017.25);
%     fftTopoMEG(1:248,condCount)=mean(abs(f(:,9:11)),2);
%     save timeTopoCond20 *Topo* conditions
    
    disp(['Done wiiiiiith ',subFold])
end
cd /home/yuval/Data/alice
save trialAlpha megBL megTr eegBL eegTr
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





