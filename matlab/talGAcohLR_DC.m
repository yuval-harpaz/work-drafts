function talGAcohLR_DC(pat,subList)
% subList is like 'subs36.mat'
if ~exist('pat','var')
    pat=[];
end
if isempty(pat)
    pat='/media/Elements/MEG/tal';
end
patR=[pat(1:(end-3)),'talResults'];

load ([pat,'/',subList])
cd ([patR,'/Coh'])
% V1pre='';
% V1post='';
% V2pre='';
% V2post='';
% for subi=1:length(subsV1)
%     subv1=subsV1{subi};
%     load (subv1)
%     eval(['V1pre',subv1,'=coh1;']);
%     V1pre=[V1pre,',V1pre',subv1];
%     eval(['V1post',subv1,'=coh2;']);
%     V1post=[V1post,',V1post',subv1];
%     %
%     subv2=subsV2{subi};
%     load (subv2)
%     eval(['V2pre',subv2,'=coh1;']);
%     V2pre=[V2pre,',V2pre',subv2];
%     eval(['V2post',subv2,'=coh2;']);
%     V2post=[V2post,',V2post',subv2];
% end
%
cfg=[];
cfg.channel='MEG';
cfg.keepindividual = 'yes';
%
% eval(['cohLRv1pre=ft_freqgrandaverage(cfg',V1pre,');']);
% eval(['cohLRv1post=ft_freqgrandaverage(cfg',V1post,');']);
% eval(['cohLRv2pre=ft_freqgrandaverage(cfg',V2pre,');']);
% eval(['cohLRv2post=ft_freqgrandaverage(cfg',V2post,');']);
% save cohLRv1pre cohLRv1pre
% save cohLRv1post cohLRv1post
% save cohLRv2pre cohLRv2pre
% save cohLRv2post cohLRv2post

% by group
gr=groups(groups>0);
% D=Dyslexia C=Control
% M=Motor, Q=Quadrato, V=Verbal, M=Motor
% group index: 1=DQ, 2=CQ, 3=CV, 4=CM
%
for grcase=1:2
    if grcase==1 %1=D 2=C
        subsGv1=subsV1(find(gr==1));
        subsGv2=subsV2(find(gr==1));
        grstr='D';
    else
        subsGv1=subsV1(find(gr>1));
        subsGv2=subsV2(find(gr>1));
        grstr='C';
    end
    V1pre='';
    V1post='';
    V2pre='';
    V2post='';
    if ~exist(['cohLRv2post_',grstr,'.mat'],'file')
        for subi=1:length(subsGv1)
            subv1=subsGv1{subi};
            load (subv1)
            eval(['V1pre',subv1,'=coh1;']);
            V1pre=[V1pre,',V1pre',subv1];
            eval(['V1post',subv1,'=coh2;']);
            V1post=[V1post,',V1post',subv1];
            %
            subv2=subsGv2{subi};
            load (subv2)
            eval(['V2pre',subv2,'=coh1;']);
            V2pre=[V2pre,',V2pre',subv2];
            eval(['V2post',subv2,'=coh2;']);
            V2post=[V2post,',V2post',subv2];
        end
        eval(['cohLRv1pre_',grstr,'=ft_freqgrandaverage(cfg',V1pre,');']);
        eval(['cohLRv1post_',grstr,'=ft_freqgrandaverage(cfg',V1post,');']);
        eval(['cohLRv2pre_',grstr,'=ft_freqgrandaverage(cfg',V2pre,');']);
        eval(['cohLRv2post_',grstr,'=ft_freqgrandaverage(cfg',V2post,');']);
        
        save (['cohLRv1pre_',grstr],['cohLRv1pre_',grstr])
        save (['cohLRv1post_',grstr],['cohLRv1post_',grstr])
        save (['cohLRv2pre_',grstr],['cohLRv2pre_',grstr])
        save (['cohLRv2post_',grstr],['cohLRv2post_',grstr])
    end
end
% gr=groups(groups>0);
% subsGv1=subsV1(find(gr==1)) % CM, control, motor learning
% subsGv2=subsV2(find(gr==1))
% V1pre='';
% V1post='';
% V2pre='';
% V2post='';
% for subi=1:length(subsGv1)
%     subv1=subsGv1{subi};
%     load (subv1)
%     eval(['V1pre',subv1,'=coh1;']);
%     V1pre=[V1pre,',V1pre',subv1];
%     eval(['V1post',subv1,'=coh2;']);
%     V1post=[V1post,',V1post',subv1];
%     %
%     subv2=subsGv2{subi};
%     load (subv2)
%     eval(['V2pre',subv2,'=coh1;']);
%     V2pre=[V2pre,',V2pre',subv2];
%     eval(['V2post',subv2,'=coh2;']);
%     V2post=[V2post,',V2post',subv2];
% end
% eval(['cohLRv1pre_DM=ft_freqgrandaverage(cfg',V1pre,');']);
% eval(['cohLRv1post_DM=ft_freqgrandaverage(cfg',V1post,');']);
% eval(['cohLRv2pre_DM=ft_freqgrandaverage(cfg',V2pre,');']);
% eval(['cohLRv2post_DM=ft_freqgrandaverage(cfg',V2post,');']);
% save cohLRv1pre_DM cohLRv1pre_DM
% save cohLRv1post_DM cohLRv1post_DM
% save cohLRv2pre_DM cohLRv2pre_DM
% save cohLRv2post_DM cohLRv2post_DM

% stat=statPlot(cohLRv1post,cohLRv2post,[10 10],[],'paired-ttest')
end