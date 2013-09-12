cd /home/yuval/Copy/MEGdata/alice/ga
load GavgM20
chans= {'A1', 'A10', 'A11', 'A12', 'A13', 'A14', 'A25', 'A26', 'A27', 'A28', 'A29', 'A30', 'A31', 'A44', 'A45', 'A46', 'A47', 'A48', 'A49', 'A50', 'A51', 'A52', 'A53', 'A54', 'A69', 'A70', 'A71', 'A72', 'A73', 'A74', 'A75', 'A76', 'A77', 'A78', 'A79', 'A80', 'A81', 'A98', 'A99', 'A100', 'A101', 'A102', 'A103', 'A104', 'A105', 'A106', 'A107', 'A108', 'A109', 'A110', 'A111', 'A112', 'A130', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A138', 'A139', 'A140', 'A141', 'A142', 'A143', 'A144', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A167', 'A168', 'A169', 'A170', 'A171', 'A172', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A209', 'A210', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243', 'A244', 'A245'};


cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.5;
cfg.method='absMean';
cfg.maxDist=0.15;
cfg.zThr=0;
cfg.channel = chans;
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,GavgM20);

xlim=repmat(0.4148,1,8); % L > R
e=aliceCompByRMSmaxPeak('GavgM20',xlim,chans)
R=e.rmsR;
L=e.rmsL;
[L;R]
[~,p,~,stats]=ttest(L,R);

chans= {'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10', 'A11', 'A12', 'A13', 'A14', 'A15', 'A16', 'A17', 'A18', 'A19', 'A20', 'A21', 'A22', 'A23', 'A24', 'A25', 'A26', 'A27', 'A28', 'A29', 'A30', 'A31', 'A32', 'A33', 'A34', 'A35', 'A36', 'A37', 'A38', 'A39', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A46', 'A47', 'A48', 'A49', 'A50', 'A51', 'A52', 'A53', 'A54', 'A55', 'A56', 'A57', 'A58', 'A59', 'A60', 'A61', 'A62', 'A63', 'A64', 'A65', 'A66', 'A67', 'A68', 'A69', 'A70', 'A71', 'A72', 'A73', 'A74', 'A75', 'A76', 'A77', 'A78', 'A79', 'A80', 'A81', 'A82', 'A83', 'A84', 'A85', 'A86', 'A87', 'A88', 'A89', 'A90', 'A91', 'A92', 'A93', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'A100', 'A101', 'A102', 'A103', 'A104', 'A105', 'A106', 'A107', 'A108', 'A109', 'A110', 'A111', 'A112', 'A113', 'A114', 'A115', 'A116', 'A117', 'A118', 'A119', 'A120', 'A121', 'A122', 'A123', 'A124', 'A125', 'A126', 'A127', 'A128', 'A129', 'A130', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A138', 'A139', 'A140', 'A141', 'A142', 'A143', 'A144', 'A145', 'A146', 'A147', 'A148', 'A149', 'A150', 'A151', 'A152', 'A153', 'A154', 'A155', 'A156', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A167', 'A168', 'A169', 'A170', 'A171', 'A172', 'A173', 'A174', 'A175', 'A176', 'A177', 'A178', 'A179', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A193', 'A194', 'A195', 'A196', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A209', 'A210', 'A211', 'A212', 'A213', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A227', 'A228', 'A229', 'A230', 'A231', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243', 'A244', 'A245', 'A246', 'A247', 'A248'};
e=aliceCompByRMSmaxPeak('GavgM20',xlim,chans)
R=e.rmsR;
L=e.rmsL;
[L;R]
[~,p,~,stats]=ttest(L,R);

% cfg.method='absMean';
% [Itroughs,Ipeaks,~,~]=findCompLims(cfg,eval(file));

% M100 (0.0885)
times=GavgM20.time(Ipeaks);
xlim=times(1);
extrema=aliceCompByMaxCh('GavgM20',xlim,'R',chans);
xlim=repmat(times(1),1,8);
e059=aliceCompByRMSmaxPeak('GavgM20',xlim,chans)
R=e059.rmsR;
L=e059.rmsL;
[L;R]
[~,p,~,stats]=ttest(L,R);
% [p, h, stats] = ranksum(L,R)
xlim=repmat(0.0885,1,8);
e089=aliceCompByRMSmaxPeak('GavgM20',xlim,chans)
R=e089.rmsR;
L=e089.rmsL;
[L;R]
[~,p,~,stats]=ttest(L,R);

xlim=repmat(0.1790,1,8);
e179=aliceCompByRMSmaxPeak('GavgM20',xlim,chans)
R=e179.rmsR;
L=e179.rmsL;
[L;R]
[~,p,~,stats]=ttest(L,R);

xlim=repmat(0.2202,1,8);
extrema=aliceCompLat('GavgM20',xlim,'L',chans);
R=extrema.minLatR;
L=extrema.maxLatL;
[L;R]'
[~,p,~,stats]=ttest(L,R) % lat sig, 8 of 8

xlim=repmat(0.4148,1,8);
e=aliceCompByRMSmaxPeak('GavgMalice',xlim,chans)
R=e.rmsR;
L=e.rmsL;
[L;R]
[~,p,~,stats]=ttest(L,R);

xlim=repmat(0.4148,1,8); % L > R
e=aliceCompByRMSmaxPeak('GavgM20',xlim,chans)
R=e.rmsR;
L=e.rmsL;
[L;R]
[~,p,~,stats]=ttest(L,R);