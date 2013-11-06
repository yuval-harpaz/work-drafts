function [figure1,labels]=aliceAlphaB3(Afreq)
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
    resti=100;
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
%     cfg=[];
%     cfg.layout='4D248.lay';
%     cfg.highlight='labels';
%     cfg.xlim=[maxfr maxfr];
%     cfg.highlightchannel=megFr.label(maxch);
%     figure;
%     ft_topoplotER(cfg,megFr);
    labels{sfi,1}=megFr.label{maxch}; %#ok<AGROW>
%     title(sf{sfi})
    if sfi==1
        pow=megFr.powspctrm;
    else
        pow=pow+megFr.powspctrm;
    end
end
megFr.powspctrm=10^26*pow/8;

map=[10:-1:0]./10;
map=map';
map(:,2)=map;
map(:,3)=map(:,1);

cfg=[];
cfg.layout='4D248.lay';
cfg.highlight='on';
cfg.xlim=[maxfr maxfr];
cfg.highlightchannel=labels;
cfg.marker='off';
cfg.highlightsymbol    = 'o';
cfg.highlightcolor     = [1 1 1];
cfg.highlightsize      = 4;
%cfg.highlightfontsize  = 12;
cfg.style              = 'straight';
cfg.interpolation      = 'linear';%'v4';% 'linear';
cfg.comment='no';
cfg.colorbar='yes';
cfg.colormap=map;
cfg.zlim=[0 1];
figure1=figure;
ft_topoplotER(cfg,megFr);



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






