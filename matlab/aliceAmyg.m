function aliceAmyg(Afreq)
for subi=1:12
    subFold=num2str(subi)
    cd /home/yuval/Data/Amyg
    cd(subFold)
    %% clean HB
    try
        LSclean=ls('*hb*');
        megFN=LSclean(1:end-1);
    catch
        megFN=ls('c,rf*');
        megFN=megFN(1:end-1);
    end
    trig=readTrig_BIU(megFN);
    trig=clearTrig(trig);
    close
    s1=find(trig,1);
    s2=s1:1017:s1+1017*60;
    s2=s2(1:60);
    s2=s2';
    cfg=[];
    cfg.demean='yes';
    cfg.channel='MEG';
    cfg.trl=s2;
    cfg.trl(:,2)=s2+1017;
    cfg.trl(:,3)=0;
    cfg.dataset=megFN;
    meg=ft_preprocessing(cfg);
    VAR=[];
    for triali=1:length(meg.trial)
        VAR(triali,1:248)=var(meg.trial{1,1}');
    end
    VARm=min(VAR,[],1);
    badi=find(VARm>5*median(VARm));
    cfg=[];
    cfg.channel{1,1}='MEG';
    if isempty(badi)
        badn=[];
    else
        badn=meg.label(badi);
        for chani=1:length(badn)
            cfg.channel{chani+1,1}=['-',badn{chani}];
        end
    end
    save bad badi badn
    cfg.output       = 'pow';
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = Afreq;
    cfg.feedback='no';
    cfg.keeptrials='yes';
    megFr = ft_freqanalysis(cfg, meg);
    [~,maxch]=max(mean(megFr.powspctrm(:,:),1));
    cfg=[];
    cfg.layout='4D248.lay';
    cfg.highlight='labels';
    cfg.xlim=[Afreq Afreq];
    cfg.highlightchannel=megFr.label(maxch);
    figure;
    ft_topoplotER(cfg,megFr);
end
end


