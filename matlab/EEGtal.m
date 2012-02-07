function EEGtal(data)
powSub=allSpectra(Signal(:,1:500),500,1,'FFT');
pow.powspctrm=powSub(:,1:45);
cfg.layout='egi65.lay';
cfg.interactive='yes';
ft_topoplotER(cfg,pow)
end