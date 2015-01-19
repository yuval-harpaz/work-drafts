cd /home/yuval/Copy/MEGdata/alice/ga
load GavgMalice
load ../ohad/avgReducedPad
subj=avgM2;
clear avg*
subj.time=GavgMalice.time(414:1127);
subj.avg=squeeze(mean(GavgMalice.individual(:,:,414:1127)));
subj=rmfield(subj,'var');
subj=rmfield(subj,'dof');
subj=rmfield(subj,'cfg');
% cfg=[];
% cfg.method='pca';
% comp=ft_componentanalysis(cfg,subj);
% comp=ft_componentanalysis([],subj);
% cfg=[];
% cfg.layout='4D248.lay';
% cfg.channel=comp.label(1:5);
% cfg.viewmode='component';
% ft_databrowser(cfg,comp);

% plot(squeeze(mean(GavgMalice.individual(:,1,:))))
% 
% cfg=[];
% cfg.layout='4D248.lay';
% cfg.component=1:16;
% figure;
% ft_topoplotIC(cfg,comp);

samps=[182,200,296,386,486];
cfg = [];
%cfg.topo      = [topoHeeg(1:248,1),topoVeeg(1:32,1),spikeTopoE8(subi,:)'];
cfg.topo      = subj.avg(:,samps);
cfg.topolabel = subj.label;
comp     = ft_componentanalysis(cfg, subj);
cfg = [];
cfg.component = [1,2];
subj1 = ft_rejectcomponent(cfg, comp,subj);
figure;
plot(subj.time,mean(abs(subj.avg)),'r');
hold on
plot(subj.time,mean(abs(subj1.trial{1})));

load LRpairs;
[~,MLi]=ismember(LRpairs(:,1),GavgMalice.label);
[~,MRi]=ismember(LRpairs(:,2),GavgMalice.label);
figure;
plot(subj.time,mean(abs(subj.avg(MRi,:))),'r');
hold on
plot(subj.time,mean(abs(subj.avg(MLi,:))));
plot(subj.time,mean(abs(subj1.trial{1}(MRi,:))),'r--');
plot(subj.time,mean(abs(subj1.trial{1}(MLi,:))),'--');
legend('right','left','right no spike','left no spike')

% samps=[182,200];
% cfg = [];
% %cfg.topo      = [topoHeeg(1:248,1),topoVeeg(1:32,1),spikeTopoE8(subi,:)'];
% cfg.topo      = subj.avg(:,samps);
% cfg.topolabel = subj.label;
% comp2     = ft_componentanalysis(cfg, subj);
% cfg = [];
% cfg.component = [1,2];
% subj2 = ft_rejectcomponent(cfg, comp2,subj);
% 
% topoplot248(subj2.trial{1}(:,296))