fileName='hb_c,rfhp0.1Hz';
cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.1;
cfg.trialdef.poststim=0.3;
cfg.trialdef.offset=-0.1;
cfg.trialfun='BIUtrialfun';
cfg.trialdef.eventvalue= [104,102]; %left index finger
cfg1=ft_definetrial(cfg);
cfg1.demean='yes';
cfg1.baselinewindow=[-0.1 0];
cfg1.bpfilter='yes';
cfg1.bpfreq=[3 30];
somsens=ft_preprocessing(cfg1);

cfg=[];
cfg.method='summary';
cfg.channel='MEG';
cfg.alim=1e-12;
somsensCln=ft_rejectvisual(cfg, somsens);
% averaging
cfg=[];
cfg.trials=find(somsensCln.trialinfo==102);
rightInd=ft_timelockanalysis(cfg,somsensCln);
cfg.trials=find(somsensCln.trialinfo==104);
leftInd=ft_timelockanalysis(cfg,somsensCln);
cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
cfg.zlim=[-2e-13 2e-13];
ft_multiplotER(cfg,leftInd);
ft_multiplotER(cfg,rightInd);

%% head model
if exist('headmodel.mat','file')
    load headmodel
else
    [vol,grid,mesh,M1]=headmodel_BIU([],[],[],[],'localspheres');
    save headmodel vol grid mesh M1
end
%% dipole fit
channelRH = {'A1', 'A2', 'A3', 'A4', 'A12', 'A13', 'A14', 'A15', 'A16', 'A17', 'A28', 'A29', 'A30', 'A31', 'A32', 'A33', 'A34', 'A35', 'A50', 'A51', 'A52', 'A53', 'A54', 'A55', 'A56', 'A57', 'A58', 'A78', 'A79', 'A80', 'A81', 'A82', 'A83', 'A84', 'A85', 'A86', 'A111', 'A112', 'A113', 'A114', 'A115', 'A116', 'A117', 'A144', 'A145', 'A146', 'A147', 'A148', 'A171', 'A172', 'A173', 'A174', 'A175', 'A193', 'A194', 'A210', 'A211'};
%channelRH = {'A11', 'A26', 'A27', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A46', 'A47', 'A48', 'A64', 'A65', 'A66', 'A67', 'A68', 'A69', 'A70', 'A71', 'A72', 'A73', 'A74', 'A92', 'A93', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'A100', 'A101', 'A102', 'A103', 'A104', 'A125', 'A126', 'A127', 'A128', 'A129', 'A130', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A153', 'A154', 'A155', 'A156', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A178', 'A179', 'A180', 'A181', 'A182', 'A183', 'A184', 'A196', 'A197', 'A198', 'A199', 'A200', 'A201', 'A213', 'A214', 'A215', 'A216', 'A217', 'A229', 'A230', 'A231', 'A232', 'A233', 'A234', 'A235'};
channelLH = {'A1', 'A2', 'A3', 'A7', 'A8', 'A9', 'A10', 'A11', 'A12', 'A21', 'A22', 'A23', 'A24', 'A25', 'A26', 'A27', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A46', 'A65', 'A66', 'A67', 'A68', 'A69', 'A70', 'A71', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'A127', 'A128', 'A129', 'A155', 'A156', 'A157'};
t=0.0355;
cfg5 = [];
cfg5.latency = [t t];  % specify latency window around M50 peak
cfg5.numdipoles = 1;
%cfg.symmetry='x';
cfg5.vol=vol;
cfg5.feedback = 'textbar';
cfg5.gridsearch='yes';
cfg5.grad=ft_convert_units(somsens.grad,'mm');
%cfg5.resolution = 0.1;
% cfg5.grid.xgrid=-75:-30;
% cfg5.grid.ygrid=75:-1:-105;
% cfg5.grid.zgrid=90:-1:-50;
cfg5.grid=grid;
cfg5.channel=channelRH;
RHdip = ft_dipolefitting(cfg5, leftInd);
cfg5.channel=channelLH;
LHdip = ft_dipolefitting(cfg5, rightInd);

%% plot dipoles
hs=ft_read_headshape('hs_file');
hs=ft_convert_units(hs,'mm');
hsx=hs.pnt(:,1);hsy=hs.pnt(:,2);hsz=hs.pnt(:,3);
figure;plot3(hsx,hsy,hsz,'rx');hold on;
ft_plot_dipole(LHdip.dip.pos,LHdip.dip.mom,'units','mm','color','b')
ft_plot_dipole(RHdip.dip.pos,RHdip.dip.mom,'units','mm','color','g')

%% now see the sensor cortex activation in the rest state (Mu).
cfg=[];cfg.channel=channelLH;
dataLH=ft_preprocessing(cfg,eyesOpen);
cfg.channel=channelRH;
dataRH=ft_preprocessing(cfg,eyesOpen);
timecourseLH=LHdip.dip.pot'*dataLH.trial{1,1};
timecourseRH=RHdip.dip.pot'*dataRH.trial{1,1};
figure;
plot(eyesOpen.time{1,1},timecourseLH,'b');
hold on;
plot(eyesOpen.time{1,1},timecourseRH,'g');

vs=eyesOpen;
vs.trial{1,1}=[timecourseLH;timecourseRH];
vs.label={'Ldipole','Rdipole'};

cfg=[];
cfg.bpfilter='yes';
cfg.bpfreq=[7 13];
vsAlpha=ft_preprocessing(cfg,vs);
cfg.hilbert='yes';
vsHilb=ft_preprocessing(cfg,vs);
% plot the hilbert envelope and the data for the RH dipole
t1=1;t2=4; %sec
samp=round(1017.25.*[t1 t2])

plot(vsHilb.time{1,1}(1,samp(1):samp(2)),vs.trial{1,1}(1,samp(1):samp(2)),'b');
hold on;
plot(vsHilb.time{1,1}(1,samp(1):samp(2)),vsHilb.trial{1,1}(1,samp(1):samp(2)),'k');
plot(vsHilb.time{1,1}(1,samp(1):samp(2)),vsAlpha.trial{1,1}(1,samp(1):samp(2)),'m');

figure; % now for the LH
plot(vsHilb.time{1,1}(1,samp(1):samp(2)),vs.trial{1,1}(2,samp(1):samp(2)),'b');
hold on;
plot(vsHilb.time{1,1}(1,samp(1):samp(2)),vsHilb.trial{1,1}(2,samp(1):samp(2)),'k');
plot(vsHilb.time{1,1}(1,samp(1):samp(2)),vsAlpha.trial{1,1}(2,samp(1):samp(2)),'m');

% now check correlations
corAlpha=corrcoef(vsAlpha.trial{1,1}');corAlpha=corAlpha(1,2)
corHilb=corrcoef(vsHilb.trial{1,1}');corHilb=corHilb(1,2)
cor=corrcoef(vs.trial{1,1}');cor=cor(1,2)
corAbs=corrcoef(abs(vs.trial{1,1}'));corAbs=corAbs(1,2)

%% let's check cross correlation for absolute MEG data
[r,lags]=xcorr(abs(vs.trial{1,1}'),'coeff');
sZero=find(lags==0);
figure;
plot(lags((sZero-500):(sZero+500)),r((sZero-500):(sZero+500),[1 2 4]));
legend('1 1','1 2','2 2')

%% now for alpha hilbert envelopes
[r,lags]=xcorr(vsHilb.trial{1,1}','coeff');
sZero=find(lags==0);
figure;
plot(lags((sZero-500):(sZero+500)),r((sZero-500):(sZero+500),[1 2 4]));
legend('1 1','1 2','2 2')
