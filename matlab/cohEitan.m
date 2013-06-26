%% fft
data=G100111;
cfg           = [];
cfg.method    = 'mtmfft';
cfg.output    = 'fourier';
cfg.tapsmofrq = 1;
cfg.foi=1:100;
freq          = ft_freqanalysis(cfg, data);
%% coherence Left - Right
load ~/ft_BIU/matlab/files/LRpairs
cfg=[];
cfg.channelcmb=LRpairs;
cfg.method    = 'coh';
cohLR          = ft_connectivityanalysis(cfg, freq);
%% prepare for powspctrm display
coh={};
coh.label=data.label;
coh.dimord='chan_freq';
coh.freq=cohLR.freq;
coh.grad=data.grad;
cohspctrm=ones(248, size(cohLR.cohspctrm,2));
for cmbi=1:115
    chi=find(strcmp(cohLR.labelcmb{cmbi,1},data.label));
    cohspctrm(chi,:)=cohLR.cohspctrm(cmbi,:);
    chi=find(strcmp(cohLR.labelcmb{cmbi,2},data.label));
    cohspctrm(chi,:)=cohLR.cohspctrm(cmbi,:);
end
coh.powspctrm=cohspctrm;
cfg=[];
cfg.xlim=[10 10];
cfg.layout='4D248.lay';
ft_topoplotER(cfg,coh);
