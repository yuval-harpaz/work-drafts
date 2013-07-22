function aliceFindMuscleThr(subFold)

cd /home/yuval/Data/alice
cd(subFold)
megFNc=ls('*lf*');
megFNc=megFNc(1:end-1);
load files/evt
load files/triggers
load files/indEOG.mat

bl=0.2;
blE=round(bl*1024);blM=round(bl*1017.23);
piskaTrlN=zeros(1,9);
trlBeg=1;
for piskai=2:2:18
    load(['files/seg',num2str(piskai),'.mat'])
    cfg=[];
    cfg.demean='yes';
    %        cfg.baselinewindow=[-bl,-bl+0.2];
    cfg.bpfilter='yes';
    cfg.bpfreq=[110 140];
    cfg.padding=0.2;
    cfg.trl=[samps(:,1)-blE,samps(:,1)+blE,-blE*ones(length(samps),1)];
    eeg=readCNT(cfg);
    eeg.trialinfo=samps(:,2);
    
    
    %% MEG
    
    startSeeg=round(evt(find(evt(:,3)==piskai),1)*1024);
    endSeeg=round(evt(find(evt(:,3)==piskai)+1,1)*1024);
    startSmeg=trigS(find(trigV==piskai));
    endSmeg=trigS(find(trigV==piskai)+1);
    megSR=(endSmeg-startSmeg)/((endSeeg-startSeeg)/1024);
    if round(megSR)~=1017
        error('problem detecting MEG sampling rate')
    end
    trl=samps(:,1)-blE;
    %trl=[avgEEG1.cfg.sampleinfo,-blE*ones(length(avgEEG1.cfg.sampleinfo),1)];
    %[eegpca.sampleinfo(trlInd(1:avgN),:),-blE*ones(length(avgEEG1.cfg.sampleinfo),1)];
    %trl=[samps(:,1)-blE,samps(:,1)+blE,-blE*ones(length(samps),1)];
    trlMEG=round((trl-startSeeg)/1024*megSR)+startSmeg;
    trlMEG(:,2)=trlMEG+round(megSR*1.2);
    trlMEG(:,3)=-blM*ones(length(trl),1);
    
    cfg=[];
    cfg.demean='yes';
    %cfg.baselinewindow=[-bl,-bl+0.2];
    cfg.bpfilter='yes';
    cfg.bpfreq=[110 140];
    cfg.padding=0.2;
    cfg.trl=trlMEG;
    cfg.dataset=megFNc;
    cfg.channel='MEG';
    meg=ft_preprocessing(cfg);
    %% cals SD
    sdE=zeros(size(eeg.time));
    sdM=zeros(size(meg.time));
    for triali=1:length(eeg.trial)
        sdE(triali)=mean(std(eeg.trial{1,triali}(1:32,:)'));
        sdM(triali)=mean(std(meg.trial{1,triali}(1:248,:)'));
    end
    piskaTrlN(piskai)=length(eeg.trial);
    trlEnd=trlBeg+piskaTrlN(piskai)-1;
    SDe(1,trlBeg:trlEnd)=sdE;
    SDm(1,trlBeg:trlEnd)=sdM;
    trlBeg=trlBeg+piskaTrlN(piskai);
end
figure;
plot(SDe,'.')
figure;
plot(SDm,'k.')
