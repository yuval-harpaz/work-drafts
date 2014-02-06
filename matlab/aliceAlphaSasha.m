cd /home/yuval/Data/Sasha
load subs
for subi=1:length(subs)
hdr=ft_read_header(subs{subi});
sRate=hdr.Fs;

samp1=31000;%round(sRate*3);
samp1Last=samp1+60*sRate;
epoched=samp1+round(sRate):round(sRate):samp1Last;


cfn=subs{subi};

cfg=[];
cfg.dataset=cfn;
cfg.trl=epoched';
cfg.trl(:,2)=cfg.trl+round(sRate);
cfg.trl(:,3)=0;
cfg.channel='MEGMAG';
cfg.blc='yes';
cfg.feedback='no';
meg=ft_preprocessing(cfg);
cfg=[];
cfg.method='var';
cfg.criterion='sd';
cfg.critval=3;
good=badTrials(cfg,meg,0);
cfg=[];
cfg.trials=good;
cfg.output       = 'pow';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = [3 6 9 10 11 12 15 20 25 30 40 50 60 70 80 90 100];
cfg.feedback='no';
%cfg.keeptrials='yes';
megFr = ft_freqanalysis(cfg, meg);
cfg=[];
cfg.xlim=[9 9];
cfg.layout = 'neuromag306mag.lay';
cfg.interactive='yes';
figure;
ft_topoplotER(cfg,megFr)
title(num2str(subi))
save (['meg',num2str(subi)],'meg')
save (['megFr',num2str(subi)],'megFr')
end
