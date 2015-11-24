function aliceAlphaD6
% previous versions had MOG artifact, here I clean it. rest and read, 60sec
sf={'idan','inbal','liron','maor','mark','odelia','ohad','yoni'};
cfg=[];
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.demean='yes';
cfg.channel={'MEG'};
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
    for piskai=[2 4 8 12 14 16]
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
%         t0=s0./1017.25;
%         dur=round((s1-s0)./1017.25);
%         p=pdf4D(fn);
%         
%         f=abs(fftRaw(fn,t0,dur,1));
        % replace bad channels by means of their neighbours
        Fread(1:size(f,1),1:100,1+size(Fread,3)*(size(Fread,1)>0):size(f,3)+size(Fread,3)*(size(Fread,1)>0))=f(:,1:100,:);
        
    end
    choice=round(1:size(Fread,3)/120:size(Fread,3));
    if length(choice)~=120
        error('must be 120sec')
    end
    Fread=Fread(:,:,choice);
    Fread=mean(Fread,3);

    % rest 1
    resti=102;
    s0=trigS(find(trigV==resti,1,'last'));
    s1=s0+60*1017.25;
    cfg.trl=[s0 s1 0];
    data=ft_preprocessing(cfg);
    % clean MOG
    data=data.trial{1}-((topoH(1:248)'*data.trial{1})'*topoH(1:248)')'-((topoV(1:248)'*data.trial{1})'*topoV(1:248)')';
    f=abs(fftBasic(data,1017.25,1));
%     dur=round((s1-s0)./1017.25);
%     t0=s0./1017.25;
%     f=abs(fftRaw(fn,t0,dur,1));
    Frest=f(:,1:100,1:60);
    Frest=mean(Frest,3);
    Frest1=load('freqD','Frest');
    Frest=(Frest+Frest1.Frest)./2;
    save freqD2 F*
    alphaRead(subi,1:248)=squeeze(max(Fread(:,9:11),[],2));
    alphaRest(subi,1:248)=squeeze(max(Frest(:,9:11),[],2));
    %         [megFr,megLR,megCoh]=pow(trlMEG,LRpairs);
    %         eval(['megFr',num2str(piskai),'=megFr'])
    %         eval(['megLR',num2str(piskai),'=megLR'])
    %         eval(['megCoh',num2str(piskai),'=megCoh'])
end
cd ../
save alphaD2 alpha*
cfg=[];
cfg.zlim=[0 5e-11];
figure;topoplot248(mean(alphaRead),cfg);
title READ

figure;topoplot248(mean(alphaRest),cfg);
title REST

load LRpairs
load ~/ft_BIU/matlab/plotwts
[~,Li]=ismember(LRpairs(:,1),wts.label);
[~,Ri]=ismember(LRpairs(:,2),wts.label);
readL=mean(alphaRead(:,Li),2);
readR=mean(alphaRead(:,Ri),2);
restL=mean(alphaRest(:,Li),2);
restR=mean(alphaRest(:,Ri),2);
rest=mean(alphaRest,2);
read=mean(alphaRead,2);
[~,p]=ttest(readL,restL)
[~,p]=ttest(readR,restR)
[~,p]=ttest(read,rest)