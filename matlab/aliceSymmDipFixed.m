
sf={'idan','inbal','liron','maor','mark','odelia','ohad','yoni'};
load /home/yuval/Copy/MEGdata/alice/ga2015/GavgEqTrlsubs
t=[0.09 0.11];
cfg=[];
cfg.latency=t;
cfg.nonlinear='no';
cfg.symmetry='anatomy';
cfg.method='pinv';
cfg.vol.type='singlesphere';
cfg.vol.unit='mm';
cfg.pairs=true;
subi=1
cd ~/Data/alice/
cd(sf{subi})
load LRi

cd MNE

fwd1=mne_read_forward_solution('fixed-fwd.fif');
brain=[fwd1.src(1).rr(li,:);fwd1.src(2).rr(ri,:)];
figure;
scatter3pnt(brain,3,'k')
hold on
pnti=[1;10243];
for srci=100:100:10242
    plot3pnt(brain(pnti,:),'.c')
    pnti=[srci;10242+srci];
    plot3pnt(brain(pnti,:),'.r')
    pause
end

scatter3pnt(dip2.cfg.grid.pos,5,'k')



lh=fwd1.src(1).rr(li,:);
rh=fwd1.src(2).rr(ri,:);
lhOri=fwd1.src(1).nn(li,:);
rhOri=fwd1.src(2).nn(ri,:);

if ~ exist('./Grid.mat','file')
    cfgg.fileName='fixed-fwd.fif';
    cfgg.subset=[li,ri];
    [Grid,ftLeadfield,ori]=fs2grid(cfgg);
    save Grid Grid ftLeadfield ori
else
    load Grid
end

cd ../

priBrain=[lh;rh];
priBrain=priBrain(:,[2,1,3]);
priBrain(:,2)=-priBrain(:,2);
priOri=[lhOri;rhOri];
priOri=priOri(:,[2,1,3]);
priOri(:,2)=-priOri(:,2);


hs=ft_read_headshape('hs_file');
[cfg.vol.o,cfg.vol.r]=fitsphere(hs.pnt*1000);

%     plot3pnt(priBrain,'.')
%     hold on
%     plot3pnt(hs.pnt,'ok')
%     %[~,badi]=ismember({'A64', 'A92', 'A93', 'A94', 'A118', 'A124', 'A125', 'A126', 'A127', 'A149', 'A150', 'A153', 'A154', 'A155', 'A175', 'A176', 'A177', 'A178', 'A179', 'A193', 'A194', 'A195', 'A212', 'A213', 'A227', 'A228', 'A229', 'A230', 'A246', 'A247', 'A248'},avgM20_1.label);
%     %avgM20_1.avg(badi,:)=0;
%     plot3pnt(priBrain(1,:),'og')
cfg.grid=ft_convert_units(ftLeadfield,'mm');
cfg.ori=priOri;
[dip,R,mom]=dipolefitBIU(cfg,eval(['Mr',num2str(subi)]))
save MNE/R100 R
save MNE/dip100 dip



% eval(['M=mean(Mr',num2str(subi),'.avg(1:248,nearest(Mr',num2str(subi),'.time,t(1)):nearest(Mr',num2str(subi),'.time,t(2))),2);'])
% 
% for srci=1:10242
%     lfl=ftLeadfield.leadfield{srci}*priOri(srci,:)';
%     lfr=ftLeadfield.leadfield{srci+10242}*priOri(srci+10242,:)';
%     tmp=pinv([lfl,lfr])*M;
%     FIXME - make symmetric dipoles for leadfield (fwd1.sol.data)
%     [~,lf,vol]=sphereGrid([],10,[],4);
%     cfg.vol=vol;
%     cfg.grid=lf;
%     [dip2,r,mom]=dipolefitBIU(cfg,eval(['Mr',num2str(subi)]));
%     POSL(subi)=dip2.grid_index(1);
%     MOML(subi,1:3)=dip2.dip.mom(1:3);
%     R(1:2568,subi)=r;
% end
% R=mean(R,2);
% hs=ft_read_headshape('hs_file')
% figure;
% plot3pnt(hs.pnt*1000,'.k')
% hold on
% scatter3pnt(dip2.cfg.grid.pos,25,R)
% figure;
% scatter3pnt(dip2.cfg.grid.pos,5,'k')
% hold on
% for subi=1:8
%     ft_plot_dipole(dip2.cfg.grid.pos(POSL(subi),:),MOML(subi,:),'units','mm','color','b')
% end
% 
% 
