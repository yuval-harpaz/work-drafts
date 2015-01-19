cd /media/yuval/Elements/SchizoRestMaor/AviMa23
%p=pdf4D(source);
% cleanCoefs = createCleanFile(p, source,...
%     'byLF',256,'Method','Adaptive',...
%     'xClean',[4,5,6],...
%     'byFFT',0,...
%     'HeartBeat',0,... % use [] for automatic HB cleaning, use 0 to avoid HB cleaning
%     'maskTrigBits', 256);

fileName='xc,lf_c,rfhp0.1Hz,ee';
p=pdf4D(fileName);
%cleanCoefs = createCleanFile(p, fileName,'byLF',0,'byFFT',0,'HeartBeat',[]);
load cleanCoefs
hdr=get(p,'header');
sRate=get(p,'dr');
lat=[1 hdr.epoch_data{1}.pts_in_epoch];
chi=channel_index(p,'MEG');
meanMEG=mean(read_data_block(p,lat,chi));
fileName='hb,xc,lf_c,rfhp0.1Hz,ee';
p1=pdf4D(fileName);
meanMEGhb=mean(read_data_block(p1,lat,chi));
artifact=meanMEG-meanMEGhb;
figure;plot(artifact)
[data,HBtimes]=correctHB(read_data_block(p,lat,chi),sRate);
corHB=mean(data);
artifact1=meanMEG-corHB;
figure;plot(artifact);hold on;plot(artifact1,'k');plot(meanMEG,'r');legend('create','correct','orig')

HBsamp=round(HBtimes*sRate);
HB=zeros(3,1017);
for i=2:(length(HBsamp)-2)
    HB(1,:)=HB(1,:)+meanMEG(HBsamp(i)-316:HBsamp(i)+700);
    HB(2,:)=HB(2,:)+meanMEGhb(HBsamp(i)-316:HBsamp(i)+700);
    HB(3,:)=HB(3,:)+corHB(HBsamp(i)-316:HBsamp(i)+700);
end
figure;plot(HB');legend('orig','create','correct');title('avg by HBtimes')

HBsamp=cleanCoefs.HBparams.whereisHB;
HB=zeros(3,1017);
for i=2:(length(HBsamp)-2)
    HB(1,:)=HB(1,:)+meanMEG(HBsamp(i)-316:HBsamp(i)+700);
    HB(2,:)=HB(2,:)+meanMEGhb(HBsamp(i)-316:HBsamp(i)+700);
    HB(3,:)=HB(3,:)+corHB(HBsamp(i)-316:HBsamp(i)+700);
end
figure;plot(HB');legend('orig','create','correct');title('avg by cleanCoefs')

% cfg=[];
% cfg.dataset='xc,lf_c,rfhp0.1Hz,ee';
% cfg.channel='MEG';
% cfg.hpfilter='yes';
% cfg.hpfreq=3;
% cfg.bsfilter='yes';
% cfg.bsfreq=[9 11];
% flt=ft_preprocessing(cfg);
% figure;plot(meanMEG,'k')
% hold on
% plot(mean(flt.trial{1}),'b')
% ECG=mean(flt.trial{1});
% [dataF,HBtimesF,temp]=correctHB(read_data_block(p,lat,chi),sRate,0,ECG);
% corHBf=mean(dataF);
% HBsamp=round(HBtimesF*sRate);
% HB=zeros(3,1017);
% for i=2:(length(HBsamp)-2)
%     HB(1,:)=HB(1,:)+meanMEG(HBsamp(i)-316:HBsamp(i)+700);
%     HB(2,:)=HB(2,:)+corHBf(HBsamp(i)-316:HBsamp(i)+700);
%     HB(3,:)=HB(3,:)+corHB(HBsamp(i)-316:HBsamp(i)+700);
% end
% figure;plot(HB');legend('orig','correctF','correct');title('avg by correctF')
% 
% HBsamp=round(HBtimes*sRate);
% HB=zeros(3,1017);
% for i=2:(length(HBsamp)-2)
%     HB(1,:)=HB(1,:)+meanMEG(HBsamp(i)-316:HBsamp(i)+700);
%     HB(2,:)=HB(2,:)+corHBf(HBsamp(i)-316:HBsamp(i)+700);
%     HB(3,:)=HB(3,:)+corHB(HBsamp(i)-316:HBsamp(i)+700);
% end
% figure;plot(HB');legend('orig','correctF','correct');title('avg by correct')

%% 
cd /media/yuval/Elements/SchizoRestMaor/AviMa10
p=pdf4D(source);
cleanCoefs = createCleanFile(p, source,...
    'byLF',256,'Method','Adaptive',...
    'xClean',[4,5,6],...
    'byFFT',0,...
    'HeartBeat',0,... % use [] for automatic HB cleaning, use 0 to avoid HB cleaning
    'maskTrigBits', 256);

fileName='xc,lf_c,rfhp0.1Hz,ee';
p=pdf4D(fileName);
%cleanCoefs = createCleanFile(p, fileName,'byLF',0,'byFFT',0,'HeartBeat',[]);
hdr=get(p,'header');
sRate=get(p,'dr');
lat=[1 hdr.epoch_data{1}.pts_in_epoch];
chi=channel_index(p,'MEG');
meanMEG=mean(read_data_block(p,lat,chi));
% fileName='hb,xc,lf_c,rfhp0.1Hz,ee';
% p1=pdf4D(fileName);
%meanMEGhb=mean(read_data_block(p1,lat,chi));
%artifact=meanMEG-meanMEGhb;
%figure;plot(artifact)
[data,HBtimes]=correctHB(read_data_block(p,lat,chi),sRate);
cfg.matchMethod='meanMEG';[dataMM,HBtimesMM]=correctHB(read_data_block(p,lat,chi),sRate,1,[],cfg);
corHB=mean(data);
artifact1=meanMEG-corHB;
%figure;plot(artifact);hold on;plot(artifact1,'k');plot(meanMEG,'r');legend('create','correct','orig')
corHBMM=mean(dataMM);
HBsamp=round(HBtimes*sRate);
HB=zeros(3,1017);
for i=2:(length(HBsamp)-2)
    HB(1,:)=HB(1,:)+meanMEG(HBsamp(i)-316:HBsamp(i)+700);
    HB(2,:)=HB(2,:)+corHBMM(HBsamp(i)-316:HBsamp(i)+700);
    HB(3,:)=HB(3,:)+corHB(HBsamp(i)-316:HBsamp(i)+700);
end
figure;plot(HB');legend('orig','MM','xcorr');title('avg by HBtimes')

HBsampMM=round(HBtimesMM*sRate);
HB=zeros(3,1017);
for i=2:(length(HBsampMM)-2)
    HB(1,:)=HB(1,:)+meanMEG(HBsampMM(i)-316:HBsampMM(i)+700);
    HB(2,:)=HB(2,:)+corHBMM(HBsampMM(i)-316:HBsampMM(i)+700);
    HB(3,:)=HB(3,:)+corHB(HBsampMM(i)-316:HBsampMM(i)+700);
end
figure;plot(HB');legend('orig','MM','xcorr');title('avg by HBtimesMM')


%sm=smooth(meanMEG,5);
figure;plot(meanMEG,'k')
hold on
plot(HBsamp,meanMEG(round(HBsamp)),'.g')
plot(HBsampMM,meanMEG(round(HBsampMM)),'ob')


cfg=[];
cfg.dataset='xc,lf_c,rfhp0.1Hz,ee';
cfg.channel='MEG';
% cfg.hpfilter='yes';
% cfg.hpfreq=3;
cfg.bsfilter='yes';
cfg.bsfreq=[9 11];
flt=ft_preprocessing(cfg);
figure;plot(meanMEG,'k')
hold on
plot(mean(flt.trial{1}),'b')
ECG=mean(flt.trial{1});
[dataF,HBtimesF,temp]=correctHB(read_data_block(p,lat,chi),sRate,0,ECG);
figure;plot(temp)

cfg=[];
cfg.dataset='xc,lf_c,rfhp0.1Hz,ee';
cfg.channel='MEG';
cfg.demean='yes';
cfg.trl=[1:1017:223795]';
cfg.trl(:,2)=cfg.trl+1016;
cfg.trl(:,3)=0;
cfg.trl=cfg.trl(1:end-1,:);
orig=ft_preprocessing(cfg);
comp=ft_componentanalysis([],orig);
cfg=[];
cfg.layout='4D248.lay';
cfg.channel=comp.label(1:5);
ft_databrowser(cfg,comp);
cfg=[];
cfg.layout='4D248.lay';
cfg.component=1:25;
ft_topoplotIC(cfg,comp);
cfg=[];
cfg.method='pca';
comp=ft_componentanalysis(cfg,orig);
cfg=[];
cfg.layout='4D248.lay';
cfg.channel=comp.label(1:5);
ft_databrowser(cfg,comp);

[~,~,~,~,~,topo]=correctHB;
figure;topoplot248(topo,[],1);


    

%% 
fileName='c,rfhp0.1Hz,ee';
cd /media/yuval/Elements/SchizoRestMaor/AviMa11
p=pdf4D(fileName);
% cleanCoefs = createCleanFile(p, source,...
%     'byLF',256,'Method','Adaptive',...
%     'xClean',[4,5,6],...
%     'byFFT',0,...
%     'HeartBeat',0,... % use [] for automatic HB cleaning, use 0 to avoid HB cleaning
%     'maskTrigBits', 256);
tic;
cleanCoefs = createCleanFile(p, fileName,'byLF',0,'byFFT',0,'HeartBeat',[]);
toc
tic;
clean=correctHB;
rewrite_pdf(clean);
toc
hdr=get(p,'header');
sRate=get(p,'dr');
lat=[1 hdr.epoch_data{1}.pts_in_epoch];
chi=channel_index(p,'MEG');
meanMEG=mean(read_data_block(p,lat,chi));
p1=pdf4D('hb_c,rfhp0.1Hz,ee');
meanMEGhb=mean(read_data_block(p1,lat,chi));
artifact=meanMEG-meanMEGhb;
figure;plot(artifact)
corHB=mean(data);
artifact1=meanMEG-corHB;
figure;plot(artifact);hold on;plot(artifact1,'k');plot(meanMEG,'r');legend('create','correct','orig')

corHB=mean(clean);

HBsamp=cleanCoefs.HBparams.whereisHB;
HB=zeros(3,1017);
for i=2:(length(HBsamp)-2)
    HB(1,:)=HB(1,:)+meanMEG(HBsamp(i)-316:HBsamp(i)+700);
    HB(2,:)=HB(2,:)+meanMEGhb(HBsamp(i)-316:HBsamp(i)+700);
    HB(3,:)=HB(3,:)+corHB(HBsamp(i)-316:HBsamp(i)+700);
end
figure;plot(HB');legend('orig','create','correct');title('avg by cleanCoefs')
cleanF=correctHB;

cfg=[];
cfg.dataset='c,rfhp0.1Hz,ee';
cfg.channel='MEG';
cfg.demean='yes';
orig=ft_preprocessing(cfg);

cfg.bsfilter='yes';
cfg.bsfreq=[9 11];
fltA=ft_preprocessing(cfg);
cfg=[];
cfg.dataset='c,rfhp0.1Hz,ee';
cfg.channel='MEG';
cfg.demean='yes';
cfg.hpfilter='yes';
cfg.hpfreq=3;
flt3=ft_preprocessing(cfg);

[~,HBtimes,temp]=correctHB(orig.trial{1},orig.fsample,0,mean(orig.trial{1}));
[dataA,HBtimesF,tempF]=correctHB(orig.trial{1},orig.fsample,0,mean(fltA.trial{1}));
[dataF3,HBtimesF3,tempF3]=correctHB(orig.trial{1},orig.fsample,0,mean(flt3.trial{1}));
%HBsamp=cleanCoefs.HBparams.whereisHB;
HBsamp=orig.fsample*HBtimes;
HB=zeros(3,1017);
for i=2:(length(HBsamp)-2)
    HB(1,:)=HB(1,:)+mean(orig.trial{1}(:,HBsamp(i)-316:HBsamp(i)+700));
    HB(2,:)=HB(2,:)+mean(dataA(:,HBsamp(i)-316:HBsamp(i)+700));
    HB(3,:)=HB(3,:)+mean(dataF3(:,HBsamp(i)-316:HBsamp(i)+700));
end
figure;plot(HB');legend('orig','alpha bs','hp ECG');

figure;plot(meanMEG,'k')
hold on
plot(mean(flt.trial{1}),'b')
ECG=mean(flt.trial{1});
[dataF,HBtimesF,temp]=correctHB(read_data_block(p,lat,chi),sRate,0,ECG);
figure;plot(temp)

trig=readTrig_BIU;


%% alice
cd /home/yuval/Copy/MEGdata/alice/idan/files
load eog

cd ../../ga
load GavgMalice
load GavgEalice
load GavgM20
load GavgE20
cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
ft_topoplotER(cfg,GavgMalice)
ft_topoplotER(cfg,GavgM20)
cfg=[];
cfg.layout='WG32.lay';
cfg.channel=chi;
cfg.interactive='yes';
ft_topoplotER(cfg,GavgEalice)
figure;ft_topoplotER(cfg,GavgE20)

cond={'2','4','20'};
for condi=1:3
    samples='s0:s1';
    if condi==3
        samples='1:s2+1';
    end
    eval(['wts=squeeze(mean(GavgM',cond{condi},'.individual(:,:,',samples,')));']);
    for subi=1:8
        eval(['data=squeeze(GavgM',cond{condi},'.individual(',num2str(subi),',:,',samples,'));']);
        mult=wts'*data;
        tc=mult(logical(eye(764)));
        %tc=tc/mean(tc(1:s3));
        eval(['TC',cond{condi},'(',num2str(subi),',1:764)=tc;']);
    end
end
figure;plot(time,TC20)
figure;plot(time,TC2)
figure;plot(time,TC4)
s0e=nearest(GavgE2.time,t0);
s1e=nearest(GavgE2.time,t1);
s2e=nearest(GavgE20.time,t1);
timeE=GavgE2.time(s0e:s1e);
s3e=nearest(timeE,-0.05);
chi=[1:12,14:18,20:32];
for condi=1:3
    samples='s0e:s1e';
    if condi==3
        samples='1:s2e';
    end
    eval(['wts=squeeze(mean(GavgE',cond{condi},'.individual(:,chi,',samples,')));']);
    for subi=1:8
        %eval(['data=squeeze(GavgE',cond{condi},'.individual(',num2str(subi),',chi,',samples,'));']);
        eval(['data=squeeze(GavgE',cond{condi},'.individual(subi,chi,',samples,'));']);
        mult=wts'*data;
        tc=mult(logical(eye(769)));
        %tc=tc/mean(tc(1:s3e));
        eval(['TCe',cond{condi},'(',num2str(subi),',1:769)=tc;']);
    end
end
figure;plot(timeE,TCe20);ylim([-15 185]);title('Word by Word, 8 subjects')
figure;plot(timeE,TCe2);ylim([-15 185]);title('Natural Reading, 8 subjects')
figure;plot(timeE,TCe4);ylim([-15 185]);title('Natural Reading, 8 subjects')
figure;plot(timeE,TCe2);ylim([-15 185]);
figure;plot(timeE,TCe4);ylim([-15 185]);