function talPowGAplot(file,freq)
% cd /media/Elements/MEG/talResults/pow/norm/dif
load(file)
eval(['pow=',file,';'])
cfg=[];
cfg.xlim=[freq freq];
cfg.layout='4D248.lay';
figure;
ft_topoplotER(cfg,pow);
end