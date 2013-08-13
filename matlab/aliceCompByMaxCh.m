function extrema=aliceCompByMaxCh(file,xlim,posSide,chans)
%   file is grandaverage file
%   xlim is time in seconds
%   posSide is which side of the head the component field is positive (for
% M100 posSide is 'R', for M170 its 'L'. you can put 'both'. it makes a
% difference when highlighting a channel with peak value.
%   chans is a channel list to include.
if ~exist('chans','var')
    chans={'A1', 'A2', 'A9', 'A10', 'A11', 'A12', 'A13', 'A14', 'A15', 'A24', 'A25', 'A26', 'A27', 'A28', 'A29', 'A30', 'A31', 'A32', 'A43', 'A44', 'A45', 'A46', 'A47', 'A48', 'A49', 'A50', 'A51', 'A52', 'A53', 'A54', 'A55', 'A68', 'A69', 'A70', 'A71', 'A72', 'A73', 'A74', 'A75', 'A76', 'A77', 'A78', 'A79', 'A80', 'A81', 'A82', 'A97', 'A98', 'A99', 'A100', 'A101', 'A102', 'A103', 'A104', 'A105', 'A106', 'A107', 'A108', 'A109', 'A110', 'A111', 'A112', 'A113', 'A129', 'A130', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A138', 'A139', 'A140', 'A141', 'A142', 'A143', 'A144', 'A145', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A167', 'A168', 'A169', 'A170', 'A171', 'A172', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A209', 'A210', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243', 'A244', 'A245'};
end
cd /home/yuval/Copy/MEGdata/alice/ga
load(file)
eval(['Gavg=',file,';'])
load ([file,'LR1'])
eval(['GavgLR=',file,'LR1;'])
load LRpairs
samp=nearest(Gavg.time,xlim);
%% left max and min
[L,I]=ismember(chans,LRpairs(:,1));
sideCh=LRpairs(I(L),1);
[~,labelI]=ismember(sideCh,Gavg.label);
[maxL,maxI]=max(Gavg.individual(:,labelI,samp)');
maxChL=Gavg.label(labelI(maxI));
[minL,minI]=min(Gavg.individual(:,labelI,samp)');
minChL=Gavg.label(labelI(minI));
%% right max and min
[L,I]=ismember(chans,LRpairs(:,2)); % L for logic
sideCh=LRpairs(I(L),2);
[~,labelI]=ismember(sideCh,Gavg.label);
[maxR,maxI]=max(Gavg.individual(:,labelI,samp)');
maxChR=Gavg.label(labelI(maxI));
[minR,minI]=min(Gavg.individual(:,labelI,samp)');
minChR=Gavg.label(labelI(minI));

cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[xlim xlim];
cfg.highlight  = 'labels';
figure;
for sub=1:8
    eval(['Gavg.individual=',file,'.individual(sub,:,:);']);
    cfg.highlightchannel=HLchans(sub,posSide,maxChL,maxChR,minChL,minChR);
    subplot(3,3,sub)
    ft_topoplotER(cfg,Gavg)
end
figure;
for sub=1:8
    Gavg.individual=GavgLR.individual(sub,:,:);
    cfg.highlightchannel=HLchans(sub,posSide,maxChL,maxChR,minChL,minChR);
    subplot(3,3,sub)
    ft_topoplotER(cfg,Gavg)
end
extrema.maxR=maxR;
extrema.maxL=maxL;
extrema.minR=minR;
extrema.minL=minL;
extrema.maxChR=maxChR;
extrema.maxChL=maxChL;
extrema.minChR=minChR;
extrema.minChL=minChL;
function highlightchannel=HLchans(sub,chanCase,maxChL,maxChR,minChL,minChR)
switch chanCase
    case 'L'
        highlightchannel={maxChL{sub},minChR{sub}};
    case 'R'
        highlightchannel={minChL{sub},maxChR{sub}};
    case 'both'
        highlightchannel={maxChL{sub},minChR{sub},minChL{sub},maxChR{sub}};
end

