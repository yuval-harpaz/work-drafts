% CHECK how come with fieldtrip and pinv you get the same moment but not
% the same Vmodel

cfg=[];
cfg.latency=[data.time(138) data.time(138)];
cfg.nonlinear='no';
cfg.grid=grid;
dipFT1=dipolefitBIU(cfg,data);

[~,gof]=fit(dipFT1.Vmodel,dipFT1.Vdata,'poly1');
0.7264

cfg=[];
cfg.latency=[data.time(138) data.time(138)];
cfg.nonlinear='no';
cfg.grid=grid;
cfg.method='pinv';
dipPI1=dipolefitBIU(cfg,data);
[~,gof]=fit(dipPI1.Vmodel,dipPI1.Vdata,'poly1');

cfg=[];
cfg.latency=[data.time(138) data.time(138)];
cfg.nonlinear='no';
cfg.grid=grid;
cfg.method='\';
dipLD1=dipolefitBIU(cfg,data);

[~,gof]=fit(dipLD1.Vmodel,dipLD1.Vdata,'poly1');


cfg=[];
cfg.latency=[data.time(138) data.time(138)];
cfg.nonlinear='no';
cfg.grid=grid;
cfg.method='*';
dipM1=dipolefitBIU(cfg,data);

