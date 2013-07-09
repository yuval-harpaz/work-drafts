function aliceFindTimes(subFold,method)
cd (['/home/yuval/Data/alice/',subFold])
if exist('files/times.mat','file')
    error('files/times exists')
end
load avgReduced
%% average across segments

switch method
    case 'posterior'
        channel = {'A1', 'A10', 'A11', 'A12', 'A13', 'A14', 'A26', 'A27', 'A28', 'A29', 'A30', 'A31', 'A45', 'A46', 'A47', 'A48', 'A49', 'A50', 'A51', 'A52', 'A53', 'A70', 'A71', 'A72', 'A73', 'A74', 'A75', 'A76', 'A77', 'A78', 'A79', 'A80', 'A99', 'A100', 'A101', 'A102', 'A103', 'A104', 'A105', 'A106', 'A107', 'A108', 'A109', 'A110', 'A111', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A138', 'A139', 'A140', 'A141', 'A142', 'A143', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A167', 'A168', 'A169', 'A170', 'A171', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A198', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A209', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243', 'A244'};
        for chi=1:length(channel)
            [~,ind]=ismember(channel{chi},avgM2.label);
            chans(chi)=ind;
        end
        avgEEGall=zeros(size(avgE2.avg));
        avgMEGall=zeros(size(avgM2.avg));
        for segi=2:2:18
            segStr=num2str(segi);
            eval(['avgEEGall=avgEEGall+avgE',segStr,'.avg;']);
            eval(['avgMEGall=avgMEGall+avgM',segStr,'.avg;']);
        end
        avgEEGall=avgEEGall./9;
        avgMEGall=avgMEGall./9;
        rmsEEG=sqrt(mean(avgEEGall.*avgEEGall,1));
        rmsMEG=sqrt(mean(avgMEGall(chans,:).*avgMEGall(chans,:),1));
    case 'all'
        avgEEGall=zeros(size(avgE2.avg));
        avgMEGall=zeros(size(avgM2.avg));
        for segi=2:2:18
            segStr=num2str(segi);
            eval(['avgEEGall=avgEEGall+avgE',segStr,'.avg;']);
            eval(['avgMEGall=avgMEGall+avgM',segStr,'.avg;']);
        end
        avgEEGall=avgEEGall./9;
        avgMEGall=avgMEGall./9;
        rmsEEG=sqrt(mean(avgEEGall.*avgEEGall,1));
        rmsMEG=sqrt(mean(avgMEGall.*avgMEGall,1));
    case 'bySeg'
        rmsEEG=zeros(1,size(avgE2.avg,2));
        rmsMEG=zeros(1,size(avgM2.avg,2));
        for segi=2:2:18
            segStr=num2str(segi);
            eval(['rmsEEG=rmsEEG+sqrt(mean(avgE',segStr,'.avg.*avgE',segStr,'.avg));']);
            eval(['rmsMEG=rmsMEG+sqrt(mean(avgM',segStr,'.avg.*avgM',segStr,'.avg));']);
        end
        rmsEEG=rmsEEG./9;
        rmsMEG=rmsMEG./9;
end
%% detect minima as component bounderies

[~,startE100]=min(rmsEEG(nearest(avgE2.time,0.045):nearest(avgE2.time,0.1)));
startE100=startE100+nearest(avgE2.time,0.045)-1;
[~,startE170]=min(rmsEEG(nearest(avgE2.time,0.1):nearest(avgE2.time,0.17)));
startE170=startE170+nearest(avgE2.time,0.1)-1;
[~,startE300]=min(rmsEEG(nearest(avgE2.time,0.17):nearest(avgE2.time,0.3)));
startE300=startE300+nearest(avgE2.time,0.17)-1;
[~,startE400]=min(rmsEEG(nearest(avgE2.time,0.3):nearest(avgE2.time,0.4)));
startE400=startE400+nearest(avgE2.time,0.3)-1;
endE400=find(diff(rmsEEG(nearest(avgE2.time,0.45):end))>-0.0055,1)+nearest(avgE2.time,0.45);
figure;
%% MEG

[~,startM100]=min(rmsMEG(nearest(avgM2.time,0.045):nearest(avgM2.time,0.1)));
startM100=startM100+nearest(avgM2.time,0.045)-1;
[~,startM170]=min(rmsMEG(nearest(avgM2.time,0.1):nearest(avgM2.time,0.17)));
startM170=startM170+nearest(avgM2.time,0.1)-1;
[~,startM300]=min(rmsMEG(nearest(avgM2.time,0.17):nearest(avgM2.time,0.3)));
startM300=startM300+nearest(avgM2.time,0.17)-1;
[~,startM400]=min(rmsMEG(nearest(avgM2.time,0.3):nearest(avgM2.time,0.4)));
startM400=startM400+nearest(avgM2.time,0.3)-1;
endM400=find(diff(rmsMEG(nearest(avgM2.time,0.45):end))>-0.0055,1)+nearest(avgM2.time,0.45);

yE=rmsEEG/max(rmsEEG);
yM=rmsMEG/max(rmsMEG);
figure;
plot(avgE2.time,yE)
hold on
plot(avgM2.time,yM,'k')
plot(avgE2.time([startE100,startE170,startE300,startE400,endE400]),yE([startE100,startE170,startE300,startE400,endE400]),'ro')
plot(avgM2.time([startM100,startM170,startM300,startM400,endM400]),yM([startM100,startM170,startM300,startM400,endM400]),'go')
legend('EEG','MEG')
save files/times start* end* rms*
end