%% max amp per chan
cd /home/yuval/Copy/MEGdata/alice/ga
chans= {'A1', 'A10', 'A11', 'A12', 'A13', 'A14', 'A25', 'A26', 'A27', 'A28', 'A29', 'A30', 'A31', 'A44', 'A45', 'A46', 'A47', 'A48', 'A49', 'A50', 'A51', 'A52', 'A53', 'A54', 'A69', 'A70', 'A71', 'A72', 'A73', 'A74', 'A75', 'A76', 'A77', 'A78', 'A79', 'A80', 'A81', 'A98', 'A99', 'A100', 'A101', 'A102', 'A103', 'A104', 'A105', 'A106', 'A107', 'A108', 'A109', 'A110', 'A111', 'A112', 'A130', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A138', 'A139', 'A140', 'A141', 'A142', 'A143', 'A144', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A167', 'A168', 'A169', 'A170', 'A171', 'A172', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A209', 'A210', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243', 'A244', 'A245'};
file='GavgMalice';
load (file)
cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.5;
cfg.method='rms';
cfg.maxDist=0.15;
cfg.zThr=0;
cfg.channel = chans;
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,eval(file));
% cfg.method='absMean';
% [Itroughs,Ipeaks,~,~]=findCompLims(cfg,eval(file));

% M100 (0.0885)
times=GavgMalice.time(Ipeaks);
xlim=times(1);
extrema=aliceCompByMaxCh(file,xlim,'R',chans);
R=extrema.maxR;
L=-extrema.minL;
[~,p,~,stats]=ttest(L,R);
[p, h, stats] = ranksum(L,R)

% M100 by individual latency
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
for subi=1:8
    load(['/home/yuval/Copy/MEGdata/alice/',sf{subi},'/times'])
    xlim(subi)=times.peakM(1);
end
extrema=aliceCompByMaxChMaxPeak(file,xlim,'R',chans);
R=extrema.maxR;
L=-extrema.minL;
[L;R]'
[~,p,~,stats]=ttest(L,R)

% M100 RMS by individual latency
e=aliceCompByRMSmaxPeak(file,xlim,chans)
R=e.rmsR;
L=e.rmsL;
[L;R]'
[~,p,~,stats]=ttest(L,R)

% M170 (0.1790)
xlim=times.peakM(2);
extrema=aliceCompByMaxCh(file,xlim,'L',chans);
R=-extrema.minR;
L=extrema.maxL;
[~,p,~,stats]=ttest(L,R)
[p, h, stats] = ranksum(L,R)


% M170 by individual latency
for subi=1:8
    load(['/home/yuval/Copy/MEGdata/alice/',sf{subi},'/times'])
    xlim(subi)=times.peakM(2);
end
extrema=aliceCompByMaxChMaxPeak(file,xlim,'L',chans);
R=-extrema.minR;
L=extrema.maxL;
[L;R]'
[~,p,~,stats]=ttest(L,R)

% M170 RMS by individual latency
e=aliceCompByRMSmaxPeak(file,xlim,chans)
R=e.rmsR;
L=e.rmsL;
[L;R]'
[~,p,~,stats]=ttest(L,R)
% M170 RMS (0.179)
xlim=repmat(0.1790,1,8)
e=aliceCompByRMSmaxPeak(file,xlim,chans)
R=e.rmsR;
L=e.rmsL;
[L;R]'
[~,p,~,stats]=ttest(L,R)

% RMS (0.210)
xlim=repmat(0.21,1,8)
e=aliceCompByRMSmaxPeak(file,xlim,chans)
R=e.rmsR;
L=e.rmsL;
[L;R]'
[~,p,~,stats]=ttest(L,R)


xlim=repmat(0.3,1,8)
e=aliceCompByRMSmaxPeak(file,xlim,chans)
R=e.rmsR;
L=e.rmsL;
[L;R]'
[~,p,~,stats]=ttest(L,R)

xlim=repmat(0.36,1,8)
e=aliceCompByRMSmaxPeak(file,xlim,chans)
R=e.rmsR;
L=e.rmsL;
[L;R]'
[~,p,~,stats]=ttest(L,R)

%% latency analysis
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
for subi=1:8
    load(['/home/yuval/Copy/MEGdata/alice/',sf{subi},'/times'])
    xlim(subi)=times.peakM(1);
end
extrema=aliceCompLat(file,xlim,'R',chans);
R=extrema.maxLatR;
L=extrema.minLatL;
[L;R]'
[~,p,~,stats]=ttest(L,R)

sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
for subi=1:8
    load(['/home/yuval/Copy/MEGdata/alice/',sf{subi},'/times'])
    xlim(subi)=times.peakM(2);
end
extrema=aliceCompLat(file,xlim,'L',chans);
R=extrema.minLatR;
L=extrema.maxLatL;
[L;R]'
[~,p,~,stats]=ttest(L,R)
R=-extrema.minR;
L=extrema.maxL;
[L;R]'
[~,p,~,stats]=ttest(L,R)


xlim=repmat(0.0885,1,8)
extrema=aliceCompLat(file,xlim,'R',chans);
R=extrema.maxLatR;
L=extrema.minLatL;
[L;R]'
[~,p,~,stats]=ttest(L,R)

R=extrema.maxR;
L=-extrema.minL;
[L;R]'
[~,p,~,stats]=ttest(L,R)  % amp sig, 7 of 8

% THIS IS NICE
xlim=repmat(0.1790,1,8)
extrema=aliceCompLat(file,xlim,'L',chans);
R=extrema.minLatR;
L=extrema.maxLatL;
[L;R]'
[~,p,~,stats]=ttest(L,R) % lat sig, 8 of 8

R=-extrema.minR;
L=extrema.maxL;
[L;R]'
[~,p,~,stats]=ttest(L,R)


% WBW
xlim=repmat(0.1790,1,8)
extrema=aliceCompLat('GavgM20',xlim,'L',chans)

extrema=aliceCompLat(file,xlim,'R',chans);
R=extrema.maxLatR;
L=extrema.minLatL;
[L;R]'
[~,p,~,stats]=ttest(L,R)

R=extrema.maxR;
L=-extrema.minL;
[L;R]'
[~,p,~,stats]=ttest(L,R)  % amp sig, 7 of 8


% M300 (0.2743)
xlim=times(3);
extrema=aliceCompByMaxCh(file,xlim,'R',chans);
R=extrema.maxR;
L=-extrema.minL;
[~,p,~,stats]=ttest(L,R)
[p, h, stats] = ranksum(L,R)


xlim=0.21;
extrema=aliceCompByMaxCh(file,xlim,'L',chans);
R=extrema.maxR;
L=-extrema.minL;
[L;R]'
[~,p,~,stats]=ttest(L,R)
[p, h, stats] = ranksum(L,R)