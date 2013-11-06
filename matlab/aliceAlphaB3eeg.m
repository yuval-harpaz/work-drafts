function [figure1,labels]=aliceAlphaB3eeg(freq)
load LRpairsEEG
LRpairsEEG=LRpairs;
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
for sfi=1:8
    cd /home/yuval/Data/alice
    cd(sf{sfi})
    load files/evt
    resti=100;
    % EEG
    sampBeg=round(evt(find(evt(:,3)==resti),1)*1024);
    sampEnd=sampBeg+60*1024;
    samps1s=sampBeg:1024:sampEnd-1;
    trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
    eeg=pow(trl,LRpairsEEG);
    % title(num2str(resti))
    % MEG
    
    
    
    
    cfg=[];
    cfg.output       = 'pow';
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = [9:11,120];
    cfg.feedback='no';
    cfg.keeptrials='yes';
    Fr = ft_freqanalysis(cfg, eeg);
    maxfri=1;
    [~,maxch]=max(mean(Fr.powspctrm(:,:,maxfri),1));
    maxfr=Fr.freq(maxfri);
    cfg=[];
    cfg.layout='WG32.lay';
    cfg.highlight='labels';
    cfg.xlim=[maxfr maxfr];
    cfg.highlightchannel=Fr.label(maxch);
    figure;
    ft_topoplotER(cfg,Fr);
    labels{sfi,1}=Fr.label{maxch}; %#ok<AGROW>
    title(sf{sfi})
    if sfi==1
        pow=Fr.powspctrm;
    else
        pow=pow+Fr.powspctrm;
    end
    
end

% Fr.powspctrm=10^26*pow/8;

map=[10:-1:0]./10;
map=map';
map(:,2)=map;
map(:,3)=map(:,1);

cfg=[];
cfg.layout='WG32.lay';
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
%cfg.comment='no';
cfg.colorbar='yes';
cfg.colormap=map;
%cfg.zlim=[0 1];
figure1=figure;
ft_topoplotER(cfg,Fr);



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






