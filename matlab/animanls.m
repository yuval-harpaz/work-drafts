cd /home/yuval/Data/Amyg/1
fileName='c,rfhp0.1Hz';
p=pdf4D(fileName);
cleanCoefs = createCleanFile_fhb(p, fileName,'byLF',0,'byFFT',0,'HeartBeat',[]);
trig=readTrig_BIU('hb_c,rfhp0.1Hz');
trigf=fixVisTrig(trig,0.1);

cfg=[];
cfg.dataset=fileName;
cfg.trialdef.eventvalue=[100,102,104,106,108];
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.2;
cfg.trialdef.poststim=0.7;
cfg.trialdef.offset=-0.2;
cfg=ft_definetrial(cfg);
cfg.channel={'MEG','-A74','-A204'};
cfg.demean='yes';
cfg.baselinewindow=[-0.2 0];
% cfg.bpfilter='yes';
% cfg.bpfreq=[3 50];
data=ft_preprocessing(cfg);

cfg            = [];
cfg.method    = 'pca';
comp           = ft_componentanalysis(cfg, data);
cfg=[];
cfg.layout='4D248.lay';
cfg.channel = 1:5;
ft_databrowser(cfg,comp);
cfg=[];
cfg.method='summary';
cfg.preproc.hpfilter='yes';
cfg.preproc.hpfreq=60;
datacln=ft_rejectvisual(cfg,data);
cfg=[];
cfg.method='summary';
datacln=ft_rejectvisual(cfg,datacln);
cfg=[];
cfg.hpfilter='yes';
cfg.hpfreq=1;
cfg.demean='yes';
cfg,baselinewindow=[-0.15 0];
datacln=ft_preprocessing(cfg,datacln)
save datacln datacln
avg=ft_timelockanalysis([],datacln);
cfg=[];
cfg.interactive='yes';
cfg.layout='4D248.lay';
ft_multiplotER(cfg,avg);

cfg              = [];
cfg.keeptrials = 'yes';
cfg.output       = 'pow';
cfg.channel      = 'MEG';
cfg.method       = 'mtmconvol';
cfg.taper        ='triang'; % not required
cfg.foi          = [10:5:40];                            % freq of interest 3 to 100Hz
cfg.t_ftimwin    = 1./cfg.foi;   % ones(length(cfg.foi),1).*0.5;  % length of time window fixed at 0.5 sec
cfg.toi          = 0:0.005:0.35;                  % time window "slides" from -0.1 to 0.5 sec in steps of 0.02 sec (20 ms)
cfg.tapsmofrq  = 1;
cfg.trials='all';%[1:2];
cfg.channel='all';
cfg.tail='beg'; % pad the template with zeros, 'beg' 'end' 'both' or [] for no padding
[TF,wlt] = freqanalysis_triang_temp(cfg, datacln);

cfgp = [];
cfgp.channel='A190';
mn=min(min(squeeze(mean(TF.powspctrm(:,1,:,:),1))));
mx=max(max(squeeze(mean(TF.powspctrm(:,1,:,:),1))));
z=abs(mx);if abs(mn)>abs(mx);z=abs(mn);end
cfgp.zlim=[-z z];
figure;ft_singleplotTFR(cfgp, TF);

peaks=peaksInTrials(TF,wlt);


post=[];negt=[];
for ti=1:length(peaks.chan{1,1}.trial)
    post=[post,peaks.chan{1,1}.trial{1,ti}.time(1,peaks.chan{1,1}.trial{1,ti}.SNR>0)];
    negt=[negt,peaks.chan{1,1}.trial{1,ti}.time(1,peaks.chan{1,1}.trial{1,ti}.SNR<0)];
end
% figure;
% plot(post,'or')
% hold on
% plot(negt,'ob')

figure;hist(post,35);
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
hold on;
hist(negt,35);
legend ('pos','neg')
title('Count of Peaks')


posSNR=[];negSNR=[];
for ti=1:length(peaks.chan{1,1}.trial)
    posSNR=[posSNR,peaks.chan{1,1}.trial{1,ti}.SNR(1,peaks.chan{1,1}.trial{1,ti}.SNR>0)];
    negSNR=[negSNR,peaks.chan{1,1}.trial{1,ti}.SNR(1,peaks.chan{1,1}.trial{1,ti}.SNR<0)];
end
figure;
plot(post,posSNR,'.r')
hold on
plot(negt,abs(negSNR),'.b')
legend ('pos','neg')
title('Absolute SNR Values')
