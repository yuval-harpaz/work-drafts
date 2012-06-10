
fn='c,rfhp0.1Hz,ee,o';

p=pdf4D(fn);
cleanCoefs = createCleanFile(p, fn,...
    'byLF',0 ,...
    'chans2ignore',[74,204],...
    'byFFT',0,...
    'HeartBeat',[]);

% cleanCoefs = createCleanFile(p, fn,...
%     'byLF',256 ,'Method','Adaptive',...
%     'xClean',[4,5,6],...
%     'chans2ignore',[74,204],...
%     'byFFT',0,...
%     'HeartBeat',0,... % use [] for automatic HB cleaning, use 0 to avoid HB cleaning
%     'maskTrigBits', 512);
fn=['hb_',fn];
trig=readTrig_BIU(fn);
trig=fixVisTrig(trig,200);
unique(trig)
cfg=[];
cfg.dataset=fn;
cfg.trialdef.eventvalue=[200,210,220];
cfg.trialdef.eventtype='TRIGGER';
cfg.trialdef.prestim=0.2;
cfg.trialdef.poststim=0.7;
cfg.trialdef.offset=-0.2;
cfg=ft_definetrial(cfg);
cfg.channel={'MEG','-A74','-A204'};
cfg.demean='yes';
cfg.baselinewindow=[-0.2 0];
% cfg.bpfilter='yes';
% cfg.bpfreq=[3 30];
data=ft_preprocessing(cfg);

cfg            = [];
cfg.method    = 'pca';
comp           = ft_componentanalysis(cfg, data);
cfg=[];
cfg.layout='4D248.lay';
cfg.channel = 1:5;
ft_databrowser(cfg,comp);
% comp.trial(1,2:end+1)=comp.trial;
% comp.time(1,2:end+1)=comp.time;
% avgcomp=ft_timelockanalysis([],comp);
% comp.trial{1,1}=avgcomp.avg;
% comp.sampleinfo(2:end+1,:)=comp.sampleinfo;
% comp.trialinfo(2:end+1,:)=comp.trialinfo;
for tri=1:length(comp.trial)
    trStd(1:2,tri)=std(comp.trial{1,tri}(1:2,102:508)');
end
plot(1:360,trStd,'o');

mx=max(trStd);
z=zscore(mx);



% cfg = [];
% cfg.component = [1 2]; % change
% data = ft_rejectcomponent(cfg, comp);

% cfg=[];
% cfg.method='summary'; %trial
% cfg.channel='MEG';
% %cfg.alim=1e-12;
% data=ft_rejectvisual(cfg, data);

cfg=[];
cfg.trials=find(z<2);
avg=ft_timelockanalysis(cfg,data);
avg=correctBL(avg,[-0.1 0]);
cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
ft_multiplotER(cfg,avg);

% x=0.144
cfg=[];
cfg.layout='4D248.lay';
cfg.channel = {'A215','A191'};
ft_databrowser(cfg,data);

