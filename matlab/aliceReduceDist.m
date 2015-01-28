function aliceReduceDist
% check distribution of prev and next saccade
if ~exist('/home/yuval/Copy/MEGdata/alice/ga2015/saccadeDist.mat','file')
    cd /home/yuval/Data/alice
    [hitsPrev,hitsNext,centers]=doReduce;%(tempStart,tempEnd,supress);
    cd /home/yuval/Copy/MEGdata/alice/ga2015
    save saccadeDist hits* centers
else
    load /home/yuval/Copy/MEGdata/alice/ga2015/saccadeDist
end
bar(centers,mean(hitsNext))
hold on
bar(centers,mean(hitsPrev))

%save /home/yuval/Copy/MEGdata/alice/ga2015/gaR avgEreduced avgMreduced
function [hitsPrev,hitsNext,centers]=doReduce
sf=[];

load comps
clear comps;
% freq=[1 100]; %[0.101 100];
% bl=0.6;
% blE=round(bl*1024);blM=round(bl*1017.23);
str='';
strE='';
for subi=1:8
    %if ~exist(['/home/yuval/Copy/MEGdata/alice/ga2015/alice',num2str(subi),'.mat'],'file')
    subFold=sf{subi};
    cd(subFold)
    
    load MEGpca
    load EEGpca
    
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
    tN=trlNext(trlNext<1);
    tP=-trlPrev(trlPrev<1);
    [hitsPrev(subi,1:81),centers]=hist(tP,[-1:0.025:1]);
    hitsNext(subi,1:81)=hist(tN,[-1:0.025:1]);
    %bar(centers,hitsNext);
    %     MEGpca.trialinfo(trlInd)=11;
    %     EEGpca.trialinfo(trlInd)=11;
    %
    %
    %
    %     %     figure;
    %     %     cfg=[];
    %     %     cfg.layout='WG32.lay';
    %     %     cfg.interactive='yes';
    %     %     cfg.xlim=[0.094 0.094];
    %     %     ft_topoplotER(cfg,avgEEGc,avgEEGo);
    %     %     figure;
    %     %     cfg=[];
    %     %     cfg.layout='4D248.lay';
    %     %     cfg.interactive='yes';
    %     %     cfg.xlim=[0.094 0.094];
    %     %     ft_topoplotER(cfg,avgMEGc,avgMEGo);
    %
    %     %cd ../
    %     %     else
    %     %         load(['/home/yuval/Copy/MEGdata/alice/ga2015/alice',num2str(subi)]);
    %     %     end
    %     str=[str,',Mr',num2str(subi)];
    %
    %     strE=[strE,',Er',num2str(subi)];
    %
    %
    %     % figure;
    %     % cfg=[];
    %     % cfg.layout='4D248.lay';
    %     % cfg.interactive='yes';
    %     % cfg.xlim=[0.094 0.094];
    %     % ft_topoplotER(cfg,avgM,avgMorig);
    %
    %
    %     %% reduce avg from trials
    %     EEGr=EEGpca;
    %     MEGr=MEGpca;
    %     cfg=[];
    %     cfg.trials=trlInd;
    %     avgMEGc=ft_timelockanalysis(cfg,MEGpca);
    %     avgEEGc=ft_timelockanalysis(cfg,EEGpca);
    %
    %
    %     supressE=round(supress*1024);
    %     supressM=round(supress*1017.23);
    %     sampEstart=nearest(avgEEGc.time,tempStart);
    %     sampMstart=nearest(avgMEGc.time,tempStart);
    %     sampEend=nearest(avgEEGc.time,tempEnd);
    %     sampMend=nearest(avgMEGc.time,tempEnd);
    %     % make template, zero beginning and end of avg
    %     temp=zeros(size(avgEEGc.avg));
    %     supressor=(0-1/supressE):1/supressE:(1-1/supressE);
    %     LS=length(supressor);
    %     temp(:,sampEstart:sampEend)=avgEEGc.avg(:,(sampEstart:sampEend));
    %     temp(:,sampEstart:sampEstart+LS-1)=repmat(supressor,34,1).*avgEEGc.avg(:,sampEstart:sampEstart+LS-1);
    %     temp(:,sampEend-LS+1:sampEend)=fliplr(repmat(supressor,34,1)).*avgEEGc.avg(:,sampEend-LS+1:sampEend);
    %     %     begSamp=nearest(avgEEGc.time,-0.1);
    %     %     endSamp=nearest(avgEEGc.time,0.5);
    %     samp0=nearest(avgEEGc.time,0);
    %     for triali=1:length(trlInd);
    %         clear T*
    %         if trlPrev(triali)>0 && trlPrev(triali)<(0.2+tempEnd) % to leave 0.2s clean baseline window
    %             prevS0=samp0-trlPrev(triali)*1024;
    %             T3=length(avgEEGc.time);
    %             T2=T3-samp0+prevS0;
    %             T1=T3-T2;
    %             EEGr.trial{triali}(:,1:T2)=EEGpca.trial{triali}(:,1:T2)-temp(:,T1:end-1);
    %         end
    %         if trlNext(triali)>0 && trlNext(triali)<(0.5-tempStart) % to have 0.5 quiet ERP
    %             nextS0=samp0+trlNext(triali)*1024;
    %             T3=length(avgEEGc.time);
    %             T5=T3-nextS0+samp0;
    %             T4=T3-T5;
    %             EEGr.trial{triali}(:,T4+1:end)=EEGpca.trial{triali}(:,T4+1:end)-temp(:,1:T5);
    %         end
    %     end
    %     cfg=[];
    %     cfg.trials=trlInd;
    %     avgEEGr=ft_timelockanalysis(cfg,EEGr);
    %     avgEEGr=correctBL(avgEEGr,[-0.6 -0.05]); %#ok<NASGU>
    %     %             figure;
    %     %             cfg=[];
    %     %             cfg.layout='WG32.lay';
    %     %             cfg.interactive='yes';
    %     %             cfg.xlim=[0.1 0.1];
    %     %             cfg.zlim=[-2 2];
    %     %             ft_topoplotER(cfg,avgEEGr,avgEEGc);
    %     eval(['E',num2str(subi),'r=avgEEGr']);
    %
    %
    %     % MEG
    %
    %
    %
    %     % make template, zero beginning and end of avg
    %     temp=zeros(size(avgMEGc.avg));
    %     supressor=(0-1/supressM):1/supressM:(1-1/supressM);
    %     LS=length(supressor);
    %     temp(:,sampMstart:sampMend)=avgMEGc.avg(:,(sampMstart:sampMend));
    %     temp(:,sampMstart:sampMstart+LS-1)=repmat(supressor,250,1).*avgMEGc.avg(:,sampMstart:sampMstart+LS-1);
    %     temp(:,sampMend-LS+1:sampMend)=fliplr(repmat(supressor,250,1)).*avgMEGc.avg(:,sampMend-LS+1:sampMend);
    %     %     begSamp=nearest(avgEEGc.time,-0.1);
    %     %     endSamp=nearest(avgEEGc.time,0.5);
    %     samp0=nearest(avgMEGc.time,0);
    %     for triali=1:length(trlInd);
    %         clear T*
    %         if trlPrev(triali)>0 && trlPrev(triali)<(0.2+tempEnd) % to leave 0.2s clean baseline window
    %             prevS0=round(samp0-trlPrev(triali)*1017.23);
    %             T3=length(avgMEGc.time);
    %             T2=T3-samp0+prevS0;
    %             T1=T3-T2;
    %             MEGr.trial{triali}(:,1:T2)=MEGpca.trial{triali}(:,1:T2)-temp(:,T1:end-1);
    %         end
    %         if trlNext(triali)>0 && trlNext(triali)<(0.5-tempStart) % to have 0.5 quiet ERP
    %             nextS0=round(samp0+trlNext(triali)*1017.23);
    %             T3=length(avgMEGc.time);
    %             T5=T3-nextS0+samp0;
    %             T4=T3-T5;
    %             MEGr.trial{triali}(:,T4+1:end)=MEGpca.trial{triali}(:,T4+1:end)-temp(:,1:T5);
    %         end
    %     end
    %     cfg=[];
    %     cfg.trials=trlInd;
    %     avgMEGr=ft_timelockanalysis(cfg,MEGr);
    %     avgMEGr=correctBL(avgMEGr,[-0.6 -0.05]); %#ok<NASGU>
    %     %     figure;
    %     %     cfg=[];
    %     %     cfg.layout='4D248.lay';
    %     %     cfg.interactive='yes';
    %     %     cfg.xlim=[0.1 0.1];
    %     %     cfg.zlim=[-2e-13 2e-13];
    %     %     ft_topoplotER(cfg,avgMEGr,avgMEGc);
    %     eval(['Mr',num2str(subi),'=avgMEGr;']);
    %     eval(['Er',num2str(subi),'=avgEEGr;']);
    %     % ns=num2str(subi);
    %save(['/home/yuval/Copy/MEGdata/alice/ga2015/alice',ns],['Mo',ns],['Mc',ns],['Eo',ns],['Ec',ns],['Mr',ns],['Er',ns]);
    cd ../
end


