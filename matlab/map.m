function fig1=map
cfg.marker='labels';
cfg.style   = 'blank';
cfg.comment = 'no';
fig1=topoplot248(zeros(1,248),cfg)
set(gcf,'Color',[1 1 1])