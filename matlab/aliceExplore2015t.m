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


[~,p]=ttest(mean(E10(:,28:30),2),mean(Er(:,28:30),2))

[~,~,sigT]=permuteMat(Mr,M10); % empty, no difference

figure;topoplot248(mean(Mr))
caxis(1.0e-12 *[ -0.10    0.1]);
figure;topoplot248(mean(M10))
caxis(1.0e-12 *[ -0.10    0.1]);

figure;
plot(avgMr.time,squeeze(mean(mean(abs(avgMr.individual),2),1)),'k')
hold on
plot(avgMr.time,squeeze(mean(mean(abs(avgMr10.individual),2),1)),'r')


[~,~,sigT]=permuteMat(Er,E10); % empty, no difference

figure;topoplot30(mean(Er))
caxis([-4 4]);
figure;topoplot30(mean(E10))
caxis([-4 4]);

figure;
plot(avgEr.time,squeeze(mean(mean(abs(avgEr.individual),2),1)),'k')
hold on
plot(avgEr.time,squeeze(mean(mean(abs(avgEr10.individual),2),1)),'r')



t=[0.16 0.18];
s1=nearest(avgEr.time,t(1));
s2=nearest(avgEr.time,t(2));
E10=mean(avgEr10.individual(:,:,s1:s2),3);
Er=mean(avgEr.individual(:,:,s1:s2),3);
s1=nearest(avgEr.time,t(1));
s2=nearest(avgEr.time,t(2));
E10=mean(avgEr10.individual(:,:,s1:s2),3);
Er=mean(avgEr.individual(:,:,s1:s2),3);
[~,~,sigT]=permuteMat(Er,E10); % empty, no difference

figure;topoplot30(mean(Er))
caxis([-4 4]);
figure;topoplot30(mean(E10))
caxis([-4 4]);

[~,p]=ttest(mean(E10(:,28:30),2),mean(Er(:,28:30),2))


