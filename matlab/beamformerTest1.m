cd /home/yuval/Data/marik/som2/1

hs=ft_read_headshape('hs_file');
load dataIndex
% Cov=zeros(248);
% for trli=1:250
%     Cov=Cov+cov(data.trial{trli}(1:248,:)');
% end
% Cov=Cov./trli;
cfg=[];
cfg.covariance='yes';
cfg.channel='MEG';
avg=ft_timelockanalysis(cfg,data);

covData=[];
for trli=1:250
    covData=[covData,data.trial{trli}(1:248,:)];
end
Cov=cov(covData');


cfg.fileName='../MNE/pos1_raw-oct-6-fwd.fif';
[Grid,ftLeadfield,ori]=fs2grid(cfg);


GridFTorder=Grid;
[~,i]=ismember(ftLeadfield.label,Grid.label);
GridFTorder.label=Grid.label(i);
for posi=1:length(Grid.leadfield)
    GridFTorder.leadfield{posi}=Grid.leadfield{posi}(i,:);
end
cfg=[];
cfg.grid=ftLeadfield;
[cfg.vol.o,cfg.vol.r]=fitsphere(hs.pnt);
cfg.grid=GridFTorder;
cfg.latency=[0.03 0.04];

[pow,R]=beamformer(cfg,avg);
view([-90 90])

[pow,R]=beamformer(cfg,avg,avg.cov);
view([-90 90])

[pow,R]=beamformer(cfg,avg,Cov);
view([-90 90])

cfg.ori=ori;

[pow,R]=beamformer(cfg,avg);
view([-90 90])

[pow,R]=beamformer(cfg,avg,avg.cov);
view([-90 90])

[pow,R]=beamformer(cfg,avg,Cov);
view([-90 90])