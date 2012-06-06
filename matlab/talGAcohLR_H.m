function talGAcohLR_H(pat)
if ~exist('pat','var')
    pat=[];
end
if isempty(pat)
    pat='/media/Elements/MEG/tal';
end
patR=[pat(1:(end-3)),'talResults'];

load ([pat,'/subs36'])
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
subsGv1=subsV1(find(gr==2)) % CM, control, motor learning
subsGv2=subsV2(find(gr==2))
V1pre='';
V1post='';
V2pre='';
V2post='';
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
eval(['cohLRv1pre_CM=ft_freqgrandaverage(cfg',V1pre,');']);
eval(['cohLRv1post_CM=ft_freqgrandaverage(cfg',V1post,');']);
eval(['cohLRv2pre_CM=ft_freqgrandaverage(cfg',V2pre,');']);
eval(['cohLRv2post_CM=ft_freqgrandaverage(cfg',V2post,');']);

save cohLRv1pre_CM cohLRv1pre_CM
save cohLRv1post_CM cohLRv1post_CM
save cohLRv2pre_CM cohLRv2pre_CM
save cohLRv2post_CM cohLRv2post_CM

gr=groups(groups>0);
subsGv1=subsV1(find(gr==1)) % CM, control, motor learning
subsGv2=subsV2(find(gr==1))
V1pre='';
V1post='';
V2pre='';
V2post='';
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
eval(['cohLRv1pre_DM=ft_freqgrandaverage(cfg',V1pre,');']);
eval(['cohLRv1post_DM=ft_freqgrandaverage(cfg',V1post,');']);
eval(['cohLRv2pre_DM=ft_freqgrandaverage(cfg',V2pre,');']);
eval(['cohLRv2post_DM=ft_freqgrandaverage(cfg',V2post,');']);
save cohLRv1pre_DM cohLRv1pre_DM
save cohLRv1post_DM cohLRv1post_DM
save cohLRv2pre_DM cohLRv2pre_DM
save cohLRv2post_DM cohLRv2post_DM

% stat=statPlot(cohLRv1post,cohLRv2post,[10 10],[],'paired-ttest')
end