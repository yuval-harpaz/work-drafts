%% check shift and tilt
function DenisAlphaTime

cd /home/yuval/Data/Denis/REST
load('Subs')
load grad
load neighbours
%temp=[-25:25 24:-1:-25];
temp=[-17:17 16:-1:-17];
%str=['Rest=ft_freqgrandaverage(cfg']
for subi=1:length(Subs)
    subFold=num2str(Subs(subi));
    cd (subFold)
    %load coilpos
    hdr=ft_read_header('clean-raw.fif');
    cfg=[];
    cfg.dataset='clean-raw.fif';
    cfg.channel=1:248;
    cfg.trl=[round(10*hdr.Fs),round(69*hdr.Fs),0];
    cfg.demean='yes';
    cfg.hpfilter='yes';
    cfg.hpfreq=6;
    meg=ft_preprocessing(cfg);
    [f,~]=fftBasic(meg.trial{1,1},678.17);
    fftTopoMEG(1:248,subi)=mean(abs(f(:,9:11)),2);
    %save(['fftTopoMEG',num2str(subi)],'fftTopoMEG');
    for i=1:248
        meg.label{i,1}=['A',num2str(i)];
    end
    meg.grad=grad;
%     cfg=[];
%     cfg.planarmethod   = 'orig';
%     cfg.neighbours     = neighbours;
%     cfg.layout='4D248.lay';
%     interp = ft_megplanar(cfg, meg);
%     meg = ft_combineplanar([], interp);
    blank=[];
    for chi=1:248
        str=[subFold,' MEG ',num2str(chi)];
        samps=getAlphaSamps(meg.trial{1,1}(chi,:),temp,1,'v1');
        timeTopoMEG(chi,subi)=100*length(samps)./length(meg.time{1,1}); %#ok<AGROW>
        disp([blank,str]);
        blank=repmat(sprintf('\b'), 1, length(str)+1);
    end
    %save(['timeTopoMEG',num2str(subi)],'timeTopoMEG');
    %[f,~]=fftBasic(meg.trial{1,1},678.17);
    %fftTopoMEG=mean(abs(f(:,9:11)),2);
    %save(['fftTopoMEGplanar',num2str(subi)],'fftTopoMEG');
    cd ..
end
save timeTopoMEG *Topo*


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
