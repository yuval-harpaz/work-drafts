cd /home/yuval/Data/epilepsy/b372/1
correctLF;
correctHB;
%correctXC;
cd ../

!SAMcov64 -r 1 -d hb,lf_c,rfhp1.0Hz -m preIctal1 -v
!SAMwts64 -r 1 -d hb,lf_c,rfhp1.0Hz -m preIctal1 -c Global -v
cd 1/SAM
[~,~,wts]=readWeights('preIctal1,20-70Hz,Global.wts');
noise=mean(abs(wts),2);
time0=799;
times=(time0-60):10:(time0-10)
trl=round(times*678.17)';
trl(:,2)=trl+6782;
trl(:,3)=0;
cfg=[];
cfg.trl=trl;
cfg.demean='yes';
cfg.dataset='hb,lf_c,rfhp1.0Hz';
cfg.bpfilter='yes';
cfg.bpfreq=[20 70];
cfg.channel='MEG';
data=ft_preprocessing(cfg);
src=zeros(63455,6);
for epochi=1:6
    src(:,epochi)=mean(abs(wts*data.trial{epochi}),2)./noise;
end
src(isnan(src))=0;
for epochi=1:6
    src(:,epochi)=mean(abs(wts*data.trial{epochi}),2)./noise;
end
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='run1';
cfg.torig=-60000;
cfg.TR=10000;
VS2Brik(cfg,src*10^13);

for epochi=2:4
    ep=num2str(epochi);
    cd /home/yuval/Data/epilepsy/b372
    cd(ep)
    cd SAM
    [~,~,wts]=readWeights(['preIctal',ep,',20-70Hz,Global.wts']);
    noise=mean(abs(wts),2);
    cd ../
    [~,time]=unix(['grep DataSe* ../preIctal',ep,'.param'])
    gaps=findstr(time,' ');
    time0=str2num(time(gaps(2)+1:end));
    times=(time0-60):10:(time0-10)
    trl=round(times*678.17)';
    trl(:,2)=trl+6782;
    trl(:,3)=0;
    cfg=[];
    cfg.trl=trl;
    cfg.demean='yes';
    cfg.dataset='hb,lf_c,rfhp1.0Hz';
    cfg.bpfilter='yes';
    cfg.bpfreq=[20 70];
    cfg.channel='MEG';
    data=ft_preprocessing(cfg);
    src=zeros(63455,6);
    for epochi=1:6
        src(:,epochi)=mean(abs(wts*data.trial{epochi}),2)./noise;
    end
    src(isnan(src))=0;
    for epochi=1:6
        src(:,epochi)=mean(abs(wts*data.trial{epochi}),2)./noise;
    end
    cd ../
    cfg=[];
    cfg.step=5;
    cfg.boxSize=[-120 120 -90 90 -20 150];
    cfg.prefix=['run',ep];
    cfg.torig=-60000;
    cfg.TR=10000;
    VS2Brik(cfg,src*10^13);
end
