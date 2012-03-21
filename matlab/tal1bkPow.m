function tal1bkPow(subs)
cd ('/home/yuval/Desktop/talResults')
for subi=1:length(subs)
    cd ('/home/yuval/Desktop/talResults')
    sub=subs{subi};
    display(['BEGGINING WITH ',sub]);
    load (['s',sub,'_1bk']);
    cfg            = [];
    cfg.output     = 'pow';
    cfg.method     = 'mtmfft';
    cfg.foilim     = [1 100];
    cfg.tapsmofrq  = 1;
    cfg.keeptrials = 'no';
    %cfg.channel    = {'MEG' '-A204' '-A74'};
    wPow=ft_freqanalysis(cfg,word);
    nwPow=ft_freqanalysis(cfg,nonword);
    %         cfg3.interactive='yes';
    %         ft_topoplotER(cfg3,alpha);
    save(['~/Desktop/talResults/s',sub,'_pow1bk'],'wPow','nwPow');
end
end