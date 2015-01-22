function aliceReduceAvgEog
cd /home/yuval/Data/alice
sf=[];
load comps
clear comps;
freq=[1 100]; %[0.101 100];
bl=0.6;
blE=round(bl*1024);blM=round(bl*1017.23);
str='';
strc='';
stro='';
strE='';
strEc='';
strEo='';
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
        %    if ~exist(['files/seg',num2str(piskai),'.mat'],'file')
        %        error(['files/seg',num2str(piskai),'.mat not found'])
        %    else
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
        %trl=[avgEEG1.cfg.sampleinfo,-blE*ones(length(avgEEG1.cfg.sampleinfo),1)];
        %[eegpca.sampleinfo(trlInd(1:avgN),:),-blE*ones(length(avgEEG1.cfg.sampleinfo),1)];
        %trl=[samps(:,1)-blE,samps(:,1)+blE,-blE*ones(length(samps),1)];
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
        
    end
    MEG.label(249:250)=EEG.label(33:34);
    
    %% find preceding and following trials
    [~,badE]=badTrials([],EEG,0);
    [~,badM]=badTrials([],MEG,0);
    bad=sort(unique([badM,badE]));
    MEG.trialinfo(bad)=3;
    EEG.trialinfo(bad)=3;
    for triali=1:length(EEG.trial)
        % is it not the beginning of a row?
        if EEG.trialinfo(triali)==1
            % is it not the last saccade?
            if triali~=length(EEG.trial)
                % is the next saccade a word?
                if EEG.trialinfo(triali+1)==1;
                    % first trial is different
                    trlCount=trlCount+1;
                    trlInd(trlCount)=triali;
                    trlNext(trlCount)=(EEG.sampleinfo(triali+1,1)-EEG.sampleinfo(triali,1))/1024;
                    if triali==1
                        trlPrev(trlCount)=0;
                    else
                        trlPrev(trlCount)=(EEG.sampleinfo(triali,1)-EEG.sampleinfo(triali-1,1))/1024;
                    end
                end
            end
        end
    end
    MEG.trialinfo(trlInd)=11;
    EEG.trialinfo(trlInd)=11;
    
    cfg=[];
    cfg.trials=trlInd;
    avgMEGo=ft_timelockanalysis(cfg,MEG);
    avgMEGo=correctBL(avgMEGo,[-0.6 -0.05]);
    avgEEGo=ft_timelockanalysis(cfg,EEG);
    avgEEGo=correctBL(avgEEGo,[-0.6 -0.05]);
    %     % check when is M/P100 to take topography
    %     cfg=[];cfg.method='absMean';
    %     [It,Ip]=findCompLims(cfg,avgMEGo);
    %     close;
    %     sM100=nearest(avgMEGo.time,0.095);% the sample for 95ms
    %     SM(subi)=Ip(nearest(Ip,sM100));
    %     TM=avgMEGo.time(SM);
    %     [It,Ip]=findCompLims(cfg,avgEEGo);
    %     close;
    %     sE100=nearest(avgEEGo.time,0.1);% the sample for 95ms
    %     SE(subi)=Ip(nearest(Ip,sE100));
    %     TE(subi)=avgEEGo.time(SE(subi));
    
    % correct H and V components
    cfg = [];
    cfg.topolabel = MEG.label;
    cfg.unmixing(1,1:249)=pinv(topoHmeg);
    cfg.unmixing(1,250)=0;
    cfg.unmixing(2,1:249)=pinv(topoVmeg);
    cfg.unmixing(2,250)=cfg.unmixing(1,249);
    cfg.unmixing(2,249)=0;
    %     cfg.unmixing(3,:)=pinv(avgMEGo.avg(:,SM(subi)));
    %     cfg.unmixing(3,[249 250])=[0 0];
    comp     = ft_componentanalysis(cfg, MEG);
    %     comp.topo(250,1)=0;
    %     comp.unmixing(1,250)=0;
    %     comp.topolabel(250)=MEG.label(250);
    cfg = [];
    cfg.component = [1,2];
    MEGpca = ft_rejectcomponent(cfg, comp,MEG);
    cfg=[];
    cfg.trials=trlInd;
    avgMEGc=ft_timelockanalysis(cfg,MEGpca);
    avgMEGc=correctBL(avgMEGc,[-0.6 -0.05]);
    
    %     figure;
    %     cfg=[];
    %     cfg.layout='4D248.lay';
    %     cfg.interactive='yes';
    %     cfg.xlim=[0.094 0.094];
    %     ft_topoplotER(cfg,avgMEG,avgMEGo);
    
    
    % correct H and V components
    cfg = [];
    cfg.unmixing(1,1:33)=pinv(topoHeeg);
    cfg.unmixing(1,34)=0;
    cfg.unmixing(2,1:33)=pinv(topoVeeg);
    cfg.unmixing(2,34)=cfg.unmixing(1,33);
    cfg.unmixing(2,34)=0;
    %     cfg.unmixing(3,:)=pinv(avgEEGo.avg(:,SE(subi)));
    %     cfg.unmixing(3,[33 34])=[0 0];
    %cfg.topo      = [topoHeeg(1:32,1),topoVeeg(1:32,1)];
    cfg.topolabel = eeg.label;
    comp     = ft_componentanalysis(cfg, EEG);
    cfg = [];
    cfg.component = [1,2];
    EEGpca = ft_rejectcomponent(cfg, comp,EEG);
    cfg=[];
    cfg.trials=trlInd;
    avgEEGc=ft_timelockanalysis(cfg,EEGpca);
    avgEEGc=correctBL(avgEEGc,[-0.6 -0.05]);
    
    %     figure;
    %     cfg=[];
    %     cfg.layout='WG32.lay';
    %     cfg.interactive='yes';
    %     cfg.xlim=[0.094 0.094];
    %     ft_topoplotER(cfg,avgEEGc,avgEEGo);
    %     figure;
    %     cfg=[];
    %     cfg.layout='4D248.lay';
    %     cfg.interactive='yes';
    %     cfg.xlim=[0.094 0.094];
    %     ft_topoplotER(cfg,avgMEGc,avgMEGo);
    
    %cd ../
    %     else
    %         load(['/home/yuval/Copy/MEGdata/alice/ga2015/alice',num2str(subi)]);
    %     end
    str=[str,',Mr',num2str(subi)];
    strc=[strc,',Mc',num2str(subi)];
    stro=[stro,',Mo',num2str(subi)];
    strE=[strE,',Er',num2str(subi)];
    strEc=[strEc,',Ec',num2str(subi)];
    strEo=[strEo,',Eo',num2str(subi)];
    
    % figure;
    % cfg=[];
    % cfg.layout='4D248.lay';
    % cfg.interactive='yes';
    % cfg.xlim=[0.094 0.094];
    % ft_topoplotER(cfg,avgM,avgMorig);
    
    
    %% reduce avg from trials
    EEGr=EEGpca;
    MEGr=MEGpca;
    tempStart=0.025;
    tempEnd=0.25;
    supress=0.05;
    supressE=round(supress*1024);
    supressM=round(supress*1017.23);
    sampEstart=nearest(avgEEGc.time,tempStart);
    sampMstart=nearest(avgMEGc.time,tempStart);
    sampEend=nearest(avgEEGc.time,tempEnd);
    sampMend=nearest(avgMEGc.time,tempEnd);
    % make template, zero beginning and end of avg
    temp=zeros(size(avgEEGc.avg));
    supressor=(0-1/supressE):1/supressE:(1-1/supressE);
    LS=length(supressor);
    temp(:,sampEstart:sampEend)=avgEEGc.avg(:,(sampEstart:sampEend));
    temp(:,sampEstart:sampEstart+LS-1)=repmat(supressor,34,1).*avgEEGc.avg(:,sampEstart:sampEstart+LS-1);
    temp(:,sampEend-LS+1:sampEend)=fliplr(repmat(supressor,34,1)).*avgEEGc.avg(:,sampEend-LS+1:sampEend);
    %     begSamp=nearest(avgEEGc.time,-0.1);
    %     endSamp=nearest(avgEEGc.time,0.5);
    samp0=nearest(avgEEGc.time,0);
    for triali=1:length(trlInd);
        clear T*
        if trlPrev(triali)>0 && trlPrev(triali)<(0.2+tempEnd) % to leave 0.2s clean baseline window
            prevS0=samp0-trlPrev(triali)*1024;
            T3=length(avgEEGc.time);
            T2=T3-samp0+prevS0;
            T1=T3-T2;
            EEGr.trial{triali}(:,1:T2)=EEGpca.trial{triali}(:,1:T2)-temp(:,T1:end-1);
        end
        if trlNext(triali)>0 && trlNext(triali)<(0.5-tempStart) % to have 0.5 quiet ERP
            nextS0=samp0+trlNext(triali)*1024;
            T3=length(avgEEGc.time);
            T5=T3-nextS0+samp0;
            T4=T3-T5;
            EEGr.trial{triali}(:,T4+1:end)=EEGpca.trial{triali}(:,T4+1:end)-temp(:,1:T5);
        end
    end
    cfg=[];
    cfg.trials=trlInd;
    avgEEGr=ft_timelockanalysis(cfg,EEGr);
    avgEEGr=correctBL(avgEEGr,[-0.6 -0.05]);
    %             figure;
    %             cfg=[];
    %             cfg.layout='WG32.lay';
    %             cfg.interactive='yes';
    %             cfg.xlim=[0.1 0.1];
    %             cfg.zlim=[-2 2];
    %             ft_topoplotER(cfg,avgEEGr,avgEEGc);
    eval(['E',num2str(subi),'r=avgEEGr']);
    
    
    % MEG
    
    
    
    % make template, zero beginning and end of avg
    temp=zeros(size(avgMEGc.avg));
    supressor=(0-1/supressM):1/supressM:(1-1/supressM);
    LS=length(supressor);
    temp(:,sampMstart:sampMend)=avgMEGc.avg(:,(sampMstart:sampMend));
    temp(:,sampMstart:sampMstart+LS-1)=repmat(supressor,250,1).*avgMEGc.avg(:,sampMstart:sampMstart+LS-1);
    temp(:,sampMend-LS+1:sampMend)=fliplr(repmat(supressor,250,1)).*avgMEGc.avg(:,sampMend-LS+1:sampMend);
    %     begSamp=nearest(avgEEGc.time,-0.1);
    %     endSamp=nearest(avgEEGc.time,0.5);
    samp0=nearest(avgMEGc.time,0);
    for triali=1:length(trlInd);
        clear T*
        if trlPrev(triali)>0 && trlPrev(triali)<(0.2+tempEnd) % to leave 0.2s clean baseline window
            prevS0=round(samp0-trlPrev(triali)*1017.23);
            T3=length(avgMEGc.time);
            T2=T3-samp0+prevS0;
            T1=T3-T2;
            MEGr.trial{triali}(:,1:T2)=MEGpca.trial{triali}(:,1:T2)-temp(:,T1:end-1);
        end
        if trlNext(triali)>0 && trlNext(triali)<(0.5-tempStart) % to have 0.5 quiet ERP
            nextS0=round(samp0+trlNext(triali)*1017.23);
            T3=length(avgMEGc.time);
            T5=T3-nextS0+samp0;
            T4=T3-T5;
            MEGr.trial{triali}(:,T4+1:end)=MEGpca.trial{triali}(:,T4+1:end)-temp(:,1:T5);
        end
    end
    cfg=[];
    cfg.trials=trlInd;
    avgMEGr=ft_timelockanalysis(cfg,MEGr);
    avgMEGr=correctBL(avgMEGr,[-0.6 -0.05]);
%     figure;
%     cfg=[];
%     cfg.layout='4D248.lay';
%     cfg.interactive='yes';
%     cfg.xlim=[0.1 0.1];
%     cfg.zlim=[-2e-13 2e-13];
%     ft_topoplotER(cfg,avgMEGr,avgMEGc);
    eval(['Mr',num2str(subi),'=avgMEGr;']);
    eval(['Mc',num2str(subi),'=avgMEGc;']);
    eval(['Mo',num2str(subi),'=avgMEGo;']);
    eval(['Er',num2str(subi),'=avgEEGr;']);
    eval(['Ec',num2str(subi),'=avgEEGc;']);
    eval(['Eo',num2str(subi),'=avgEEGo;']);
    ns=num2str(subi);
    save(['/home/yuval/Copy/MEGdata/alice/ga2015/alice',ns],['Mo',ns],['Mc',ns],['Eo',ns],['Ec',ns],['Mr',ns],['Er',ns]);
    cd ../
end

cfg=[];
cfg.channel=1:248;
cfg.keepindividual='yes';
eval(['avgMpca=ft_timelockgrandaverage(cfg',strc,');'])
eval(['avgMorig=ft_timelockgrandaverage(cfg',stro,');'])
eval(['avgMreduced=ft_timelockgrandaverage(cfg',str,');'])

cfg.channel=[1:12,14:18,20:32];
eval(['avgEpca=ft_timelockgrandaverage(cfg',strEc,');'])
eval(['avgEorig=ft_timelockgrandaverage(cfg',strEo,');'])
eval(['avgEreduced=ft_timelockgrandaverage(cfg',strE,');'])
save /home/yuval/Copy/MEGdata/alice/ga2015/ga avgEpca avgMpca avgEorig avgMorig avgEreduced avgMreduced
figure;
cfg=[];
cfg.layout='WG32.lay';
cfg.interactive='yes';
cfg.xlim=[0.094 0.094];
ft_topoplotER(cfg,avgEreduced,avgEpca,avgEorig);
cfg.layout='4D248.lay';
ft_topoplotER(cfg,avgMreduced,avgMpca,avgMorig);