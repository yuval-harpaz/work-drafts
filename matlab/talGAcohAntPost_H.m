function talGAcohLR_H(pat)
if ~exist('pat','var')
    pat=[];
end
if isempty(pat)
    pat='/media/Elements/MEG/tal';
end
patR=[pat(1:(end-3)),'talResults'];

load ([pat,'/subs42'])
cd ([patR,'/Coh'])

cfg=[];
cfg.channel='MEG';
cfg.keepindividual = 'yes';
cfg.parameter='cohspctrm';

% by group
gr=groups(groups>0);

chanLists={'LL','L','C','R','RR'};
grname={'DM' 'CM'}
listSize=[7 8 11 8 7];
for groupi=1:2
    subsGv1=subsV1(find(gr==groupi)) % CM, control, motor learning
    subsGv2=subsV2(find(gr==groupi))
    for listi=1:5
        V1pre=[];
        V1post=[];
        V2pre=[];
        V2post=[];
        ch_ch_fr1=[];
        ch_ch_fr2=[];
        for subi=1:length(subsGv1)
            
            for visiti=1:2
                vstr=num2str(visiti);
                eval(['subvi=subsGv',vstr,'{subi};'])
                load ([subvi,'AP'])
                if subi==1
                    if visiti==1
                        eval(['V1pre=coh1.coh',chanLists{listi},';'])
                        V1pre.cohspctrm=ones([listSize(listi),listSize(listi),length(coh1.cohLL.freq),length(subsGv1)]);
                        V1pre.dimord='chan_chan_freq_rpt';
                        V1post=V1pre;V2pre=V1pre;V2post=V1post;
                    end
                end
                chcount=0;
                for chani=1:listSize(listi)
                    for chanj=1:listSize(listi)
                        if ~(chani==chanj)
                            chcount=chcount+1;
                            eval(['ch_ch_fr1(chani,chanj,1:length(coh1.coh',chanLists{listi},'.freq))=coh1.coh',chanLists{listi},'.cohspctrm(chcount,:);'])
                            eval(['ch_ch_fr2(chani,chanj,1:length(coh1.coh',chanLists{listi},'.freq))=coh1.coh',chanLists{listi},'.cohspctrm(chcount,:);'])
                        else
                            eval(['ch_ch_fr1(chani,chanj,1:length(coh1.coh',chanLists{listi},'.freq))=ones(1,length(coh1.cohLL.freq));'])
                            eval(['ch_ch_fr2(chani,chanj,1:length(coh1.coh',chanLists{listi},'.freq))=ones(1,length(coh1.cohLL.freq));'])
                           
                        end
                    end
                end
                eval(['V',vstr,'pre.cohspctrm(:,:,:,subi)=ch_ch_fr1'])
                eval(['V',vstr,'post.cohspctrm(:,:,:,subi)=ch_ch_fr2'])
            end
%             subv2=subsGv2{subi};
%             load ([subv2,'',chanLists{listi},''])
%             eval(['V2pre.cohspctrm(:,:,:,subi)=coh1.coh',chanLists{listi},'.cohspctrm;'])
%             eval(['V2post.cohspctrm(:,:,:,subi)=coh2.coh',chanLists{listi},'.cohspctrm;'])
        end
%         label=coh1.cohL.label;
%         freq=coh1.cohL.freq;
        subjects=subsGv1;
        save(['coh',chanLists{listi},'v1pre_',grname{groupi}],'subjects','V1pre')
        save(['coh',chanLists{listi},'v1post_',grname{groupi}],'subjects','V1post')
        save(['coh',chanLists{listi},'v2pre_',grname{groupi}],'subjects','V2pre')
        save(['coh',chanLists{listi},'v2post_',grname{groupi}],'subjects','V2post')
    end
end
% % stat=statPlot(cohLRv1post,cohLRv2post,[10 10],[],'paired-ttest')
end