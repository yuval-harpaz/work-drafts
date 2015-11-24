function aliceAlphaD6
% previous versions had MOG artifact, here I clean it. rest and read, 60sec
sf={'idan','inbal','liron','maor','mark','odelia','ohad','yoni'};
conds={'News','Thamil','Loud'};
cfg=[];
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.demean='yes';
cfg.channel={'MEG'};
piska=[6 10 18];
for subi=1:8
    cd /home/yuval/Copy/MEGdata/alice
    cd (sf{subi})
    fn=ls('xc*lf*');
    fn=fn(1:end-1);
    cfg.dataset=fn;
    load files/triggers
    load files/topoMOG
    load files/eog
    Fread=[];
    for condi=1:3
        piskai=piska(condi);
        %load(['files/seg',num2str(piskai)])
        %load files/evt
        load(['files/seg',num2str(piskai)],'samps')
        s0=trigS(find(trigV==2));
        s1=round((samps(end,1)-samps(1,1))./1024*1017+s0);
        if s1>trigS(find(trigV==piskai)+1)
            error('reading is in the break!')
        end
        cfg.trl=[s0 s1 0];
        data=ft_preprocessing(cfg);
        % clean MOG
        data.trial{1}=data.trial{1}-((topoH(1:248)'*data.trial{1})'*topoH(1:248)')'-((topoV(1:248)'*data.trial{1})'*topoV(1:248)')';
        data=correctBL(data);
        data=data.trial{1};
        f=abs(fftBasic(data,1017.25,1));
        eval(['F',conds{condi},'=mean(f(:,1:100,:),3);']);
        %Fread(1:size(f,1),1:100,1+size(Fread,3)*(size(Fread,1)>0):size(f,3)+size(Fread,3)*(size(Fread,1)>0))=f(:,1:100,:);
        eval(['alpha',conds{condi},'(subi,1:248)=squeeze(max(F',conds{condi},'(:,9:11),[],2));']);
    end
    save freqD3 F*
end
cd ../
save alphaD3 alpha*
cfg=[];
cfg.zlim=[0 5e-11];
figure;topoplot248(mean(alphaNews),cfg);
title NEWS

figure;topoplot248(mean(alphaThamil),cfg);
title THAMIL

figure;topoplot248(mean(alphaLoud),cfg);
title LOUD

