cd /media/yuval/Elements/SchizoRestMaor
load group
load Subs
load LRpairs;
scCount=0;sc=false;
coCount=0;
scLabel={};
coLabel={};
for subi=1:length(Subs)
    sub=Subs{subi,1};
    cd(sub)
    clear cond*
    try
        load splitconds
        if subi==1;
            [~,Li]=ismember(LRpairs(:,1),cond204.label);
            [~,Ri]=ismember(LRpairs(:,2),cond204.label);
        end
        cfg           = [];
        cfg.method    = 'mtmfft';
        cfg.output    = 'fourier';
        cfg.tapsmofrq = 1;
        cfg.foi=9:11;
        freq          = ft_freqanalysis(cfg, cond204);
        cfg=[];
        cfg.channelcmb=LRpairs;
        cfg.method    = 'coh';
        cohLR          = ft_connectivityanalysis(cfg, freq);
        coh=mean(cohLR.cohspctrm,2);
        Coh=ones(248,1);
        Coh(Ri)=coh;
        Coh(Li)=coh;
        
        if strcmp(Subs{subi,2}(1),'S')
            sc=true;
            scCount=scCount+1;
        else
            sc=false;
            coCount=coCount+1;
        end
        if sc
            cohSc(1:248,scCount)=Coh;
            fSc(1:248,scCount)=mean(squeeze(mean(abs(freq.fourierspctrm))),2);
            scLabel{scCount}=sub;
        else
            cohCo(1:248,coCount)=Coh;
            fCo(1:248,coCount)=mean(squeeze(mean(abs(freq.fourierspctrm))),2);
            coLabel{coCount}=sub;
        end
        disp(['done ',sub]);
    catch
        disp([sub,' had no split cond'])
    end
    cd ../
end

save cohPSD fCo fSc cohCo cohSc scLabel coLabel

[~,chani]=ismember('A158',cond204.label);
[~,p]=ttest2(fSc(chani,:),fCo(chani,:))

[~,p]=ttest2(fSc',fCo');
cfg=[];
cfg.highlight='labels';
cfg.highlightchannel=find(p<0.05);
cfg.zlim=[0 5e-14];
figure;topoplot248(mean(fSc,2),cfg);title('Sciz')
figure;topoplot248(mean(fCo,2),cfg);title('Cont')
[~,p]=ttest2(cohSc',cohCo');
cfg=[];
cfg.highlight='labels';
cfg.highlightchannel=find(p<0.05);
cfg.zlim=[0 0.75];
figure;topoplot248(mean(cohSc,2),cfg);title('Sciz')
figure;topoplot248(mean(cohCo,2),cfg);title('Cont')
