function talPower1bk(subs)
cd ('/media/Elements/MEG/talResults')
for subi=1:length(subs)
    sub=subs{subi};
    load(['s',sub,'_1bk.mat'])
    WNW={'W','NW';'word','nonword'};
    for Wi=1:2
        eval(['data=',WNW{2,Wi},';']);
        cfg2            = [];
        cfg2.output     = 'pow';
        cfg2.method     = 'mtmfft';
        cfg2.foilim     = [1 100];
        cfg2.tapsmofrq  = 1;
        cfg2.keeptrials = 'no';
        %cfg.channel    = {'MEG' '-A204' '-A74'};
        pow=ft_freqanalysis(cfg2,data);
        %         cfg3.interactive='yes';
        %         ft_topoplotER(cfg3,alpha);
        save(['/media/Elements/MEG/talResults/s',sub,'_pow_',WNW{1,Wi}],'pow');
        
    end
    clear *word*
    
    %
end
end
