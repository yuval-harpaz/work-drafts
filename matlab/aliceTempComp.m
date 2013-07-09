function aliceTempComp(subFold)
cd /home/yuval/Data/alice
cd(subFold)
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
        for triali=1:length(trlInd)
            trial=eegpca.trial{1,triali}(1:32,:);
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
        avg=avg./length(trlInd);
        avgEEG1=avgEEG;
        avgEEG1.avg=avg;
        avgEEG1=correctBL(avgEEG1,[-0.6 -0.4]);
        figure;
        cfg=[];
        cfg.layout='WG32.lay';
        cfg.interactive='yes';
        ft_multiplotER(cfg,avgEEG1,avgEEG);
        pause
        close all
        eval(['avgC',num2str(piskai),'=avgEEG1']);
    end
    
end
save avgC avgC*            