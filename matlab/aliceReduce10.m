function aliceReduce10(tempStart,tempEnd,supress)
cd /home/yuval/Data/alice
if ~existAndFull('tempStart')
    tempStart=0.055;
end
if ~existAndFull('tempEnd')
    tempEnd=0.35;
end
if ~existAndFull('supress')
    supress=0.05;
end


tic
[avgMr10,avgEr10,N,sampM]=doReduce(tempStart,tempEnd,supress);
toc
%load /home/yuval/Copy/MEGdata/alice/ga2015/ga
% figure;
% cfg=[];
% cfg.interactive='yes';
% %cfg.xlim=[0.3 0.3];
% cfg.zlim=[-3e-14 3e-14];
% cfg.layout='4D248.lay';
% % ft_topoplotER(cfg,avgMr,avgMpca);
% % cfg.layout='WG32.lay';
% % ft_topoplotER(cfg,avgEr,avgEpca);
% dif=avgMr;
% dif.individual=avgMpca.individual-avgMr.individual;
% % ft_topoplotER(cfg,avgMr,avgMpca,dif)
% cfg.channel= {'A99', 'A100', 'A131', 'A132', 'A133', 'A134', 'A135', 'A159', 'A160', 'A161', 'A162', 'A181', 'A182', 'A183', 'A184', 'A199', 'A200', 'A201', 'A216'};
% ft_singleplotER(cfg,avgMr,avgMpca,dif)
[avgMr,avgEr]=aliceChooseNtrials10(N,[],sampM);
save /home/yuval/Copy/MEGdata/alice/ga2015/gaR10 avgEr avgMr avgEr10 avgMr10 tempStart tempEnd supress N
function [avgMreduced,avgEreduced, N,sampM]=doReduce(tempStart,tempEnd,supress) %#ok<STOUT>
sf=[];
load comps
clear comps;
% freq=[1 100]; %[0.101 100];
% bl=0.6;
% blE=round(bl*1024);blM=round(bl*1017.23);
str='';
strE='';
for subi=1:7
    %if ~exist(['/home/yuval/Copy/MEGdata/alice/ga2015/alice',num2str(subi),'.mat'],'file')
    subFold=sf{subi};
    cd(subFold)
    
    load MEGpca10
    load EEGpca10
    
    %% find preceding and following trials
    [~,badE]=badTrials([],EEGpca,0);
    [~,badM]=badTrials([],MEGpca,0);
    bad=sort(unique([badM,badE]));
    MEGpca.trialinfo(bad)=3;
    EEGpca.trialinfo(bad)=3;
    trlCount=0;
    trlPrev=[];
    trlNext=[];
    trlInd=[];
    for triali=1:length(EEGpca.trial)
        % is it not the beginning of a row?
        if EEGpca.trialinfo(triali)==1
            % is it not the last saccade?
            if triali~=length(EEGpca.trial)
                % is the next saccade a word?
                if EEGpca.trialinfo(triali+1)==1;
                    % first trial is different
                    trlCount=trlCount+1;
                    trlInd(trlCount)=triali;
                    trlNext(trlCount)=(EEGpca.sampleinfo(triali+1,1)-EEGpca.sampleinfo(triali,1))/1024;
                    if triali==1
                        trlPrev(trlCount)=0;
                    else
                        trlPrev(trlCount)=(EEGpca.sampleinfo(triali,1)-EEGpca.sampleinfo(triali-1,1))/1024;
                    end
                end
            end
        end
    end
    MEGpca.trialinfo(trlInd)=11;
    EEGpca.trialinfo(trlInd)=11;
    
    
    
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
    
    strE=[strE,',Er',num2str(subi)];
    
    
    % figure;
    % cfg=[];
    % cfg.layout='4D248.lay';
    % cfg.interactive='yes';
    % cfg.xlim=[0.094 0.094];
    % ft_topoplotER(cfg,avgM,avgMorig);
    
    
    %% reduce avg from trials
    EEGr=EEGpca;
    MEGr=MEGpca;
    cfg=[];
    cfg.trials=trlInd;
    avgMEGc=ft_timelockanalysis(cfg,MEGpca);
    avgEEGc=ft_timelockanalysis(cfg,EEGpca);
    
    
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
            EEGr.trial{triali}(:,T4+1:end)=EEGr.trial{triali}(:,T4+1:end)-temp(:,1:T5);
        end
    end
    cfg=[];
    cfg.trials=trlInd;
    avgEEGr=ft_timelockanalysis(cfg,EEGr);
    avgEEGr=correctBL(avgEEGr,[-0.6 -0.05]); %#ok<NASGU>
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
            MEGr.trial{triali}(:,T4+1:end)=MEGr.trial{triali}(:,T4+1:end)-temp(:,1:T5);
        end
    end
    cfg=[];
    cfg.trials=trlInd;
    avgMEGr=ft_timelockanalysis(cfg,MEGr);
    avgMEGr=correctBL(avgMEGr,[-0.6 -0.05]); %#ok<NASGU>
    %     figure;
    %     cfg=[];
    %     cfg.layout='4D248.lay';
    %     cfg.interactive='yes';
    %     cfg.xlim=[0.1 0.1];
    %     cfg.zlim=[-2e-13 2e-13];
    %     ft_topoplotER(cfg,avgMEGr,avgMEGc);
    eval(['Mr',num2str(subi),'=avgMEGr;']);
    eval(['Er',num2str(subi),'=avgEEGr;']);
    % ns=num2str(subi);
    %save(['/home/yuval/Copy/MEGdata/alice/ga2015/alice',ns],['Mo',ns],['Mc',ns],['Eo',ns],['Ec',ns],['Mr',ns],['Er',ns]);
    cd ../
    N(subi)=length(trlInd);
    sampM(subi,1)=MEGpca.sampleinfo(1);
    sampM(subi,2)=MEGpca.sampleinfo(end);
end

cfg=[];
cfg.channel=1:248;
cfg.keepindividual='yes';
% eval(['avgMpca=ft_timelockgrandaverage(cfg',strc,');'])
% eval(['avgMorig=ft_timelockgrandaverage(cfg',stro,');'])
eval(['avgMreduced=ft_timelockgrandaverage(cfg',str,');'])
%
cfg.channel=[1:12,14:18,20:32];
% eval(['avgEpca=ft_timelockgrandaverage(cfg',strEc,');'])
% eval(['avgEorig=ft_timelockgrandaverage(cfg',strEo,');'])
eval(['avgEreduced=ft_timelockgrandaverage(cfg',strE,');'])

