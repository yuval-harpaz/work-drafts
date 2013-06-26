function alice1(subFold)
cd /home/yuval/Data/alice
cd(subFold)
%% clean HB
try
    LSclean=ls('*hb*');
    megFNc=LSclean(1:end-1);
catch
    LSclean=[];
end
LSraw=ls('c,rf*');
megFN=LSraw(1:end-1);
if isempty(LS)
    p=pdf4D(megFN);
    cleanCoefs = createCleanFile(p, megFN,...
        'byLF',256 ,'Method','Adaptive',...
        'xClean',[4,5,6],...
        'byFFT',0,...
        'HeartBeat',[]);
    LSclean=ls('*hb*')
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
    %megFN='c,rfhp0.1Hz';
    %megFN=['xc,hb,lf_',megFN];
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
if ~exist('./files/topoEOG.mat','file')
    % V
    startSeeg=round(evt(find(evt(:,3)==204,1,'first'))*1024);
    endSeeg=round(evt(find(evt(:,3)==206,1,'last'))*1024);
    sd=std(eog.trial{1,1}(:,startSeeg:endSeeg)');
    indV=2;indH=1;
    if sd(1)>sd(2)*2
        indV=1;indH=2;
    end
    eogSeg=eog.trial{1,1}(:,startSeeg:endSeeg);
    figure;
    plot(eog.time{1,1}(startSeeg:endSeeg),eog.trial{1,1}([indH,indV],startSeeg:endSeeg))
    legend('HEOG','VEOG')
    title('UP-DOWN Eye Movement')
    cfg=[];
    cfg.demean='yes';
    cfg.lpfilter='yes';
    cfg.lpfreq=40;
    cfg.padding=0.7;
    cfg.channel={'EEG',eog.label{indV}};
    cfg.trl=[startSeeg-500,endSeeg+500,-500];
    upDown=readCNT(cfg);
    cfg=[];
    cfg.method='pca';
    comp           = ft_componentanalysis(cfg, upDown);
    % cfg=[];
    % cfg.layout='WG32.lay';
    % cfg.channel = {comp.label{1:5}};
    % cfg.continuous='yes';
    % cfg.blocksize=1;
    % cfgo=ft_databrowser(cfg,comp);
    r=corr([comp.trial{1,1}(1,:)',eog.trial{1,1}(indV,startSeeg-500:endSeeg+500)']);
    if abs(r(1,2)<0.75)
        error('no correlation between pca1 and V EOG')
    end
    topoV=comp.topo(:,1);
    % H
    startSeeg=round(evt(find(evt(:,3)==214,1,'first'))*eog.fsample);
    endSeeg=round(evt(find(evt(:,3)==216,1,'last'))*eog.fsample);
    eogSeg=eog.trial{1,1}(:,startSeeg:endSeeg);
    figure;
    plot(eog.time{1,1}(startSeeg:endSeeg),eog.trial{1,1}([indH,indV],startSeeg:endSeeg))
    legend('HEOG','VEOG')
    title('Right-Left Eye Movement')
    
    % cfg.channel='EEG';%{'HEOG','VEOG'};
    cfg=[];
    cfg.demean='yes';
    cfg.lpfilter='yes';
    cfg.lpfreq=40;
    cfg.padding=0.7;
    cfg.channel={'EEG',eog.label{indV}};
    cfg.trl=[startSeeg-500,endSeeg+500,-500];
    rightLeft=readCNT(cfg);
    
    cfg=[];
    cfg.method='pca';
    comp           = ft_componentanalysis(cfg, rightLeft);
    % cfg=[];
    % cfg.layout='WG32.lay';
    % cfg.channel = {comp.label{1:5}};
    % cfg.continuous='yes';
    % cfg.blocksize=1;
    % cfgo=ft_databrowser(cfg,comp);
    r=corr([comp.trial{1,1}(1,:)',eog.trial{1,1}(indH,startSeeg-500:endSeeg+500)']);
    if abs(r(1,2))<0.75
        error('no correlation between pca1 and H EOG')
    end
    topoH=comp.topo(:,1);
    save files/indEOG indV indH
    save files/topoEOG topoH topoV
end
load files/triggers
if ~exist('./files/topoMOG.mat','file')
    % V
    startSmeg=trigS(find(trigV==204,1,'first'));
    endSmeg=trigS(find(trigV==206,1,'last'));
    cfg=[];
    cfg.demean='yes';
    cfg.lpfilter='yes';
    cfg.lpfreq=40;
    cfg.padding=0.7;
    cfg.channel='MEG';
    cfg.trl=[startSmeg-500,endSmeg+500,-500];
    cfg.dataset=megFNc;
    upDown=ft_preprocessing(cfg);
    cfg=[];
    cfg.method='pca';
    comp           = ft_componentanalysis(cfg, upDown);
    % cfg=[];
    % cfg.layout='WG32.lay';
    % cfg.channel = {comp.label{1:5}};
    % cfg.continuous='yes';
    % cfg.blocksize=1;
    % cfgo=ft_databrowser(cfg,comp);
    load ~/ft_BIU/matlab/plotwts
    figure1=figure('position',[1,1,1500,500]);
    for compi=1:5
        wts.avg=comp.topo(:,compi);
        subplot(1,5,compi)
        ft_topoplotER([],wts);
    end
    answer=inputdlg('ENTER Comp Number for VERTICAL')
    compnum = str2num(answer{1});
    topoH=comp.topo(:,compnum);
    % H
    startSmeg=trigS(find(trigV==214,1,'first'));
    endSmeg=trigS(find(trigV==216,1,'last'));
    cfg=[];
    cfg.demean='yes';
    cfg.lpfilter='yes';
    cfg.lpfreq=40;
    cfg.padding=0.7;
    cfg.channel='MEG';
    cfg.trl=[startSmeg-500,endSmeg+500,-500];
    cfg.dataset=megFNc;
    rightLeft=ft_preprocessing(cfg);
    cfg=[];
    cfg.method='pca';
    comp           = ft_componentanalysis(cfg, rightLeft);
    % cfg=[];
    % cfg.layout='WG32.lay';
    % cfg.channel = {comp.label{1:5}};
    % cfg.continuous='yes';
    % cfg.blocksize=1;
    % cfgo=ft_databrowser(cfg,comp);
    load ~/ft_BIU/matlab/plotwts
    figure1=figure('position',[1,1,1500,500]);
    for compi=1:5
        wts.avg=comp.topo(:,compi);
        subplot(1,5,compi)
        ft_topoplotER([],wts);
    end
    answer=inputdlg('ENTER Comp Number for HORIZONTAL')
    compnum = str2num(answer{1});
    topoH=comp.topo(:,compnum);
    
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
for piskai=2:2:18
    if ~exist(['files/seg',num2str(piskai),'.mat'],'file')
        % EEG
        startSeeg=round(evt(find(evt(:,3)==piskai),1)*1024);
        endSeeg=round(evt(find(evt(:,3)==piskai)+1,1)*1024);
        eogSeg=eog.trial{1,1}(indH,startSeeg:endSeeg);
        plot(eog.time{1,1}(startSeeg:endSeeg),eogSeg);
        legend('HEOG')
        [wordS,rowS]=findSaccade(eogSeg,2,1.5);
        samps=sortrows([wordS,rowS;ones(size(wordS)),3*ones(size(rowS))]');
        samps(:,1)=samps(:,1)+startSeeg-1;
        cfg=[];
        cfg.demean='yes';
        cfg.bpfilter='yes';
        cfg.bpfreq=[1 40];
        cfg.padding=0.7;
        cfg.trl=[samps(:,1)-205,samps(:,1)+614,-205*ones(length(samps),1)];
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
        [~,endSaccS]=max(abs(compAvg.avg(1,205:307)));
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
        avgEEG=correctBL(avgEEG,[-0.2,-0.1])
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
        if ~round(megSR)==1017
            error('problem detecting MEG sampling rate')
        end
        trl=round((samps(:,1)-startSeeg)/1024*megSR)+startSmeg;
        trl=[trl-203,trl+610,-203*ones(size(trl))];
        cfg=[];
        cfg.channel='MEG';%{'HEOG','VEOG'};
        cfg.demean='yes';
        % cfg.blcwindow=[-0.2,-0.1]; ugly!
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
        avgMEG=ft_timelockanalysis(cfg,meg);
        avgMEG.time=avgMEG.time-endSaccS/1024;
        %    avgMEG=correctBL(avgMEG,[-0.2,-0.1])
        figure;
        cfg=[];
        cfg.layout='4D248.lay';
        cfg.interactive='yes';
        ft_multiplotER(cfg,avgMEG)
        title('PRESS A KEY TO GO ON')
        pause
        %save seg1 avgEEG samps endSaccS avgMEG
        save (['files/seg',num2str(piskai)],'avgEEG','samps','endSaccS','avgMEG')
    end
end


%% word by word
% cfg=[];
% % cfg.channel='EEG';%{'HEOG','VEOG'};
% cfg.demean='yes';
% cfg.bpfilter='yes';
% cfg.bpfreq=[1 40];
% cfg.padding=0.7;
% time0=round(1024*evt(evt(:,3)==50,1));
% cfg.trl=[time0-205,time0+614,-205*ones(length(time0),1)];
% eeg=readCNT(cfg);
% cfg=[];
% cfg.channel='EEG';
% avgWBW=ft_timelockanalysis(cfg,eeg);
% avgWBW=correctBL(avgWBW,[-0.1,0])
% cfg=[];
% cfg.layout='WG32.lay';
% cfg.interactive='yes';
% figure;
% ft_multiplotER(cfg,avgWBW)
% save avgWBW avgWBW
% FIXME - correct for diode;
%% MEG
% cd /home/yuval/Data/alice/maor
% load seg1
% % megFN='c,rfhp0.1Hz';
% % megFN=['xc,hb,lf_',megFN];
% trig=readTrig_BIU(megFNc);
% trig=clearTrig(trig);
% startSmeg=find(trig==2);
% endSmeg=find(trig==18,1); % was supposed to be 20
% megSR=(endSmeg-startSmeg)/((endS-startS)/1024);
% trl=round((samps(:,1)-startS)/1024*megSR)+startSmeg;
% trl=[trl-203,trl+610,-203*ones(size(trl))];
%
%
%
%
% cfg=[];
% cfg.channel='MEG';%{'HEOG','VEOG'};
% cfg.demean='yes';
% cfg.bpfilter='yes';
% cfg.bpfreq=[1 40];
% cfg.padding=0.7;
% cfg.trl=trl;
% cfg.dataset=megFNc;
% meg=ft_preprocessing(cfg);
% meg.trialinfo=samps(:,2);
%
%
%
% cfg=[];
% %cfg.channel='MEG';
% cfg.trials=find(samps(:,2)==1);
% avgMEG=ft_timelockanalysis(cfg,meg);
% avgMEG.time=avgMEG.time-endSaccS/1024;
%
% % avgMEG=correctBL(avgMEG,[-0.2,-0.1])
% figure;
% cfg=[];
% cfg.layout='4D248.lay';
% cfg.interactive='yes';
% ft_multiplotER(cfg,avgMEG)
%
%
%
% save seg1 avgEEG samps endSaccS avgMEG
%
%
% % word by word
% time0=find(trig==50)';
% cfg=[];
% % cfg.channel='EEG';%{'HEOG','VEOG'};
% cfg.demean='yes';
% %cfg.blcwindow=[-0.1 0];
% cfg.bpfilter='yes';
% cfg.bpfreq=[1 40];
% cfg.dataset=megFNc;
% cfg.padding=0.7;
% cfg.channel={'MEG','TRIGGER'};
% cfg.trl=[time0-203,time0+614,-203*ones(length(time0),1)];
% meg=ft_preprocessing(cfg);
%
% cfg=[];
% cfg.method='pca';
% comp           = ft_componentanalysis(cfg, meg);
% cfg=[];
% cfg.layout='4D248.lay';
% cfg.channel = {comp.label{1:5}};
% cfgo=ft_databrowser(cfg,comp);
% ca=ft_timelockanalysis([],comp);
% plot(ca.avg(1,:),'g')
% % cfg = [];
% % cfg.component = 1; % change
% % cfg.feedback='no';
% % megca = ft_rejectcomponent(cfg, comp);
% cfg=[];
% cfg.method='pca';
% cfg.channel='MEG';
% comp           = ft_componentanalysis(cfg, meg);
% ca=ft_timelockanalysis([],comp);
%
% y=[ca.avg(1,163),ca.avg(1,343)];
% avgComp=[y(1)*ones(1,162),ca.avg(1,163:343),y(2)*ones(1,length(avgWBWmeg.time)-343)];
% plot(avgComp)
% %avgComp=comp.topo(2:end,1)'*avgWBWmeg.avg(2:end,:);
%
% artifact=repmat(comp.topo(2:end,1),1,length(avgWBWmeg.time)).*repmat(ca.avg(1,:),248,1);
% avgMegCln=avgWBWmeg;
% avgMegCln.avg(2:end,:)=avgWBWmeg.avg(2:end,:)-artifact;
% % cfg=[];
% % cfg.method='summary';
% % cfg.channel='MEG';
% % megcln=ft_rejectvisual(cfg,meg);
% cfg=[];
% %cfg.channel='MEG';
% avgWBWmeg=ft_timelockanalysis(cfg,meg);
%
% cfg = [];
% cfg.component = 1; % change
% cfg.feedback='no';
% avgWBWmegCa = ft_rejectcomponent(cfg, comp,avgWBWmeg);
%
%
%
% cfg=[];
% cfg.layout='4D248.lay';
% cfg.interactive='yes';
% figure;
% ft_multiplotER(cfg,avgMegCln)
% save avgWBWmeg avgWBWmeg

%% old stuff

% see the components and find the HB and MOG artifact
% remember the numbers of the bad components and close the data browser
% load ~/ft_BIU/matlab/plotwts
% wts.avg=compMOG.topo(:,1);
% figure;ft_topoplotER([],wts);
% wts.avg=compMOG.topo(:,2);
% figure;ft_topoplotER([],wts);
%
% megFN='c,rfhp0.1Hz';
% megFN=['xc,hb,lf_',megFN];
% %
%
%
% %trig=readTrig_BIU(megFN);
% %trig=clearTrig(trig);
%
% cfg=[];
% cfg.trl=[starts,ends,starts];
% cfg.demean='yes';
% cfg.lpfilter='yes';
% cfg.lpfreq=40;
% cfg.channel={'MEG'};
% cfg.dataset=['xc,hb,lf_',fileName];
% MOG4pca=ft_preprocessing(cfg);
%
% cfg.trl=[1,length(trig),0];
% %cfg.lpfilter='no';
% cfg.channel={'MEG','X1','X2'};
% cfg.dataset=fileName;
% MOGraw=ft_preprocessing(cfg);
% % cfg=[];
% % cfg.method='summary'; %trial
% % cfg.channel='MEG';
% % cfg.alim=1e-12;
% % MOGcln=ft_rejectvisual(cfg, MOG);
%
%
% cfg=[];
% cfg.method='pca';
% cfg.channel = 'MEG';
% compMOG           = ft_componentanalysis(cfg, MOG4pca);
% % see the components and find the HB and MOG artifact
% % remember the numbers of the bad components and close the data browser
% load ~/ft_BIU/matlab/plotwts
% wts.avg=compMOG.topo(:,1);
% figure;ft_topoplotER([],wts);
% wts.avg=compMOG.topo(:,2);
% figure;ft_topoplotER([],wts);
% % red A154 blue A174
%
% comp_V_H=[compMOG.topo(:,1),compMOG.topo(:,2)]';
% save comp_V_H comp_V_H
% mog_V_H=comp_V_H*MOGraw.trial{1,1}(1:248,:);
%
% s=round(159*1017.25):round(169*1017.25);
% t=MOGraw.time{1,1}(1,s);
% figure;
% plot(t,5e11*mog_V_H(2,s))
% hold on
% plot(t,MOGraw.trial{1,1}(249,s),'c')
% %plot(t,MOGraw.trial{1,1}(1:249,s))
%
% tRS=1.816e05;
% plot(MOGraw.trial{1,1}(249,tRS:tRS+2*10172))
% hold on
% plot(trig(1,tRS:tRS+2*10172)./100,'y')
% plot(5e11*mog_V_H(2,tRS:tRS+2*10172),'m')
% plot(5e11*mog_V_H(1,tRS:tRS+2*10172),'r')
%
% plot(MOGraw.time{1,1}(1,t),MOGraw.trial{1,1}(221,t),'c')
% hold on
% plot(MOGraw.time{1,1}(1,t),MOGraw.trial{1,1}(221,t),'b')
%
% plot(MOGraw.time{1,1}(1,t),MOGraw.trial{1,1}(1:248,t))




% load mog/comp_V_H
% compTrace=[];
% for i=1:find(meg.trialinfo==1)%length(meg.trial)
%     compTrace(i,1:814)=comp_V_H(1,:)*meg.trial{1,i};
% end
% figure;
% plot(meg.time{1,1},mean(compTrace,1));
%
% % pca
% cfg=[];
% cfg.method='pca';
% comp           = ft_componentanalysis(cfg, meg);
% cfg=[];
% cfg.layout='4D248.lay';
% cfg.channel = {comp.label{1:5}};
% cfgo=ft_databrowser(cfg,comp);
% cfg=[];
% cfg.trials=find(meg.trialinfo==1);
% avgComp=ft_timelockanalysis(cfg,comp);
% plot(avgComp.time,avgComp.avg(1:5,:))
% legend('1','2','3','4','5')
% LRcomp=1;
% [~,endSaccS]=max(abs(avgComp.avg(LRcomp,205:307)));
%
% cfg = [];
% cfg.component = LRcomp; % change
% megpca = ft_rejectcomponent(cfg, comp);
%
%
% cfg=[];
% cfg.trl=[1,find(trig==18,1),1];
% cfg.demean='yes';
% cfg.lpfilter='yes';
% cfg.lpfreq=40;
% cfg.channel='MEG';
% cfg.dataset=megFN;
% megcont=ft_preprocessing(cfg);
% MOG=comp_V_H*megcont.trial{1,1};
% plot(1:length(MOG),1e11*MOG,'g')
