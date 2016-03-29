%% define trials
sub='603';
DIR=dir([sub,'*.bdf']);
cfg1=[];
cfg1.dataset=[DIR.name]; %change for each subject
cfg1.trialdef.pre = 0.5;
cfg1.trialdef.post = 1.5;
cfg1.trialdef.offset = -0.5;
cfg1.trl=CEcreateTRL(cfg1);

%% preprocess data, filter 50Hz and 1Hz hp
cfg1.continuous='yes';
cfg1.channel={'all','-Status','-EXG8'};
cfg1.reref         = 'yes';
cfg1.refchannel    = [69 70];
cfg1.demean='yes';
cfg1.baselinewindow=[-0.25 -0.15];
cfg1.hpfreq=1;
cfg1.hpfilter='yes';
cfg1.dftfilter='yes';
save cfg1 cfg1
data=ft_preprocessing(cfg1);

% check bad channels (their SD is more than 2 times the median SD)
for triali=1:length(data.trial)
    SD(1:64,triali)=std(data.trial{triali}(1:64,:),[],2);
end
SD=mean(SD,2);
badChanI=find(SD>2*median(SD));
badChan=data.label(badChanI);
save badChan badChan 
%% look for muscle artifact (you want no bad channels when you check)
% filter for high frequencies
cfg=[];
cfg.bpfilter='yes';
cfg.bpfreq=[110 140];
cfg.channel=1:64;
datahp=ft_preprocessing(cfg,data);

% check noise: for each trial the average across channels and time points
% is computed (average of absolute values). then reject trials with  with
% SD greater than 3
cfg=[];
cfg.badChan=badChan;
trialshp=badTrials(cfg,datahp,1);
clear datahp
%% filter the data of trials with no muscle artifact (1-40Hz)
cfg=[];
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.trials=trialshp;
data=ft_preprocessing(cfg,data);
% create horizontal and vertical EOG channels
data.label{72}='HEOG';
data.label{73}='VEOG';
for triali=1:length(data.trial)
    data.trial{triali}(72,:)=data.trial{triali}(64+1,:)-data.trial{triali}(64+2,:);
    data.trial{triali}(73,:)=data.trial{triali}(64+3,:)-data.trial{triali}(64+7,:);
end
save bp data

%% find blinks
load bp
for triali=1:length(data.trial)
    SD(1:64,triali)=std(data.trial{triali}(1:64,:),[],2);
end
SD=mean(SD,2);
SDSD=std(SD);
badChanI=find(SD>(median(SD)+2.5*SDSD));
if isempty(badChanI)
    badChan='';
else
    badChan=data.label(badChanI);
end
save badChan1 badChan

% resample the data to 256Hz to make it smaller
cfg=[];
cfg.detrend    = 'no';
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
    
% look for good trials
cfg=[];
cfg.badChan=badChan;
cfg.critval=4;
goodTrials=badTrials(cfg,datars,1);

% run component analysis
cfg=[];
cfg.channel=channel;
%cfg.method='pca';
cfg.trials=goodTrials;
comp=ft_componentanalysis(cfg,datars);

% browse components
cfg=[];
cfg.layout='biosemi64.lay';
cfg.channel=comp.label(1:5);
ft_databrowser(cfg,comp)
% choose which component (or components) to reject
compi=[1];
save comp comp compi

%% correct bad channels for single trials (and later blinks)
load comp
load bp
topo=nan(64,1);
[~,chani]=ismember(comp.topolabel,data.label);
topo(chani)=comp.topo(:,compi);
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

% fix permanently bad channels
cfg=[];
cfg.neighbours=neib;
cfg.badchannel=data.label(bad); %check if it took the right channels around!
dataclean1=ft_channelrepair(cfg, data); % this is going to be the really clean data
% fix channels that were bad in few trials
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
        dataclean1.trial(badTrl)=dataclean2.trial; % plant the fixed trials in dataclean1
    end
end
figure;plot(SDchan');

% correct blinks again, on repaired data
for triali=1:length(data.trial)
    blink(triali,1:size(dataclean1.trial{1},2))=topo'*dataclean1.trial{triali}(1:64,:);
end

% correct blinks only for trials where blinks are present 
dataclean2=dataclean1;
for triali=1:length(data.trial)
    if bnk(triali)
        dataclean2.trial{triali}(1:64,:)=dataclean1.trial{triali}(1:64,:)-topo*blink(triali,:);
    end
end
%% reref to average reference
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
save datafinal datafinal

