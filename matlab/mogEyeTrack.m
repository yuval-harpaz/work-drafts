fileName='c,rfDC';
p=pdf4D(fileName);
cleanCoefs = createCleanFile(p, fileName,...
    'byLF',256 ,'Method','Adaptive',...
    'xClean',[4,5,6],...
    'byFFT',0,...
    'HeartBeat',[]);

fileName=['xc,hb,lf_',fileName];
trig=readTrig_BIU(fileName);
trig=clearTrig(trig);

starts=find(trig==200,1);
ends=find(trig==20,1);
cfg=[];
cfg.trl=[starts,ends,starts];
cfg.demean='yes';
cfg.lpfilter='yes';
cfg.lpfreq=40;
cfg.channel={'MEG'};
cfg.dataset=fileName;
MOG4pca=ft_preprocessing(cfg);

cfg.trl=[1,length(trig),0];
cfg.lpfilter='no';
cfg.channel={'MEG','X1','X2'};
MOGraw=ft_preprocessing(cfg);
% cfg=[];
% cfg.method='summary'; %trial
% cfg.channel='MEG';
% cfg.alim=1e-12;
% MOGcln=ft_rejectvisual(cfg, MOG);


cfg=[];
cfg.method='pca';
cfg.channel = 'MEG';
compMOG           = ft_componentanalysis(cfg, MOG4pca);
% see the components and find the HB and MOG artifact
% remember the numbers of the bad components and close the data browser
load ~/ft_BIU/matlab/plotwts
wts.avg=compMOG.topo(:,1);
figure;ft_topoplotER([],wts);
% red A154 blue A174

cfg=[];
cfg.layout='4D248.lay';
cfg.channel = {compMOG.label{1:5}};
cfg.continuous='yes';
cfg.event.type='';
cfg.event.sample=1;%startt*1017.25+1;
cfg.blocksize=3;
comppic=ft_databrowser(cfg,compMOG);


mogV=compMOG.topo(:,1)'*MOGraw.trial{1,1}(1:248,:);
mogH=compMOG.topo(:,2)'*MOGraw.trial{1,1}(1:248,:);
figure;
plot(MOGraw.time{1,1},MOGraw.trial{1,1}(250,:))
hold on
plot(MOG.time{1,1},2*mogV./(max(abs(mogV))),'r')
plot(MOG.time{1,1},2*MOG.trial{1,1}(221,:)./(max(abs(MOG.trial{1,1}(221,:)))),'c')


plot(MOG.time{1,1},MOG.trial{1,1}(249,:))

t=round(159*1017.25):round(169*1017.25)
plot(MOGraw.time{1,1}(1,t),MOGraw.trial{1,1}(221,t),'c')
hold on
plot(MOGraw.time{1,1}(1,t),MOGraw.trial{1,1}(221,t),'b')

plot(MOGraw.time{1,1}(1,t),MOGraw.trial{1,1}(1:248,t))
