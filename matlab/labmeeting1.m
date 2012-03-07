% lab meeting
cd /home/yuval/Data/Amb
lim=2*10^(-13);
cfg=[];
cfg.xlim=[0.170 0.170];
cfg.zlim=[-lim lim];
for subi=1:9
    folder=num2str(subi)
    cd(folder)
    load eSre
    figure;
    ft_topoplotER(cfg,Sre);
    title(folder)
    cd ..
end

close all


ambMonte('','subp','domp',0.995)