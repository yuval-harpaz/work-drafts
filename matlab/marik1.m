cd /home/yuval/Data/camera
fileName1='1/c,rfhp0.1Hz';
fileName2='2/c,rfhp0.1Hz';

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
cfg=[];
cfg.trl=trl'-102;
cfg.trl(:,2)=trl+306;
cfg.trl(:,3)=102;
cfg.dataset=fileName1;
cfg.demean='yes';
cfg.baselinewindow=[-0.1 0];
cfg.bpfilter='yes';
cfg.bpfreq=[3 30];
cfg.channel='MEG';
cfg.feedback='no';
leftInd=ft_preprocessing(cfg);
cfg=[];
cfg.method='summary';
cfg.channel='MEG';
cfg.alim=1e-12;
leftIndCln=ft_rejectvisual(cfg, leftInd);
liAvg=ft_timelockanalysis([],leftIndCln);
%% read and reject artifacts run2
trig=readTrig_BIU(fileName2);
trig=clearTrig(trig);
trl=find(trig==2);
cfg=[];
cfg.trl=trl'-102;
cfg.trl(:,2)=trl+306;
cfg.trl(:,3)=102;
cfg.dataset=fileName2;
cfg.demean='yes';
cfg.baselinewindow=[-0.1 0];
cfg.bpfilter='yes';
cfg.bpfreq=[3 30];
cfg.channel='MEG';
cfg.feedback='no';
leftInd2=ft_preprocessing(cfg);
cfg=[];
cfg.method='summary';
cfg.channel='MEG';
cfg.alim=1e-12;
leftInd2Cln=ft_rejectvisual(cfg, leftInd2);
li2Avg=ft_timelockanalysis([],leftInd2Cln);

t=0.252;
cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[t t];
%cfg.interactive='yes';
figure;
ft_topoplotER(cfg,liAvg);
figure;
ft_topoplotER(cfg,li2Avg);

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

avgBoth=rmfield(liAvg,'dof');
avgBoth=rmfield(avgBoth,'cfg');
avgBoth.avg=[liAvg.avg;li2Avg.avg];
avgBoth.var=[liAvg.var;li2Avg.var];
avgBoth.grad=ft_convert_units(grad,'mm');
for chi=1:248
    avgBoth.label{248+chi,1}=[liAvg.label{chi,1},'B'];
end
avgBoth.grad.tra=liAvg.grad.tra;
avgBoth.grad.tra(271+1:271*2,276+1:276*2)=liAvg.grad.tra;
save avgBoth avgBoth
%% dipole fit

cd /home/yuval/Data/camera/1;
load headmodel
load ../leftIndAvgs
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
load grad
megi=ismember(grad.chantype,'meg');
grad.chanori=grad.chanori(megi,:);
grad.chanpos=grad.chanpos(megi,:);
grad.chantype=grad.chantype(megi,:);
grad.chanunit=grad.chanunit(megi,:);
grad.coilori=grad.coilori(megi,:);
grad.coilpos=grad.coilpos(megi,:);
grad.label=grad.label(megi,:);
grad.tra=eye(248*2);

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

