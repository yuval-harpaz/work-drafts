%% Unitization Exp1 - Semantic (use with fieldtrip-60260216)

%% define trials
DIR=dir('*.bdf');
cfg=[];
cfg.dataset=DIR.name; %change for each subject
cfg.trialdef.pre = 0.5;
cfg.trialdef.post = 1.5;
cfg.trialdef.offset = -0.5;
trl=CEcreateTRL(cfg);
save trl trl
%% find muscle artifacts
% preprocess data for artifact rejection
cfg.continuous='yes';
cfg.channel={'all','-Status','-EXG8'};
cfg.reref         = 'yes';
cfg.refchannel    = [69 70];
cfg.demean='yes';
data=ft_preprocessing(cfg);

avg=ft_timelockanalysis([],data);
plot(avg.time,avg.avg)

% view artifacts using Fieldtrip
cfg=[];
cfg.method='summary';
cfg.preproc.hpfreq=60;
cfg.preproc.hpfilter='yes';
clean=ft_rejectvisual(cfg, data);



%% preprocess the data
cfg1=[];
cfg1.demean='yes'; % normalize the data according to the base line average time window (see two lines below)
cfg1.continuous='yes';
cfg1.baselinewindow=[-0.2,0];
cfg1.bpfilter='yes';
cfg1.bpfreq=[1 30];  
%cfg1.padding = 10;
%cfg1.reref         = 'yes';
%cfg1.refchannel    = [69 70];
data=ft_preprocessing(cfg1,clean);
save data data
clearvars -except data

%% ica
% run ica
cfg            = [];
cfg.resamplefs = 200;
cfg.detrend    = 'no';
dummy           = ft_resampledata(cfg, data);

% run ica
cfg            = [];
comp           = ft_componentanalysis(cfg, dummy);
save comp comp*

% see the components and find the artifact 
cfg=[];
cfg.comp=1:10;
cfg.viewmode='component';
cfg.layout='biosemi64.lay';
ft_databrowser(cfg,comp);

figure;
seeOneCompTopo(cfg,comp,2) % view the components before rejection 

% run the ICA in the original data 
cfg = [];
cfg.topo      = comp.topo;
cfg.topolabel = comp.topolabel;
comp_orig     = ft_componentanalysis(cfg, data);

% remove the artifact component 
cfg = [];
cfg.component = [1,2,3,9,10]; %change
dataica = ft_rejectcomponent(cfg, comp_orig);
save dataica dataica

%% visual rejection
cfg=[];
cfg.method='trial'; 
cfg.alim=[];
UNIT833=ft_rejectvisual(cfg, dataica); 

%new trials after removal
cfg=[];
cfg.method='trial'; 
cfg.alim=[];
ft_rejectvisual(cfg, UNIT833); 

% interpolation
cfg=[];
cfg.layout='biosemi64.lay';
lay = ft_prepare_layout(cfg);
  sens = [];
  sens.label = lay.label;
  sens.pnt = lay.pos;
  sens.pnt(:,3) = 0;
intUNIT833=UNIT833;
cfg.neighbourdist=0.15;
intUNIT833.elec=sens;

% select channels to repair
cfg.badchannel={'T7'}; %check if it took the right channels around!
cfg.trials=[1];   % the number of the channel might change
intUNIT833=ft_channelrepair(cfg, intUNIT833);

% repair channels
trials4Inter=[min(cfg.trials) max(cfg.trials)];% array that includes the first and last trials number waiting for interpolation
j=1;
for ind=trials4Inter(1):trials4Inter(2)
    UNIT833.trial{1,ind}(find(strcmp(UNIT833.label,cfg.badchannel)),:)=intUNIT833.trial{1,j}(find(strcmp(UNIT833.label,cfg.badchannel)),:);
    j=j+1;
end

% by summary
cfg=[];
cfg.method='summary'; 
cfg.channel={'EEG'};
cfg.alim=[];
UNIT833=ft_rejectvisual(cfg, UNIT833);

%% blc correction and index restore
cfg=[];
cfg.blc='yes';
cfg.blcwindow=[-0.2 0];
UNIT833=ft_preprocessing(cfg,UNIT833);
UNIT833.cfg.previous.trl(:,4:size(UNIT833.trialinfo,2)+3)=UNIT833.trialinfo;
save UNIT833 UNIT833

% plot data from all trials
cfg=[];
cfg.layout = 'biosemi64.lay';
cfg.interactive = 'yes';
figure
ft_multiplotER(cfg,ft_timelockanalysis(cfg,UNIT833)) 

%% split and average

% re-new rearrange correct
cfg.trig = 21; %related - repeat (col 4)
cfg.resp = 1; %correct response (col 7)
UNIT833RelRpt=split_dataUNIT(cfg,UNIT833);
avUNIT833RelRpt=ft_timelockanalysis(cfg,UNIT833RelRpt);

cfg.trig = 22; %unrelated - repeat (col 4)
cfg.resp = 1; %correct response (col 7)
UNIT833UnrelRpt=split_dataUNIT(cfg,UNIT833);
avUNIT833UnrelRpt=ft_timelockanalysis(cfg,UNIT833UnrelRpt);

cfg.trig = 23; %related - repair (col 4)
cfg.resp = 1; %correct response (col 7)
UNIT833RelRpr=split_dataUNIT(cfg,UNIT833);
avUNIT833RelRpr=ft_timelockanalysis(cfg,UNIT833RelRpr);

cfg.trig = 24; %unrelated - repair (col 4)
cfg.resp = 1; %correct response (col 7)
UNIT833UnrelRpr=split_dataUNIT(cfg,UNIT833);
avUNIT833UnrelRpr=ft_timelockanalysis(cfg,UNIT833UnrelRpr);

cfg.trig = 25; %related - new (col 4)
cfg.resp = 1; %correct response (col 7)
UNIT833RelNew=split_dataUNIT(cfg,UNIT833);
avUNIT833RelNew=ft_timelockanalysis(cfg,UNIT833RelNew);

cfg.trig = 26; %unrelated - new (col 4)
cfg.resp = 1; %correct response (col 7)
UNIT833UnrelNew=split_dataUNIT(cfg,UNIT833);
avUNIT833UnrelNew=ft_timelockanalysis(cfg,UNIT833UnrelNew);

numOfTrials = [length(UNIT833RelRpt.trial) length(UNIT833UnrelRpt.trial) length(UNIT833RelRpr.trial) length(UNIT833UnrelRpr.trial) length(UNIT833RelNew.trial) length(UNIT833UnrelNew.trial)]
    
save UNIT833raw UNIT833*  
save UNIT833_avg av* 
 
%% plot
cfg=[];
cfg.interactive='yes';
cfg.layout='biosemi64.lay';
figure;
ft_multiplotER(cfg,ft_timelockanalysis(cfg,UNIT833))
figure;
ft_multiplotER(cfg,avUNIT833RelRpt,avUNIT833RelNew);
figure;
ft_multiplotER(cfg,avUNIT833UnrelRpt,avUNIT833UnrelNew);

