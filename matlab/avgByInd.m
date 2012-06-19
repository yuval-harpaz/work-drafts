function avgTrace=avgByInd(chan,trNum,pkLat,data,winOddSamp)
% averages one channel over trials according to index

% avgTrace=avgByInd('A191',trNum,pkLat,dataNoMOG,401)
% the window in samples should be an odd number
[~,chi]=ismember(chan,data.label);
halfWin=(winOddSamp-1)/2;
avgTrace=zeros(1,winOddSamp);
for tri=1:length(trNum)
    lat=nearest(data.time{1,1},pkLat(tri));
    avgTrace=avgTrace+data.trial{1,trNum(tri)}(chi,(lat-halfWin):(lat+halfWin));
end
avgTrace=avgTrace./tri;
figure;plot(avgTrace)
title ('PRESS KEY TO CLOSE FIG')
pause
close all
end