function aliceAlphaTimeCond20tf1(thrSig,thrSNR) %(subFold)
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
temp=[-25:25 24:-1:-25];
for sfi=1:length(sf)
    subFold=sf{sfi};
    % checks peak to peak alpha as percent of time
    
    %thr=3;
    %thr='%75';
    %thr='v0.55';
    
    cd /home/yuval/Data/alice
    cd(subFold)
    load avgWbW2
    %for triali=1:length(megpca.trial)
    
    [~,chansL]=ismember({'A161','A162'},megpca.label);
    posL=getAlphaSamps(megpca,temp,thrSig,thrSNR,chansL);
    [~,chansR]=ismember({'A167','A168'},megpca.label);
    posR=getAlphaSamps(megpca,temp,thrSig,thrSNR,chansR);
    Nl=min(sum(posL==1),sum(posL==-1));
    Nr=min(sum(posR==1),sum(posR==-1));
    alphaLp=zeros(size(megpca.trial{1},2),1);
    alphaRp=alphaLp;
    alphaLn=alphaLp;alphaRn=alphaLp;
    
    trials=find(posL==-1);
    trials=trials(1:Nl);
    for triali=trials'
        alphaLn=alphaLn+mean(megpca.trial{triali}(chansL,:))';
    end
    alphaLn=alphaLn./Nl;
    trials=find(posL==1);
    trials=trials(1:Nl);
    for triali=trials'
        alphaLp=alphaLp+mean(megpca.trial{triali}(chansL,:))';
    end
    alphaLp=alphaLp./Nl;
    trials=find(posR==-1);
    trials=trials(1:Nr);
    for triali=trials'
        alphaRn=alphaRn+mean(megpca.trial{triali}(chansR,:))';
    end
    alphaRn=alphaRn./Nr;
    trials=find(posR==1);
    trials=trials(1:Nr);
    for triali=trials'
        alphaRp=alphaRp+mean(megpca.trial{triali}(chansR,:))';
    end
    alphaRp=alphaRp./Nr;
    alphaMl(sfi,1:length(megpca.time{1}))=(alphaLp-alphaLn)./2;
    alphaMr(sfi,1:length(megpca.time{1}))=(alphaRp-alphaRn)./2;
    erMl(sfi,1:length(megpca.time{1}))=(alphaLp+alphaLn)./2;
    erMr(sfi,1:length(megpca.time{1}))=(alphaRp+alphaRn)./2;
    nMl(sfi)=Nl;nMr(sfi)=Nr;
    % EEG
    [~,chansL]=ismember({'P7'},eegpca.label);
    posL=getAlphaSamps(eegpca,temp,thrSig,thrSNR,chansL);
    [~,chansR]=ismember({'P8'},eegpca.label);
    posR=getAlphaSamps(eegpca,temp,thrSig,thrSNR,chansR);
    Nl=min(sum(posL==1),sum(posL==-1));
    Nr=min(sum(posR==1),sum(posR==-1));
    alphaLp=zeros(size(eegpca.trial{1},2),1);
    alphaRp=alphaLp;
    alphaLn=alphaLp;alphaRn=alphaLp;
    
    trials=find(posL==-1);
    trials=trials(1:Nl);
    for triali=trials'
        alphaLn=alphaLn+eegpca.trial{triali}(chansL,:)';
    end
    alphaLn=alphaLn./Nl;
    trials=find(posL==1);
    trials=trials(1:Nl);
    for triali=trials'
        alphaLp=alphaLp+eegpca.trial{triali}(chansL,:)';
    end
    alphaLp=alphaLp./Nl;
    trials=find(posR==-1);
    trials=trials(1:Nr);
    for triali=trials'
        alphaRn=alphaRn+eegpca.trial{triali}(chansR,:)';
    end
    alphaRn=alphaRn./Nr;
    trials=find(posR==1);
    trials=trials(1:Nr);
    for triali=trials'
        alphaRp=alphaRp+eegpca.trial{triali}(chansR,:)';
    end
    alphaRp=alphaRp./Nr;
    nEl(sfi)=Nl;nEr(sfi)=Nr;
    alphaEl(sfi,1:length(eegpca.time{1}))=(alphaLp-alphaLn)./2;
    alphaEr(sfi,1:length(eegpca.time{1}))=(alphaRp-alphaRn)./2;
    erEl(sfi,1:length(eegpca.time{1}))=(alphaLp+alphaLn)./2;
    erEr(sfi,1:length(eegpca.time{1}))=(alphaRp+alphaRn)./2;

    
    eval(['e',num2str(sfi),'=avgWbWeeg;'])
    eval(['m',num2str(sfi),'=avgWbWmeg;'])
    
    disp(['Done wiiiiiith ',subFold])
end
cd /home/yuval/Data/alice
% timeE=eegpca.time{1};timeM=megpca.time{1};
% figure;plot(timeE,mean(alphaEr));hold on;plot(timeE,mean(erEr),'r');title('EEG RH')
% figure;plot(timeE,mean(alphaEl));hold on;plot(timeE,mean(erEl),'r');title('EEG LH')
% figure;plot(timeM,mean(alphaMr));hold on;plot(timeM,mean(erMr),'r');title('MEG RH')
% figure;plot(timeM,mean(alphaMl));hold on;plot(timeM,mean(erMl),'r');title('MEG LH')

cfg=[];
cfg.keepindividual='yes';
gaE=ft_timelockgrandaverage(cfg,e1,e2,e3,e4,e5,e6,e7,e8);
gaM=ft_timelockgrandaverage(cfg,m1,m2,m3,m4,m5,m6,m7,m8);

save alpha_er alphaEr alphaEl alphaMr alphaMl erEl erEr erMl erMr nEl nEr nMl nMr gaE gaM
%save trialAlpha megBL megTr eegBL eegTr
function pos=getAlphaSamps(data,temp,thrSig,thrSNR,chans)
times=[];
meg=strcmp(data.label{1},'A22');
if meg
    comp100t=0.12;
else
    comp100t=0.09;
end
comp100s=nearest(data.time{1},comp100t);
testSamps=[comp100s-102-26 comp100s-102+26];
pos=zeros(length(data.trial),1);
for triali=1:length(data.trial)
    %for chani=chans %1:length(data.label)
    if length(chans)==1
        chan=data.trial{triali}(chans,:);
    else
        chan=mean(data.trial{triali}(chans,:));
    end
        [snr,signal]=match_temp(chan,temp,51);
        %[~,sigI]=findPeaks(signal,thrSig,50);
        %[~,snrI]=findPeaks(snr,thrSNR,50);
        [~,alphaIpos]=findPeaks(signal,thrSig,50);
        [~,alphaIneg]=findPeaks(-signal,thrSig,50);
        %
        
        % check signal peaks
        %             sigDif=diff(sigI);
        %             [~,difI]=find((sigDif>88).*(sigDif<121));
        %             alphaIpos=unique([sigI(difI) sigI(difI+1)]);
        %             [~,sigI]=findPeaks(-signal,thrSig,50);
        %             sigDif=diff(sigI);
        %             [~,difI]=find((sigDif>88).*(sigDif<121));
        %             alphaIneg=unique([sigI(difI) sigI(difI+1)]);
        if ~isempty(alphaIpos) && ~isempty(alphaIneg)
            [alphaI,ii]=sort([alphaIpos alphaIneg]);
            isPos=ii<(length(alphaIpos)+1);
            
            critPeak=find((alphaI>testSamps(1)).*(alphaI<testSamps(2)));
            if ~isempty(critPeak);
                pos(triali)=2*isPos(critPeak(end))-1;
                %             figure;plot(data.time{1,1},signal);
                %             hold on;plot(data.time{1,1}(alphaI),signal(alphaI),'g.')
                %             samps=[];
            end
        end
    %end
    %disp(['done trial ',num2str(triali)])
end
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





