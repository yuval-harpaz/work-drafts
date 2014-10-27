function aliceAlphaTimePlanar(thrSig,thrSNR) %(subFold)
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
%sf={'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
for sfi=1:length(sf)
    subFold=sf{sfi};
    % checks peak to peak alpha as percent of time
    
    %thr=3;
    %thr='%75';
    %thr='v0.55';
    if ~exist('thrSig','var')
        thrSig=0;
    end
    if ~exist('thrSNR','var')
        thrSNR=0;
    end
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
    for resti=100;%[100,102];
        temp=[-25:25 24:-1:-25];
        restS=find(trigV==resti);
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
        if sfi==1
            cfg=[];
            cfg.method='distance';
            cfg.grad=meg.grad;
            cfg.neighbourdist = 0.07; % default is 0.04m
            neighbours = ft_prepare_neighbours(cfg);
            neighbours=neighbours(1:248);
        end
        cfg=[];
        cfg.planarmethod   = 'orig';
        cfg.neighbours     = neighbours;
        cfg.layout='4D248.lay';
        interp = ft_megplanar(cfg, meg);
        cfg=[];
        cfg.foi=9:11;
        cfg.method='maxCmb';
        [cpYH,report]=combineplanarYH(cfg,interp);
%         cpsum = ft_combineplanar([], interp);
%         cfg=[];
%         cfg.combinemethod='svd';
%         cpsvd = ft_combineplanar(cfg, interp);
        blank=[];
        for chi=1:248
            str=[subFold,' MEG ',num2str(chi)];
            samps=getAlphaSamps(cpYH.trial{1,1}(chi,:),temp,thrSig,thrSNR);
            timeTopoMEG(chi,1)=100*length(samps)./length(meg.time{1,1}); %#ok<AGROW>
            disp([blank,str]);
            blank=repmat(sprintf('\b'), 1, length(str)+1);
        end
    end
    f=fftBasic(cpYH.trial{1},1017.25);
    fftTopoMEG(1:248,sfi)=mean(abs(f(:,9:11)),2);
    %save timeTopoPlanar *Topo*
end
cd ../
save timeTopoPlanar *Topo*


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
