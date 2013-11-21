function aliceAlphaC
cond=100;
Afreq=[3 6 9 10 11 12 15 20 25 30 40 50 60 70 80 90 100];
sf={'maor' 'idan'  'liron' 'yoni' 'odelia' 'inbal' 'ohad'   'mark'};
strOp='cfg';
for sfi=1:8
    subi=sfi;
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
    %meg=pow(trl,LRpairs);
    
    cfg=[];
    cfg.dataset=megFNc;
    cfg.trl=trl;
%     cfg.trl(:,2)=cfg.trl+1017;
%     cfg.trl(:,3)=0;
    cfg.channel='MEG';
    cfg.blc='yes';
    cfg.feedback='no';
    meg=ft_preprocessing(cfg);
    
    cfg=[];
    cfg.method='var';
    cfg.criterion='sd';
    cfg.critval=3;
    good=badTrials(cfg,meg,0);
    cfg=[];
    cfg.trials=good;
    cfg.output       = 'pow';
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = Afreq;
    cfg.feedback='no';
    %cfg.keeptrials='yes';
    megFr = ft_freqanalysis(cfg, meg);
    %         [~,maxch]=max(mean(megFr.powspctrm(:,:),2));
    %         maxchans=megFr.label(maxch);
    eval(['open_',num2str(subi),'=megFr']);
    strOp=[strOp,',','open_',num2str(subi)];
end

cfg=[];
cfg.keepindividual = 'yes';
eval(['Open=ft_freqgrandaverage(',strOp,');'])
subs=sf;
save /home/yuval/Copy/MEGdata/alpha/alice/Open Open 
save /home/yuval/Copy/MEGdata/alpha/alice/subs subs






% function data=pow(trl,LRpairs)
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
%




