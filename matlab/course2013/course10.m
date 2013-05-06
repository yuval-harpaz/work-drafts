%% Connectivity

%% Read raw data, rest, eyes open.
cd somsens
fileName='hb_c,rfhp0.1Hz';
cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0;
cfg.trialdef.poststim=120;
cfg.trialdef.offset=0;
cfg.trialfun='BIUtrialfun';
cfg.trialdef.eventvalue= 90;
cfg.channel='MEG';
cfg=ft_definetrial(cfg);
cfg.padding=0.5;
cfg.bpfilter='yes';
cfg.bpfreq=[1 90];
cfg.demean='yes';
cfg.continuous='yes';
cfg.channel='MEG';
eyesOpen=ft_preprocessing(cfg);
%% View the data
% see the onset of alpha for A113, A114 and A115
cfgb=[];
cfgb.layout='4D248.lay';
cfgb.continuous='yes';
cfgb.event.type='';
cfgb.event.sample=1;
cfgb.blocksize=10;
cfgb.viewmode='vertical';
cfgb.ylim=[-1e-12  1e-12];
cfgb.channel={'A112','A113','A114','A115','A116'};
comppic=ft_databrowser(cfgb,eyesOpen);
%% Warning! cleaning data with PCA introduced false synchrony to dipoles
% do not clean artifacts with component analysis before running
% connectivity analysis
%% Read somatosensory evoked responses.
% reject bad trials
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
cfg1.channel='MEG';
cfg1.feedback='no';
somsens=ft_preprocessing(cfg1);
cfg=[];
cfg.method='summary';
cfg.channel='MEG';
cfg.alim=1e-12;
somsensCln=ft_rejectvisual(cfg, somsens);
%% Averaging left and right responses separately
cfg=[];
cfg.feedback='no';
cfg.trials=find(somsensCln.trialinfo==102);
rightInd=ft_timelockanalysis(cfg,somsensCln);
cfg.trials=find(somsensCln.trialinfo==104);
leftInd=ft_timelockanalysis(cfg,somsensCln);
%% Plot left finger response
% select which channels to use for dipole fit
cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
cfg.zlim=[-2e-13 2e-13];
cfg.xlim=[0.036 0.036];
figure;
ft_topoplotER(cfg,leftInd);
%% Plot right finger response
% here too you have to select channels
figure;
ft_topoplotER(cfg,rightInd);

%% Head model
if exist('headmodel.mat','file')
    load headmodel
else
    [vol,grid,mesh,M1]=headmodel_BIU([],[],[],[],'localspheres');
    save headmodel vol grid mesh M1
end
%% Dipole fit
% Here you use the channels selected at " Plot right finger response "
channelRH = {'A1', 'A2', 'A3', 'A4', 'A12', 'A13', 'A14', 'A15', 'A16', 'A17', 'A28', 'A29', 'A30', 'A31', 'A32', 'A33', 'A34', 'A35', 'A50', 'A51', 'A52', 'A53', 'A54', 'A55', 'A56', 'A57', 'A58', 'A78', 'A79', 'A80', 'A81', 'A82', 'A83', 'A84', 'A85', 'A86', 'A111', 'A112', 'A113', 'A114', 'A115', 'A116', 'A117', 'A144', 'A145', 'A146', 'A147', 'A148', 'A171', 'A172', 'A173', 'A174', 'A175', 'A193', 'A194', 'A210', 'A211'};
%channelRH = {'A11', 'A26', 'A27', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A46', 'A47', 'A48', 'A64', 'A65', 'A66', 'A67', 'A68', 'A69', 'A70', 'A71', 'A72', 'A73', 'A74', 'A92', 'A93', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'A100', 'A101', 'A102', 'A103', 'A104', 'A125', 'A126', 'A127', 'A128', 'A129', 'A130', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A153', 'A154', 'A155', 'A156', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A178', 'A179', 'A180', 'A181', 'A182', 'A183', 'A184', 'A196', 'A197', 'A198', 'A199', 'A200', 'A201', 'A213', 'A214', 'A215', 'A216', 'A217', 'A229', 'A230', 'A231', 'A232', 'A233', 'A234', 'A235'};
channelLH = {'A1', 'A2', 'A3', 'A7', 'A8', 'A9', 'A10', 'A11', 'A12', 'A21', 'A22', 'A23', 'A24', 'A25', 'A26', 'A27', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A46', 'A65', 'A66', 'A67', 'A68', 'A69', 'A70', 'A71', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'A127', 'A128', 'A129', 'A155', 'A156', 'A157'};
t=0.0355;
cfg5 = [];
cfg5.latency = [t t];
cfg5.numdipoles = 1;
cfg5.vol=vol;
cfg5.feedback = 'textbar';
cfg5.gridsearch='yes';
cfg5.grad=ft_convert_units(leftInd.grad,'mm');
cfg5.grid=grid;
cfg5.channel=channelRH;
RHdip = ft_dipolefitting(cfg5, leftInd);
cfg5.channel=channelLH;
LHdip = ft_dipolefitting(cfg5, rightInd);
% plot dipoles
hs=ft_read_headshape('hs_file');
hs=ft_convert_units(hs,'mm');
hsx=hs.pnt(:,1);hsy=hs.pnt(:,2);hsz=hs.pnt(:,3);
figure;plot3(hsx,hsy,hsz,'r.');hold on;
ft_plot_dipole(LHdip.dip.pos,LHdip.dip.mom,'units','mm','color','b')
ft_plot_dipole(RHdip.dip.pos,RHdip.dip.mom,'units','mm','color','g')

%% Plot dipole timecourse
cfg=[];cfg.channel=channelLH;
dataLH=ft_preprocessing(cfg,rightInd);

cfg.channel=channelRH;
dataRH=ft_preprocessing(cfg,leftInd);
timecourseLH=LHdip.dip.pot'*dataLH.avg;
timecourseRH=RHdip.dip.pot'*dataRH.avg;
figure;
plot(dataLH.time,timecourseLH,'b');
hold on;
plot(dataLH.time,timecourseRH,'g');
legend('LHdipole','RHdipole');

%% Now see the somatosensory cortex activation in the rest state (Mu).
% choose channels for data display
cfg=[];cfg.channel=channelLH;
dataLH=ft_preprocessing(cfg,eyesOpen);
cfg.channel=channelRH;
dataRH=ft_preprocessing(cfg,eyesOpen);
% time window with no MOG, 65 to 75s
smp1=nearest(dataLH.time{1,1},65);
smp2=nearest(dataLH.time{1,1},75);
timecourseLH=LHdip.dip.pot'*dataLH.trial{1,1}(:,smp1:smp2);
timecourseRH=RHdip.dip.pot'*dataRH.trial{1,1}(:,smp1:smp2);
timecourseLH=timecourseLH/max(abs(timecourseLH));
timecourseRH=timecourseRH/max(abs(timecourseRH));
figure1=figure;
set(figure1,'position',[100,100,1500,600])
plot(eyesOpen.time{1,1}(:,smp1:smp2),timecourseLH,'b');
hold on;
plot(eyesOpen.time{1,1}(:,smp1:smp2),timecourseRH+1.5,'g');
%% Make Hilbert envelope
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
title('RH')
legend('raw','envelope','alpha')
figure; % now for the LH
plot(vsHilb.time{1,1}(1,samp(1):samp(2)),vs.trial{1,1}(2,samp(1):samp(2)),'b');
hold on;
plot(vsHilb.time{1,1}(1,samp(1):samp(2)),vsHilb.trial{1,1}(2,samp(1):samp(2)),'k');
plot(vsHilb.time{1,1}(1,samp(1):samp(2)),vsAlpha.trial{1,1}(2,samp(1):samp(2)),'m');
title('LH')
legend('raw','envelope','alpha')
%% check correlations (don't expect much)
corAlpha=corrcoef(vsAlpha.trial{1,1}');corAlpha=corAlpha(1,2)
corHilb=corrcoef(vsHilb.trial{1,1}');corHilb=corHilb(1,2)
cor=corrcoef(vs.trial{1,1}');cor=cor(1,2)
corAbs=corrcoef(abs(vs.trial{1,1}'));corAbs=corAbs(1,2)

%% let's check cross correlation for absolute MEG data
win=3000;
[r,lags]=xcorr(vs.trial{1,1}','coeff');
sZero=find(lags==0);
figure;
plot(lags((sZero-win):(sZero+win)),r((sZero-win):(sZero+win),[1 2 4]));
legend('LH - LH','LH - RH','RH - RH')

%% now for alpha hilbert envelopes
[r,lags]=xcorr(vsHilb.trial{1,1}','coeff');
sZero=find(lags==0);
figure;
plot(lags((sZero-win):(sZero+win)),r((sZero-win):(sZero+win),[1 2 4]));
legend('LH - LH','LH - RH','RH - RH')
%% Coherence
cfg           = [];
cfg.method    = 'mtmfft';
cfg.output    = 'fourier';
cfg.tapsmofrq = 4;
cfg.foi=1:50;
freq          = ft_freqanalysis(cfg, vs);
cfg           = [];
cfg.method    = 'coh';
cohLR          = ft_connectivityanalysis(cfg, freq);
figure;
plot(cohLR.freq,squeeze(cohLR.cohspctrm(1,2,:)))
xlabel('Frequency (Hz)')
ylabel('Coherence')

%% Another approach to left-right coherence
dataShort=eyesOpen;
dataShort.trial{1,1}=eyesOpen.trial{1,1}(:,smp1:smp2);
dataShort.time{1,1}=eyesOpen.time{1,1}(:,smp1:smp2);
%compute coh (not via fieldtrip) for every LR pair
temp={};
temp.label=dataShort.label;
temp.dimord='chan_freq';
temp.freq=(1:50);
temp.grad=dataShort.grad;
temp.powspctrm=ones(248,50);
coh=temp;
for cmbi=1:113
    chiL=find(strcmp(LRpairs{cmbi,1},dataShort.label));
    dataL=dataShort.trial{1,1}(chiL,:);
    chiR=find(strcmp(LRpairs{cmbi,2},dataShort.label));
    dataR=dataShort.trial{1,1}(chiR,:);
    [Cxy,F] = mscohere(dataL,dataR,[],[],[],dataShort.fsample);
    for freqi=1:50
        fi(freqi)=nearest(F,freqi); %frequency index
        coh.powspctrm(chiL,freqi)=Cxy(fi(freqi));
        coh.powspctrm(chiR,freqi)=Cxy(fi(freqi));
    end
end
cfg=[];
cfg.xlim=[11 11];
cfg.layout='4D248.lay';
figure;
ft_topoplotER(cfg,coh)
title('11Hz');
figure;
cfg.xlim=[3 3];
ft_topoplotER(cfg,coh)
title('3Hz')

%% Compute coherence for pairs of voxels with SAMwts
% this requires running SAMcov and SAMwts first
% just watch the result in html version

% foi=11;
% [SAMHeader, ~, ActWgts]=readWeights('SAM/Raw,1-70Hz,Global.wts');
% cohlr=zeros(length(ActWgts),1);
% for Xi=-12:0.5:12
%     for Yi=-9:0.5:-0.5
%         for Zi=-2:0.5:15
%             [indR,~]=voxIndex([Xi,Yi,Zi],100.*[...
%                 SAMHeader.XStart SAMHeader.XEnd ...
%                 SAMHeader.YStart SAMHeader.YEnd ...
%                 SAMHeader.ZStart SAMHeader.ZEnd],...
%                 100.*SAMHeader.StepSize,0);
%             [indL,~]=voxIndex([Xi,-Yi,Zi],100.*[...
%                 SAMHeader.XStart SAMHeader.XEnd ...
%                 SAMHeader.YStart SAMHeader.YEnd ...
%                 SAMHeader.ZStart SAMHeader.ZEnd],...
%                 100.*SAMHeader.StepSize,0);
%             if ~isempty(find(ActWgts(indR,:))) && ~isempty(find(ActWgts(indL,:)))
%                 vsL=ActWgts(indL,:)*dataShort.trial{1,1};
%                 vsR=ActWgts(indR,:)*dataShort.trial{1,1};
%                 [Cxy,F] = mscohere(vsL,vsR,[],[],[],dataShort.fsample);
%                 fi=nearest(F,foi);
%                 cohlr(indR,1)=Cxy(fi);
%                 cohlr(indL,1)=cohlr(indR);
%                 display(['X Y Z = ',num2str([Xi,Yi,Zi])])
%             end
%         end
%     end
% end
% % plant ones in the midline
% Yi=0
% for Xi=-12:0.5:12
%     for Zi=-2:0.5:15
%         [indM,~]=voxIndex([Xi,Yi,Zi],100.*[...
%             SAMHeader.XStart SAMHeader.XEnd ...
%             SAMHeader.YStart SAMHeader.YEnd ...
%             SAMHeader.ZStart SAMHeader.ZEnd],...
%             100.*SAMHeader.StepSize,0);
%         cohlr(indM)=1;
%     end
% end
% % eval(['coh',conds{i},'=cohlr;'])
% 
% cfg=[];
% cfg.step=5;
% cfg.boxSize=[-120 120 -90 90 -20 150];
% cfg.prefix='CohLR11Hz';
% VS2Brik(cfg,cohlr)
