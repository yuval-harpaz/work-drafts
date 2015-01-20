function aliceReduceAvgEog
cd /home/yuval/Data/alice
sf=[];
load comps
clear comps;
freq=[1 100]; %[0.101 100];
bl=0.6;
blE=round(bl*1024);blM=round(bl*1017.23);
str='';
stro='';
strE='';
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
    eval(['Mc',num2str(subi),'=avgMEGc;']);
    eval(['Mo',num2str(subi),'=avgMEGo;']);
    eval(['Ec',num2str(subi),'=avgEEGc;']);
    eval(['Eo',num2str(subi),'=avgEEGo;']);
%     ns=num2str(subi);
%     save(['/home/yuval/Copy/MEGdata/alice/ga2015/alice',ns],['Mo',ns],['M',ns],['Eo',ns],['E',ns]);
    %cd ../
    %     else
    %         load(['/home/yuval/Copy/MEGdata/alice/ga2015/alice',num2str(subi)]);
    %     end
    str=[strc,',M',num2str(subi)];
    strc=[strc,',Mc',num2str(subi)];
    stro=[stro,',Mo',num2str(subi)];
    strE=[strEc,',E',num2str(subi)];
    strEc=[strEc,',Ec',num2str(subi)];
    strEo=[strEo,',Eo',num2str(subi)];
    % end
    % cfg=[];
    % cfg.channel=1:248;
    % cfg.keepindividual='yes';
    % eval(['avgM=ft_timelockgrandaverage(cfg',str,');'])
    % eval(['avgMorig=ft_timelockgrandaverage(cfg',stro,');'])
    % cfg.channel=[1:12,14:18,20:32];
    % eval(['avgE=ft_timelockgrandaverage(cfg',strE,');'])
    % eval(['avgEorig=ft_timelockgrandaverage(cfg',strEo,');'])
    % save /home/yuval/Copy/MEGdata/alice/ga2015/ga avgE avgM avgEorig avgMorig
    % figure;
    % cfg=[];
    % cfg.layout='WG32.lay';
    % cfg.interactive='yes';
    % cfg.xlim=[0.094 0.094];
    % ft_topoplotER(cfg,avgE,avgEorig);
    % figure;
    % cfg=[];
    % cfg.layout='4D248.lay';
    % cfg.interactive='yes';
    % cfg.xlim=[0.094 0.094];
    % ft_topoplotER(cfg,avgM,avgMorig);
    
    
    %% reduce avg from trials
    tempStart=0.05;
    tempEnd=0.24;
    supress=0.1;
    supressE=round(supress*1024);
    supressM=round(supress*1017.23);
    sampE=nearest(avgEEG.time,tempStart);
    
    for chani=1:32
        chan=avgEEG.avg(chani,:);
        spikeLine=chan(spikeStart):(chan(spikeEnd)-chan(spikeStart))/length(spikeStart:spikeEnd-1):chan(spikeEnd);
        chan(spikeStart:spikeEnd)=spikeLine;
        avgEEG.avg(chani,:)=chan;
    end
    avg=zeros(size(avgEEGc.avg));
    begSamp=nearest(avgEEGc.time,-0.1);
    endSamp=nearest(avgEEGc.time,0.5);
    %    avgN=50;
    %     if length(trlInd)<50
    %         warning('less than 50 trials')
    %         avgN=length(trlInd);
    %         eval(['!echo "segment ',num2str(trigValues(piskai)),' had ',num2str(avgN),'trials" >>errors.txt'])
    %         trials=1:avgN;
    %     else % take as little muscle artifact as possible
    %     cfg=[];
    %     cfg.demean='yes';
    %     %        cfg.baselinewindow=[-bl,-bl+0.2];
    %     cfg.bpfilter='yes';
    %     cfg.bpfreq=[110 140];
    %     cfg.padding=2;
    %     cfg.trl=[samps(:,1)-blE,samps(:,1)+blE,-blE*ones(length(samps),1)];
    %     eegHF=readCNT(cfg);
    %     sdE=zeros(1,length(trlInd));
    %     for triali=1:length(trlInd)
    %         sdE(triali)=mean(std(eeg.trial{1,trlInd(triali)}(1:32,:)'));
    %     end
    %     [~,msci]=sort(sdE);
    %     trials=msci(1:50);
    %    end
    samp0=nearest(avgEEGc.time,0);
    for triali=1:length(trlInd);
        trial=EEGpca.trial{1,trlInd(triali)}(1:32,:);
        if trlPrev(triali)>0 && trlPrev(triali)<0.7
            prevS0=samp0-trlPrev(triali)*1024;
            trial(:,1:prevS0+1024*0.5)=trial(:,1:prevS0+1024*0.5)-avgEEG.avg(:,endSamp-prevS0-1024*0.5+1:endSamp);
        end
        if trlNext(triali)>0 && trlNext(triali)<0.6
            nextS0=samp0+trlNext(triali)*1024;
            trial(:,nextS0-round(1024*0.1):end)=trial(:,nextS0-round(1024*0.1):end)-avgEEG.avg(:,begSamp:begSamp+size(trial(:,nextS0-round(1024*0.1):end),2)-1);
        end
        avg=avg+trial;
    end
    avg=avg./avgN;
    avgEEG1=avgEEGorig;
    avgEEG1.avg=avg;
    avgEEG1=correctBL(avgEEG1,[-0.4 -0.2]);
    avgEEG1.cfg.trials=trlInd(1:avgN);
    avgEEG1.cfg.sampleinfo=eegpca.sampleinfo(trlInd(1:avgN),:);
    
    %         cfg=[];
    %         cfg.channel='EEG';
    %         cfg.trials=trlInd(1:avgN);
    %         avgEEG0=ft_timelockanalysis(cfg,eegpca);
    %         avgEEG0.time=avgEEG0.time-endSaccS/1024;
    %         avgEEG0=correctBL(avgEEG0,[-bl,-bl+0.2]);
    %         figure;
    %         cfg=[];
    %         cfg.layout='WG32.lay';
    %         cfg.interactive='yes';
    %         ft_multiplotER(cfg,avgEEG1,avgEEG0);
    %         pause
    %         close all
    eval(['avgE',num2str(trigValues(piskai)),'=avgEEG1']);
    
    
    %% MEG
    
    %         startSeeg=round(evt(find(evt(:,3)==trigValues(piskai)),1)*1024);
    %         endSeeg=round(evt(find(evt(:,3)==trigValues(piskai))+1,1)*1024);
    %         startSmeg=trigS(find(trigV==trigValues(piskai)));
    %         endSmeg=trigS(find(trigV==trigValues(piskai))+1);
    %         megSR=(endSmeg-startSmeg)/((endSeeg-startSeeg)/1024);
    %         if round(megSR)~=1017
    %             error('problem detecting MEG sampling rate')
    %         end
    %         trl=samps(:,1)-blE;
    %         %trl=[avgEEG1.cfg.sampleinfo,-blE*ones(length(avgEEG1.cfg.sampleinfo),1)];
    %         %[eegpca.sampleinfo(trlInd(1:avgN),:),-blE*ones(length(avgEEG1.cfg.sampleinfo),1)];
    %         %trl=[samps(:,1)-blE,samps(:,1)+blE,-blE*ones(length(samps),1)];
    %         trlMEG=round((trl-startSeeg)/1024*megSR)+startSmeg;
    %         trlMEG(:,2)=trlMEG+round(megSR*1.2);
    %         trlMEG(:,3)=-blM*ones(length(trl),1);
    %
    %         cfg=[];
    %         cfg.demean='yes';
    %         cfg.baselinewindow=[-bl,-bl+0.2];
    %         cfg.bpfilter='yes';
    %         cfg.bpfreq=freq;
    %         cfg.padding=2;
    %         cfg.trl=trlMEG;
    %         cfg.dataset=megFNc;
    %         cfg.channel='MEG';
    %         meg=ft_preprocessing(cfg);
    %         % correct H and V components
    %         cfg = [];
    %         cfg.topo      = [topoHmeg(1:248,1),topoVmeg(1:248,1)];
    %         cfg.topolabel = meg.label(1:248);
    %         comp     = ft_componentanalysis(cfg, meg);
    %         cfg = [];
    %         cfg.component = [1,2];
    %         megpca = ft_rejectcomponent(cfg, comp,meg);
    %
    
    
    cfg=[];
    cfg.channel='MEG';
    cfg.trials=find(samps(:,2)==1);
    avgMEG=ft_timelockanalysis(cfg,megpca);
    avgMEG.time=avgMEG.time-endSaccS/1024;
    avgMEG=correctBL(avgMEG,[-bl,-bl+0.2]);
    %for triali=1:avgN
    samp0=nearest(avgMEG.time,0);
    
    spikeStart=nearest(avgMEG.time,-0.05);
    spikeEnd=nearest(avgMEG.time,0.03);
    for chani=1:248
        chan=avgMEG.avg(chani,:);
        spikeLine=chan(spikeStart):(chan(spikeEnd)-chan(spikeStart))/(spikeEnd-spikeStart):chan(spikeEnd);
        if length(spikeLine)<(spikeEnd-spikeStart+1)
            if ((spikeEnd-spikeStart+1)-length(spikeLine))>1
                error('wrong spike length');
            else
                spikeLine(end+1)=chan(spikeEnd);
            end
        end
        chan(spikeStart:spikeEnd)=spikeLine;
        avgMEG.avg(chani,:)=chan;
    end
    
    
    avg=zeros(size(avgMEG.avg));
    begSamp=nearest(avgMEG.time,-0.1);
    endSamp=nearest(avgMEG.time,0.5);
    
    for triali=trials
        trial=megpca.trial{1,trlInd(triali)};
        if trlPrev(triali)>0 && trlPrev(triali)<0.7
            prevS0=round(samp0-trlPrev(triali)*megSR);
            trial(:,1:prevS0+round(megSR*0.5))=trial(:,1:prevS0+round(megSR*0.5))-avgMEG.avg(:,endSamp-prevS0-round(megSR*0.5)+1:endSamp);
        end
        if trlNext(triali)>0 && trlNext(triali)<0.6
            nextS0=samp0+round(trlNext(triali)*megSR);
            trial(:,nextS0-round(megSR*0.1):end)=trial(:,nextS0-round(megSR*0.1):end)-avgMEG.avg(:,begSamp:begSamp+size(trial(:,nextS0-round(megSR*0.1):end),2)-1);
        end
        avg=avg+trial;
    end
    avg=avg./avgN;
    avgMEG1=avgMEG;
    avgMEG1.avg=avg;
    avgMEG1=correctBL(avgMEG1,[-0.4 -0.2]);
    avgMEG1.cfg.trials=trlInd(1:avgN);
    avgMEG1.cfg.sampleinfo=megpca.sampleinfo(trlInd(1:avgN),:);
    eval(['avgM',num2str(trigValues(piskai)),'=avgMEG1']);
    
    clear avg*EG*
    save avgReducedEog avgM* avgE*
    cd ../
end