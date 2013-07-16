cd /home/yuval/Data/alice/yoni
load avgReduced
gaE=ft_timelockgrandaverage([],avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);
gaM=ft_timelockgrandaverage([],avgM2,avgM4,avgM6,avgM8,avgM10,avgM12,avgM14,avgM16,avgM18);


cfg=[];
cfg.notBefore=0.035;
cfg.notAfter=0.35;
cfg.method='absMean';
cfg.maxDist=0.075;
cfg.zThr=0;
cfg.channel = {'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A140', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A167', 'A168', 'A169', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A209', 'A210', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243', 'A244', 'A245'}
timesM=findCompLims0(cfg,gaM)


cfg=[];
cfg.notBefore=0.035;
cfg.notAfter=0.5;
cfg.method='absMean';
cfg.maxDist=0.075;
cfg.channel = {'FC1', 'FC2', 'Cz', 'CP1', 'CP2', 'Pz', 'O1', 'Oz', 'O2'};
timesE=findCompLims0(cfg,gaE)






cfg=[];
cfg.notBefore=0.05;
cfg.method='rms';
cfg.channel = {'FC1', 'FC2', 'Cz', 'CP1', 'CP2', 'Pz', 'O1', 'Oz', 'O2'};
timesE=findCompLims0(cfg,gaE)
cfg=[];
cfg.notBefore=0.05;
cfg.method='rms';
cfg.channel = {'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A140', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A167', 'A168', 'A169', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A209', 'A210', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243', 'A244', 'A245'};
timesE=findCompLims0(cfg,gaM)


cfg=[];
cfg.layout='WG32.lay';
cfg.interactive='yes';
figure;
ft_multiplotER(cfg,gaE);
cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
ft_multiplotER(cfg,gaM);





cfg=[];
cfg.notBefore=0.05;
cfg.method='svd';
cfg.channel = {'A104', 'A132', 'A134', 'A135', 'A136', 'A140', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A167', 'A168', 'A169', 'A171', 'A181', 'A182', 'A183', 'A184', 'A185', 'A188', 'A189', 'A190', 'A191', 'A192', 'A199', 'A200', 'A201', 'A202', 'A203', 'A205', 'A206', 'A207', 'A208', 'A209', 'A210', 'A215', 'A216', 'A217', 'A218', 'A219', 'A222', 'A223', 'A224', 'A225', 'A226', 'A234', 'A235', 'A236', 'A237', 'A238', 'A240', 'A241', 'A242', 'A243', 'A244', 'A245'}
timesC=findCompLims(cfg,avgM2,avgM4,avgM6,avgM8,avgM10,avgM12,avgM14,avgM16,avgM18)


cfg=[];
cfg.notBefore=0.06;
cfg.method='rms';
cfg.channel = {'FC1', 'FC2', 'Cz', 'CP1', 'CP2', 'Pz', 'O1', 'Oz', 'O2'}
timesC=findCompLims(cfg,avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);


cfg=[];
cfg.method='svd';
cfg.notBefore=0.06;
timesSVD=findCompLims(cfg,avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);

cfg=[];
cfg.notBefore=0.06;
cfg.method='absMean';
cfg.chans={'O1','O2','Oz'};
timesO=findCompLims(cfg,avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);

cfg=[];
cfg.notBefore=0.06;
cfg.method='rms';
%cfg.chans={'O1','O2','Oz'};
timesRMS=findCompLims(cfg,avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);

cfg=[];
cfg.notBefore=0.06;
cfg.method='rms';
%cfg.chans={'O1','O2','Oz'};
timesMrms=findCompLims(cfg,avgM2,avgM4,avgM6,avgM8,avgM10,avgM12,avgM14,avgM16,avgM18);

