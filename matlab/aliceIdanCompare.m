%% SAMwts
load /home/yuval/Copy/MEGdata/alice/ga2015/GavgEqTrlsubs Mr1
cd /home/yuval/Copy/MEGdata/alice/idan
trl=Mr1.cfg.previous.previous.previous{1,1}.previous.trl;
sRate=1/diff(Mr1.time(1:2));
trl2mark(trl,sRate)

fwd=mne_read_forward_solution('MNE/fixed-fwd.fif');
%load LRi
%brain=[fwd.src(1).rr(li,:);fwd.src(2).rr(ri,:)];
brain=fwd.source_rr;
cd SAM
grid2t(brain*10);
cd ../../
!SAMcov64 -r idan -d xc,hb,lf_c,rfDC -m ori -v
!SAMwts64 -r idan -d xc,hb,lf_c,rfDC -m ori -c Global -t pnt.txt -v
cd idan/SAM
[~, ~, wts]=readWeights('pnt.txt.wts');

t1=nearest(Mr1.time,0.09);
t2=nearest(Mr1.time,0.11);
source=mean(wts*Mr1.avg(1:248,t1:t2),2);
smp=ceil(0.2*sRate);
trlNoise=0:smp:smp*71;
trlNoise=round(sRate*10)+trlNoise';
trlNoise(:,2)=trlNoise(:,1)+smp;
trlNoise(:,3)=0;
cfg=[];
cfg.bpfilter='yes';
cfg.bpfreq=[3 35];
cfg.padding=1;
cfg.trl=trlNoise;
cfg.dataset='/home/yuval/Data/emptyRoom/xc,lf_c,rfhp0.1Hz';
cfg.channel='MEG';
empty=ft_preprocessing(cfg);
empty=ft_timelockanalysis([],empty);
t1=nearest(empty.time,0.09);
t2=nearest(empty.time,0.11);
% noise=abs(mean(wts*empty.avg(1:248,t1:t2),2));
% scatter3pnt(brain,25,noise);
noise1=mean(abs(wts),2);
%scatter3pnt(brain,25,noise1);
figure;
scatter3pnt(brain,25,abs(source)./noise1);
pct=1;
caxis([prctile(source./noise1,pct) prctile(source./noise1,100-pct)])
view([0 -80])
%% SAMNwts
Nwts=zeros(size(wts));
for pnti=1:length(brain)
    !echo 7 > idan/SAM/Tetra.txt
    Xi=brain(pnti,1)*100;
    Yi=brain(pnti,2)*100;
    Zi=brain(pnti,3)*100;
    eval(['!echo "',num2str(Xi),' ',num2str(Yi),' ',num2str(Zi),'" >> idan/SAM/Tetra.txt'])
    
    eval(['!echo "',num2str(Xi-1),' ',num2str(Yi),' ',num2str(Zi),'" >> idan/SAM/Tetra.txt'])
    eval(['!echo "',num2str(Xi+1),' ',num2str(Yi),' ',num2str(Zi),'" >> idan/SAM/Tetra.txt'])
    eval(['!echo "',num2str(Xi),' ',num2str(Yi-1),' ',num2str(Zi),'" >> idan/SAM/Tetra.txt'])
    eval(['!echo "',num2str(Xi),' ',num2str(Yi+1),' ',num2str(Zi),'" >> idan/SAM/Tetra.txt'])
    eval(['!echo "',num2str(Xi),' ',num2str(Yi),' ',num2str(Zi-1),'" >> idan/SAM/Tetra.txt'])
    eval(['!echo "',num2str(Xi),' ',num2str(Yi),' ',num2str(Zi+1),'" >> idan/SAM/Tetra.txt'])
    %eval(['!echo "',num2str(Xi),' ',num2str(-Yi),' ',num2str(Zi),'" >> idan/SAM/Tetra.txt'])
    !SAMNwts64 -r idan -d xc,hb,lf_c,rfDC -m ori -c Global -t Tetra.txt -v
    [~, ~, NWgts]=readWeights('idan/SAM/ori,Tetra.txt.wts');
    Nwts(pnti,:)=NWgts(1,:);
    disp(['XXXXXXXXX ',num2str(pnti),' XXXXXXXXXXX'])
end
save idan/SAM/Nwts7 Nwts

Nsource=mean(Nwts*Mr1.avg(1:248,t1:t2),2);
figure;scatter3pnt(brain,25,abs(Nsource)./noise1);
pct=5;
caxis([prctile(Nsource./noise1,pct) prctile(Nsource./noise1,100-pct)])
view([0 -80])

%% SAMNwts, one contralateral source
Nwts8=zeros(size(wts));
for pnti=1:length(brain)
    !echo 8 > idan/SAM/Tetra.txt
    Xi=brain(pnti,1)*100;
    Yi=brain(pnti,2)*100;
    Zi=brain(pnti,3)*100;
    eval(['!echo "',num2str(Xi),' ',num2str(Yi),' ',num2str(Zi),'" >> idan/SAM/Tetra.txt'])
    
    eval(['!echo "',num2str(Xi-1),' ',num2str(Yi),' ',num2str(Zi),'" >> idan/SAM/Tetra.txt'])
    eval(['!echo "',num2str(Xi+1),' ',num2str(Yi),' ',num2str(Zi),'" >> idan/SAM/Tetra.txt'])
    eval(['!echo "',num2str(Xi),' ',num2str(Yi-1),' ',num2str(Zi),'" >> idan/SAM/Tetra.txt'])
    eval(['!echo "',num2str(Xi),' ',num2str(Yi+1),' ',num2str(Zi),'" >> idan/SAM/Tetra.txt'])
    eval(['!echo "',num2str(Xi),' ',num2str(Yi),' ',num2str(Zi-1),'" >> idan/SAM/Tetra.txt'])
    eval(['!echo "',num2str(Xi),' ',num2str(Yi),' ',num2str(Zi+1),'" >> idan/SAM/Tetra.txt'])
    eval(['!echo "',num2str(Xi),' ',num2str(-Yi),' ',num2str(Zi),'" >> idan/SAM/Tetra.txt'])
    !SAMNwts64 -r idan -d xc,hb,lf_c,rfDC -m ori -c Global -t Tetra.txt -v
    [~, ~, NWgts]=readWeights('idan/SAM/ori,Tetra.txt.wts');
    Nwts8(pnti,:)=NWgts(1,:);
    disp(['XXXXXXXXX ',num2str(pnti),' XXXXXXXXXXX'])
end
save idan/SAM/Nwts8 Nwts8

Nsource8=mean(Nwts8*Mr1.avg(1:248,t1:t2),2);
figure;scatter3pnt(brain,25,abs(Nsource8)./noise1);
pct=5;
caxis([prctile(Nsource8./noise1,pct) prctile(Nsource8./noise1,100-pct)])
view([0 -80])

