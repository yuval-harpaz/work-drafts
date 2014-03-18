function aquaPower
cd ('/media/Elements/quadaqua');
load subs subs
sess={'a','b'};
for subi=1:length(subs)
    cd ('/media/Elements/quadaqua');
    sub=subs{subi};
    display(['BEGGINING WITH ',sub]);
    cd (sub)
    for resti=1:2;
        cd(sess{resti})
        clnsource=['xc,lf,hb_c,rfhp0.1Hz'];
        trig=clearTrig(readTrig_BIU(clnsource));
        close all
        if ~max(find(unique(trig)))>0
            error('no rest trig')
        end
        for trval=[92 94];
            time0=find(trig==trval);
            epoched=time0+1017:1017:time0+145*1017.25;
            cfg.dataset=clnsource;
            cfg.trialdef.poststim=2;
            cfg.trialfun='trialfun_beg';
            cfg1=[];
            cfg1=ft_definetrial(cfg);
            cfg1.trl(1:size(epoched,2),1)=epoched';
            cfg1.trl(1:size(epoched,2),2)=epoched'+1017;
            cfg1.trl(1:size(epoched,2),3)=0;
            cfg1.channel={'MEG'};
            %% reading high frequencies to find muscle artifact
            cfg1.hpfilter='yes';cfg1.hpfreq=20;
            cfg1.blc='yes';
            data=ft_preprocessing(cfg1);
            trialAbs=[];
            for triali=1:length(data.trial)
                trialAbs(triali)=mean(mean(abs(data.trial{1,triali})));
            end
            %finding trials with sd > 2
            sd=std(trialAbs);
            good=find(trialAbs<median(trialAbs)+sd*3);
            badn=num2str(length(trialAbs)-length(good));
            display(['rejected ',badn,' trials']);
            find(trialAbs>median(trialAbs)+sd*3)
            trl=data.cfg.trl(good,:);
            %save trl92 trl
            cfg1.trl=trl;
            cfg1=rmfield(cfg1,'hpfilter');
            cfg1=rmfield(cfg1,'hpfreq');
            %%  reading data after artifact rejection and compute power spectrum
            data=ft_preprocessing(cfg1);
            %             if strcmp(clnsource,['xc,lf_',source]); % if heartbit wasnot cleaned yet
            %                 data=pcaOutHB(data);
            %             end
            cfg2            = [];
            cfg2.output     = 'pow';
            cfg2.method     = 'mtmfft';
            cfg2.foilim     = [1 100];
            cfg2.tapsmofrq  = 1;
            cfg2.keeptrials = 'no';
            %cfg.channel    = {'MEG' '-A204' '-A74'};
            pow=ft_freqanalysis(cfg2,data);
            save trl trl
            %         cfg3.interactive='yes';
            %         ft_topoplotER(cfg3,alpha);
            save(['/media/Elements/quadaqua/pow/s',sub,'_pow',num2str(trval),'_',num2str(resti)],'pow');
        end
        cd ..
        %
    end
    cd ..
end
end