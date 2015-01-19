function aliceReduceSpikeComp1

times=[];
cd /home/yuval/Data/alice
load ga/GavgMalice
load ga/GavgEalice
COMPS=load('comps');
SF=COMPS.sf;
load spikeTopo
load spikeSamps
for subi=1:8
    subFold=SF{subi};
    cd(subFold)
    if ~exist('avgReducedSC1.mat','file')
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
        %subi=find(ismember(SF,subFold));
        
        for piskai=2:2:18
            
            load(['files/seg',num2str(piskai),'.mat'])
            cfg=[];
            cfg.demean='yes';
            cfg.baselinewindow=[-bl,-bl+0.2];
            cfg.bpfilter='yes';
            cfg.bpfreq=[1 40];
            cfg.padding=2;
            cfg.trl=[samps(:,1)-blE,samps(:,1)+blE,-blE*ones(length(samps),1)];
            eeg=readCNT(cfg);
            eeg.trialinfo=samps(:,2);
            cfg=[];
            cfg.channel='EEG';
            cfg.trials=find(samps(:,2)==1);
            avgEEGorig=ft_timelockanalysis(cfg,eeg);
            avgEEGorig=correctBL(avgEEGorig,[-bl,-bl+0.2]);
            topo=[];
            topo=[topoHeeg(1:32,1),topoVeeg(1:32,1)]; % EOG
            spikeSamp=[nearest(avgEEGorig.time,times(1)),nearest(avgEEGorig.time,times(2))]; % eye muscle spike
            topo(:,[3,4])=[avgEEGorig.avg(:,spikeSamp)];
            trialSamp=[nearest(avgEEGorig.time,0.02):20:nearest(avgEEGorig.time,0.5)];
            topo(:,5:length(trialSamp)+4)=avgEEGorig.avg(:,trialSamp);
            % correct H and V components
            cfg = [];
            cfg.topo      = topo;%[topoHeeg(1:32,1),topoVeeg(1:32,1),spikeTopoE8(subi,:)'];
            cfg.topolabel = eeg.label(1:32);
            comp     = ft_componentanalysis(cfg, eeg);
            cfg = [];
            cfg.component = [1,2,3,4];
            eegpca = ft_rejectcomponent(cfg, comp,eeg);
            
            cfg=[];
            cfg.channel='EEG';
            cfg.trials=find(samps(:,2)==1);
            avgEEG=ft_timelockanalysis(cfg,eegpca);
            avgEEG.time=avgEEG.time-endSaccS/1024;
            avgEEG=correctBL(avgEEG,[-bl,-bl+0.2]);
            %avgEEGorig=avgEEG;
            % remove spike from avg (-50 to 30ms)
            
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
            %     spikeStart=nearest(avgEEG.time,-0.05);
            %     spikeEnd=nearest(avgEEG.time,0.03);
            %     for chani=1:32
            %         chan=avgEEG.avg(chani,:);
            %         spikeLine=chan(spikeStart):(chan(spikeEnd)-chan(spikeStart))/length(spikeStart:spikeEnd-1):chan(spikeEnd);
            %         chan(spikeStart:spikeEnd)=spikeLine;
            %         avgEEG.avg(chani,:)=chan;
            %     end
            avg=zeros(size(avgEEG.avg));
            begSamp=nearest(avgEEG.time,-0.1);
            endSamp=nearest(avgEEG.time,0.5);
            avgN=50;
            if length(trlInd)<50
                warning('less than 50 trials')
                avgN=length(trlInd);
                eval(['!echo "segment ',num2str(piskai),' had ',num2str(avgN),'trials" >>errors.txt'])
                trials=1:avgN;
            else % take as little muscle artifact as possible
                cfg=[];
                cfg.demean='yes';
                %        cfg.baselinewindow=[-bl,-bl+0.2];
                cfg.bpfilter='yes';
                cfg.bpfreq=[110 140];
                cfg.padding=2;
                cfg.trl=[samps(:,1)-blE,samps(:,1)+blE,-blE*ones(length(samps),1)];
                eegHF=readCNT(cfg);
                sdE=zeros(1,length(trlInd));
                for triali=1:length(trlInd)
                    sdE(triali)=mean(std(eeg.trial{1,trlInd(triali)}(1:32,:)'));
                end
                [~,msci]=sort(sdE);
                trials=msci(1:50);
            end
            for triali=trials
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
            cfg.padding=2;
            cfg.trl=trlMEG;
            cfg.dataset=megFNc;
            cfg.channel='MEG';
            meg=ft_preprocessing(cfg);
            % correct H and V components
            cfg = [];
            cfg.topo      = [topoHmeg(1:248,1),topoVmeg(1:248,1),spikeTopo8(subi,:)'];
            cfg.topolabel = meg.label(1:248);
            comp     = ft_componentanalysis(cfg, meg);
            cfg = [];
            cfg.component = [1,2,3];
            megpca = ft_rejectcomponent(cfg, comp,meg);
            
            
            
            cfg=[];
            cfg.channel='MEG';
            cfg.trials=find(samps(:,2)==1);
            avgMEG=ft_timelockanalysis(cfg,megpca);
            avgMEG.time=avgMEG.time-endSaccS/1024;
            avgMEG=correctBL(avgMEG,[-bl,-bl+0.2]);
            %for triali=1:avgN
            samp0=nearest(avgMEG.time,0);
            
            %     spikeStart=nearest(avgMEG.time,-0.05);
            %     spikeEnd=nearest(avgMEG.time,0.03);
            %     for chani=1:248
            %         chan=avgMEG.avg(chani,:);
            %         spikeLine=chan(spikeStart):(chan(spikeEnd)-chan(spikeStart))/(spikeEnd-spikeStart):chan(spikeEnd);
            %         if length(spikeLine)<(spikeEnd-spikeStart+1)
            %             if ((spikeEnd-spikeStart+1)-length(spikeLine))>1
            %                 error('wrong spike length');
            %             else
            %                 spikeLine(end+1)=chan(spikeEnd);
            %             end
            %         end
            %         chan(spikeStart:spikeEnd)=spikeLine;
            %         avgMEG.avg(chani,:)=chan;
            %     end
            
            
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
            eval(['avgM',num2str(piskai),'=avgMEG1']);
        end
        clear avg*EG*
        save avgReducedSC1 avgM* avgE*
    else
        disp([subFold,' skipped'])
    end
    cd ..
end
if ~exist('/home/yuval/Copy/MEGdata/alice/ga/GavgMaliceSC1.mat','file')
    aliceGAnotReduced('alice','avgReducedSC1','SC1')
end

cd /home/yuval/Copy/MEGdata/alice/ga
load('GavgMaliceSC1.mat')
load('GavgEaliceSC1.mat')
load LRpairsEEG; LRpairsEEG=LRpairs; load LRpairs

GavgMalice=correctBL(GavgMalice,[-0.2 -0.05]);
GavgEalice=correctBL(GavgEalice,[-0.2 -0.05]);
GavgMaliceSC=GavgMalice;
GavgEaliceSC=GavgEalice;
[~,MLi]=ismember(LRpairs(:,1),GavgMaliceSC.label);
[~,MRi]=ismember(LRpairs(:,2),GavgMaliceSC.label);
[~,ELi]=ismember(LRpairsEEG(:,1),GavgEaliceSC.label);
[~,ERi]=ismember(LRpairsEEG(:,2),GavgEaliceSC.label);
t0=-0.2;t1=0.55;
s0=nearest(GavgMaliceSC.time,t0);
s1=nearest(GavgMaliceSC.time,t1);
time=GavgMaliceSC.time(s0:s1);
s0e=nearest(GavgEaliceSC.time,t0);
s1e=nearest(GavgEaliceSC.time,t1);
timeE=GavgEaliceSC.time(s0e:s1e);
s3e=nearest(timeE,-0.05);s3=nearest(time,-0.05);
MaLSC=squeeze(mean(abs(mean(GavgMaliceSC.individual(:,MLi,s0:s1),1))));
MaRSC=squeeze(mean(abs(mean(GavgMaliceSC.individual(:,MRi,s0:s1),1))));
MaLSC=correctBL(MaLSC',[1 s3]);
MaRSC=correctBL(MaRSC',[1 s3]);


load GavgMalice
load GavgEalice
GavgMalice=correctBL(GavgMalice,[-0.2 -0.05]);
GavgEalice=correctBL(GavgEalice,[-0.2 -0.05]);
MaL=squeeze(mean(abs(mean(GavgMalice.individual(:,MLi,s0:s1),1))));
MaR=squeeze(mean(abs(mean(GavgMalice.individual(:,MRi,s0:s1),1))));
MaL=correctBL(MaL',[1 s3]);
MaR=correctBL(MaR',[1 s3]);
figure;
plot(time,MaL)
hold on
plot(time,MaR,'r')
plot(time,MaLSC,'--')
plot(time,MaRSC,'r--')
legend('left reduced','right reduced','left no spike','right no spike')

EaL=squeeze(mean(abs(mean(GavgEalice.individual(:,ELi,s0e:s1e),1))));
EaR=squeeze(mean(abs(mean(GavgEalice.individual(:,ERi,s0e:s1e),1))));
EaL=correctBL(EaL',[1 s3]);
EaR=correctBL(EaR',[1 s3]);
EaLSC=squeeze(mean(abs(mean(GavgEaliceSC.individual(:,ELi,s0e:s1e),1))));
EaRSC=squeeze(mean(abs(mean(GavgEaliceSC.individual(:,ERi,s0e:s1e),1))));
EaLSC=correctBL(EaLSC',[1 s3]);
EaRSC=correctBL(EaRSC',[1 s3]);
figure;
plot(timeE,EaL)
hold on
plot(timeE,EaR,'r')
plot(timeE,EaLSC,'--')
plot(timeE,EaRSC,'r--')
legend('left reduced','right reduced','left no spike','right no spike')

%%

t=-0.022;
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[t t];
cfg.zlim=[-3e-14 3e-14];
cfg.interactive='yes';
% cfg.trials=3;
figure;ft_topoplotER(cfg,GavgMaliceSC,GavgMalice)

t=-0.022;
cfg=[];
cfg.layout='WG32.lay';
cfg.xlim=[t t];
cfg.zlim=[-2 2];
cfg.interactive='yes';
figure;ft_topoplotER(cfg,GavgEaliceSC,GavgEalice)



