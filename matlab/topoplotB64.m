function fig1=topoplotB64(vec,cfg)
%% reading weights
% topoplot of 248 values
if ~exist ('cfg','var')
    cfg=[];
end
cfg.layout='biosemi64.lay';
cfg.interactive='yes';
pth=which('topoplotB64');
pth=pth(1:length(pth)-length('topoplotB64.m'));
load ([pth,'bios64'])
bios64.avg(:,1)=vec;
nans=find(isnan(vec));
if ~isempty(nans)
    bios64.avg(nans)=[];
    bios64.label(nans)=[];
end
fig1=ft_topoplotER(cfg,bios64);
