function marikDenoiseictal6(time,freq)
% marikDenoiseictal5([121 122],[70 70]) % first detection of 70Hz
% marikDenoiseictal5([122 123],[119 119])

% time=[120 125];

fn='lf,hb_c,rfhp1.0Hz';
hdr=ft_read_header(fn);

cfg=[];
cfg.trl=[round(hdr.Fs*time(1)),round(hdr.Fs*time(2)),round(hdr.Fs*time(1))];
cfg.dataset=fn;
cfg.channel='MEG';
cfg.hpfilter='yes';
cfg.hpfreq=20;
raw=ft_preprocessing(cfg);

new_data=DATA_adaptive_pca_denoiser5(raw.trial{1,1},100,500,3);

raw.trial{1,1}=raw.trial{1,1}(:,1:size(new_data,2));
raw.time{1,1}=raw.time{1,1}(1,1:size(new_data,2));
dn=raw;
dn.trial{1,1}=new_data;
cfg=[];
cfg.output       = 'pow';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = [5:125];
cfg.feedback='no';
cfg.keeptrials='yes';
megFr = ft_freqanalysis(cfg, raw);

cfg=[];
cfg.output       = 'pow';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = [5:125];
cfg.feedback='no';
cfg.keeptrials='yes';
megFrDN = ft_freqanalysis(cfg, dn);

cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
cfg.xlim=[freq(1) freq(2)];
cfg.interpolation      = 'linear';
figure;
ft_topoplotER(cfg,megFr);
title('RAW')
figure;
ft_topoplotER(cfg,megFrDN);
title('DENOISED')


