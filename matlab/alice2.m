function alice1(subFold,thrWord)
cd /home/yuval/Data/alice
cd(subFold)
%% clean HB
try
    LSclean=ls('*lf*');
    megFNc=LSclean(1:end-1);
catch
    LSclean=[];
end
if ~exist('thrWord')
    thrWord=[];
end
if isempty(thrWord)
    thrWord=1.5;
end
LSraw=ls('c,rf*');
megFN=LSraw(1:end-1);
if isempty(LSclean)
    p=pdf4D(megFN);
    cleanCoefs = createCleanFile(p, megFN,...
        'byLF',256 ,'Method','Adaptive',...
        'xClean',[4,5,6],...
        'byFFT',0,...
        'HeartBeat',[],...
        'outLierMargin',30);
    LSclean=ls('*lf*')
    megFNc=LSclean(1:end-1);
end
%% find events and prepare stuff
if ~exist('./files','dir')
    mkdir files
end

if ~exist('./files/eog.mat','file')
    cfg=[];
    cfg.channel={'HEOG','VEOG'};
    cfg.demean='yes';
    cfg.lpfilter='yes';
    cfg.lpfreq=40;
    eog=readCNT(cfg);
    save files/eog eog
else
    load files/eog
end
if ~exist('./files/evt.mat','file')
    evt=readTrg;
    evt=evt(evt(:,3)>0,:);
    save files/evt evt
else
    load files/evt
end
% MEG triggers
if ~exist('files/triggers.mat','file')
    trig=readTrig_BIU(megFNc);
    trig=clearTrig(trig);
    trigS=find(trig)
    trigV=trig(trigS)
    save files/triggers trigS trigV
end

%% comp analysis for eye movement
if ~exist('eog','var')
    load ./files/eog.mat
end
if ~exist('./files/topoEOG.mat','file') || ~exist('./files/topoMOG.mat','file')
    %% EEG
    % Vertical - define data segment
    startSeeg=round(evt(find(evt(:,3)==204,1,'first'))*1024);
    endSeeg=round(evt(find(evt(:,3)==206,1,'last'))*1024);
    % check which EOG has more SD for this piece and declare it VEOG
    sd=std(eog.trial{1,1}(:,startSeeg:endSeeg)');
    indV=2;indH=1;
    if sd(1)>sd(2)*2
        indV=1;indH=2;
    end
    eogSeg=eog.trial{1,1}(:,startSeeg:endSeeg);
%     figure;
%     plot(eog.time{1,1}(startSeeg:endSeeg),eog.trial{1,1}([indH,indV],startSeeg:endSeeg))
%     legend('HEOG','VEOG')
%     title('UP-DOWN Eye Movement')
    cfg=[];
    cfg.demean='yes';
    cfg.bpfilter='yes';
    cfg.bpfreq=[1 40];
    cfg.padding=0.7;
    cfg.channel={'EEG',eog.label{indV}};
    cfg.trl=[startSeeg-512,endSeeg+512,-512];
    upDown=readCNT(cfg);
    cfg=[];
    cfg.method='pca';
    comp           = ft_componentanalysis(cfg, upDown);
    r=corr([comp.trial{1,1}(1:5,:)',upDown.trial{1,1}(33,:)']);
    r=abs(r(1:5,6));
    [maxcor,rowi]=max(abs(r(1:end-1,end)));
    if abs(maxcor)<0.9
        error('no correlation between pca1 and V EOG')
    end
    topoV=comp.topo(:,rowi);
    % H
    startSeeg=round(evt(find(evt(:,3)==214,1,'first'))*eog.fsample);
    endSeeg=round(evt(find(evt(:,3)==216,1,'last'))*eog.fsample);
    eogSeg=eog.trial{1,1}(:,startSeeg:endSeeg);
%     figure;
%     plot(eog.time{1,1}(startSeeg:endSeeg),eog.trial{1,1}([indH,indV],startSeeg:endSeeg))
%     legend('HEOG','VEOG')
%     title('Right-Left Eye Movement')
    
    cfg=[];
    cfg.demean='yes';
    cfg.bpfilter='yes';
    cfg.bpfreq=[1 40];
    cfg.padding=0.7;
    cfg.channel={'EEG',eog.label{indH}};
    cfg.trl=[startSeeg-512,endSeeg+512,-512];
    rightLeft=readCNT(cfg);
    
    cfg=[];
    cfg.method='pca';
    comp           = ft_componentanalysis(cfg, rightLeft);
    r=corr([comp.trial{1,1}(1:5,:)',rightLeft.trial{1,1}(33,:)']);
    r=abs(r(1:5,6));
    [maxcor,rowi]=max(abs(r(1:end-1,end)));
    if maxcor<0.9
        error('no correlation between pca1 and H EOG')
    end
    topoH=comp.topo(:,rowi);
    save files/indEOG indV indH
    save files/topoEOG topoH topoV
    %% MEG
    load files/triggers
    % get eog for resampling
    veog=upDown.trial{1,1}(33,:);
    vtime=upDown.time{1,1};
    heog=rightLeft.trial{1,1}(33,:);
    htime=rightLeft.time{1,1};
    
    % V
    startSmeg=trigS(find(trigV==204,1,'first'));
    endSmeg=trigS(find(trigV==206,1,'last'));
    cfg=[];
    cfg.demean='yes';
    cfg.bpfilter='yes';
    cfg.bpfreq=[1 40];
    cfg.padding=0.7;
    cfg.channel='MEG';
    cfg.trl=[startSmeg-509,endSmeg+509,-509];
    cfg.dataset=megFNc;
    upDown=ft_preprocessing(cfg);
    % resample veog
    rsind=zeros(1,length(upDown.time{1,1}));
    for sampi=1:length(upDown.time{1,1})
        rsind(sampi)=nearest(vtime,upDown.time{1,1}(1,sampi));
    end
    upDown.trial{1,1}(249,:)=veog(1,rsind);
    upDown.label{249,1}='VEOG';
    % pca
    cfg=[];
    cfg.method='pca';
    comp           = ft_componentanalysis(cfg, upDown);
    
    r=corr([comp.trial{1,1}(1:5,:)',upDown.trial{1,1}(249,:)']);
    r=abs(r(1:5,6));
    [maxcor,rowi]=max(abs(r(1:end-1,end)));
    if abs(maxcor)<0.9
        error('no correlation between pca1 and V EOG')
    end
    topoV=comp.topo(:,rowi);
    
    % H
    startSmeg=trigS(find(trigV==214,1,'first'));
    endSmeg=trigS(find(trigV==216,1,'last'));
    cfg=[];
    cfg.demean='yes';
    cfg.lpfilter='yes';
    cfg.lpfreq=40;
    cfg.padding=0.7;
    cfg.channel='MEG';
    cfg.trl=[startSmeg-509,endSmeg+509,-509];
    cfg.dataset=megFNc;
    rightLeft=ft_preprocessing(cfg);
    % resampling heog
    rsind=zeros(1,length(rightLeft.time{1,1}));
    for sampi=1:length(rightLeft.time{1,1})
        rsind(sampi)=nearest(htime,rightLeft.time{1,1}(1,sampi));
    end
    rightLeft.trial{1,1}(249,:)=heog(1,rsind);
    rightLeft.label{249,1}='HEOG';
    
    cfg=[];
    cfg.method='pca';
    comp           = ft_componentanalysis(cfg, rightLeft);
    
    r=corr([comp.trial{1,1}(1:5,:)',rightLeft.trial{1,1}(249,:)']);
    r=abs(r(1:5,6));
    [maxcor,rowi]=max(abs(r(1:end-1,end)));
    if abs(maxcor)<0.9
        error('no correlation between pca1 and H EOG')
    end
    topoH=comp.topo(:,rowi);
    
    save files/topoMOG topoH topoV
end

%% average saccades


%EEG
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
        % EEG
        startSeeg=round(evt(find(evt(:,3)==piskai),1)*1024);
        endSeeg=round(evt(find(evt(:,3)==piskai)+1,1)*1024);
        eogSeg=eog.trial{1,1}(indH,startSeeg:endSeeg);
        figure;
        plot(eog.time{1,1}(startSeeg:endSeeg),eogSeg);
        grid on
        legend('HEOG')
        % define the end of the reading
        answer=inputdlg('Reading End Time');
        endSeeg0=str2num(answer{1,1})*1024;
        close
        eogSeg=eog.trial{1,1}(indH,startSeeg:endSeeg0);
        [wordS,rowS]=findSaccade(eogSeg,2,thrWord);
        samps=sortrows([wordS,rowS;ones(size(wordS)),3*ones(size(rowS))]');
        samps(:,1)=samps(:,1)+startSeeg-1;
        cfg=[];
        cfg.demean='yes';
        cfg.baselinewindow=[-bl,-bl+0.2];
        cfg.bpfilter='yes';
        cfg.bpfreq=[1 40];
        cfg.padding=0.7;
        cfg.trl=[samps(:,1)-blE,samps(:,1)+blE,-blE*ones(length(samps),1)];
        eeg=readCNT(cfg);
        eeg.trialinfo=samps(:,2);
        cfg = [];
        cfg.topo      = topoHeeg(1:32,1);
        cfg.topolabel = eeg.label(1:32);
        compH     = ft_componentanalysis(cfg, eeg);
        cfg = [];
        cfg.component = 1;
        eegpca = ft_rejectcomponent(cfg, compH,eeg);
        compAvg=ft_timelockanalysis([],compH)
        [~,endSaccS]=max(abs(compAvg.avg(1,nearest(compAvg.time,0):nearest(compAvg.time,0)+75)));
        figure;
        plot(compAvg.time,compAvg.avg)
        hold on
        plot(endSaccS/1024,compAvg.avg(1,nearest(compAvg.time,endSaccS/1024)),'ro')
        title('Heog COMP and the end of the saccade (red o)')
        
        cfg=[];
        cfg.channel='EEG';
        cfg.trials=find(samps(:,2)==1);
        avgEEG=ft_timelockanalysis(cfg,eegpca);
        avgEEG.time=avgEEG.time-endSaccS/1024;
        avgEEG=correctBL(avgEEG,[-bl,-bl+0.2])
        figure;
        cfg=[];
        cfg.layout='WG32.lay';
        cfg.interactive='yes';
        ft_multiplotER(cfg,avgEEG)
        title('PRESS A KEY TO GO ON')
        pause
        % MEG
        
        % megFN='c,rfhp0.1Hz';
        % megFN=['xc,hb,lf_',megFN];
        % trig=readTrig_BIU(megFNc);
        % trig=clearTrig(trig);
        startSmeg=trigS(find(trigV==piskai));
        endSmeg=trigS(find(trigV==piskai)+1);
        %endSmeg=find(trig==18,1); % was supposed to be 20
        megSR=(endSmeg-startSmeg)/((endSeeg-startSeeg)/1024);
        if round(megSR)~=1017
            error('problem detecting MEG sampling rate')
        end
        trl=round((samps(:,1)-startSeeg)/1024*megSR)+startSmeg;
        trl=[trl-blM,trl+blM,-blM*ones(size(trl))];
        cfg=[];
        cfg.channel='MEG';%{'HEOG','VEOG'};
        cfg.demean='yes';
        cfg.baselinewindow=[-bl,-bl+0.2]; % ugly!
        cfg.bpfilter='yes';
        cfg.bpfreq=[1 40];
        cfg.padding=0.7;
        cfg.trl=trl;
        cfg.dataset=megFNc;
        meg=ft_preprocessing(cfg);
        meg.trialinfo=samps(:,2);
        cfg = [];
        cfg.topo      = topoHmeg;
        cfg.topolabel = meg.label;
        compH     = ft_componentanalysis(cfg, meg);
        cfg = [];
        cfg.component = 1;
        megpca = ft_rejectcomponent(cfg, compH,meg);
        cfg=[];
        cfg.trials=find(samps(:,2)==1);
        avgMEG=ft_timelockanalysis(cfg,megpca);
        avgMEG.time=avgMEG.time-endSaccS/1024;
        avgMEG=correctBL(avgMEG,[-bl,-bl+0.2])
        figure;
        cfg=[];
        cfg.layout='4D248.lay';
        cfg.interactive='yes';
        ft_multiplotER(cfg,avgMEG)
        title('PRESS A KEY TO GO ON')
        pause
        %save seg1 avgEEG samps endSaccS avgMEG
        save (['files/seg',num2str(piskai)],'avgEEG','samps','endSaccS','avgMEG')
        close all;
    end
end


