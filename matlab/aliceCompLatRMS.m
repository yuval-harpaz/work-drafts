function extrema=aliceCompLatRMS(file,xlim,chans)
%   file is grandaverage file
%   xlim is time in seconds per subject
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
win=30; % how many samples around peak to look for maximum
%% looks for max v and latency around individual peak (Left)
[L,I]=ismember(chans,LRpairs(:,1));
sideChL=LRpairs(I(L),1);
[~,labelI]=ismember(sideChL,Gavg.label);
for sub=1:8
    samp=nearest(Gavg.time,xlim(sub));
    subdata=squeeze(Gavg.individual(sub,labelI,samp-win:samp+win));
    subdata=sqrt(mean(subdata.*subdata)); % RMS
    [maxL(1,sub),maxI(1,sub)]=max(subdata);
    maxLatL(1,sub)=Gavg.time(maxI(1,sub)+samp-win+1);
%     [minL(1,sub),minI(1,sub)]=min(subdata);
%     minLatL(1,sub)=Gavg.time(minI(1,sub)+samp-win+1);
end
%% right max and min
[L,I]=ismember(chans,LRpairs(:,2)); % L for logic
sideChR=LRpairs(I(L),2);
[~,labelI]=ismember(sideChR,Gavg.label);
maxI=[];minI=[];
for sub=1:8
    
    samp=nearest(Gavg.time,xlim(sub));
    subdata=squeeze(Gavg.individual(sub,labelI,samp-win:samp+win));
    subdata=sqrt(mean(subdata.*subdata)); % RMS
    [maxR(1,sub),maxI(1,sub)]=max(subdata);
    maxLatR(1,sub)=Gavg.time(maxI(1,sub)+samp-win+1);
%     [minR(1,sub),minI(1,sub)]=min(subdata);
%     minLatR(1,sub)=Gavg.time(minI(1,sub)+samp-win+1);
end
cfg=[];
cfg.layout='4D248.lay';
cfg.highlight  = 'on';
figure;
for sub=1:8
    cfg.xlim=[xlim(sub) xlim(sub)];
    eval(['Gavg.individual=',file,'.individual(sub,:,:);']);
    cfg.highlightchannel={sideChL{:,:},sideChR{:,:}};
    subplot(3,3,sub)
    ft_topoplotER(cfg,Gavg)
end

extrema.rmsR=maxR;
extrema.rmsL=maxL;

extrema.rmsLatR=maxLatR;
extrema.rmsLatL=maxLatL;
