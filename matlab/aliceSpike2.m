function aliceSpike2
% Here I try to pool all trials together
filtFreq=[0.101 100];
cd /home/yuval/Data/alice
load ga/GavgMalice
load ga/GavgEalice
COMPS=load('comps');
SF=COMPS.sf;
load spikeTopo

for subi=1:8
    subFold=SF{subi};
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
    bl=0.2;
    blE=round(bl*1024);blM=round(bl*1017.23);
    trlE=round(0.5*1024);trlM=round(0.5*1017.23);
    trigValues=[2,4,8,12,14,16];
    for piskai=1:6
        load(['files/seg',num2str(trigValues(piskai)),'.mat'])
        cfg=[];
        cfg.demean='yes';
        cfg.baselinewindow=[-bl,-bl+0.15];
        cfg.bpfilter='yes';
        cfg.bpfreq=filtFreq;
        cfg.padding=2;
        cfg.trl=[samps(:,1)-blE,samps(:,1)+trlE,-blE*ones(length(samps),1)];
        eeg=readCNT(cfg);
        eeg.trialinfo=samps(:,2);
        if piskai==1;
            EEG=eeg;
        else
            EEG.trial(end+1:end+length(eeg.trial))=eeg.trial;
            EEG.time(end+1:end+length(eeg.trial))=eeg.time;
            EEG.sampleinfo(end+1:end+length(eeg.trial),:)=eeg.sampleinfo;
        end
        % correct H and V
        %         cfg = [];
        %         cfg.topo      = [topoHeeg(1:32,1),topoVeeg(1:32,1)];
        %         cfg.topolabel = eeg.label(1:32);
        %         comp     = ft_componentanalysis(cfg, eeg);
        %         cfg = [];
        %         cfg.component = [1,2];
        %         eegpca = ft_rejectcomponent(cfg, comp,eeg);
        
        %         cfg=[];
        %         cfg.channel='EEG';
        %         cfg.trials=find(samps(:,2)==1);
        %         avgEEG=ft_timelockanalysis(cfg,eegpca);
        %         avgEEG.time=avgEEG.time-endSaccS/1024;
        %         avgEEG=correctBL(avgEEG,[-bl,-bl+0.15]);
        %% MEG
        
        startSeeg=round(evt(find(evt(:,3)==trigValues(piskai)),1)*1024);
        endSeeg=round(evt(find(evt(:,3)==trigValues(piskai))+1,1)*1024);
        startSmeg=trigS(find(trigV==trigValues(piskai)));
        endSmeg=trigS(find(trigV==trigValues(piskai))+1);
        megSR=(endSmeg-startSmeg)/((endSeeg-startSeeg)/1024);
        if round(megSR)~=1017
            error('problem detecting MEG sampling rate')
        end
        trl=samps(:,1)-blE;
        %trl=[avgEEG1.cfg.sampleinfo,-blE*ones(length(avgEEG1.cfg.sampleinfo),1)];
        %[eegpca.sampleinfo(trlInd(1:avgN),:),-blE*ones(length(avgEEG1.cfg.sampleinfo),1)];
        %trl=[samps(:,1)-blE,samps(:,1)+blE,-blE*ones(length(samps),1)];
        trlMEG=round((trl-startSeeg)/1024*megSR)+startSmeg;
        trlMEG(:,2)=trlMEG+trlM+round(bl*1017.23);
        trlMEG(:,3)=-blM*ones(length(trl),1);
        
        cfg=[];
        cfg.demean='yes';
        cfg.baselinewindow=[-bl,-bl+0.15];
        cfg.bpfilter='yes';
        cfg.bpfreq=filtFreq;
        cfg.padding=2;
        cfg.trl=trlMEG;
        cfg.dataset=megFNc;
        cfg.channel='MEG';
        meg=ft_preprocessing(cfg);
        if piskai==1;
            MEG=meg;
        else
            MEG.trial(end+1:end+length(meg.trial))=meg.trial;
            MEG.time(end+1:end+length(meg.trial))=meg.time;
            MEG.sampleinfo(end+1:end+length(meg.trial),:)=meg.sampleinfo;
        end
        % correct H and V and spike components, leave P100 in
        %         cfg = [];
        %         cfg.topo      = [topoHmeg(1:248,1),topoVmeg(1:248,1),spikeTopo8(subi,:)',topoM100./max(abs(spikeTopo8(subi,:)))];
        %         cfg.topolabel = meg.label(1:248);
        %         comp     = ft_componentanalysis(cfg, meg);
        %         cfg = [];
        %         cfg.component = [1,2,3];
        %         megpca = ft_rejectcomponent(cfg, comp,meg);
        
        
        
        %         cfg=[];
        %         cfg.channel='MEG';
        %         cfg.trials=find(samps(:,2)==1);
        %         avgMEG=ft_timelockanalysis(cfg,megpca);
        %         avgMEG.time=avgMEG.time-endSaccS/1024;
        %         avgMEG=correctBL(avgMEG,[-bl,-bl+0.15]);
        %         if trigValues(piskai)==2
        %             MEG=meg;
        %             MEG.trial={};
        %             MEG.trial{1}=avgMEG.avg(:,M0-40:M0+25);
        %             MEG.time={};
        %             MEG.time{1}=avgMEG.time(:,M0-40:M0+25);
        %         else
        %             MEG.trial{trigValues(piskai)/2}=avgMEG.avg(:,M0-40:M0+25);
        %             MEG.time{trigValues(piskai)/2}=avgMEG.time(:,M0-40:M0+25);
        %         end
        
    end
    %     clear avg*EG*
    %     save avgReducedSC2 avgM* avgE*
    %     EEG.sampleinfo=[];
    %     MEG.sampleinfo=[];
    %     for pi=1:9
    %         EEG.sampleinfo(pi,1:2)=[1000*pi+1, 1000*pi+length(EEG.time{1})];
    %         MEG.sampleinfo(pi,1:2)=[1000*pi+1, 1000*pi+length(MEG.time{1})];
    %     end
    
    cfg=[];
    cfg.layout='4D248.lay';
    cfg.interactive='yes';
    cfg.xlim=[-0.02 -0.02];
    ft_topoplotER(cfg,avgMEG);
    cfg=[];
    cfg.method='pca';
    spikeComp=ft_componentanalysis(cfg,MEG);
    tic
    spikeComp=ft_componentanalysis([],MEG);
    toc
    compPlot(spikeComp);
    avgSpikeComp=ft_timelockanalysis([],spikeComp);
    cfg=[];
    cfg.channel=spikeComp.label(1:5);
    cfg.layout='4D248.lay';
    ft_databrowser(cfg,spikeComp);
    
    
    cd ../
end