function fig1=topoplotE64(vec,cfg)
%% reading weights
% topoplot of 248 values
if ~exist ('cfg','var')
    cfg=[];
end
%
cfg.layout   = 'GSN-HydroCel-64_1.0.sfp';
cfg.interactive='yes';
pth=which('topoplotB64');
pth=pth(1:length(pth)-length('topoplotB64.m'));
load ([pth,'egi64'])
pth=which('ft_topoplotER');
pth=pth(1:length(pth)-length('ft_topoplotER.m'));

% elec = ft_read_sens([pth,'\template\electrode\GSN-HydroCel-64_1.0.sfp']);
% cfgl = [];
% cfgl.channel  = egi64.label;
% cfgl.layout   = 'GSN-HydroCel-64_1.0.sfp';
% %cfg.feedback = 'yes';
% lay          = ft_prepare_layout(cfgl);

egi64.avg(:,1)=vec;
nans=find(isnan(vec));
if ~isempty(nans)
    egi64.avg(nans)=[];
    egi64.label(nans)=[];
end
fig1=ft_topoplotER(cfg,egi64);
