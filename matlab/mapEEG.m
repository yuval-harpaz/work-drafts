function fig1=mapEEG
cfg.marker='labels';
cfg.style   = 'blank';
cfg.comment = 'no';
cfg.layout='WG32.lay';
fig1=topoplot32(zeros(1,32),cfg)
set(gcf,'Color',[1 1 1])