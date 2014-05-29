function aquaGAcohLR
sufix=''; % W for words NW for non words (1bk)
cond=''; % for rest condition
rest=true;
pat='/media/Elements/MEG/tal';
patR=[pat(1:(end-3)),'talResults'];
%subList='subs46';
%load ([pat,'/',subList])
cd ([patR,'/',cond,'Coh'])

cfg=[];
cfg.channel='MEG';
cfg.keepindividual = 'yes';

quad={'quad06';'quad11';'quad14';'quad15';'quad16';'quad18';'quad37';'quad42'};
verb={'quad24';'quad25';'quad26';'quad27';'quad30';'quad32';'quad35';'quad36'};
V1pre='';
V2pre='';
for subi=1:8
    sub=num2str(subi)
    subv1=quad{subi};
    load ([subv1,sufix])
    eval(['V1pre',sub,'=coh1;']);
    V1pre=[V1pre,',V1pre',sub];
    %
    subv2=[subv1,'02'];
    load ([subv2,sufix])
    eval(['V2pre',sub,'=coh1;']);
    V2pre=[V2pre,',V2pre',sub];
end
eval(['cohLRv1_quad=ft_freqgrandaverage(cfg',V1pre,');']);
eval(['cohLRv2_quad=ft_freqgrandaverage(cfg',V2pre,');']);
V1pre='';
V2pre='';
for subi=1:8
    sub=num2str(subi)
    subv1=verb{subi};
    load ([subv1,sufix])
    eval(['V1pre',sub,'=coh1;']);
    V1pre=[V1pre,',V1pre',sub];
    %
    subv2=[subv1,'02'];
    load ([subv2,sufix])
    eval(['V2pre',sub,'=coh1;']);
    V2pre=[V2pre,',V2pre',sub];
end
eval(['cohLRv1_verb=ft_freqgrandaverage(cfg',V1pre,');']);
eval(['cohLRv2_verb=ft_freqgrandaverage(cfg',V2pre,');']);

cd /media/Elements/quadaqua/Coh
V1pre='';
V2pre='';
for subi=1:8
    sub=num2str(subi)
    load (sub)
    eval(['V1pre',sub,'=cohV1;']);
    V1pre=[V1pre,',V1pre',sub];
    eval(['V2pre',sub,'=cohV2;']);
    V2pre=[V2pre,',V2pre',sub];
end
eval(['cohLRv1_aqua=ft_freqgrandaverage(cfg',V1pre,');']);
eval(['cohLRv2_aqua=ft_freqgrandaverage(cfg',V2pre,');']);
save GA cohLRv*


