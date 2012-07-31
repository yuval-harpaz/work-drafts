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
for groupi=1:2
    subsGv1=subsV1(find(gr==groupi)) % CM, control, motor learning
    subsGv2=subsV2(find(gr==groupi))
    for listi=1:5
        V1pre=[];
        V1post=[];
        V2pre=[];
        V2post=[];
        for subi=1:length(subsGv1)
            subv1=subsGv1{subi};
            load ([subv1,'AP'])
            if subi==1
                eval(['V1pre=coh1.coh',chanLists{listi},';'])
                V1pre.cohspctrm=zeros([size(V1pre.cohspctrm),length(subsGv1)]);
                V1post=V1pre;V2pre=V1pre;V2post=V1post;
            end
            eval(['V1pre.cohspctrm(:,:,:,subi)=coh1.coh',chanLists{listi},'.cohspctrm;'])
            eval(['V1post.cohspctrm(:,:,:,subi)=coh2.coh',chanLists{listi},'.cohspctrm;'])
            subv2=subsGv2{subi};
            load ([subv2,'AP'])
            eval(['V2pre.cohspctrm(:,:,:,subi)=coh1.coh',chanLists{listi},'.cohspctrm;'])
            eval(['V2post.cohspctrm(:,:,:,subi)=coh2.coh',chanLists{listi},'.cohspctrm;'])
        end
        label=coh1.cohL.label;
        freq=coh1.cohL.freq;
        subjects=subsGv1;
        save(['cohAPv1pre_',grname{groupi}],'label','freq','subjects','V1pre')
        save(['cohAPv1post_',grname{groupi}],'label','freq','subjects','V1post')
        save(['cohAPv2pre_',grname{groupi}],'label','freq','subjects','V2pre')
        save(['cohAPv2post_',grname{groupi}],'label','freq','subjects','V2post')
    end
end
% % stat=statPlot(cohLRv1post,cohLRv2post,[10 10],[],'paired-ttest')
end