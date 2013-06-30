function aliceTables(subFold)
cd (['/home/yuval/Data/alice/',subFold])
if ~exist('files/seg18.mat','file')
    error('seg18 not found, run alice1')
end
%% average across segments
avgEEGall=zeros(32,820);
avgMEGall=zeros(248,814);
for segi=2:2:18
    segStr=num2str(segi);
    load (['files/seg',segStr])
    avgEEGall=avgEEGall+avgEEG.avg;
    avgMEGall=avgMEGall+avgMEG.avg;
end
avgEEGall=(avgEEGall+avgEEG.avg)./9;
avgMEGall=(avgMEGall+avgMEG.avg)./9;

%% detect minima as component bounderies
rmsEEG=sqrt(mean(avgEEGall.*avgEEGall,1));
% plot(avgEEG.time,mean(abs(avgEEGall)))
% hold on

[~,startE100]=min(rmsEEG(nearest(avgEEG.time,0):nearest(avgEEG.time,0.1)));
startE100=startE100+nearest(avgEEG.time,0)-1;
[~,startE170]=min(rmsEEG(nearest(avgEEG.time,0.1):nearest(avgEEG.time,0.17)));
startE170=startE170+nearest(avgEEG.time,0.1)-1;
[~,startE300]=min(rmsEEG(nearest(avgEEG.time,0.17):nearest(avgEEG.time,0.3)));
startE300=startE300+nearest(avgEEG.time,0.17)-1;
[~,startE400]=min(rmsEEG(nearest(avgEEG.time,0.3):nearest(avgEEG.time,0.4)));
startE400=startE400+nearest(avgEEG.time,0.3)-1;
endE400=find(diff(rmsEEG(nearest(avgEEG.time,0.45):end))>-0.0055,1)+nearest(avgEEG.time,0.45);
figure;
plot(avgEEG.time,rmsEEG)
hold on
plot(avgEEG.time([startE100,startE170,startE300,startE400,endE400]),rmsEEG([startE100,startE170,startE300,startE400,endE400]),'ro')

%% calculate area for whole head RMS
EEGtable=zeros(9,4);
for segi=2:2:18
    segStr=num2str(segi);
    load (['files/seg',segStr])
    rms=sqrt(mean(avgEEG.avg.*avgEEG.avg,1));
    EEGtable(segi/2,1)=trapz(rms(startE100:startE170));
    EEGtable(segi/2,2)=trapz(rms(startE170:startE300));
    EEGtable(segi/2,3)=trapz(rms(startE300:startE400));
    EEGtable(segi/2,4)=trapz(rms(startE400:endE400));
end
plot(EEGtable([1 2 4 6 7 8],:)','b')
hold on
plot(EEGtable(3,:),'r')
plot(EEGtable(5,:),'g')
plot(EEGtable(9,:),'k')
legend('1','2','4','6','7','8','3 news','5 tamil','9 loud')
save tableWH EEGtable
