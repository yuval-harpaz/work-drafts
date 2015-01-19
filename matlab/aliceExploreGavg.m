cd /home/yuval/Copy/MEGdata/alice/ga
load GavgM20
load GavgM2
load GavgM4
load GavgE20
load GavgE2
load GavgE4
GavgM20=correctBL(GavgM20,[-0.2 -0.05]);
GavgM2=correctBL(GavgM2,[-0.2 -0.05]);
GavgM4=correctBL(GavgM4,[-0.2 -0.05]);
GavgE20=correctBL(GavgE20,[-0.2 -0.05]);
GavgE2=correctBL(GavgE2,[-0.2 -0.05]);
GavgE4=correctBL(GavgE4,[-0.2 -0.05]);
GavgM20abs=GavgM20;GavgM20abs.individual=abs(GavgM20abs.individual);
GavgM2abs=GavgM2;GavgM2abs.individual=abs(GavgM2abs.individual);
GavgM4abs=GavgM4;GavgM4abs.individual=abs(GavgM4abs.individual);
GavgE20abs=GavgE20;GavgE20abs.individual=abs(GavgE20abs.individual);
GavgE2abs=GavgE2;GavgE2abs.individual=abs(GavgE2abs.individual);
GavgE4abs=GavgE4;GavgE4abs.individual=abs(GavgE4abs.individual);
t0=-0.2;t1=0.55;
s0=nearest(GavgM2.time,t0);
s1=nearest(GavgM2.time,t1);
s2=nearest(GavgM20.time,t1);
time=GavgM2.time(s0:s1);
s3=nearest(time,-0.05);
s0e=nearest(GavgE2.time,t0);
s1e=nearest(GavgE2.time,t1);
s2e=nearest(GavgE20.time,t1);
timeE=GavgE2.time(s0e:s1e);
s3e=nearest(timeE,-0.05);

chi=1:248;
globM2=squeeze(mean(abs(mean(GavgM2.individual(:,chi,s0:s1)))));
globM20=squeeze(mean(abs(mean(GavgM20.individual(:,chi,1:s2+1)))));
globM4=squeeze(mean(abs(mean(GavgM4.individual(:,chi,s0:s1)))));
globM2abs=squeeze(mean(mean(GavgM2abs.individual(:,chi,s0:s1))));
globM20abs=squeeze(mean(mean(GavgM20abs.individual(:,chi,1:s2+1))));
globM4abs=squeeze(mean(mean(GavgM4abs.individual(:,chi,s0:s1))));
chiE=[1:12,14:18,20:32];
globE2=squeeze(mean(abs(mean(GavgE2.individual(:,chiE,s0e:s1e)))));
globE20=squeeze(mean(abs(mean(GavgE20.individual(:,chiE,1:s2e)))));
globE4=squeeze(mean(abs(mean(GavgE4.individual(:,chiE,s0e:s1e)))));
globE2abs=squeeze(mean(mean(GavgE2abs.individual(:,chiE,s0e:s1e))));
globE20abs=squeeze(mean(mean(GavgE20abs.individual(:,chiE,1:s2e))));
globE4abs=squeeze(mean(mean(GavgE4abs.individual(:,chiE,s0e:s1e))));
figure;
plot(time,globM2)
hold on
plot(time,globM4,'--')
plot(time,globM20,'r')
ylim([0 3.5e-14]);
title('abs mean')
figure;
plot(time,globM2abs)
hold on
plot(time,globM4abs,'--')
plot(time,globM20abs,'r')
ylim([0 3.5e-14]);
title('mean abs')
figure;
plot(timeE,globE2)
hold on
plot(timeE,globE4,'--')
plot(timeE,globE20,'r')
ylim([0 1.7]);
title('abs mean')
figure;
plot(timeE,globE2abs)
hold on
plot(timeE,globE4abs,'--')
plot(timeE,globE20abs,'r')
ylim([0 1.7]);
title('mean abs')


%% mean Abs mean
glob2=squeeze(mean(abs(mean(GavgM2.individual))));
glob20=squeeze(mean(abs(mean(GavgM20.individual))));
glob4=squeeze(mean(abs(mean(GavgM4.individual))));
figure;
plot(GavgM2.time,glob2,'b');
hold on
plot(GavgM4.time,glob4,'b--');
plot(GavgM20.time,glob20,'r');
xlim([-0.2 0.55])
cfg=[];
cfg.interactive='yes';
cfg.xlim=[0.12 0.12];
cfg.layout='4D248.lay';
figure;
ft_topoplotER(cfg,GavgM20)
figure;
ft_topoplotER(cfg,GavgM2)
%% mean Abs mean, posterior channels
channel = {'A1', 'A10', 'A11', 'A12', 'A13', 'A14', 'A26', 'A27', 'A28', 'A29', 'A30', 'A31', 'A45', 'A46', 'A47', 'A48', 'A49', 'A50', 'A51', 'A52', 'A53', 'A69', 'A70', 'A71', 'A72', 'A73', 'A74', 'A75', 'A76', 'A77', 'A78', 'A79', 'A80', 'A81', 'A99', 'A100', 'A101', 'A102', 'A103', 'A104', 'A105', 'A106', 'A107', 'A108', 'A109', 'A110', 'A111', 'A130', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A138', 'A139', 'A140', 'A141', 'A142', 'A143', 'A144', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A167', 'A168', 'A169', 'A170', 'A171', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242'};
[~,chi]=ismember(channel,GavgM20.label);
t0=-0.2;t1=0.55;
s0=nearest(GavgM2.time,t0);
s1=nearest(GavgM2.time,t1);
s2=nearest(GavgM20.time,t1);
time=GavgM2.time(s0:s1);
s3=nearest(time,-0.05);
GavgM2=correctBL(GavgM2,[-0.2 -0.05]);
GavgM20=correctBL(GavgM20,[-0.2 -0.05]);
GavgM4=correctBL(GavgM4,[-0.2 -0.05]);


% first average subjects
glob2=squeeze(mean(abs(mean(GavgM2.individual(:,chi,s0:s1)))));
glob20=squeeze(mean(abs(mean(GavgM20.individual(:,chi,1:s2+1)))));
glob4=squeeze(mean(abs(mean(GavgM4.individual(:,chi,s0:s1)))));
glob2=glob2./mean(glob2(1:s3));
glob4=glob4./mean(glob4(1:s3));
glob20=glob20./mean(glob20(1:s3));


figure;
plot(time,glob2,'b');
hold on
plot(time,glob4,'b--');
plot(time,glob20,'r');
ylim([0 7])
title('subjects first')
glob2=mean(squeeze(mean(abs(GavgM2.individual(:,chi,s0:s1)))));
glob20=mean(squeeze(mean(abs(GavgM20.individual(:,chi,1:s2+1)))));
glob4=mean(squeeze(mean(abs(GavgM4.individual(:,chi,s0:s1)))));
glob2=glob2./mean(glob2(1:s3));
glob4=glob4./mean(glob4(1:s3));
glob20=glob20./mean(glob20(1:s3));
figure;
plot(time,glob2,'b');
hold on
plot(time,glob4,'b--');
plot(time,glob20,'r');
ylim([0 7])
title('channels first')

% all channels
chi=1:248;
t0=-0.2;t1=0.55;
s0=nearest(GavgM2.time,t0);
s1=nearest(GavgM2.time,t1);
s2=nearest(GavgM20.time,t1);
time=GavgM2.time(s0:s1);
s3=nearest(time,-0.05);
GavgM2=correctBL(GavgM2,[-0.2 -0.05]);
GavgM20=correctBL(GavgM20,[-0.2 -0.05]);
GavgM4=correctBL(GavgM4,[-0.2 -0.05]);


% first average subjects
glob2=squeeze(mean(abs(mean(GavgM2.individual(:,chi,s0:s1)))));
glob20=squeeze(mean(abs(mean(GavgM20.individual(:,chi,1:s2+1)))));
glob4=squeeze(mean(abs(mean(GavgM4.individual(:,chi,s0:s1)))));
glob2=glob2./mean(glob2(1:s3));
glob4=glob4./mean(glob4(1:s3));
glob20=glob20./mean(glob20(1:s3));


figure;
plot(time,glob2,'b');
hold on
plot(time,glob4,'b--');
plot(time,glob20,'r');
ylim([0 7])
title('subjects first 248')
glob2=mean(squeeze(mean(abs(GavgM2.individual(:,chi,s0:s1)))));
glob20=mean(squeeze(mean(abs(GavgM20.individual(:,chi,1:s2+1)))));
glob4=mean(squeeze(mean(abs(GavgM4.individual(:,chi,s0:s1)))));
glob2=glob2./mean(glob2(1:s3));
glob4=glob4./mean(glob4(1:s3));
glob20=glob20./mean(glob20(1:s3));
figure;
plot(time,glob2,'b');
hold on
plot(time,glob4,'b--');
plot(time,glob20,'r');
ylim([0 7])
title('channels first 248')


%% multiply Gavg field by individual data
cond={'2','4','20'};
for condi=1:3
    samples='s0:s1';
    if condi==3
        samples='1:s2+1';
    end
    eval(['wts=squeeze(mean(GavgM',cond{condi},'.individual(:,:,',samples,')));']);
    for subi=1:8
        eval(['data=squeeze(GavgM',cond{condi},'.individual(',num2str(subi),',:,',samples,'));']);
        mult=wts'*data;
        tc=mult(logical(eye(764)));
        tc=tc/mean(tc(1:s3));
        eval(['TC',cond{condi},'(',num2str(subi),',1:764)=tc;']);
    end
end


load GavgE2
load GavgE4
load GavgE20
s0e=nearest(GavgE2.time,t0);
s1e=nearest(GavgE2.time,t1);
s2e=nearest(GavgE20.time,t1);
timeE=GavgE2.time(s0e:s1e);
s3e=nearest(timeE,-0.05);
chi=[1:12,14:18,20:32];
for condi=1:3
    samples='s0e:s1e';
    if condi==3
        samples='1:s2e';
    end
    eval(['wts=squeeze(mean(GavgE',cond{condi},'.individual(:,chi,',samples,')));']);
    for subi=1:8
        %eval(['data=squeeze(GavgE',cond{condi},'.individual(',num2str(subi),',chi,',samples,'));']);
        eval(['data=squeeze(GavgE',cond{condi},'.individual(subi,chi,',samples,'));']);
        mult=wts'*data;
        tc=mult(logical(eye(769)));
        tc=tc/mean(tc(1:s3e));
        eval(['TCe',cond{condi},'(',num2str(subi),',1:769)=tc;']);
    end
end


%% Gavg all alice paragraphs
cd /home/yuval/Copy/MEGdata/alice/ga
load('GavgEalice.mat')
load('GavgMalice.mat')
cond={'2','4','20'};
load('GavgMalice.mat')
t0=-0.2;t1=0.55;
s0=nearest(GavgMalice.time,t0);
s1=nearest(GavgMalice.time,t1);
time=GavgMalice.time(s0:s1);
s3=nearest(time,-0.05);
samples=s0:s1;
wts=squeeze(mean(GavgMalice.individual(:,:,samples)));
for subi=1:8
    data=squeeze(GavgMalice.individual(subi,:,samples));
    mult=wts'*data;
    tc=mult(logical(eye(764)));
    tc=tc/mean(tc(1:s3));
    TCalice(subi,1:764)=tc;
end
figure;plot(time,TCalice)
title('MEG')

s0e=nearest(GavgEalice.time,t0);
s1e=nearest(GavgEalice.time,t1);
timeE=GavgEalice.time(s0e:s1e);
s3e=nearest(timeE,-0.05);
chi=[1:12,14:18,20:32];
samples=s0e:s1e;
wts=squeeze(mean(GavgEalice.individual(:,chi,samples)));
for subi=1:8
    %eval(['data=squeeze(GavgE',cond{condi},'.individual(',num2str(subi),',chi,',samples,'));']);
    data=squeeze(GavgEalice.individual(subi,chi,samples));
    mult=wts'*data;
    tc=mult(logical(eye(769)));
    tc=tc/mean(tc(1:s3e));
    TCeAlice(subi,1:769)=tc;
end
figure;plot(timeE,TCeAlice)
title('EEG')

%plot(tc)
%%
glob2=squeeze(mean(abs(GavgM2.individual(:,chi,s0:s1)),2));
glob20=squeeze(mean(abs(GavgM20.individual(:,chi,1:s2+1)),2));
glob4=squeeze(mean(abs(GavgM4.individual(:,chi,s0:s1)),2));



bl=repmat(mean(glob2(:,1:s3),2),1,764);
glob2bl=glob2-bl;
bl=repmat(mean(glob4(:,1:s3),2),1,764);
glob4bl=glob4-bl;
bl=repmat(mean(glob20(:,1:s3),2),1,764);
glob20bl=glob20-bl;
figure;
plot(time,mean(glob2),'b');
hold on
plot(time,mean(glob4),'b--');
plot(time,mean(glob20),'r');

figure;
plot(time,mean(glob2bl),'b');
hold on
plot(time,mean(glob4bl),'b--');
plot(time,mean(glob20bl),'r');



FIXME - plots are not the same after baseline correction


ttest(glob20,(glob2+glob4)/2);



cfg=[];
cfg.notBefore=0.025;
cfg.notAfter=0.5;
cfg.method='absMean';
cfg.maxDist=0.15;
cfg.zThr=0;
cfg.channel = chans;
[Itroughs,Ipeaks,~,~]=findCompLims(cfg,GavgM20);

xlim=repmat(0.4148,1,8); % L > R
e=aliceCompByRMSmaxPeak('GavgM20',xlim,chans)
R=e.rmsR;
L=e.rmsL;
[L;R]
[~,p,~,stats]=ttest(L,R);

chans= {'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10', 'A11', 'A12', 'A13', 'A14', 'A15', 'A16', 'A17', 'A18', 'A19', 'A20', 'A21', 'A22', 'A23', 'A24', 'A25', 'A26', 'A27', 'A28', 'A29', 'A30', 'A31', 'A32', 'A33', 'A34', 'A35', 'A36', 'A37', 'A38', 'A39', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A46', 'A47', 'A48', 'A49', 'A50', 'A51', 'A52', 'A53', 'A54', 'A55', 'A56', 'A57', 'A58', 'A59', 'A60', 'A61', 'A62', 'A63', 'A64', 'A65', 'A66', 'A67', 'A68', 'A69', 'A70', 'A71', 'A72', 'A73', 'A74', 'A75', 'A76', 'A77', 'A78', 'A79', 'A80', 'A81', 'A82', 'A83', 'A84', 'A85', 'A86', 'A87', 'A88', 'A89', 'A90', 'A91', 'A92', 'A93', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'A100', 'A101', 'A102', 'A103', 'A104', 'A105', 'A106', 'A107', 'A108', 'A109', 'A110', 'A111', 'A112', 'A113', 'A114', 'A115', 'A116', 'A117', 'A118', 'A119', 'A120', 'A121', 'A122', 'A123', 'A124', 'A125', 'A126', 'A127', 'A128', 'A129', 'A130', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A138', 'A139', 'A140', 'A141', 'A142', 'A143', 'A144', 'A145', 'A146', 'A147', 'A148', 'A149', 'A150', 'A151', 'A152', 'A153', 'A154', 'A155', 'A156', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A167', 'A168', 'A169', 'A170', 'A171', 'A172', 'A173', 'A174', 'A175', 'A176', 'A177', 'A178', 'A179', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A193', 'A194', 'A195', 'A196', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A209', 'A210', 'A211', 'A212', 'A213', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A227', 'A228', 'A229', 'A230', 'A231', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243', 'A244', 'A245', 'A246', 'A247', 'A248'};
e=aliceCompByRMSmaxPeak('GavgM20',xlim,chans)
R=e.rmsR;
L=e.rmsL;
[L;R]
[~,p,~,stats]=ttest(L,R);

% cfg.method='absMean';
% [Itroughs,Ipeaks,~,~]=findCompLims(cfg,eval(file));

% M100 (0.0885)
times=GavgM20.time(Ipeaks);
xlim=times(1);
extrema=aliceCompByMaxCh('GavgM20',xlim,'R',chans);
xlim=repmat(times(1),1,8);
e059=aliceCompByRMSmaxPeak('GavgM20',xlim,chans)
R=e059.rmsR;
L=e059.rmsL;
[L;R]
[~,p,~,stats]=ttest(L,R);
% [p, h, stats] = ranksum(L,R)
xlim=repmat(0.0885,1,8);
e089=aliceCompByRMSmaxPeak('GavgM20',xlim,chans)
R=e089.rmsR;
L=e089.rmsL;
[L;R]
[~,p,~,stats]=ttest(L,R);

xlim=repmat(0.1790,1,8);
e179=aliceCompByRMSmaxPeak('GavgM20',xlim,chans)
R=e179.rmsR;
L=e179.rmsL;
[L;R]
[~,p,~,stats]=ttest(L,R);

xlim=repmat(0.2202,1,8);
extrema=aliceCompLat('GavgM20',xlim,'L',chans);
R=extrema.minLatR;
L=extrema.maxLatL;
[L;R]'
[~,p,~,stats]=ttest(L,R) % lat sig, 8 of 8

xlim=repmat(0.4148,1,8);
e=aliceCompByRMSmaxPeak('GavgMalice',xlim,chans)
R=e.rmsR;
L=e.rmsL;
[L;R]
[~,p,~,stats]=ttest(L,R);

xlim=repmat(0.4148,1,8); % L > R
e=aliceCompByRMSmaxPeak('GavgM20',xlim,chans)
R=e.rmsR;
L=e.rmsL;
[L;R]
[~,p,~,stats]=ttest(L,R);
