cd /home/yuval/Copy/MEGdata/alice/ga2015
load gaR10

% GavgE20.label=GavgE20.label([1:12,14:18,20:32]);
% GavgE20.individual=GavgE20.individual(:,[1:12,14:18,20:32],:);
% GavgE20=correctBL(GavgE20,[-0.2 -0.05]);
% GavgM20=correctBL(GavgM20,[-0.2 -0.05]);
avgEr=correctBL(avgEr,[-0.2 -0.05]);
avgMr=correctBL(avgMr,[-0.2 -0.05]);
avgEr10=correctBL(avgEr10,[-0.2 -0.05]);
avgMr10=correctBL(avgMr10,[-0.2 -0.05]);



t=[0.0875 0.1125];
s1=nearest(avgMr.time,t(1));
s2=nearest(avgMr.time,t(2));
M10=mean(avgMr10.individual(:,:,s1:s2),3);
Mr=mean(avgMr.individual(:,:,s1:s2),3);
s1=nearest(avgEr.time,t(1));
s2=nearest(avgEr.time,t(2));
E10=mean(avgEr10.individual(:,:,s1:s2),3);
Er=mean(avgEr.individual(:,:,s1:s2),3);




[~,~,sigT]=permuteMat(Mr,M10); % empty, no difference

figure;topoplot248(mean(Mr))

figure;topoplot248(mean(M10))

figure;
plot(avgMr.time,squeeze(mean(mean(abs(avgMr.individual),2),1)),'k')
hold on
plot(avgMr.time,squeeze(mean(mean(abs(avgMr10.individual),2),1)),'r') % FIX FILTER!!!
