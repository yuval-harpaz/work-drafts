%% define trials
try
    cd ~/Data/Daniel
catch
    cd /media/yuval/a599eaa1-cc66-4429-9604-79d874cb2efc/home/yuval/Data/Daniel
end
sub='610';
if ~exist([sub,'/bp.mat'],'file')
    DIR=dir([sub,'/*.bdf']);
    cfg1=[];
    cfg1.dataset=[sub,'/',DIR.name]; %change for each subject
    cfg1.trialdef.pre = 0.5;
    cfg1.trialdef.post = 1.5;
    cfg1.trialdef.offset = -0.5;
    cfg1.trl=CEcreateTRL(cfg1);
    
    %% find muscle artifacts
    % preprocess data, filter 50Hz and 1Hz hp
    cfg1.continuous='yes';
    cfg1.channel={'all','-Status','-EXG8'};
    cfg1.reref         = 'yes';
    cfg1.refchannel    = [69 70];
    cfg1.demean='yes';
    cfg1.baselinewindow=[-0.25 -0.15];
    cfg1.hpfreq=1;
    cfg1.hpfilter='yes';
    cfg1.dftfilter='yes';
    data=ft_preprocessing(cfg1);
    % check bad channels
    for triali=1:length(data.trial)
        SD(1:64,triali)=std(data.trial{triali}(1:64,:),[],2);
    end
    SD=mean(SD,2);
    badChanI=find(SD>2*median(SD));
    badChan=data.label(badChanI);
    cfg=[];
    cfg.bpfilter='yes';
    cfg.bpfreq=[110 140];
    cfg.channel=1:64;
    datahp=ft_preprocessing(cfg,data);
    cfg=[];
    cfg.badChan=badChan;
    trialshp=badTrials(cfg,datahp,1);
    clear datahp
    cfg=[];
    cfg.bpfilter='yes';
    cfg.bpfreq=[1 40];
    cfg.trials=trialshp;
    data=ft_preprocessing(cfg,data);
    % R=zeros(4,4);
    % for triali=1:length(comp.trial)
    %     r=corr(datars.trial{triali}([65:67,71],:)');
    %     r(r>-0.65)=0;
    %     R=R+r;
    % end
    % R=R./triali;
    
    data.label{72}='HEOG';
    data.label{73}='VEOG';
    for triali=1:length(data.trial)
        data.trial{triali}(72,:)=data.trial{triali}(64+1,:)-data.trial{triali}(64+2,:);
        data.trial{triali}(73,:)=data.trial{triali}(64+3,:)-data.trial{triali}(64+7,:);
    end
    save([sub,'/bp.mat'],'data','cfg1','badChan','trialshp')
else
    load([sub,'/bp.mat'])
end

if ~exist([sub,'/comp.mat'],'file')
    cfg=[];
    %cfg.resamplefs = ;
    cfg.detrend    = 'no';
    %   cfg.demean     = 'no'
    datars=ft_resampledata(cfg,data);
    % list the channels to be used
    channel={'EEG'};
    if ~isempty(badChanI)
        for chani=1:length(badChanI)
            channel{1,chani+1}=['-',badChan{chani}];
        end
    end
    % cfg=[];
    % cfg.method='summary';
    % cfg.channel=channel;
    % cfg.keepchannel='yes';
    % datars=ft_rejectvisual(cfg,datars)
    goodTrials=badTrials([],datars,1);
    
    cfg=[];
    cfg.channel=channel;
    %cfg.channel{end+1}='VEOG';
    %cfg.channel{end+1}='EXG3';
    cfg.method='pca';
    cfg.trials=goodTrials;
    comp=ft_componentanalysis(cfg,datars);
    
    R=zeros(20,1);
    for triali=1:length(comp.trial)
        R=R+corr(comp.trial{triali}(1:length(R),:)',datars.trial{triali}(73,:)');
    end
    R=R./triali;
    [~,compi1]=max(abs(R));
    % the blink should be all positive or all negative component
    [~,compi2]=max(abs(sum(comp.topo(:,1:20)./abs(comp.topo(:,1:20)))));
    if compi1==compi2
        compi=compi1;
        save([sub,'/comp'],'comp','compi')
    else
        % FIXME ask which component is blink with figures
        error('which is blink?')
    end
else
    load([sub,'/comp.mat'])
end
% find horizontal component
% check which component is most correlted with the eog channel
if ~exist([sub,'/datafinal.mat'],'file')
    topo=nan(64,1);
    [~,chani]=ismember(comp.topolabel,data.label);
    topo(chani)=comp.topo(:,compi);
    % topoplotB64(topo)
    
    % cfg=[];
    % cfg.layout='biosemi64.lay';
    % cfg.channel=comp.label(1:5);
    % ft_databrowser(cfg,comp)
    
    %FIXME - fix data bad channels trial by trial, correct blinks, reject more trials and average
    
    % fix blink topography map
    bad=find(isnan(topo));
    topo(bad)=0;
    load sens
    load neib
    
    
    data.elec=sens;
    dataclean=data;
    % make blink timecourse, not so good because of bad channels
    for triali=1:length(data.trial)
        blink(triali,1:size(data.trial{1},2))=topo'*data.trial{triali}(1:64,:);
    end
    % assess in which trials there are blink
    for triali=1:length(data.trial)
        bnk(triali,1)=sum(blink(triali,:)>200)>0;
    end
    % clean the data from blinks crudely, despite bad channels
    for triali=1:length(data.trial)
        if bnk(triali)
            dataclean.trial{triali}(1:64,:)=data.trial{triali}(1:64,:)-topo*blink(triali,:);
        end
    end
    topo(bad)=nan;
    % fix blink topo
    for badi=bad'
        neibi=find(ismember(data.label(1:64),neib(badi).neighblabel));
        topo(badi)=nanmean(topo(neibi));
    end
    % fix permanently bad channels
    cfg=[];
    cfg.neighbours=neib;
    cfg.badchannel=data.label(bad); %check if it took the right channels around!
    dataclean1=ft_channelrepair(cfg, data); % this is going to be the really clean data
    badThreshold=150;
    for chani=1:64
        for triali=1:length(data.trial)
            SDchan(chani,triali)=std(dataclean.trial{triali}(chani,:)');
            %check if it took the right channels around!
            %cfg.trials=[1];
        end
        badTrl=find(SDchan(chani,:)>badThreshold);
        if ~isempty(badTrl);
            %BAD=unique(bad,
            cfg.badchannel=data.label(chani);
            cfg.trials=badTrl;
            dataclean2=ft_channelrepair(cfg, dataclean1); % this has few fixed trials
            dataclean1.trial(badTrl)=data.trial; % plant the fixed trials in dataclean1
        end
    end
    figure;plot(SDchan');
    
    % correct blinks again, on repaired data
    for triali=1:length(data.trial)
        blink(triali,1:size(dataclean1.trial{1},2))=topo'*dataclean1.trial{triali}(1:64,:);
    end
    % assess in which trials there are blink
    % for triali=1:length(dataclean1.trial)
    %     bnk(triali,1)=sum(blink(triali,:)>200)>0;
    % end
    dataclean2=dataclean1;
    for triali=1:length(data.trial)
        if bnk(triali)
            dataclean2.trial{triali}(1:64,:)=dataclean1.trial{triali}(1:64,:)-topo*blink(triali,:);
        end
    end
    
    cfg=[];
    cfg.reref='yes';
    cfg.refchannel=1:64;
    cfg.channel=1:64;
    datafinal=ft_preprocessing(cfg,dataclean2);
    trials=badTrials([],datafinal,1)
    cfg=[];
    cfg.trials=trials;
    avg=ft_timelockanalysis(cfg,datafinal);
    figure;plot(avg.time,avg.avg(1:64,:)','b')
    save ([sub,'/datafinal.mat'],'datafinal')
end
% cfg=[];
% cfg.badChan=badChan;
% trials=badTrials(cfg,data,1);
%
%
% cfg=[];
% cfg.dataset=DIR.name;
% cfg.trl=trl;
% cfg.channel={'all','-Status','-EXG8'};
% cfg.demean='yes';
% cfg.baselinewindow=[-0.25 -0.15];
% cfg.bpfilter='yes';
% cfg.bpfreq=[1 40];
% cfg.reref         = 'yes';
% cfg.refchannel    = 'all';
% data=ft_preprocessing(cfg);
% avg=ft_timelockanalysis([],data);
%
%
%
%
% cfg=[];
% cfg.badChan=badChan;
% trials=badTrials(cfg,data,0);
% cfg=[];
% cfg.trials=trials;
% %badTrials([],data)
% avg=ft_timelockanalysis(cfg,data);
% time=avg.time;
% avg=avg.avg;
% avg(badChanI,:)=0;
% AVG(1:64,1:1025,subi)=avg(1:64,:);
%
%
% data50=dftloop
%
% avg=ft_timelockanalysis([],data);
% plot(avg.time,avg.avg)
%
% % view artifacts using Fieldtrip
% cfg=[];
% cfg.method='summary';
% cfg.preproc.hpfreq=60;
% cfg.preproc.hpfilter='yes';
% clean=ft_rejectvisual(cfg, data);
%
%
%
% %% preprocess the data
% cfg1=[];
% cfg1.demean='yes'; % normalize the data according to the base line average time window (see two lines below)
% cfg1.continuous='yes';
% cfg1.baselinewindow=[-0.2,0];
% cfg1.bpfilter='yes';
% cfg1.bpfreq=[1 30];
% %cfg1.padding = 10;
% %cfg1.reref         = 'yes';
% %cfg1.refchannel    = [69 70];
% data=ft_preprocessing(cfg1,clean);
% save data data
% clearvars -except data
%
% %% ica
% % run ica
% cfg            = [];
% cfg.resamplefs = 200;
% cfg.detrend    = 'no';
% dummy           = ft_resampledata(cfg, data);
%
% % run ica
% cfg            = [];
% comp           = ft_componentanalysis(cfg, dummy);
% save comp comp*
%
% % see the components and find the artifact
% cfg=[];
% cfg.comp=1:10;
% cfg.viewmode='component';
% cfg.layout='biosemi64.lay';
% ft_databrowser(cfg,comp);
%
% figure;
% seeOneCompTopo(cfg,comp,2) % view the components before rejection
%
% % run the ICA in the original data
% cfg = [];
% cfg.topo      = comp.topo;
% cfg.topolabel = comp.topolabel;
% comp_orig     = ft_componentanalysis(cfg, data);
%
% % remove the artifact component
% cfg = [];
% cfg.component = [1,2,3,9,10]; %change
% dataica = ft_rejectcomponent(cfg, comp_orig);
% save dataica dataica
%
% %% visual rejection
% cfg=[];
% cfg.method='trial';
% cfg.alim=[];
% UNIT833=ft_rejectvisual(cfg, dataica);
%
% %new trials after removal
% cfg=[];
% cfg.method='trial';
% cfg.alim=[];
% ft_rejectvisual(cfg, UNIT833);
%
% % interpolation
% cfg=[];
% cfg.layout='biosemi64.lay';
% lay = ft_prepare_layout(cfg);
% sens = [];
% sens.label = lay.label;
% sens.pnt = lay.pos;
% sens.pnt(:,3) = 0;
% intUNIT833=UNIT833;
% cfg.neighbourdist=0.15;
% intUNIT833.elec=sens;
%
% % select channels to repair
% cfg.badchannel={'T7'}; %check if it took the right channels around!
% cfg.trials=[1];   % the number of the channel might change
% intUNIT833=ft_channelrepair(cfg, intUNIT833);
%
% % repair channels
% trials4Inter=[min(cfg.trials) max(cfg.trials)];% array that includes the first and last trials number waiting for interpolation
% j=1;
% for ind=trials4Inter(1):trials4Inter(2)
%     UNIT833.trial{1,ind}(find(strcmp(UNIT833.label,cfg.badchannel)),:)=intUNIT833.trial{1,j}(find(strcmp(UNIT833.label,cfg.badchannel)),:);
%     j=j+1;
% end
%
% % by summary
% cfg=[];
% cfg.method='summary';
% cfg.channel={'EEG'};
% cfg.alim=[];
% UNIT833=ft_rejectvisual(cfg, UNIT833);
%
% %% blc correction and index restore
% cfg=[];
% cfg.blc='yes';
% cfg.blcwindow=[-0.2 0];
% UNIT833=ft_preprocessing(cfg,UNIT833);
% UNIT833.cfg.previous.trl(:,4:size(UNIT833.trialinfo,2)+3)=UNIT833.trialinfo;
% save UNIT833 UNIT833
%
% % plot data from all trials
% cfg=[];
% cfg.layout = 'biosemi64.lay';
% cfg.interactive = 'yes';
% figure
% ft_multiplotER(cfg,ft_timelockanalysis(cfg,UNIT833))
%
% %% split and average
%
% % re-new rearrange correct
% cfg.trig = 21; %related - repeat (col 4)
% cfg.resp = 1; %correct response (col 7)
% UNIT833RelRpt=split_dataUNIT(cfg,UNIT833);
% avUNIT833RelRpt=ft_timelockanalysis(cfg,UNIT833RelRpt);
%
% cfg.trig = 22; %unrelated - repeat (col 4)
% cfg.resp = 1; %correct response (col 7)
% UNIT833UnrelRpt=split_dataUNIT(cfg,UNIT833);
% avUNIT833UnrelRpt=ft_timelockanalysis(cfg,UNIT833UnrelRpt);
%
% cfg.trig = 23; %related - repair (col 4)
% cfg.resp = 1; %correct response (col 7)
% UNIT833RelRpr=split_dataUNIT(cfg,UNIT833);
% avUNIT833RelRpr=ft_timelockanalysis(cfg,UNIT833RelRpr);
%
% cfg.trig = 24; %unrelated - repair (col 4)
% cfg.resp = 1; %correct response (col 7)
% UNIT833UnrelRpr=split_dataUNIT(cfg,UNIT833);
% avUNIT833UnrelRpr=ft_timelockanalysis(cfg,UNIT833UnrelRpr);
%
% cfg.trig = 25; %related - new (col 4)
% cfg.resp = 1; %correct response (col 7)
% UNIT833RelNew=split_dataUNIT(cfg,UNIT833);
% avUNIT833RelNew=ft_timelockanalysis(cfg,UNIT833RelNew);
%
% cfg.trig = 26; %unrelated - new (col 4)
% cfg.resp = 1; %correct response (col 7)
% UNIT833UnrelNew=split_dataUNIT(cfg,UNIT833);
% avUNIT833UnrelNew=ft_timelockanalysis(cfg,UNIT833UnrelNew);
%
% numOfTrials = [length(UNIT833RelRpt.trial) length(UNIT833UnrelRpt.trial) length(UNIT833RelRpr.trial) length(UNIT833UnrelRpr.trial) length(UNIT833RelNew.trial) length(UNIT833UnrelNew.trial)]
%
% save UNIT833raw UNIT833*
% save UNIT833_avg av*
%
% %% plot
% cfg=[];
% cfg.interactive='yes';
% cfg.layout='biosemi64.lay';
% figure;
% ft_multiplotER(cfg,ft_timelockanalysis(cfg,UNIT833))
% figure;
% ft_multiplotER(cfg,avUNIT833RelRpt,avUNIT833RelNew);
% figure;
% ft_multiplotER(cfg,avUNIT833UnrelRpt,avUNIT833UnrelNew);
%
