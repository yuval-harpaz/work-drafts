
%% alice - rest
cd /home/yuval/Copy/MEGdata/alice/ga
aliceTtest0('GavgFrMaliceLR',9,1);
aliceTtest0('GavgFrMrestLR',10,1);



aliceTtest0('GavgFrEaliceLR',9,1);
aliceTtest0('GavgFrErestLR',10,1);
stat=statPlot('GavgFrMrestLR','GavgFrMaliceLR',[9 9],[-3e-27 3e-27],'paired-ttest') 
stat=statPlot('GavgFrErestLR','GavgFrEaliceLR',[9 9],[-1 1],'paired-ttest') 

stat=statPlot('GavgFrMrestLR','GavgFrMaliceLR',[10 10],[-3e-27 3e-27],'paired-ttest') 
stat=statPlot('GavgFrErestLR','GavgFrEaliceLR',[10 10],[-1 1],'paired-ttest')

%% find peak freq
load /home/yuval/Copy/MEGdata/alice/ga/GavgFrMrestLR
cfg=[];
cfg.interactive='yes';
cfg.layout='4D248.lay';
cfg.xlim=[9 10];
ft_topoplotER(cfg,GavgFrMrestLR)
load /home/yuval/Copy/MEGdata/alice/ga/GavgFrMaliceLR
ft_topoplotER(cfg,GavgFrMaliceLR)
load /home/yuval/Copy/MEGdata/alice/ga/GavgFrErestLR
cfg.layout='WG32.lay';
ft_topoplotER(cfg,GavgFrErestLR)

%% 8Hz
stat=statPlot('GavgFrMrestLR','GavgFrMaliceLR',[8 8],[-3e-27 3e-27],'paired-ttest') 
stat=statPlot('GavgFrErestLR','GavgFrEaliceLR',[8 8],[-1 1],'paired-ttest') 


aliceTtest0('GavgFrM102LR',10,1);
aliceTtest0('GavgFrM2LR',10,1);
aliceTtest0('GavgFrM4LR',10,1);
aliceTtest0('GavgFrM10LR',10,1);
aliceTtest0('GavgFrM18LR',10,1);
stat=statPlot('GavgFrM18LR','GavgFrM16LR',[10 10],[-3e-27 3e-27],'paired-ttest') % rest
stat=statPlot('GavgFrM18LR','GavgFrM16LR',[20 20],[-7e-28 7e-28],'paired-ttest') % rest
aliceTtest0('GavgFrMaliceLR',10,1);
aliceTtest0('GavgFrMrestLR',10,1);
stat=statPlot('GavgFrMrestLR','GavgFrMaliceLR',[20 20],[-7e-28 7e-28],'paired-ttest') % rest
stat=statPlot('GavgFrErestLR','GavgFrEaliceLR',[20 20],[-0.2 0.2],'paired-ttest') % rest


aliceTtest0('GavgFrEaliceLR',12,1);
aliceTtest0('GavgFrErestLR',12,1);
stat=statPlot('GavgFrErestLR','GavgFrEaliceLR',[12 12],[-0.3 0.3],'paired-ttest') % rest
stat=statPlot('GavgFrMrestLR','GavgFrMaliceLR',[12 12],[],'paired-ttest') % rest