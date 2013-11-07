function aliceTal(Afreq)

cd ('/media/Elements/MEG/tal')
load subs46no36
grp=groups(groups>0);
subs=subsV1(grp>1);
for subi=1:length(subs)
    cd ('/media/Elements/MEG/tal')
    sub=subs{subi};
    display(['BEGGINING WITH ',sub]);
    cd ([sub,'/',sub,'/0.14d1']);
    conditions=textread('conditions','%s');
    restcell=find(strcmp('rest',conditions),1);
    resti=1;
    path2file=conditions{restcell(resti)+1};
    source= conditions{restcell(resti)+2};
    cd(path2file(end-16:end))
    if exist(['xc,hb,lf_',source],'file')
        clnsource=['xc,hb,lf_',source];
    elseif exist(['hb,xc,lf_',source],'file')
        clnsource=['hb,xc,lf_',source];
    elseif exist(['xc,lf_',source],'file')
        clnsource=['xc,lf_',source];
    else
        error('no cleaned source file found')
    end
    trig=readTrig_BIU(clnsource);
    trig=clearTrig(trig);
    close
    if ~max(find(unique(trig)))>0
        error('no rest trig')
    end
    for trval=[92 94];
        time0=find(trig==trval);
        epoched=time0+1017:1017:time0+60*1017.25;
        cfg=[];
        cfg.dataset=clnsource;
        cfg.trl=epoched';
        cfg.trl(:,2)=cfg.trl+1017;
        cfg.trl(:,3)=0;
        cfg.trialfun='trialfun_beg';
        cfg.channel={'MEG','-A74','-A204'}
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
        cnd='eyes closed';
        if trval==94
           cnd='eyes open';
        end
        title([sub,' ',cnd])
    end
end
end