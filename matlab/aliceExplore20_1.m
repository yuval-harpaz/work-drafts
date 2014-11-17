load LRpairs
load /home/yuval/Copy/MEGdata/alice/ga/GavgM20
cfg=[];
cfg.xlim=[0.13 0.13];
cfg.layout='4D248.lay';
cfg.interactive='yes';
ft_topoplotER(cfg,GavgM20);

[~,Li]=ismember(LRpairs(:,1),GavgM20.label);
[~,Ri]=ismember(LRpairs(:,2),GavgM20.label);

rmsL=sqrt(squeeze(mean(GavgM20.individual(:,Li,:).*GavgM20.individual(:,Li,:),2)));
rmsR=sqrt(squeeze(mean(GavgM20.individual(:,Ri,:).*GavgM20.individual(:,Ri,:),2)));
figure;
plot(GavgM20.time,mean(rmsL))
hold on
plot(GavgM20.time,mean(rmsR),'r')

chans= {'A1', 'A10', 'A11', 'A12', 'A13', 'A14', 'A25', 'A26', 'A27', 'A28', 'A29', 'A30', 'A31', 'A44', 'A45', 'A46', 'A47', 'A48', 'A49', 'A50', 'A51', 'A52', 'A53', 'A54', 'A69', 'A70', 'A71', 'A72', 'A73', 'A74', 'A75', 'A76', 'A77', 'A78', 'A79', 'A80', 'A81', 'A98', 'A99', 'A100', 'A101', 'A102', 'A103', 'A104', 'A105', 'A106', 'A107', 'A108', 'A109', 'A110', 'A111', 'A112', 'A130', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A138', 'A139', 'A140', 'A141', 'A142', 'A143', 'A144', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A167', 'A168', 'A169', 'A170', 'A171', 'A172', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A209', 'A210', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243', 'A244', 'A245'};

[a,~]=ismember(chans,LRpairs(:,1));
chansL=chans(a);
[a,~]=ismember(chans,LRpairs(:,2));
chansR=chans(a);
[~,Li]=ismember(chansL,GavgM20.label);
[~,Ri]=ismember(chansR,GavgM20.label);
rmsL=sqrt(squeeze(mean(GavgM20.individual(:,Li,:).*GavgM20.individual(:,Li,:),2)));
rmsR=sqrt(squeeze(mean(GavgM20.individual(:,Ri,:).*GavgM20.individual(:,Ri,:),2)));
figure;
plot(GavgM20.time,mean(rmsL))
hold on
plot(GavgM20.time,mean(rmsR),'r')
[~,p]=ttest(rmsL,rmsR);
plot(GavgM20.time(p<0.05),0,'k*')

%chansL = {'A102', 'A103', 'A104', 'A133', 'A134', 'A135', 'A136', 'A160', 'A161', 'A162', 'A163', 'A181', 'A182', 'A183', 'A184', 'A185', 'A199', 'A200', 'A201', 'A202', 'A203', 'A215', 'A216', 'A217', 'A218', 'A219'};
chansL = {'A27', 'A46', 'A47', 'A48', 'A71', 'A72', 'A73', 'A74', 'A100', 'A101', 'A102', 'A103', 'A104', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A199', 'A200', 'A201', 'A202', 'A203', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A234', 'A235', 'A236', 'A237', 'A238'};
[~,b]=ismember(chansL,LRpairs(:,1));
chansR=LRpairs(b,2);

chansL={'A161','A162'};
chansR={'A167','A168'};
[~,Li]=ismember(chansL,GavgM20.label);
[~,Ri]=ismember(chansR,GavgM20.label);
rmsL=sqrt(squeeze(mean(GavgM20.individual(:,Li,:).*GavgM20.individual(:,Li,:),2)));
rmsR=sqrt(squeeze(mean(GavgM20.individual(:,Ri,:).*GavgM20.individual(:,Ri,:),2)));
figure;
plot(GavgM20.time,mean(rmsL))
hold on
plot(GavgM20.time,mean(rmsR),'r')
[~,p]=ttest(rmsL,rmsR);
plot(GavgM20.time(p<0.05),0,'k*')
legend('L','R','sig')

L=squeeze(mean(GavgM20.individual(:,Li,:),2));
R=squeeze(mean(-GavgM20.individual(:,Ri,:),2));
figure;
plot(GavgM20.time,mean(L))
hold on
plot(GavgM20.time,mean(R),'r')
[~,p]=ttest(L,R);
plot(GavgM20.time(p<0.05),0,'k*')
legend('L','R','sig')


%chans= {'A1', 'A10', 'A11', 'A12', 'A13', 'A14', 'A25', 'A26', 'A27', 'A28', 'A29', 'A30', 'A31', 'A44', 'A45', 'A46', 'A47', 'A48', 'A49', 'A50', 'A51', 'A52', 'A53', 'A54', 'A69', 'A70', 'A71', 'A72', 'A73', 'A74', 'A75', 'A76', 'A77', 'A78', 'A79', 'A80', 'A81', 'A98', 'A99', 'A100', 'A101', 'A102', 'A103', 'A104', 'A105', 'A106', 'A107', 'A108', 'A109', 'A110', 'A111', 'A112', 'A130', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A138', 'A139', 'A140', 'A141', 'A142', 'A143', 'A144', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A167', 'A168', 'A169', 'A170', 'A171', 'A172', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A209', 'A210', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243', 'A244', 'A245'};
chans=chansL;
chans(end+1:end+length(chansR))=chansR;
cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.5;
cfg.method='absMean';
cfg.maxDist=0.15;
cfg.zThr=0;
cfg.channel = chans;
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,GavgM20);

%% area
%compTimes=[0.025,0.08;0.08,0.15;0.15,0.26;0.26,0.3;0.38,0.48];
% compi=5;
% compSamp0=nearest(GavgM20.time,compTimes(compi,1));
% compSamp1=nearest(GavgM20.time,compTimes(compi,2));
load LRpairs
load /home/yuval/Copy/MEGdata/alice/ga/GavgM20
chansL={'A161','A162'};
chansR={'A167','A168'};
[~,Li]=ismember(chansL,GavgM20.label);
[~,Ri]=ismember(chansR,GavgM20.label);
L=squeeze(mean(GavgM20.individual(:,Li,:),2));
R=squeeze(mean(-GavgM20.individual(:,Ri,:),2));
compSamp0=nearest(GavgM20.time,0.41);
compSamp1=nearest(GavgM20.time,0.48);
areaL=trapz(L(:,compSamp0:compSamp1)');
areaR=trapz(R(:,compSamp0:compSamp1)');
[~,p]=ttest(areaL,areaR)
[areaL',areaR']

compSamp0=nearest(GavgM20.time,0.17);
compSamp1=nearest(GavgM20.time,0.27);
areaL=trapz(L(:,compSamp0:compSamp1)');
areaR=trapz(R(:,compSamp0:compSamp1)');
[~,p]=ttest(areaL,areaR)


% rms
% compSamp0=nearest(GavgM20.time,0.41);
% compSamp1=nearest(GavgM20.time,0.5);
% areaL=trapz(squeeze(sqrt(mean(GavgM20.individual(:,Li,compSamp0:compSamp1).^2,2)))');
% areaR=trapz(squeeze(sqrt(mean(GavgM20.individual(:,Ri,compSamp0:compSamp1).^2,2)))');
% [~,p]=ttest(areaL,areaR)

%% EEG
cd /home/yuval/Copy/MEGdata/alice/ga
load LRpairsEEG
load GavgE20
cfg=[];
cfg.xlim=[0.1 0.1];
cfg.interactive='yes';
cfg.layout='WG32.lay';
figure;ft_topoplotER(cfg,GavgE20);
[~,Li]=ismember(LRpairs(:,1),GavgE20.label);
[~,Ri]=ismember(LRpairs(:,2),GavgE20.label);

rmsL=sqrt(squeeze(mean(GavgE20.individual(:,Li,:).*GavgE20.individual(:,Li,:),2)));
rmsR=sqrt(squeeze(mean(GavgE20.individual(:,Ri,:).*GavgE20.individual(:,Ri,:),2)));


L=squeeze(mean(GavgE20.individual(:,Li,:),2));
R=squeeze(mean(GavgE20.individual(:,Ri,:),2));

[~,p]=ttest(L,R);
figure;
plot(GavgE20.time,mean(rmsL))
hold on
plot(GavgE20.time,mean(rmsR),'r')
plot(GavgE20.time(p<0.01),0,'k*')
legend('L','R','sig')

chansL={'P7','P3','O1'};
chansR={'P8','P4','O2'};
% chansL={'F7','FC5','T7'};
% chansR={'F8','FC6','T8'};
chansL={'P7'};
chansR={'P8'};

[~,Li]=ismember(chansL,GavgE20.label);
[~,Ri]=ismember(chansR,GavgE20.label);
rmsL=sqrt(squeeze(mean(GavgE20.individual(:,Li,:).*GavgE20.individual(:,Li,:),2)));
rmsR=sqrt(squeeze(mean(GavgE20.individual(:,Ri,:).*GavgE20.individual(:,Ri,:),2)));
figure;
plot(GavgE20.time,mean(rmsL))
hold on
plot(GavgE20.time,mean(rmsR),'r')
[~,p]=ttest(rmsL,rmsR);
plot(GavgE20.time(p<0.05),0,'k*')
legend('L','R','sig')

L=squeeze(mean(GavgE20.individual(:,Li,:),2));
R=squeeze(mean(GavgE20.individual(:,Ri,:),2));
figure;
plot(GavgE20.time,mean(L))
hold on
plot(GavgE20.time,mean(R),'r')
[~,p]=ttest(L,R);
plot(GavgE20.time(p<0.05),0,'k*')
legend('L','R','sig')
%compTimes=[0.025,0.08;0.08,0.15;0.15,0.26;0.26,0.3;0.38,0.48];
% compi=5;
% compSamp0=nearest(GavgM20.time,compTimes(compi,1));
% compSamp1=nearest(GavgM20.time,compTimes(compi,2));
compSamp0=nearest(GavgE20.time,0.41);
compSamp1=nearest(GavgE20.time,0.48);
areaL=trapz(squeeze(mean(GavgE20.individual(:,Li,compSamp0:compSamp1),2))');
areaR=trapz(squeeze(mean(GavgE20.individual(:,Ri,compSamp0:compSamp1),2))');
[~,p]=ttest(areaL,areaR)

compSamp0=nearest(GavgE20.time,0.07);
compSamp1=nearest(GavgE20.time,0.125);
areaL=trapz(squeeze(mean(GavgE20.individual(:,Li,compSamp0:compSamp1),2))');
areaR=trapz(squeeze(mean(GavgE20.individual(:,Ri,compSamp0:compSamp1),2))');
[~,p]=ttest(areaL,areaR)


compSamp0=nearest(GavgE20.time,0.33);
compSamp1=nearest(GavgE20.time,0.41);
areaL=trapz(squeeze(mean(GavgE20.individual(:,Li,compSamp0:compSamp1),2))');
areaR=trapz(squeeze(mean(GavgE20.individual(:,Ri,compSamp0:compSamp1),2))');
[~,p]=ttest(areaL,areaR)

compSamp0=nearest(GavgE20.time,0.41);
compSamp1=nearest(GavgE20.time,0.48);
areaL=trapz(squeeze(mean(GavgE20.individual(:,Li,compSamp0:compSamp1),2))');
areaR=trapz(squeeze(mean(GavgE20.individual(:,Ri,compSamp0:compSamp1),2))');
[~,p]=ttest(areaL,areaR)

compSamp0=nearest(GavgE20.time,0.36);
compSamp1=nearest(GavgE20.time,0.48);
areaL=trapz(squeeze(mean(GavgE20.individual(:,Li,compSamp0:compSamp1),2))');
areaR=trapz(squeeze(mean(GavgE20.individual(:,Ri,compSamp0:compSamp1),2))');
[~,p]=ttest(areaL,areaR)

% rms
% compSamp0=nearest(GavgM20.time,0.41);
% compSamp1=nearest(GavgM20.time,0.5);
% areaL=trapz(squeeze(sqrt(mean(GavgM20.individual(:,Li,compSamp0:compSamp1).^2,2)))');
% areaR=trapz(squeeze(sqrt(mean(GavgM20.individual(:,Ri,compSamp0:compSamp1).^2,2)))');
% [~,p]=ttest(areaL,areaR)
