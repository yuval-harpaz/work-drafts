function alicePlotLR1(xlim,cond,savePath)

cd /home/yuval/Copy/MEGdata/alice/ga
%GavgMLR1=load (['GavgM',cond,'LR1']);
%GavgELR1=load (['GavgE',cond,'LR1'])
load (['GavgM',cond])
eval(['GavgM=GavgM',cond])
load (['GavgE',cond])
eval(['GavgE=GavgE',cond])
figure1=figure('position',[20,20,1000,1000]);

subplot(2,2,1)
cfg=[];
cfg.xlim=[xlim xlim];
%cfg.interactive='yes';
cfg.layout='WG32.lay';
cfg.zlim=[-2 2];
ft_topoplotER(cfg,GavgE);
subplot(2,2,3)
aliceTtest0(['GavgE',cond,'LR1'],xlim,1);
% cfg.zlim=[];
% ft_topoplotER(cfg,GavgEaliceLR1);
subplot(2,2,2)
cfg.layout='4D248.lay';
cfg.zlim=[-5e-14 5e-14];
ft_topoplotER(cfg,GavgM);
subplot(2,2,4)
aliceTtest0(['GavgM',cond,'LR1'],xlim,1);
if exist('savePath','var')
    if ischar(savePath)
        saveas(figure1,[savePath,cond,'_',num2str(xlim),'.png'])
    end
end
% cfg.zlim=[];
% ft_topoplotER(cfg,GavgMaliceLR1);





