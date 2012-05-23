cd /home/yuval/Desktop/amb
load 25/DOM/dom.mat
dom25=dom;
diary on
cfg=[];
for subj=1:25
    subjn=num2str(subj);
    hs=ft_read_headshape([subjn,'/DOM/hs_file']);
    [o,r]=fitsphere(hs.pnt);
    load([subjn,'/DOM/dom.mat']);
    cfg.template={dom25.grad};
    cfg.inwardshift=0.025;
    cfg.vol.r=r;cfg.vol.o=o;
    cfg.trials=1;
    dom_ra=ft_megrealign(cfg,dom);
    close all;
    subjn=num2str(subj);
    hs=ft_read_headshape([subjn,'/SUB/hs_file']);
    [o,r]=fitsphere(hs.pnt);
    load([subjn,'/SUB/sub.mat']);
    cfg.vol.r=r;cfg.vol.o=o;
    sub_ra=ft_megrealign(cfg,sub);
    close all;
    save([subjn,'/DOM/dom_ra.mat'],'dom_ra')
    save([subjn,'/SUB/sub_ra.mat'],'sub_ra')
    display(subjn);
end
diary off