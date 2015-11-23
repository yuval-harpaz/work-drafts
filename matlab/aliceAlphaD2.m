function aliceAlphaD2

sf={'idan','inbal','liron','maor','mark','odelia','ohad','yoni'};

for subi=1:8
    cd /home/yuval/Copy/MEGdata/alice
    cd (sf{subi})
    fn=ls('xc*lf*');
    fn=fn(1:end-1);
    load files/triggers
    load files/topoMOG
    Fread=[];
    for piskai=[2 4 8]
        % EEG
        load(['files/seg',num2str(piskai)])
        load files/evt
        sampBeg=samps(find(samps(:,2)==1,1),1);
        sampEnd=samps(find(samps(:,2)==1,1,'last'),1);
        (sampEnd-sampBeg)/1017.25;
        samps1s=sampBeg:1024:sampEnd;
        trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
        %         [eegFr,eegLR,eegCoh]=pow(trl,LRpairsEEG);
        %         % title(num2str(piskai))
        %         eval(['eegFr',num2str(piskai),'=eegFr'])
        %         eval(['eegLR',num2str(piskai),'=eegLR'])
        %         eval(['eegCoh',num2str(piskai),'=eegCoh'])
        % MEG
        startSeeg=round(evt(find(evt(:,3)==piskai),1)*1024);
        endSeeg=round(evt(find(evt(:,3)==piskai)+1,1)*1024);
        startSmeg=trigS(find(trigV==piskai));
        endSmeg=trigS(find(trigV==piskai)+1);
        megSR=(endSmeg-startSmeg)/((endSeeg-startSeeg)/1024);
        if round(megSR)~=1017
            error('problem detecting MEG sampling rate')
        end
        trlMEG=round((trl(:,1)-startSeeg)/1024*megSR)+startSmeg;
        trlMEG(:,2)=trlMEG+1017;
        trlMEG(:,3)=zeros(length(trl),1);
        s0=trl(1);
        s1=trl(end,2);
        t0=s0./1017.25;
        dur=round((s1-s0)./1017.25);
        p=pdf4D(fn);
        
        f=abs(fftRaw(fn,t0,dur,1));
        % replace bad channels by means of their neighbours
        Fread(1:size(f,1),1:100,1+size(Fread,3)*(size(Fread,1)>0):size(f,3)+size(Fread,3)*(size(Fread,1)>0))=f(:,1:100,:);
        
    end
    Fread=Fread(:,:,1:60);
    Fread=mean(Fread,3);
    bad=[22 44 133 134];
    
    for badi=1:length(bad)
        badRep=[bad(badi)-1 bad(badi)+1];
        if bad(badi)==133
            badRep=[101 182];
        elseif bad(badi)==134
            badRep=[102 183];
        end
        Fread(bad(badi),:)=(Fread(badRep(1),:)+Fread(badRep(2),:))./2;
    end

    % rest 1
    resti=100;
    s0=trigS(find(trigV==resti,1,'last'));
    s1=s0+60*1017.25;
    dur=round((s1-s0)./1017.25);
    t0=s0./1017.25;
    f=abs(fftRaw(fn,t0,dur,1));
    Frest=f(:,1:100,1:60);
    Frest=median(Frest,3);
    %save freqD F*
    alphaRead(subi,1:248)=squeeze(mean(Fread(:,9:11),2));
    alphaRest(subi,1:248)=squeeze(mean(Frest(:,9:11),2));
    %         [megFr,megLR,megCoh]=pow(trlMEG,LRpairs);
    %         eval(['megFr',num2str(piskai),'=megFr'])
    %         eval(['megLR',num2str(piskai),'=megLR'])
    %         eval(['megCoh',num2str(piskai),'=megCoh'])
end
cd ../
%save alphaD alpha*
cfg.zlim=[0 4e-11];
figure;topoplot248(mean(alphaRead),cfg,1);
title READ

figure;topoplot248(mean(alphaRest),cfg,1);
title REST