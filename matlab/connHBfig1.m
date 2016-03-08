
cd /media/yuval/win_disk/Data/connectomeDB/MEG/599671/unprocessed/MEG/3-Restin/4D
load comp

topo=comp.topo(:,1);
topo(3:248)=topo(2:247);
topo(2)=nan;
cfg=[];
cfg.zlim=[0 10];
cfg.comment='no';
cfg.interpolation='linear';
cfg.interplimits = 'electrodes';
figure;topoplot248(topo,cfg);
