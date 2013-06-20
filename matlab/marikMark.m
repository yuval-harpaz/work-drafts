cd /home/yuval/Data/camera
fileName1='1/xc,hb,lf_c,rfhp0.1Hz';
fileName2='2/xc,hb,lf_c,rfhp0.1Hz';

%% clean 
% p=pdf4D(fileName1);
% cleanCoefs = createCleanFile(p, fileName1,...
%     'byLF',256 ,'Method','Adaptive',...
%     'xClean',[4,5,6],...
%     'byFFT',0,...
%     'HeartBeat',[]);
% 
% p=pdf4D(fileName2);
% cleanCoefs = createCleanFile(p, fileName2,...
%     'byLF',256 ,'Method','Adaptive',...
%     'xClean',[4,5,6],...
%     'byFFT',0,...
%     'HeartBeat',[]);

%% read and reject artifacts run1
trig=readTrig_BIU(fileName1);
trig=clearTrig(trig);
trl=find(trig==2);
trl=trl(2:end);
cfg=[];
cfg.trl=trl'-102;
cfg.trl(:,2)=trl+306;
cfg.trl(:,3)=-102;
cfg.dataset=fileName1;
cfg.demean='yes';
%cfg.baselinewindow=[-0.1 0];
cfg.bpfilter='yes';
cfg.bpfreq=[3 30];
cfg.channel='MEG';
cfg.feedback='no';
cfg.padding = 1;
Ind=ft_preprocessing(cfg);




% cfgc            = [];
% %cfgc.method='pca';
% cfgc.numcomponent=20;
% comp           = ft_componentanalysis(cfgc, Ind);
% 
% %see the components and find the artifact
% cfgb=[];
% cfgb.layout='4D248.lay';
% cfgb.channel = {comp.label{1:5}};
% cfgbo=ft_databrowser(cfgb,comp);

cfg=[];
cfg.method='summary';
cfg.channel='MEG';
cfg.alim=1e-12;
IndCln=ft_rejectvisual(cfg, Ind);
iAvg=ft_timelockanalysis([],IndCln);
t=0.052;
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[t t];
cfg.interactive='yes';
figure;
ft_topoplotER(cfg,iAvg);
%% read and reject artifacts run2
trig=readTrig_BIU(fileName2);
trig=clearTrig(trig);
trl=find(trig==2);
cfg=[];
cfg.trl=trl'-102;
cfg.trl(:,2)=trl+306;
cfg.trl(:,3)=-102;
cfg.dataset=fileName2;
cfg.demean='yes';
%cfg.baselinewindow=[-0.1 0];
cfg.bpfilter='yes';
cfg.bpfreq=[3 30];
cfg.channel={'MEG'};
cfg.feedback='no';
cfg.padding = 1;
Ind2=ft_preprocessing(cfg);
cfg=[];
cfg.method='summary';
cfg.channel='MEG';
cfg.alim=1e-12;
Ind2Cln=ft_rejectvisual(cfg, Ind2);
i2Avg=ft_timelockanalysis([],Ind2Cln);

% fix bad A164, A185
i163=find(ismember(iAvg.label,'A163'));
i185=find(ismember(iAvg.label,'A185'));
i203=find(ismember(iAvg.label,'A203'));
i136=find(ismember(iAvg.label,'A136'));
i164=find(ismember(iAvg.label,'A164'));
i186=find(ismember(iAvg.label,'A186'));
i2Avg.avg(i185,:)=(i2Avg.avg(i163,:)+i2Avg.avg(i203,:))./2;
%li2Avg.avg(i185,:)=li2Avg.avg(i185,:)+1e-15.*(rand(size(li2Avg.avg(i185,:)))-0.5);
i2Avg.avg(i164,:)=(i2Avg.avg(i136,:)+i2Avg.avg(i186,:))./2;

t=0.052;
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[t t];
%cfg.interactive='yes';
figure;
ft_topoplotER(cfg,i2Avg);
figure;
ft_topoplotER(cfg,iAvg);
save averages iAvg i2Avg
%% create headmodels
cd 1
[vol,grid,~,M1]=headmodel_BIU([],[],5,[],'localspheres');
save headmodel vol grid M1
!rm modte*
cd ../2
[vol,grid,~,M1]=headmodel_BIU([],[],5,[],'localspheres');
save headmodel vol grid M1
!rm modte*
cd ..
%% unify headmodels
load 1/headmodel
vol1=vol;
load 2/headmodel
chanN=length(vol1.label);
vol2=vol;
vol=rmfield(vol1,'cfg');
vol.r=[vol1.r;vol2.r];
vol.o=[vol1.o;vol2.o];
grad=rmfield(vol1.cfg.grad,'balance');
grad.label=vol.label;
grad.chanori(chanN+1:2*chanN,:)=vol2.cfg.grad.chanori;
grad.chanpos(chanN+1:2*chanN,:)=vol2.cfg.grad.chanpos;
grad.chantype(chanN+1:2*chanN,:)=vol2.cfg.grad.chantype;
grad.chanunit(chanN+1:2*chanN,:)=vol2.cfg.grad.chanunit;
grad.coilori(chanN+1:2*chanN,:)=vol2.cfg.grad.coilori;
grad.coilpos(chanN+1:2*chanN,:)=vol2.cfg.grad.coilpos;
for chi=1:chanN
    vol.label{chanN+chi,1}=[vol1.label{chi,1},'B'];
end
load averages
avgBoth=rmfield(iAvg,'dof');
avgBoth=rmfield(avgBoth,'cfg');
avgBoth.avg=[iAvg.avg;i2Avg.avg];
avgBoth.var=[iAvg.var;i2Avg.var];
avgBoth.grad=ft_convert_units(grad,'mm');
for chi=1:248
    avgBoth.label{248+chi,1}=[iAvg.label{chi,1},'B'];
end
avgBoth.grad.tra=iAvg.grad.tra;
avgBoth.grad.tra(271+1:271*2,276+1:276*2)=iAvg.grad.tra;
save avgBoth avgBoth
save vol vol
%% dipole fit

cd 1;
load headmodel
load ../averages
liAvg.grad=ft_convert_units(liAvg.grad,'mm');
cfg = [];
cfg.latency = [t t];  % specify latency window around M50 peak
cfg.numdipoles = 1;
cfg.vol=vol;
cfg.feedback = 'textbar';
cfg.gridsearch='yes';
dip = ft_dipolefitting(cfg, liAvg);

hs=ft_read_headshape('hs_file');
figure;plot3pnt(hs.pnt,'ro');
hold on;
ft_plot_dipole(dip.dip.pos/1000,dip.dip.mom/1000,'units','m')

cd /home/yuval/Data/camera/2;
load headmodel
li2Avg.grad=ft_convert_units(li2Avg.grad,'mm');
cfg = [];
cfg.latency = [t t];  % specify latency window around M50 peak
cfg.numdipoles = 1;
cfg.vol=vol;
cfg.feedback = 'textbar';
cfg.gridsearch='yes';
dip = ft_dipolefitting(cfg, li2Avg);

ft_plot_dipole(dip.dip.pos/1000,dip.dip.mom/1000,'units','m','color','green');

%% remove refs from grad
grad=iAvg.grad;
megi=ismember(grad.chantype,'meg');

grad.chanori=[grad.chanori(megi,:);grad.chanori(megi,:)];
grad.chanpos=[grad.chanpos(megi,:);grad.chanpos(megi,:)];
grad.chantype=grad.chantype(megi,:);
grad.chantype(249:496)=grad.chantype;
grad.chanunit=grad.chanunit(megi,:);
grad.chanunit(249:496)=grad.chanunit;
grad.coilori=[grad.coilori(megi,:);grad.coilori(megi,:)];
grad.coilpos=[grad.coilpos(megi,:);grad.coilpos(megi,:)];

grad.label=avgBoth.label;
grad.tra=eye(248*2);
grad=ft_convert_units(grad,'mm')
save grad496 grad
%% hybrid model dipole fit
cd /home/yuval/Data/camera
load vol
load avgBoth
load grad496
t=0.252;
avgBoth.grad=grad;
cfg = [];
cfg.latency = [t t];  % specify latency window around M50 peak
cfg.numdipoles = 1;
cfg.vol=vol;
cfg.feedback = 'textbar';
cfg.gridsearch='yes';
cfg.channel     = avgBoth.label;
dip = ft_dipolefitting(cfg, avgBoth);
ft_plot_dipole(dip.dip.pos/1000,dip.dip.mom/1000,'units','m','color','blue');
%% mne
load ctx
ctx=[lh;rh];
cfg = [];
%cfg.grad = ft_convert_units(stdAvg.grad,'mm');
cfg.channel ='MEG';
cfg.grid.pos = ctx;
cfg.grid.inside = [1:size(ctx,1)]';
cfg.vol = vol;
cfg.grad=grad;
leadfield = ft_prepare_leadfield(cfg);

cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0];
cfg.channel='MEG';
cov=ft_timelockanalysis(cfg, avgBoth);

cfg=[];
cfg.method = 'mne';
cfg.grid = leadfield;
cfg.vol = vol;
cfg.mne.lambda = 1e9;
cov.grad=grad;
source = ft_sourceanalysis(cfg,cov);
figure;
scatter3(ctx(:,1),ctx(:,2),ctx(:,3),20,source.avg.pow(:,155),'fill')
axis tight
view(200, 30)
%view(3)
% lh only
% scatter3(ctx(1:6237,1),ctx(1:6237,2),ctx(1:6237,3),30,source.avg.pow(1:6237,155),'fill')
% axis tight
% view(200, 30)
% 
% scatter3(ctx(6238:end,1),ctx(6238:end,2),ctx(6238:end,3),30,source.avg.pow(6238:end,155),'fill')
% axis tight
% view(180, 30)

%% one by one
load averages
load 1/headmodel;
load ctx
ctx=[lh;rh];
cfg = [];
%cfg.grad = ft_convert_units(stdAvg.grad,'mm');
cfg.channel ='MEG';
cfg.grid.pos = ctx;
cfg.grid.inside = [1:size(ctx,1)]';
cfg.vol = vol;
cfg.grad=ft_convert_units(iAvg.grad,'mm');
leadfield = ft_prepare_leadfield(cfg);

cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0];
cfg.channel='MEG';
cov=ft_timelockanalysis(cfg, iAvg);

cfg=[];
cfg.method = 'mne';
cfg.grid = leadfield;
cfg.vol = vol;
cfg.mne.lambda = 1e9;
cov.grad=ft_convert_units(iAvg.grad,'mm');
source = ft_sourceanalysis(cfg,cov);
figure;
scatter3(ctx(:,1),ctx(:,2),ctx(:,3),20,source.avg.pow(:,155),'fill')
axis tight
view(200, 30)

load 2/headmodel;
cfg = [];
%cfg.grad = ft_convert_units(stdAvg.grad,'mm');
cfg.channel ='MEG';
cfg.grid.pos = ctx;
cfg.grid.inside = [1:size(ctx,1)]';
cfg.vol = vol;
cfg.grad=ft_convert_units(i2Avg.grad,'mm');
leadfield = ft_prepare_leadfield(cfg);
cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0];
cfg.channel='MEG';
cov=ft_timelockanalysis(cfg, i2Avg);


cfg=[];
cfg.method = 'mne';
cfg.grid = leadfield;
cfg.vol = vol;
cfg.mne.lambda = 1e9;
cov.grad=ft_convert_units(i2Avg.grad,'mm');
source = ft_sourceanalysis(cfg,cov);
figure;
scatter3(ctx(:,1),ctx(:,2),ctx(:,3),20,source.avg.pow(:,155),'fill')
axis tight
view(200, 30)

%% beamforming 
cd /home/yuval/Data/marik/mark
load ctx
load leadfield.mat
load vol
load grad496
load avgBoth
ctx=[lh;rh];

cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0.3];
cfg.channel='MEG';
cov=ft_timelockanalysis(cfg, avgBoth);

cfg=[];
cfg.method = 'sam';
cfg.grid = leadfield;
cfg.vol = vol;
cfg.sam.lambda = 0.05;
cfg.fixedori='gareth';
cov.grad=grad;
s = ft_sourceanalysis(cfg, cov);
sN=length(s.avg.mom);
s.avg.pow=zeros(1,sN);
s.avg.norm=zeros(1,sN);
for si=1:sN
    if ~isempty(s.avg.mom{1,si})
        s.avg.pow(1,si)=abs(s.avg.mom{1,si}(1,155));
        %s.avg.norm(1,si)=s.avg.pow(1,si)./mean(abs(s.avg.filter{1,si}));
    end
end

figure;
noori=s.avg.pow./s.avg.noise;
scatter3(ctx(:,1),ctx(:,2),ctx(:,3),20,noori,'fill')
axis tight
view(200, 30)

%% fixed ori
load ctxdip
clear grid
grid.pos=[lhpnt;rhpnt];
grid.mom=[lhori;rhori];
grid.inside=1:length(grid.mom);
cfg=[];
cfg.method = 'sam';
cfg.grid = grid;
cfg.vol = vol;
cfg.sam.lambda = 0.05;
cfg.fixedori='set';
s = ft_sourceanalysis(cfg, cov);
sN=length(s.avg.mom);
s.avg.pow=zeros(1,sN);
s.avg.norm=zeros(1,sN);
for si=1:sN
    if ~isempty(s.avg.mom{1,si})
        s.avg.pow(1,si)=abs(s.avg.mom{1,si}(1,155));
        %s.avg.norm(1,si)=s.avg.pow(1,si)./mean(abs(s.avg.filter{1,si}));
    end
end
fixedori=s.avg.pow./s.avg.noise;
figure;
scatter3(grid.pos(:,1),grid.pos(:,2),grid.pos(:,3),20,fixedori,'fill')
axis tight
view(200, 30)



clear grid
grid.pos=[lhpnt;rhpnt];
%grid.mom=[lhori;rhori];
grid.inside=1:length(grid.pos);
cfg=[];
cfg.method = 'sam';
cfg.grid = grid;
cfg.vol = vol;
cfg.sam.lambda = 0.05;
cfg.fixedori='gareth';
s = ft_sourceanalysis(cfg, cov);
sN=length(s.avg.mom);
s.avg.pow=zeros(1,sN);
s.avg.norm=zeros(1,sN);
for si=1:sN
    if ~isempty(s.avg.mom{1,si})
        s.avg.pow(1,si)=abs(s.avg.mom{1,si}(1,155));
        %s.avg.norm(1,si)=s.avg.pow(1,si)./mean(abs(s.avg.filter{1,si}));
    end
end
fixedori=s.avg.pow./s.avg.noise;
figure;
scatter3(grid.pos(:,1),grid.pos(:,2),grid.pos(:,3),20,fixedori,'fill')
axis tight
view(200, 30)



