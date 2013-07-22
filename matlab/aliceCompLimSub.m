
cd /home/yuval/Data/alice/maor
load avgReduced
gaE=ft_timelockgrandaverage([],avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);
gaM=ft_timelockgrandaverage([],avgM2,avgM4,avgM6,avgM8,avgM10,avgM12,avgM14,avgM16,avgM18);

cfg=[];
cfg.layout='WG32.lay';
cfg.interactive='yes';
figure;
ft_multiplotER(cfg,gaE);
cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
figure;
ft_multiplotER(cfg,gaM);


cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.5;
cfg.method='absMean';
cfg.maxDist=0.15;
cfg.zThr=0;
% cfg.channel = {'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A140', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A167', 'A168', 'A169', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A209', 'A210', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243', 'A244', 'A245'}
cfg.channel = {'A44', 'A45', 'A46', 'A52', 'A53', 'A69', 'A70', 'A71', 'A72', 'A73', 'A77', 'A78', 'A79', 'A80', 'A81', 'A97', 'A98', 'A99', 'A100', 'A101', 'A102', 'A103', 'A107', 'A108', 'A109', 'A110', 'A111', 'A112', 'A129', 'A130', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A138', 'A139', 'A140', 'A141', 'A142', 'A143', 'A144', 'A145', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A165', 'A166', 'A167', 'A168', 'A169', 'A170', 'A171', 'A172', 'A180', 'A181', 'A182', 'A183', 'A184', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A197', 'A198', 'A199', 'A200', 'A201', 'A205', 'A206', 'A207', 'A208', 'A209', 'A215', 'A216', 'A217', 'A223', 'A224', 'A225', 'A234', 'A243'};
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,gaM);
times={};
times.peakM=gaM.time(Ipeaks)';
times.troughM=gaM.time(Itroughs);
cfg.channel = {'FC1', 'FC2', 'Cz', 'CP1', 'CP2', 'Pz', 'O1', 'Oz', 'O2'};
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,gaE);
times.peakE=gaE.time(Ipeaks)';
times.troughE=gaE.time(Itroughs);

save times times




clear

cd /home/yuval/Data/alice/yoni
load avgReduced
gaE=ft_timelockgrandaverage([],avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);
gaM=ft_timelockgrandaverage([],avgM2,avgM4,avgM6,avgM8,avgM10,avgM12,avgM14,avgM16,avgM18);

cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.5;
cfg.method='absMean';
cfg.maxDist=0.1;
cfg.zThr=0;
cfg.channel = {'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A140', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A167', 'A168', 'A169', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A209', 'A210', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243', 'A244', 'A245'}
%cfg.channel = {'A44', 'A45', 'A46', 'A52', 'A53', 'A69', 'A70', 'A71', 'A72', 'A73', 'A77', 'A78', 'A79', 'A80', 'A81', 'A97', 'A98', 'A99', 'A100', 'A101', 'A102', 'A103', 'A107', 'A108', 'A109', 'A110', 'A111', 'A112', 'A129', 'A130', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A138', 'A139', 'A140', 'A141', 'A142', 'A143', 'A144', 'A145', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A165', 'A166', 'A167', 'A168', 'A169', 'A170', 'A171', 'A172', 'A180', 'A181', 'A182', 'A183', 'A184', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A197', 'A198', 'A199', 'A200', 'A201', 'A205', 'A206', 'A207', 'A208', 'A209', 'A215', 'A216', 'A217', 'A223', 'A224', 'A225', 'A234', 'A243'};
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,gaM);
times={};
times.peakM=gaM.time(Ipeaks)';
times.troughM=gaM.time(Itroughs);
cfg.channel = {'FC1', 'FC2', 'Cz', 'CP1', 'CP2', 'Pz', 'O1', 'Oz', 'O2'};
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,gaE);
times.peakE=gaE.time(Ipeaks)';
times.troughE=gaE.time(Itroughs);
save times times


clear

cd /home/yuval/Data/alice/odelia
load avgReduced
gaE=ft_timelockgrandaverage([],avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);
gaM=ft_timelockgrandaverage([],avgM2,avgM4,avgM6,avgM8,avgM10,avgM12,avgM14,avgM16,avgM18);

cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.5;
cfg.method='absMean';
cfg.maxDist=0.1;
cfg.zThr=0;
cfg.channel = {'A167', 'A168', 'A169', 'A181', 'A188', 'A189', 'A190', 'A191', 'A199', 'A200', 'A201', 'A202', 'A205', 'A206', 'A207', 'A208', 'A215', 'A216', 'A217', 'A218', 'A219', 'A222', 'A223', 'A224', 'A225', 'A234', 'A235', 'A236', 'A237'};
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,gaM);
times={};
times.peakM=gaM.time(Ipeaks)';
times.troughM=gaM.time(Itroughs);
cfg.channel = {'FC1', 'FC2', 'Cz', 'CP1', 'CP2', 'Pz', 'O1', 'Oz', 'O2'};
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,gaE);
times.peakE=gaE.time(Ipeaks)';
times.troughE=gaE.time(Itroughs);
save times times

clear
close
cd /home/yuval/Data/alice/idan
load avgReduced
gaE=ft_timelockgrandaverage([],avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);
gaM=ft_timelockgrandaverage([],avgM2,avgM4,avgM6,avgM8,avgM10,avgM12,avgM14,avgM16,avgM18);

cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.5;
cfg.method='absMean';
cfg.maxDist=0.1;
cfg.zThr=0;
cfg.channel = {'A104', 'A105', 'A111', 'A112', 'A113', 'A134', 'A135', 'A136', 'A137', 'A140', 'A141', 'A142', 'A143', 'A144', 'A160', 'A162', 'A163', 'A164', 'A165', 'A167', 'A168', 'A169', 'A170', 'A171', 'A172', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A188', 'A189', 'A190', 'A191', 'A192', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A206', 'A207', 'A208', 'A209', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A223', 'A224', 'A225', 'A226', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A242', 'A243'};
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,gaM);
times={};
times.peakM=gaM.time(Ipeaks)';
times.troughM=gaM.time(Itroughs);
cfg.channel = {'FC1', 'FC2', 'Cz', 'CP1', 'CP2', 'Pz', 'O1', 'Oz', 'O2'};
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,gaE);
times.peakE=gaE.time(Ipeaks)';
times.troughE=gaE.time(Itroughs);
save times times

clear
close all
cd /home/yuval/Data/alice/liron
load avgReduced
gaE=ft_timelockgrandaverage([],avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);
gaM=ft_timelockgrandaverage([],avgM2,avgM4,avgM6,avgM8,avgM10,avgM12,avgM14,avgM16,avgM18);

cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.5;
cfg.method='absMean';
cfg.maxDist=0.1;
cfg.zThr=0;
cfg.channel = {'A79', 'A101', 'A108', 'A109', 'A110', 'A111', 'A112', 'A131', 'A132', 'A133', 'A138', 'A140', 'A141', 'A142', 'A143', 'A144', 'A159', 'A160', 'A161', 'A163', 'A166', 'A167', 'A168', 'A169', 'A170', 'A171', 'A172', 'A180', 'A181', 'A182', 'A183', 'A184', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A205', 'A206', 'A207', 'A208', 'A209', 'A210', 'A211', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A240', 'A241', 'A242', 'A243', 'A244', 'A245'};
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,gaM);
times={};
times.peakM=gaM.time(Ipeaks)';
times.troughM=gaM.time(Itroughs);
cfg.channel = {'FC1', 'FC2', 'Cz', 'CP1', 'CP2', 'Pz', 'O1', 'Oz', 'O2'};
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,gaE);
times.peakE=gaE.time(Ipeaks)';
times.troughE=gaE.time(Itroughs);
save times times

cd /home/yuval/Data/alice/inbal
load avgReduced
gaE=ft_timelockgrandaverage([],avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);
gaM=ft_timelockgrandaverage([],avgM2,avgM4,avgM6,avgM8,avgM10,avgM12,avgM14,avgM16,avgM18);

cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.5;
cfg.method='absMean';
cfg.maxDist=0.1;
cfg.zThr=0;
cfg.channel = {'A30', 'A51', 'A52', 'A53', 'A77', 'A78', 'A79', 'A80', 'A81', 'A82', 'A106', 'A107', 'A108', 'A109', 'A110', 'A111', 'A112', 'A113', 'A128', 'A129', 'A130', 'A131', 'A132', 'A138', 'A139', 'A140', 'A141', 'A142', 'A143', 'A144', 'A145', 'A156', 'A157', 'A158', 'A159', 'A160', 'A162', 'A165', 'A166', 'A167', 'A168', 'A169', 'A170', 'A171', 'A172', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A196', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A206', 'A207', 'A208', 'A209', 'A210', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A223', 'A224', 'A225', 'A226', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A243', 'A244'};
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,gaM);
times={};
times.peakM=gaM.time(Ipeaks)';
times.troughM=gaM.time(Itroughs);
cfg.channel = {'FC1', 'FC2', 'Cz', 'CP1', 'CP2', 'Pz', 'O1', 'Oz', 'O2'};
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,gaE);
times.peakE=gaE.time(Ipeaks)';
times.troughE=gaE.time(Itroughs);
save times times

cd /home/yuval/Data/alice/mark
load avgReduced
gaE=ft_timelockgrandaverage([],avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);
gaM=ft_timelockgrandaverage([],avgM2,avgM4,avgM6,avgM8,avgM10,avgM12,avgM14,avgM16,avgM18);

cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.5;
cfg.method='absMean';
cfg.maxDist=0.1;
cfg.zThr=0;
cfg.channel = {'A141', 'A142', 'A157', 'A158', 'A159', 'A161', 'A168', 'A169', 'A170', 'A171', 'A172', 'A173', 'A180', 'A181', 'A182', 'A183', 'A189', 'A190', 'A191', 'A192', 'A193', 'A196', 'A197', 'A198', 'A199', 'A200', 'A201', 'A206', 'A207', 'A208', 'A209', 'A210', 'A211', 'A213', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A227', 'A230', 'A231', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243', 'A244', 'A245', 'A246', 'A247'};

[Itroughs,Ipeaks,~,~]=findCompLims(cfg,gaM);
times={};
times.peakM=gaM.time(Ipeaks)';
times.troughM=gaM.time(Itroughs);
cfg.channel = {'FC1', 'FC2', 'Cz', 'CP1', 'CP2', 'Pz', 'O1', 'Oz', 'O2'};
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,gaE);
times.peakE=gaE.time(Ipeaks)';
times.troughE=gaE.time(Itroughs);
save times times


cd /home/yuval/Data/alice/ohad
load avgReduced
gaE=ft_timelockgrandaverage([],avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);
gaM=ft_timelockgrandaverage([],avgM2,avgM4,avgM6,avgM8,avgM10,avgM12,avgM14,avgM16,avgM18);

cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.5;
cfg.method='absMean';
cfg.maxDist=0.1;
cfg.zThr=0;
cfg.channel = {'A68', 'A69', 'A70', 'A71', 'A97', 'A98', 'A99', 'A100', 'A101', 'A102', 'A112', 'A113', 'A129', 'A130', 'A131', 'A132', 'A133', 'A134', 'A136', 'A137', 'A138', 'A141', 'A142', 'A143', 'A144', 'A145', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A168', 'A169', 'A170', 'A171', 'A172', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A209', 'A210', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243', 'A244', 'A245'};
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,gaM);
times={};
times.peakM=gaM.time(Ipeaks)';
times.troughM=gaM.time(Itroughs);
cfg.channel = {'FC1', 'FC2', 'Cz', 'CP1', 'CP2', 'Pz', 'O1', 'Oz', 'O2'};
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,gaE);
times.peakE=gaE.time(Ipeaks)';
times.troughE=gaE.time(Itroughs);
save times times