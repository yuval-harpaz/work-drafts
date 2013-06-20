fileName='c,rfDC';
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
cfg.dataset=['xc,hb,lf_',fileName];
MOG4pca=ft_preprocessing(cfg);

cfg.trl=[1,length(trig),0];
%cfg.lpfilter='no';
cfg.channel={'MEG','X1','X2'};
cfg.dataset=fileName;
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
wts.avg=compMOG.topo(:,2);
figure;ft_topoplotER([],wts);
% red A154 blue A174

comp_V_H=[compMOG.topo(:,1),compMOG.topo(:,2)]';
save comp_V_H comp_V_H
mog_V_H=comp_V_H*MOGraw.trial{1,1}(1:248,:);

s=round(159*1017.25):round(169*1017.25);
t=MOGraw.time{1,1}(1,s);
figure;
plot(t,5e11*mog_V_H(2,s))
hold on
plot(t,MOGraw.trial{1,1}(249,s),'c')
%plot(t,MOGraw.trial{1,1}(1:249,s))

tRS=1.816e05;
plot(MOGraw.trial{1,1}(249,tRS:tRS+2*10172))
hold on
plot(trig(1,tRS:tRS+2*10172)./100,'y')
plot(5e11*mog_V_H(2,tRS:tRS+2*10172),'m')
plot(5e11*mog_V_H(1,tRS:tRS+2*10172),'r')

plot(MOGraw.time{1,1}(1,t),MOGraw.trial{1,1}(221,t),'c')
hold on
plot(MOGraw.time{1,1}(1,t),MOGraw.trial{1,1}(221,t),'b')

plot(MOGraw.time{1,1}(1,t),MOGraw.trial{1,1}(1:248,t))
