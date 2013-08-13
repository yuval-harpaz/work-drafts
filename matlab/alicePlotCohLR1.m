function alicePlotCohLR1(xlim,cond,savePath)

cd /home/yuval/Copy/MEGdata/alice/ga
%GavgMLR1=load (['GavgM',cond,'LR1']);
%GavgELR1=load (['GavgE',cond,'LR1'])
load (['GavgCohM',cond])
eval(['GavgM=GavgCohM',cond])
load (['GavgCohE',cond])
eval(['GavgE=GavgCohE',cond])
figure1=figure('position',[20,20,1000,490]);

subplot(1,2,1)
cfg=[];
cfg.xlim=[xlim xlim];
%cfg.interactive='yes';
cfg.layout='WG32.lay';
cfg.zlim=[0 1];
ft_topoplotER(cfg,GavgE);
subplot(1,2,2)
cfg.layout='4D248.lay';
cfg.zlim=[0 1];
ft_topoplotER(cfg,GavgM);

if exist('savePath','var')
    if ischar(savePath)
        saveas(figure1,[savePath,cond,'Coh',num2str(xlim),'Hz.png'])
    end
end
% cfg.zlim=[];
% ft_topoplotER(cfg,GavgMaliceLR1);





