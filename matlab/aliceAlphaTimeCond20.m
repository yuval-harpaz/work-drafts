function aliceAlphaTimeCond20(thrSig,thrSNR) %(subFold)
%sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
sf={'maor'  'odelia'	'ohad'  'yoni' 'mark'};
conditions={'50';'WBW'};
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
    %condCount=1;
    
    condi=50;%;
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
        str=[subFold,' EEG ',num2str(chi)];
        %str=['processed ',num2str(chi),' of 30 channels'];
        samps=getAlphaSamps(eegpca.trial{1,1}(chi,:),temp,thrSig,thrSNR);
        %samps(badSamps
        s=false(1,length(eegpca.time{1,1}));
        s(samps)=true;
        s(badSamp)=false;
        timeTopoEEG(chi,1)=100*sum(s)./(length(s)-length(badSamp)); %#ok<AGROW>
        %timeTopoEEG(chi,condCount)=100*length(samps)./(length(s)-length(samps)); %#ok<AGROW>
        disp([blank,str]);
        blank=repmat(sprintf('\b'), 1, length(str)+1);
    end
    f=abs(fftBasic(eegpca.trial{1,1},1024,1));
    fftTopoEEG(1:30,1)=mean(mean(abs(f(:,9:11,goodSec)),3),2);
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
    fftTopoMEG(1:248,1)=mean(mean(abs(f(:,9:11,goodSec)),3),2);
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
        str=[subFold,' ',conditions{1},' MEG ',num2str(chi)];
        samps=getAlphaSamps(megpca.trial{1,1}(chi,:),temp,thrSig,thrSNR);
        s=false(1,length(megpca.time{1,1}));
        s(samps)=true;
        s(badSampRS)=false;
        timeTopoMEG(chi,1)=100*sum(s)./(length(s)-length(badSampRS)); %#ok<NASGU>
        %timeTopoMEG(chi,condCount)=100*length(samps)./length(meg.time{1,1}); %#ok<AGROW>
        disp([blank,str]);
        blank=repmat(sprintf('\b'), 1, length(str)+1);
    end
    %condCount=condCount+1;
    
    
    f=fftBasic(megpca.trial{1}(1:248,:),1017.25);
    fftTopoMEG(1:248,1)=mean(abs(f(:,9:11)),2);
    save timeTopoCond20 *Topo* conditions
    

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





