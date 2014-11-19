function Schiz3

cd /media/yuval/Elements/SchizoRestMaor
load group
load Subs
load LRpairs;
scCount=0;sc=false;
coCount=0;
scLabel={};
coLabel={};
for subi=1:length(Subs)
    if strcmp(Subs{subi,3},'v')
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
            cfg.foi=1:70;
            freq          = ft_freqanalysis(cfg, cond204);
            cfg=[];
            cfg.channelcmb=LRpairs;
            cfg.method    = 'coh';
            cohLR          = ft_connectivityanalysis(cfg, freq);
%             coh1to4=cohBand(cohLR,1:4,Li,Ri);
%             coh5to8=cohBand(cohLR,5:8,Li,Ri);
%             coh9to12=cohBand(cohLR,9:12,Li,Ri);
%             coh13to19=cohBand(cohLR,13:19,Li,Ri);
%             coh20to25=cohBand(cohLR,20:25,Li,Ri);
%             coh26to70=cohBand(cohLR,26:70,Li,Ri);
            cohLR=cohBand(cohLR,Li,Ri);
            cfg=[];
            %cfg.channelcmb=LRpairs;
            cfg.method    = 'coh';
            coh           = ft_connectivityanalysis(cfg, freq);
            disp(['saving ',sub]);
            save freq freq
            save cohLR cohLR
            save coh coh
            clear coh freq cohLR
% %             coh1to4=cohBand(cohLR,1:4,Li,Ri);
% %             coh5to8=cohBand(cohLR,5:8,Li,Ri);
% %             coh9to12=cohBand(cohLR,9:12,Li,Ri);
% %             coh13to19=cohBand(cohLR,13:19,Li,Ri);
% %             coh20to25=cohBand(cohLR,20:25,Li,Ri);
% %             coh26to70=cohBand(cohLR,26:70,Li,Ri);
%             coh=cohBand(cohLR,Li,Ri);
%             if strcmp(Subs{subi,2}(1),'S')
%                 sc=true;
%                 scCount=scCount+1;
%             else
%                 sc=false;
%                 coCount=coCount+1;
%             end
%             if sc
%                 cohSc(1:248,1:70,scCount)=Coh;
%                 fSc(1:248,1:70,scCount)=squeeze(mean(freq.fourierspctrm));
%                 scLabel{scCount}=sub;
%             else
%                 cohCo(1:248,1:70,coCount)=Coh;
%                 fCo(1:248,1:70,coCount)=squeeze(mean(freq.fourierspctrm));
%                 coLabel{coCount}=sub;
%             end
            disp(['done ',sub]);
        catch
            disp([sub,' had no split cond'])
        end
        cd ../
    end
end
function cohFreq=cohBand(cohLR,Li,Ri)
%coh=mean(cohLR.cohspctrm(:,9:12),2);
cohFreq=ones(248,70);
cohFreq(Ri,:)=cohLR.cohspctrm;
cohFreq(Li,:)=cohLR.cohspctrm;
% save cohPSD fCo fSc cohCo cohSc scLabel coLabel
%
% [~,chani]=ismember('A158',cond204.label);
% [~,p]=ttest2(fSc(chani,:),fCo(chani,:))
%
% [~,p]=ttest2(fSc',fCo');
% cfg=[];
% cfg.highlight='labels';
% cfg.highlightchannel=find(p<0.05);
% cfg.zlim=[0 5e-14];
% figure;topoplot248(mean(fSc,2),cfg);title('Sciz')
% figure;topoplot248(mean(fCo,2),cfg);title('Cont')
% [~,p]=ttest2(cohSc',cohCo');
% cfg=[];
% cfg.highlight='labels';
% cfg.highlightchannel=find(p<0.05);
% cfg.zlim=[0 0.75];
% figure;topoplot248(mean(cohSc,2),cfg);title('Sciz')
% figure;topoplot248(mean(cohCo,2),cfg);title('Cont')
