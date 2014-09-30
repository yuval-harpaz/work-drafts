% b335
cd /home/yuval/Desktop/EEG/1
cfg.dataset=source;
cfg.trl=round(678.17*[20 200 0]);
cfg.channel='MEG';
meg=ft_preprocessing(cfg);
%f=fftBasic(meg.trial{1,1},meg.fsample);
cfg=[];
%cfg.trials=find(datacln.trialinfo==222);
cfg.output       = 'pow';
cfg.channel      = 'MEG';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = 1:100;
cfg.feedback='no';
FrAll = ft_freqanalysis(cfg, meg);

% plot results for alpha
cfgp = [];
cfgp.xlim = [20 70];
cfgp.layout       = '4D248.lay';
cfgp.interactive='yes';
ft_topoplotER(cfgp, FrAll);
%% EEG
cd /home/yuval/Desktop/EEG
cfg=[];
%cfg.dataset=source;
cfg.trl=round(678.17*[20 200 0]);
%cfg.channel='MEG';
eeg=readCNT(cfg);
cfg=[];
%cfg.trials=find(datacln.trialinfo==222);
cfg.output       = 'pow';
%cfg.channel      = 'MEG';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = 1:100;
cfg.feedback='no';
FrEEG = ft_freqanalysis(cfg, eeg);

cfgp = [];
cfgp.xlim = [20 70];
cfgp.layout       = 'WG32.lay';
cfgp.interactive='yes';
ft_topoplotER(cfgp, FrEEG);

%% SAM
%freq=[15 35];
!SAMcov64 -r 1 -d c,rfhp1.0Hz -m run1 -v
!SAMwts64 -r 1 -d c,rfhp1.0Hz -m run1 -c sega -v
cd /home/yuval/Desktop/EEG/1/SAM
[~,~,wts]=readWeights('run1,15-35Hz,sega.wts');
ns=mean(abs(wts),2);
cd /home/yuval/Desktop/EEG/1
cfg=[];
cfg.dataset=source;
cfg.trl=round(678.17*[20 200 0]);
cfg.channel='MEG';
cfg.bpfilt='yes';
cfg.bpfreq=[15 35];
meg=ft_preprocessing(cfg);
plot(meg.time{1,1},meg.trial{1,1}(100,:))
img=zeros(size(ns));
nonZero=find(wts(:,1));
count=0;
for voxi=nonZero'
    img(voxi)=mean(abs(wts(voxi,:)*meg.trial{1,1}))./ns(voxi);
    if voxi>count+1000;
        count=count+1000;
        disp(num2str(count))
    end
end

cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='run1_20to200';
VS2Brik(cfg,img);
cfg.prefix='noise';
VS2Brik(cfg,ns);


freq=[22 29];
F=zeros(size(ns));;
Fbl=F;
bl=(35:45);
count=0;
for voxi=nonZero'
    f=abs(fftBasic(wts(voxi,:)*meg.trial{1,1},678.17));
    F(voxi)=mean(f(freq(1):freq(end)));
    Fbl(voxi)=mean(f(bl));
    if voxi>count+1000;
        count=count+1000;
        disp(num2str(count))
    end
end
img=(F-Fbl)./Fbl;
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix=['F',num2str(freq(1)),'_',num2str(freq(end))];
VS2Brik(cfg,img);

%% low freq included
cd /home/yuval/Desktop/EEG
!SAMcov64 -r 1 -d c,rfhp1.0Hz -m run1low -v
!SAMwts64 -r 1 -d c,rfhp1.0Hz -m run1low -c Global -v
cd /home/yuval/Desktop/EEG/1/SAM
[~,~,wts]=readWeights('run1low,5-70Hz,Global.wts');
ns=mean(abs(wts),2);
cd /home/yuval/Desktop/EEG/1
cfg=[];
cfg.dataset=source;
cfg.trl=round(678.17*[20 200 0]);
cfg.channel='MEG';
cfg.bpfilt='yes';
cfg.bpfreq=[15 35];
meg=ft_preprocessing(cfg);
plot(meg.time{1,1},meg.trial{1,1}(100,:))
img=zeros(size(ns));
nonZero=find(wts(:,1));
count=0;
for voxi=nonZero'
    img(voxi)=mean(abs(wts(voxi,:)*meg.trial{1,1}))./ns(voxi);
    if voxi>count+1000;
        count=count+1000;
        disp(num2str(count))
    end
end
cd /home/yuval/Desktop/EEG
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='run1low';
VS2Brik(cfg,img);


%% dipole fit
cd /home/yuval/Desktop/EEG/1
cfg.dataset='hb_c,rfhp1.0Hz';
cfg.trl=round([1 meg.fsample*100 0]);
cfg.channel='MEG';
meg=ft_preprocessing(cfg);

samp=nearest(meg.time{1},93.8176);
cfg=[];
cfg.interpolate='linear';
cfg.interactive='yes';
topoplot248(meg.trial{1}(:,samp),cfg)
channels = {'A114', 'A175', 'A228', 'A115', 'A247', 'A174', 'A194', 'A176', 'A245', 'A116', 'A210', 'A113', 'A146', 'A145', 'A193', 'A227', 'A195', 'A172', 'A173', 'A147', 'A148', 'A211', 'A248', 'A149', 'A246'};
%channels = {'A56', 'A57', 'A58', 'A81', 'A82', 'A83', 'A84', 'A85', 'A86', 'A112', 'A113', 'A114', 'A115', 'A116', 'A117', 'A118', 'A143', 'A144', 'A145', 'A146', 'A147', 'A148', 'A149', 'A150', 'A170', 'A171', 'A172', 'A173', 'A174', 'A175', 'A176', 'A192', 'A193', 'A194', 'A195', 'A209', 'A210', 'A211', 'A226', 'A227', 'A228', 'A244', 'A245', 'A246', 'A247', 'A248'};
cfg = [];
cfg.feedback               = 'no';
cfg.grad = meg.grad;
cfg.headshape='hs_file';
cfg.singlesphere='yes';
vol  = ft_prepare_localspheres_BIU(cfg);
vol=[];
vol.o=[0.0116,0.0018,0.0397];
vol.r=0.11;
figure;
showHeadInGrad([],'m');
hold on;
ft_plot_vol(vol);

cfg5 = [];
cfg5.latency = [93.8176 93.8176]; 
cfg5.numdipoles = 1;
cfg5.vol=vol;
cfg5.feedback = 'textbar';
cfg5.gridsearch='yes';
cfg5.channel=channels;
dip = ft_dipolefitting(cfg5, meg);
dip.dip.pos*1000

%% freq dipole
cfg=[];
%cfg.trials=find(datacln.trialinfo==222);
cfg.output       = 'fourier';
cfg.channel      = 'MEG';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = 1:100;
cfg.feedback='no';
FrAll = ft_freqanalysis(cfg, meg);

cfg = [];
%cfg.latency = [93.8176 93.8176]; 
cfg.frequency=29;
cfg.numdipoles = 1;
cfg.vol=vol;
cfg.feedback = 'textbar';
cfg.gridsearch='yes';
cfg.channel=channels;
dip = ft_dipolefitting(cfg, FrAll);
dip.dip.pos*1000