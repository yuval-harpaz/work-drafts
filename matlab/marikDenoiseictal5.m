function marikDenoiseictal5(time,freq)
% marikDenoiseictal5([121 122],[70 70]) % first detection of 70Hz
% marikDenoiseictal5([122 123],[119 119])

% time=[120 125];

fn='lf,hb_c,rfhp1.0Hz';
hdr=ft_read_header(fn);

cfg=[];
cfg.trl=[round(hdr.Fs*115),round(hdr.Fs*135),round(hdr.Fs*115)];
cfg.dataset=fn;
cfg.channel='MEG';
cfg.hpfilter='yes';
cfg.hpfreq=20;
raw=ft_preprocessing(cfg);
cfg.trl=[round(hdr.Fs*time(1)),round(hdr.Fs*time(2)),round(hdr.Fs*time(1))];
rawT=ft_preprocessing(cfg);


cfg=[];
cfg.output       = 'pow';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = [5:125];
cfg.feedback='no';
cfg.keeptrials='yes';
megFr = ft_freqanalysis(cfg, rawT);


load hp20_new_data_100_epoch500_r3
t1=nearest(raw.time{1,1},time(1));
t2=nearest(raw.time{1,1},time(2));
dnT=rawT;
dnT.trial{1,1}=new_data(:,t1:t2);

cfg=[];
cfg.output       = 'pow';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = [5:125];
cfg.feedback='no';
cfg.keeptrials='yes';
megFrDN = ft_freqanalysis(cfg, dnT);

cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
cfg.xlim=[freq(1) freq(2)];
cfg.interpolation      = 'linear';
figure;
ft_topoplotER(cfg,megFr,megFrDN);


