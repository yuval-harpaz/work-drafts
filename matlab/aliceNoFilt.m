function [avgMraw,avgEraw]=aliceNoFilt
cd /home/yuval/Data/alice
sf=[];
load comps
clear comps;
freq=[1 100]; %[0.101 100];
bl=0.6;
blE=round(bl*1024);blM=round(bl*1017.23);
for subi=1:8
    %if ~exist(['/home/yuval/Copy/MEGdata/alice/ga2015/alice',num2str(subi),'.mat'],'file')
    subFold=sf{subi};
    cd(subFold)
    megFNc=ls('*lf*');
    megFNc=megFNc(1:end-1);
    load files/evt
    load files/triggers
    load files/indEOG.mat
    load files/topoEOG
    topoHeeg=topoH;
    topoVeeg=topoV;
    load files/topoMOG
    topoHmeg=topoH;
    topoVmeg=topoV;
    clear topoH topoV
    trlCount=0;
    trlInd=[];
    trlNext=[];
    trlPrev=[];
    trigValues=[2,4,8,12,14,16];
    for piskai=1:6
        load(['files/seg',num2str(trigValues(piskai)),'.mat'])
        clear avgEEG avgMEG
        cfg=[];
        cfg.demean='yes';
        cfg.baselinewindow=[-bl,-bl+0.2];
%         cfg.bpfilter='yes';
%         cfg.bpfreq=freq;
%         cfg.padding=2;
        cfg.trl=[samps(:,1)-blE,samps(:,1)+blE,-blE*ones(length(samps),1)];
        eeg=readCNT(cfg);
        eeg.trialinfo=samps(:,2);
        load files/indEOG.mat
        if indH==2 % make H and V eog fit their label
            for triali=1:length(eeg.trial)
                tmp=eeg.trial{triali}(33,:);
                eeg.trial{triali}(33,:)=eeg.trial{triali}(34,:);
                eeg.trial{triali}(34,:)=tmp;
            end
            clear tmp
        end
        if piskai==1;
            EEG=eeg;
        else
            EEG.trial(end+1:end+length(eeg.trial))=eeg.trial;
            EEG.time(end+1:end+length(eeg.trial))=eeg.time;
            EEG.sampleinfo(end+1:end+length(eeg.trial),:)=eeg.sampleinfo;
            EEG.trialinfo(end+1:end+length(eeg.trial),:)=eeg.trialinfo;
        end
        startSeeg=round(evt(find(evt(:,3)==trigValues(piskai)),1)*1024);
        endSeeg=round(evt(find(evt(:,3)==trigValues(piskai))+1,1)*1024);
        startSmeg=trigS(find(trigV==trigValues(piskai)));
        endSmeg=trigS(find(trigV==trigValues(piskai))+1);
        megSR=(endSmeg-startSmeg)/((endSeeg-startSeeg)/1024);
        if round(megSR)~=1017
            error('problem detecting MEG sampling rate')
        end
        %% MEG
        trl=samps(:,1)-blE;
        trlMEG=round((trl-startSeeg)/1024*megSR)+startSmeg;
        trlMEG(:,2)=trlMEG+round(megSR*1.2);
        trlMEG(:,3)=-blM*ones(length(trl),1);
        cfg=[];
        cfg.demean='yes';
        cfg.baselinewindow=[-bl,-bl+0.2];
%         cfg.bpfilter='yes';
%         cfg.bpfreq=freq;
%         cfg.padding=2;
        cfg.trl=trlMEG;
        cfg.dataset=megFNc;
        cfg.channel='MEG';
        meg=ft_preprocessing(cfg);
        if piskai==1;
            MEG=meg;
            MEG.trialinfo=eeg.trialinfo;
        else
            MEG.trial(end+1:end+length(meg.trial))=meg.trial;
            MEG.time(end+1:end+length(meg.trial))=meg.time;
            MEG.sampleinfo(end+1:end+length(meg.trial),:)=meg.sampleinfo;
            MEG.trialinfo(end+1:end+length(meg.trial),:)=eeg.trialinfo;
        end
    end
    %MEG.label(249:250)=EEG.label(33:34);
    [~,badE]=badTrials([],EEG,0);
    [~,badM]=badTrials([],MEG,0);
    bad=sort(unique([badM,badE]));
    MEG.trialinfo(bad)=3;
    EEG.trialinfo(bad)=3;
    trlInd=find(MEG.trialinfo==1);
    cfg=[];
    cfg.trials=trlInd;
    cfg.channel=1:248;
    avgMEG=ft_timelockanalysis(cfg,MEG);
    cfg.channel=[1:12,14:18,20:32];
    avgEEG=ft_timelockanalysis(cfg,EEG);    
    eval(['M',num2str(subi),'=avgMEG'])
    eval(['E',num2str(subi),'=avgEEG'])
    cd ../
end
cfg=[];
cfg.channel=1:248;
cfg.keepindividual='yes';
avgMraw=ft_timelockgrandaverage(cfg,M1,M2,M3,M4,M5,M6,M7,M8);
cfg.channel=[1:12,14:18,20:32];
avgEraw=ft_timelockgrandaverage(cfg,E1,E2,E3,E4,E5,E6,E7,E8);