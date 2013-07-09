function aliceReduceAvg(subFold)

cd /home/yuval/Data/alice
cd(subFold)
if exist('avgReduced.mat','file')
    error('avgReduced.mat exists')
end
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
bl=0.6;
blE=round(bl*1024);blM=round(bl*1017.23);
for piskai=2:2:18
    if ~exist(['files/seg',num2str(piskai),'.mat'],'file')
        error(['files/seg',num2str(piskai),'.mat not found'])
    else
        load(['files/seg',num2str(piskai),'.mat'])
        cfg=[];
        cfg.demean='yes';
        cfg.baselinewindow=[-bl,-bl+0.2];
        cfg.bpfilter='yes';
        cfg.bpfreq=[1 40];
        cfg.padding=0.7;
        cfg.trl=[samps(:,1)-blE,samps(:,1)+blE,-blE*ones(length(samps),1)];
        eeg=readCNT(cfg);
        eeg.trialinfo=samps(:,2);
        % correct H and V components
        cfg = [];
        cfg.topo      = [topoHeeg(1:32,1),topoVeeg(1:32,1)];
        cfg.topolabel = eeg.label(1:32);
        comp     = ft_componentanalysis(cfg, eeg);
        cfg = [];
        cfg.component = [1,2];
        eegpca = ft_rejectcomponent(cfg, comp,eeg);
                    
                
            
        cfg=[];
        cfg.channel='EEG';
        cfg.trials=find(samps(:,2)==1);
        avgEEG=ft_timelockanalysis(cfg,eegpca);
        avgEEG.time=avgEEG.time-endSaccS/1024;
        avgEEG=correctBL(avgEEG,[-bl,-bl+0.2]);
        
%         figure;
%         cfg=[];
%         cfg.layout='WG32.lay';
%         cfg.interactive='yes';
%         ft_multiplotER(cfg,avgEEG);

        %% find preceding and following trials
        samp0=nearest(avgEEG.time,0);
        trlCount=0;
        trlInd=[];
        trlNext=[];
        trlPrev=[];
        for triali=1:length(eegpca.trial)
            % is it not the beginning of a row?
            if eegpca.trialinfo(triali)==1
                % is it not the last saccade?
                if triali~=length(eegpca.trial)
                    % is the next saccade a word?
                    if eegpca.trialinfo(triali+1)==1;
                        % first trial is different   
                        trlCount=trlCount+1;
                        trlInd(trlCount)=triali;
                        trlNext(trlCount)=(eegpca.sampleinfo(triali+1,1)-eegpca.sampleinfo(triali,1))/1024;
                        if triali==1
                            trlPrev(trlCount)=0;
                        else 
                            trlPrev(trlCount)=(eegpca.sampleinfo(triali,1)-eegpca.sampleinfo(triali-1,1))/1024;;
                        end
                    end
                end
            end
        end
        %% reduce avg from trials
        avg=zeros(size(avgEEG.avg));
        begSamp=nearest(avgEEG.time,-0.1);
        endSamp=nearest(avgEEG.time,0.5);
        avgN=50;
        if length(trlInd)<50
            warning('less than 50 trials')
            avgN=length(trlInd);
            eval(['!echo "segment ',num2str(piskai),' had ',num2str(avgN),'trials" >>errors.txt'])
        end 
        for triali=1:avgN
            trial=eegpca.trial{1,trlInd(triali)}(1:32,:);
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
        avgEEG1=avgEEG;
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
        eval(['avgE',num2str(piskai),'=avgEEG1']);
        
        
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
        cfg.baselinewindow=[-bl,-bl+0.2];
        cfg.bpfilter='yes';
        cfg.bpfreq=[1 40];
        cfg.padding=0.7;
        cfg.trl=trlMEG;
        cfg.dataset=megFNc;
        cfg.channel='MEG';
        meg=ft_preprocessing(cfg);
        % correct H and V components
        cfg = [];
        cfg.topo      = [topoHmeg(1:248,1),topoVmeg(1:248,1)];
        cfg.topolabel = meg.label(1:248);
        comp     = ft_componentanalysis(cfg, meg);
        cfg = [];
        cfg.component = [1,2];
        megpca = ft_rejectcomponent(cfg, comp,meg);
                    
                
            
        cfg=[];
        cfg.channel='MEG';
        cfg.trials=find(samps(:,2)==1);
        avgMEG=ft_timelockanalysis(cfg,megpca);
        avgMEG.time=avgMEG.time-endSaccS/1024;
        avgMEG=correctBL(avgMEG,[-bl,-bl+0.2]);
        %for triali=1:avgN
        samp0=nearest(avgMEG.time,0);
        avg=zeros(size(avgMEG.avg));
        begSamp=nearest(avgMEG.time,-0.1);
        endSamp=nearest(avgMEG.time,0.5);
        for triali=1:avgN
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
        eval(['avgM',num2str(piskai),'=avgMEG1']);
    end
    
end
clear avg*EG*
save avgReduced avgM* avgE*