function alicePCA10
cd /home/yuval/Data/alice
sf=[];
load comps
clear comps;
freq=[1 40]; %[0.101 100];
bl=0.6;
blE=round(bl*1024);blM=round(bl*1017.23);
for subi=1:7
    %if ~exist(['/home/yuval/Copy/MEGdata/alice/ga2015/alice',num2str(subi),'.mat'],'file')
    subFold=sf{subi};
    cd(subFold)
    %if ~exist('EEGpca10.mat','file')
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
        trigValues=[10];
        piskai=1;
        load(['files/seg',num2str(trigValues(piskai)),'.mat'])
        clear avgEEG avgMEG
        cfg=[];
        cfg.demean='yes';
        cfg.baselinewindow=[-bl,-bl+0.2];
        cfg.bpfilter='yes';
        cfg.bpfreq=freq;
        cfg.padding=2;
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
        cfg.bpfilter='yes';
        cfg.bpfreq=freq;
        cfg.padding=2;
        cfg.trl=trlMEG;
        cfg.dataset=megFNc;
        cfg.channel='MEG';
        meg=ft_preprocessing(cfg);
        for timei=1:length(meg.time{1})
            rsi(timei)=nearest(eeg.time{1},meg.time{1}(timei));
        end
        for triali=1:length(meg.trial)
            meg.trial{triali}(249,:)=eeg.trial{triali}(33,rsi);
            meg.trial{triali}(250,:)=eeg.trial{triali}(34,rsi);
        end
        if piskai==1;
            MEG=meg;
            MEG.trialinfo=eeg.trialinfo;
        else
            MEG.trial(end+1:end+length(meg.trial))=meg.trial;
            MEG.time(end+1:end+length(meg.trial))=meg.time;
            MEG.sampleinfo(end+1:end+length(meg.trial),:)=meg.sampleinfo;
            MEG.trialinfo(end+1:end+length(meg.trial),:)=eeg.trialinfo;
        end
        MEG.label(249:250)=EEG.label(33:34);
        % correct H and V components
        cfg = [];
        cfg.topolabel = MEG.label;
        cfg.unmixing(1,1:249)=pinv(topoHmeg);
        cfg.unmixing(1,250)=0;
        cfg.unmixing(2,1:249)=pinv(topoVmeg);
        cfg.unmixing(2,250)=cfg.unmixing(1,249);
        cfg.unmixing(2,249)=0;
        comp     = ft_componentanalysis(cfg, MEG);
        cfg = [];
        cfg.component = [1,2];
        MEGpca = ft_rejectcomponent(cfg, comp,MEG);
        MEGpca=correctBL(MEGpca,[-0.6 -0.05]);
        % correct H and V components
        cfg = [];
        cfg.unmixing(1,1:33)=pinv(topoHeeg);
        cfg.unmixing(1,34)=0;
        cfg.unmixing(2,1:33)=pinv(topoVeeg);
        cfg.unmixing(2,34)=cfg.unmixing(1,33);
        cfg.unmixing(2,34)=0;
        cfg.topolabel = eeg.label;
        comp     = ft_componentanalysis(cfg, EEG);
        cfg = [];
        cfg.component = [1,2];
        EEGpca = ft_rejectcomponent(cfg, comp,EEG);
        EEGpca=correctBL(EEGpca,[-0.6 -0.05]);
        disp(['saving ',subFold]);
        save MEGpca10 MEGpca
        save EEGpca10 EEGpca
%    end
    cd ../
end