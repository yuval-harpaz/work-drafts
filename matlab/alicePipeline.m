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
xlim=times(2);
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
%% exploring results
% evoked response

open aliceStatExplore1



%% subject by subject
subfolder='mark';
alice2(subFolder);
aliceReduceAvg(subFolder);
aliceAlpha(subFolder);
aliceWbW(subFolder);

%% run all
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
for i=1:length(sf)
    % alice2(sf{i});
    % aliceReduceAvg(sf{i});
    % aliceAlpha(sf{i});
    aliceWbW(sf{i});
    %     cd(sf{i})
    %     movefile('files/topo*','files/prev/')
    %movefile('files/prev/seg*','files/')
%     cd ..
end

%% find timing of components
open aliceCompLimSub
% max([EEG,MEG]) to min([EEG,MEG])
comps=aliceCompLimSub2;
%% calculating area
aliceTables
aliceTables('LR');
aliceTables('Post');
aliceTables('PostLR');
% ci=1 for N100, 2 for N170, 3 for M100, 4 for M170
% test tamil effect for N100, whole head rms.
[p,stats,X]=aliceStats(1,'z','tablesPost','tamil')
[p,stats,X]=aliceStats(3,'z','tablesPost','tamil')
[p,stats,X]=aliceStats(1,'z','tablesWH','loud')
[p,stats,X]=aliceStats(2,'z','tablesR','loud','U')
[p,stats,X]=aliceStats(1,'z','tablesPost','WBW')
[p,stats,X]=aliceStats(3,'z','tablesPost','WBW')
[p,stats,X]=aliceStats(2,'z','tablesPost','WBW')
[p,stats,X]=aliceStats(1,'z','tablesWH')
[p,stats,X]=aliceStats(1,'','tablesLR')

[p,stats,X]=aliceStats(1,'z','tablesPost','tamil','U')
[p,stats,X]=aliceStats(3,'z','tablesPost','tamil','U')
[p,stats,X]=aliceStats(1,'z','tablesWH','loud','U')

%% LR
aliceLR
aliceLR1('alice')
aliceGA('LR')
aliceGA('LRalice')
aliceLR1('6101820')
cd /home/yuval/Copy/MEGdata/alice/ga
stat=statPlot('GavgE10LR','GavgE8_12LR',[0.17 0.17],[],'paired-ttest') % tamil
stat=statPlot('GavgE10LR','GavgE8_12LR',[0.1 0.1],[],'paired-ttest')
stat=statPlot('GavgE20LR','GavgE2_4LR',[0.1 0.1],[],'paired-ttest') % WbW
stat=statPlot('GavgE20LR','GavgE2_4LR',[0.17 0.17],[],'paired-ttest')
stat=statPlot('GavgE18LR','GavgE16LR',[0.17 0.17],[],'paired-ttest')
stat=statPlot('GavgM18LR','GavgM16LR',[0.17 0.17],[],'paired-ttest')
stat=statPlot('GavgM10LR','GavgM8_12LR',[0.17 0.17],[],'paired-ttest') % tamil

%stat=statPlot('GavgM10LR','GavgM8_12LR',[0.17 0.17],[],'paired-ttest') % tamil
load /home/yuval/Copy/MEGdata/alice/ga/GavgEaliceLR.mat
load /home/yuval/Copy/MEGdata/alice/ga/GavgMaliceLR.mat
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[0.17 0.17];
figure;
ft_topoplotER(cfg,GavgMaliceLR)
cfg=[];
cfg.layout='WG32.lay';
cfg.xlim=[0.17 0.17];
figure;
ft_topoplotER(cfg,GavgEaliceLR)

aliceTtest0('GavgMaliceLR',0.17,0);

aliceTtest0('GavgMaliceLR',0.17,1);

aliceTtest0('GavgM20LR',0.17,1); % Word bt Word
aliceTtest0('GavgM20LR',0.1,1);
aliceTtest0('GavgE20LR',0.17,1);
aliceTtest0('GavgE20LR',0.1,1);

%% Freq LR differences
aliceGA('frLR')
aliceGA('frLRalice')
aliceGA('frLRrest')
aliceGA('frLRwbw')


stat=statPlot('GavgFrM20LR','GavgFrMrestLR',[9 9],[-3e-27 3e-27],'paired-ttest') % rest
stat=statPlot('GavgFrM20LR','GavgFrMaliceLR',[9 9],[-3e-27 3e-27],'paired-ttest') % rest


stat=statPlot('GavgFrM2LR','GavgFrM100LR',[10 10],[-3e-27 3e-27],'paired-ttest') % rest
aliceTtest0('GavgFrM100LR',10,1);

open aliceStatExplore

%% Fr differences
aliceGA('fr')
aliceGA('frAlice')
aliceGA('frRest')



stat=statPlot('GavgFrMrest','GavgFrMalice',[9 9],[0 1e-26],'paired-ttest')
stat=statPlot('GavgFrErest','GavgFrEalice',[9 9],[0 5],'paired-ttest')
stat=statPlot('GavgFrM20','GavgFrMrest',[9 9],[0 1e-26],'paired-ttest')

stat=statPlot('GavgFrM8','GavgFrM10',[10 10],[0 1e-26],'paired-ttest') 
stat=statPlot('GavgFrM102','GavgFrM100',[9 9],[0 1e-26],'paired-ttest') 
stat=statPlot('GavgFrE100','GavgFrE2',[9 9],[0 5],'paired-ttest')
stat=statPlot('GavgFrErest','GavgFrE2',[9 9],[0 5],'paired-ttest')
%% coh
aliceGA('coh')
stat=statPlot('GavgCohM10','GavgCohMalice',[9 9],[0 1],'paired-ttest')
stat=statPlot('GavgCohE10','GavgCohEalice',[9 9],[0 1],'paired-ttest')
stat=statPlot('GavgCohMrest','GavgCohMalice',[9 9],[0 1],'paired-ttest')

%% N400
aliceTtest0('GavgEaliceLR1',0.36,1);
aliceTtest0('GavgMaliceLR1',0.36,1);
alicePlotLR(0.36)

alicePlotLR(0.17)
% see plotN400.m



%% old

alice1('maor')

alice1('yoni',1);
aliceReduceAvg('maor')
aliceAlpha('maor')

subFolder={'yoni','idan','liron'};
for i=1:3
    sf=subFolder{i};
    aliceReduceAvg(sf)
    aliceAlpha(sf)
end

aliceWbW('liron')

aliceTables('maor') % blink issues with speach paragraph

subFolder='odelia';
alice1(subFolder);
aliceReduceAvg(subFolder)
aliceAlpha(subFolder)
aliceWbW(subFolder)

open alicePlots

open aliceTestCompLimMethod

open aliceCompLimSub
% 
% times=findCompLims('rms',[],avgE2);
% timeCourse=findCompLims('yzero',[],avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);
% timeCourseO=findCompLims('yzero',{'O1','O2','Oz'},avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);
% timeCourseO=findCompLims('absMean',{'O1','O2','Oz'},avgE2,avgE4,avgE6,avgE8,avgE10,avgE12,avgE14,avgE16,avgE18);


