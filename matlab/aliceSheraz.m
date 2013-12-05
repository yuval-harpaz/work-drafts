
Afreq=[3 6 9 10 11 12 15 20 25 30 40 50 60 70 80 90 100];
cd /home/yuval/Copy/MEGdata/alpha/sheraz
hdr=ft_read_header('Sheraz01_raw.fif')
for mini=1:7 % minutes
    timeBL=60000*(mini-1);
    trl=[timeBL+10000:1000:timeBL+69000]';
    trl(:,2)=trl+1000;
    trl(:,3)=0;
    cfg=[];
    cfg.trl=trl;
    cfg.demean='yes';
    cfg.dataset='Sheraz01_raw.fif';
    cfg.channel='MEGMAG';
    meg=ft_preprocessing(cfg);
    
    cfg=[];
    cfg.method='abs';
    cfg.criterion='sd';
    cfg.critval=3;
    good=badTrials(cfg,meg,0);
    
    cfg=[];
    cfg.output       = 'pow';
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.trials=good;
    cfg.foi          = Afreq;
    cfg.feedback='no';
    cfg.keeptrials='yes';
    megFr = ft_freqanalysis(cfg, meg);
    cfg=[];
    %cfg.layout='neuromag306all.lay';
    cfg.layout='neuromag306mag.lay';
    cfg.interactive='yes';
    cfg.xlim=[10 10];
    figure;
    ft_topoplotER(cfg,megFr);
    title(['min ',num2str(mini)])
    eval(['megFr',num2str(mini),'=megFr']);
end



