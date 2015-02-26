cd /home/yuval/Data/marik/som1
load avg
% fileName1='1/xc,hb,lf_c,rfhp0.1Hz';
% fileName2='2/xc,hb,lf_c,rfhp0.1Hz';



% t=0.1;
% cfg=[];
% cfg.layout='4D248.lay';
% cfg.xlim=[t t];
% cfg.interactive='yes';
% figure;
% ft_topoplotER(cfg,avg1_foot1);
% figure;
% ft_topoplotER(cfg,iAvg);
% save averages iAvg i2Avg
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
cd 3
[vol,grid,~,M1]=headmodel_BIU([],[],5,[],'localspheres');
save headmodel vol grid M1
!rm modte*
cd ..
%% unify headmodels


cd /home/yuval/Data/marik/som1/1
[~,~,mesh,~,volSph]=headmodel_BIU([],[],5,[],'localspheres');
[~,~,mesh]=headmodel_BIU([],[],5,[],'localspheres');
cd ../
load avg
%grad=rmfield(avg1.cfg.grad,'balance');
grad=avg1_hand2.grad;
grad.label=avg1_hand2.label;
grad.chanori=grad.chanori(1:248,:);
grad.chanpos=grad.chanpos(1:248,:);
grad.chantype=grad.chantype(1:248,:);
grad.chanunit=grad.chanunit(1:248,:);
grad.coilori=grad.coilori(1:248,:);
grad.coilpos=grad.coilpos(1:248,:);
grad.tra=grad.tra(1:248,1:248);

chanN=248;
grad.chanori(chanN+1:2*chanN,:)=avg2_hand2.grad.chanori(1:248,:);
grad.chanpos(chanN+1:2*chanN,:)=avg2_hand2.grad.chanpos(1:248,:);
grad.chantype(chanN+1:2*chanN,:)=avg2_hand2.grad.chantype(1:248,:);
grad.chanunit(chanN+1:2*chanN,:)=avg2_hand2.grad.chanunit(1:248,:);
grad.coilori(chanN+1:2*chanN,:)=avg2_hand2.grad.coilori(1:248,:);
grad.coilpos(chanN+1:2*chanN,:)=avg2_hand2.grad.coilpos(1:248,:);

grad.chanori(2*chanN+1:3*chanN,:)=avg3_hand2.grad.chanori(1:248,:);
grad.chanpos(2*chanN+1:3*chanN,:)=avg3_hand2.grad.chanpos(1:248,:);
grad.chantype(2*chanN+1:3*chanN,:)=avg3_hand2.grad.chantype(1:248,:);
grad.chanunit(2*chanN+1:3*chanN,:)=avg3_hand2.grad.chanunit(1:248,:);
grad.coilori(2*chanN+1:3*chanN,:)=avg3_hand2.grad.coilori(1:248,:);
grad.coilpos(2*chanN+1:3*chanN,:)=avg3_hand2.grad.coilpos(1:248,:);
grad.tra=eye(chanN*3);
for chi=1:248
    label{chi,1}=[avg1_hand2.label{chi,1},'A'];
    label{248+chi,1}=[avg1_hand2.label{chi,1},'B'];
    label{2*248+chi,1}=[avg1_hand2.label{chi,1},'C'];
end
grad.label=label;
loc={'_foot1','_foot2','_hand2'};
for loci=1:3
    avg=rmfield(eval(['avg1',loc{loci}]),'dof');
    avg=rmfield(avg,'cfg');
    eval(['avg.avg=[avg1',loc{loci},'.avg;avg2',loc{loci},'.avg;avg3',loc{loci},'.avg];'])
    eval(['avg.var=[avg1',loc{loci},'.var;avg2',loc{loci},'.var;avg3',loc{loci},'.var];'])
    avg.grad=ft_convert_units(grad,'mm');
    avg.label=label;
    eval(['avg',loc{loci},'=avg;']);
end
load 1/headmodel
vol1=vol;
load 2/headmodel
vol2=vol;
load 3/headmodel
vol3=vol;
vol=rmfield(vol1,'cfg');
vol.r=[vol1.r(1:248,:);vol2.r(1:248,:);vol3.r(1:248,:)];
vol.o=[vol1.o(1:248,:);vol2.o(1:248,:);vol3.o(1:248,:)];
vol.label=label;
% dipole fit

t=[0.027 0.037];
%liAvg.grad=ft_convert_units(liAvg.grad,'mm');
cfg = [];
cfg.latency = t; 
cfg.numdipoles = 1;
cfg.vol=volSph;
cfg.feedback = 'textbar';
cfg.gridsearch='yes';
cfg.channel='MEG';
dip = ft_dipolefitting(cfg, avg_hand2);
hs=ft_read_headshape('1/hs_file');
figure;plot3pnt(hs.pnt,'ro');
hold on;
ft_plot_dipole(dip.dip.pos/1000,dip.dip.mom/1000,'units','m')



%% mne

cfg = [];
cfg.grad = ft_convert_units(grad,'mm');
cfg.channel ='MEG';
cfg.grid.pos=mesh.tess_ctx.vert;
cfg.grid.inside=1:length(cfg.grid.pos);
cfg.vol = vol;
leadfield = ft_prepare_leadfield(cfg);

cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'no';
cfg.covariancewindow = [-0.1 0];
cov=ft_timelockanalysis(cfg, avg_hand2);

% cfg        = [];
% cfg.method = 'mne';
% cfg.grid   = leadfield;
% cfg.vol    = vol;
% cfg.mne.prewhiten = 'yes';
% cfg.mne.lambda    = 3;
% cfg.mne.scalesourcecov = 'yes';
% sourceFC  = ft_sourceanalysis(cfg,tlckFC);

cfg=[];
cfg.method = 'mne';
cfg.grid = leadfield;
cfg.vol = vol;
cfg.mne.lambda = 1e9;
cov.grad=ft_convert_units(grad,'mm');
source = ft_sourceanalysis(cfg,cov);
s1=nearest(cov.time,t(1));
s2=nearest(cov.time,t(2));
src=mean(source.avg.pow(:,s1:s2),2);
% figure;
% scatter3(cfg.grid.pos(:,1),cfg.grid.pos(:,2),cfg.grid.pos(:,3),20,src,'fill')
% axis tight
% view(200, 30)


bnd.pnt=mesh.tess_ctx.vert;
bnd.tri=mesh.tess_ctx.face;
figure;
ft_plot_mesh(bnd, 'vertexcolor', src);


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



