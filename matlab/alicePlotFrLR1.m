function alicePlotFrLR1(xlim,cond,savePath)

cd /home/yuval/Copy/MEGdata/alice/ga
%GavgMLR1=load (['GavgM',cond,'LR1']);
%GavgELR1=load (['GavgE',cond,'LR1'])
load (['GavgFrM',cond])
eval(['GavgM=GavgFrM',cond])
load (['GavgFrE',cond])
eval(['GavgE=GavgFrE',cond])
figure1=figure('position',[20,20,1000,1000]);

subplot(2,2,1)
cfg=[];
cfg.xlim=[xlim xlim];
%cfg.interactive='yes';
cfg.layout='WG32.lay';
cfg.zlim=[0 4.5];
ft_topoplotER(cfg,GavgE);
subplot(2,2,3)
aliceTtest0(['GavgFrE',cond,'LR'],xlim,1);
% cfg.zlim=[];
% ft_topoplotER(cfg,GavgEaliceLR1);
subplot(2,2,2)
cfg.layout='4D248.lay';
cfg.zlim=[0 5e-27];
ft_topoplotER(cfg,GavgM);
subplot(2,2,4)
aliceTtest0(['GavgFrM',cond,'LR'],xlim,1);
if exist('savePath','var')
    if ischar(savePath)
        saveas(figure1,[savePath,cond,'_',num2str(xlim),'Hz.png'])
    end
end
% cfg.zlim=[];
% ft_topoplotER(cfg,GavgMaliceLR1);





