cd /home/yuval/Data/marik/som2/1
load ../avgFilt avg1_handR
hs=ft_read_headshape('hs_file');

cfg=[];
cfg.fileName='../MNE/pos1_raw-oct-6-fwd.fif';
[Grid,ftLeadfield,ori]=fs2grid(cfg);

cfg=[];
cfg.latency=[0.03 0.04];
%cfg.noise='wts';
[pow,R]=beamformer(cfg,avg1_handR);view([-86 22])

[cfg.vol.o,cfg.vol.r]=fitsphere(hs.pnt);
cfg.grid=ftLeadfield;
[pow,R]=beamformer(cfg,avg1_handR);view([-86 22])

GridFTorder=Grid;
[~,i]=ismember(ftLeadfield.label,Grid.label);
GridFTorder.label=Grid.label(i);
for posi=1:length(Grid.leadfield)
    GridFTorder.leadfield{posi}=Grid.leadfield{posi}(i,:);
end
cfg.grid=GridFTorder;
[pow,R]=beamformer(cfg,avg1_handR);view([-86 22])



cfg.ori=ori;
[pow,R]=beamformer(cfg,avg1_handR);view([-90 90])