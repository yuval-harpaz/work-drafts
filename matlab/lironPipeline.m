load /home/yuval/Data/tel_hashomer/liron/VG_OE.mat
cfg=[];
cfg.preproc.hpfilter='yes';
cfg.preproc.hpfreq=110;
cfg.method='summary';
VG=ft_rejectvisual(cfg,VG);
OE=ft_rejectvisual(cfg,OE);
cfg=[];
cfg.method='summary';
VG=ft_rejectvisual(cfg,VG);
OE=ft_rejectvisual(cfg,OE);

cfg=[];
cfg.dataset='c,rfhp0.1Hz';
cfg.trl=[(VG.sampleinfo(:,1)+305);(OE.sampleinfo(:,1)+305)];
cfg.trl(:,2)=cfg.trl+610;
cfg.trl(:,1)=cfg.trl(:,1)-153;
cfg.trl(:,3)=-153;
cfg.bpfilter='yes';
cfg.bpfreq=[3 35];
cfg.demean='yes';
cfg.baselinewindow=[-0.15 0];
cfg.padding=0.7;
cfg.channel='MEG';
all=ft_preprocessing(cfg);
save all all
cfg=[];
cfg.trials=1:62;
vg=ft_timelockanalysis(cfg,all);
cfg.trials=63:124;
oe=ft_timelockanalysis(cfg,all);
cfg=[];
cfg.interactive='yes';
cfg.layout='4D248.lay';
ft_topoplotER(cfg,vg)
% vg=ft_timelockanalysis([],VG);
% oe=ft_timelockanalysis([],OE);

t=sort([(VG.sampleinfo(:,1)+305)/1017.25;(OE.sampleinfo(:,1)+305)/1017.25]);
Trig2mark('All',t');
clear
FN='c,rfhp0.1Hz';
cd /home/yuval/Data/tel_hashomer
!~/bin/SAMcov -r liron -d c,rfhp0.1Hz -m VGall -v
!~/bin/SAMwts -r liron -d c,rfhp0.1Hz -m VGall -c Alla -v

wtsNoSuf='/home/yuval/Data/tel_hashomer/liron/SAM/VGall,1-35Hz,Alla';
[SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts')


%%
cd /home/yuval/Data/tel_hashomer/liron
load all
load(['SAM/VGall,1-35Hz,Alla.mat'])
cfg=[];
cfg.trials=1:62;
vg=ft_timelockanalysis(cfg,all);
cfg.trials=63:124;
oe=ft_timelockanalysis(cfg,all);
cfg=[];
cfg.trials=1:62;
cfg.bpfreq=[8 13];
cfg.bpfilter='yes';
cfg.demean='yes';
VGalpha=ft_preprocessing(cfg,all);
cfg.trials=63:124;
OEalpha=ft_preprocessing(cfg,all);
%cfg.channel    = {'MEG' '-A204' '-A74'};

noise=rand(248,1017)-0.5;
ns=ActWgts*noise;
%nsFac=prctile(ns,75,2);
ns=ns-repmat(mean(ns,2),1,size(ns,2));
ns=ns.*ns;
ns=mean(ns,2);

% SAMspm
spm=zeros(size(ActWgts,1),1);
conds={'VGalpha','OEalpha'};
for condi=1:2
    eval(['data=',conds{condi},';'])
    for triali=1:length(data.trial);
        vs=ActWgts*data.trial{1,triali};
        vs=vs-repmat(mean(vs,2),1,size(vs,2));
        pow=vs.*vs;
        pow=mean(pow,2);
        pow=pow./ns;
        spm=spm+pow;
        display(['trial ',num2str(triali)])
    end
    eval(['spm',conds{condi}(1:2),'=spm./triali;'])
end
   
cfg=[];
%cfg.func='~/vsMovies/Data/funcTemp+orig';
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='vgAlpha';
VS2Brik(cfg,spmVG);

VGvs=ActWgts*vg.avg./repmat(nsFac,1,size(vg.avg,2));
% OEvs=ActWgts*oe.avg./repmat(nsFac,1,size(oe.avg,2));

torig=-150; % beginning of VS in ms
TR=num2str(1000/1017.25); % time of requisition, time gap between samples (sampling rate here is 1017.25)
cfg=[];
%cfg.func='~/vsMovies/Data/funcTemp+orig';
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='vg';
cfg.TR=TR;
cfg.torig=torig;
VS2Brik(cfg,VGvs);
!mv vg+* ../
cd ..
!~/abin/3dcalc -a vg+orig -expr '1e+9*a' -prefix sc_vg



load VG_OE
cfg2            = [];
cfg2.output     = 'pow';
cfg2.method     = 'mtmfft';
cfg2.foilim     = [1 100];
cfg2.tapsmofrq  = 1;
cfg2.keeptrials = 'no';
%cfg.channel    = {'MEG' '-A204' '-A74'};
powOE=ft_freqanalysis(cfg2,OE);
powVG=ft_freqanalysis(cfg2,VG);
cfg=[];
cfg.interactive='yes';
cfg.xlim=[10 10];
cfg.layout='4D248.lay';
cfg.zlim=[0 2e-26];
ft_topoplotER(cfg,powVG)

%% 

[vol,grid,mesh,M1,single]=headmodel_BIU([],[],[],[],'localspheres');
hdr=ft_read_header('c,rfhp0.1Hz');
VG.grad=ft_convert_units(hdr.grad,'mm');
cfg                  = [];
cfg.covariance       = 'yes';
cfg.removemean       = 'yes';
cfg.keeptrials='yes';
cov=timelockanalysis(cfg, VG);
cfg8        = [];
cfg8.method = 'sam';
cfg8.grid= grid;
cfg8.vol    = vol;
cfg8.lambda = 0.05;
%cfg.channel={'MEG','MEGREF'};
cfg8.keepfilter='yes';
source = ft_sourceanalysis(cfg8, cov);
source.avg.nai=(source.avg.pow-source.avg.noise)./source.avg.noise;

load ~/ft_BIU/matlab/files/sMRI.mat
mri_realign=sMRI;
mri_realign.transform=inv(M1)*sMRI.transform;
cfg10 = [];
cfg10.parameter = 'avg.pow';
inai = sourceinterpolate(cfg10, source,mri_realign);

cfg9 = [];
cfg9.interactive = 'yes';
cfg9.funparameter = 'avg.pow';
cfg9.method='ortho';
%cfg.funcolorlim = [0 50];
figure;ft_sourceplot(cfg9,inai);


%% weights for alpha

wtsNoSuf='/home/yuval/Data/tel_hashomer/liron/SAM/alpha,7-13Hz,Alla';
[SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts')
%
 
cd /home/yuval/Data/tel_hashomer/liron
load all
load(['SAM/VGall,1-35Hz,Alla.mat'])

cfg=[];
cfg.trials=1:62;
vg=ft_timelockanalysis(cfg,all);
cfg.trials=63:124;
oe=ft_timelockanalysis(cfg,all);
cfg=[];
cfg.trials=1:62;
cfg.bpfreq=[8 13];
cfg.bpfilter='yes';
cfg.demean='yes';
VGalpha=ft_preprocessing(cfg,all);
cfg.trials=63:124;
OEalpha=ft_preprocessing(cfg,all);
%cfg.channel    = {'MEG' '-A204' '-A74'};

%noise=rand(248,1017)-0.5;
ns=ActWgts;
%nsFac=prctile(ns,75,2);
ns=ns-repmat(mean(ns,2),1,size(ns,2));
ns=ns.*ns;
ns=mean(ns,2);

% SAMspm
spm=zeros(size(ActWgts,1),1);
conds={'VGalpha','OEalpha'};
for condi=1:2
    eval(['data=',conds{condi},';'])
    for triali=1:length(data.trial);
        vs=ActWgts*data.trial{1,triali};
        vs=vs-repmat(mean(vs,2),1,size(vs,2));
        pow=vs.*vs;
        pow=mean(pow,2);
        pow=pow./ns;
        spm=spm+pow;
        display(['trial ',num2str(triali)])
    end
    eval(['spm',conds{condi}(1:2),'=spm./triali;'])
end
   
cfg=[];
%cfg.func='~/vsMovies/Data/funcTemp+orig';
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='vgAlphaAlpha';
VS2Brik(cfg,spmVG);
cfg.prefix='oeAlphaAlpha';
VS2Brik(cfg,spmOE);

!~/abin/3dcalc -a vgAlphaAlpha+orig -b oeAlphaAlpha+orig -exp "b-a" -prefix oe_vg_alpha

%% 2 -6  7
cd /home/yuval/Data/tel_hashomer
load liron/all
cfg=[];
cfg.trials=1:62;
cfg.bpfreq=[8 13];
cfg.bpfilter='yes';
cfg.demean='yes';
VGalpha=ft_preprocessing(cfg,all);
cfg.trials=63:124;
OEalpha=ft_preprocessing(cfg,all);
load(['liron/SAM/VGall,1-35Hz,Alla.mat'])
wts='/home/yuval/Data/tel_hashomer/liron/SAM/alpha,points.txt.wts';
conds={'VGalpha','OEalpha'};
NspmLoop % this takes a couple of days!!!
cd liron
cfg=[];
%cfg.func='~/vsMovies/Data/funcTemp+orig';
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='vgNalpha';
VS2Brik(cfg,NspmVG);
cfg.prefix='oeNalpha';
VS2Brik(cfg,NspmOE);
!~/abin/3dcalc -a vgNalpha+orig -b oeNalpha+orig -exp "(b-a)*10^32" -prefix oe_vg_Nalpha
%% neighbour vertices N weights
load /home/yuval/Data/tel_hashomer/liron/vert % taken from MRliron/ortho_brainhull.ply, RAI order
load /home/yuval/Data/tel_hashomer/liron/face

fv={};
fv.faces=face+1; % index started with 0
fv.vertices=(-1)*vert(:,2); % RAI to PRI
fv.vertices(:,2)=vert(:,1);
fv.vertices(:,3)=vert(:,3);

% patch(fv)
% alpha(0.5)
cd /home/yuval/Data/tel_hashomer
load liron/all
cfg=[];
cfg.trials=1:62;
cfg.bpfreq=[8 13];
cfg.bpfilter='yes';
cfg.demean='yes';
VGalpha=ft_preprocessing(cfg,all);
cfg.trials=63:124;
OEalpha=ft_preprocessing(cfg,all);
conds={'VGalpha','OEalpha'};
for vi=1:length(fv.vertices)
    [~,vrti]=neigbourVerts(fv,vi);
    xyz=fv.vertices([vi,vrti'],:); % first vs is center, the rest are the neighbours
    nV=size(xyz,1);
    display([num2str(vi),' of ',num2str(length(fv.vertices)),' vertices']);
    eval(['!echo ',num2str(nV),' > liron/SAM/points.txt'])
    for neigi=1:nV
        xyzstr=[num2str(xyz(neigi,1)),' ',num2str(xyz(neigi,2)),' ',num2str(xyz(neigi,3))];
        eval(['!echo "',xyzstr,'" >> liron/SAM/points.txt']);
    end
    !SAMNwts -r liron -d c,rfhp0.1Hz -m alpha -c Alla -t points.txt -v
    [~, ~, actWgts]=readWeights(wts);
    %noise=rand(248,1017)-0.5;
    %ns=ActWgts*noise;
    ns=actWgts(1,:)-mean(actWgts(1,:),2);
    ns=ns.*ns;
    ns=mean(ns);
    for condi=1:2
        eval(['lng=length(',conds{condi},'.trial);'])
        nspm=0;
        for triali=1:lng;
            %                         if triali==1
            %                             display(['going through ',num2str(lng),' trials'])
            %                         end
            eval(['vs=actWgts(1,:)*',conds{condi},'.trial{1,triali};']);
            vs=vs-mean(vs);
            pow=vs.*vs;
            pow=mean(pow);
            pow=pow./ns;
            nspm=nspm+pow;
            %display(['trial ',num2str(triali)])
        end
        eval(['Nspm',conds{condi}(1:2),'([indR indL],1)=nspm./triali;'])
    end
end

%%
!echo 2 > points.txt
!echo "2 -6 7" >> points.txt
!echo "2 6 7" >> points.txt
!cp points.txt SAM/
cd ..

!SAMNwts -r liron -d c,rfhp0.1Hz -m alpha -c Alla -t points.txt -v

[indR,~]=voxIndex([2,-6,7],100.*[...
    SAMHeader.XStart SAMHeader.XEnd ...
    SAMHeader.YStart SAMHeader.YEnd ...
    SAMHeader.ZStart SAMHeader.ZEnd],...
    100.*SAMHeader.StepSize,0);
[indL,~]=voxIndex([2,6,7],100.*[...
    SAMHeader.XStart SAMHeader.XEnd ...
    SAMHeader.YStart SAMHeader.YEnd ...
    SAMHeader.ZStart SAMHeader.ZEnd],...
    100.*SAMHeader.StepSize,0);



wtsNoSuf='/home/yuval/Data/tel_hashomer/liron/SAM/alpha,points.txt';
[SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts')

noise=rand(248,1017)-0.5;
ns=ActWgts*noise;
%nsFac=prctile(ns,75,2);
ns=ns-repmat(mean(ns,2),1,size(ns,2));
ns=ns.*ns;
ns=mean(ns,2);

spm=zeros(size(ActWgts,1),1);
conds={'VGalpha','OEalpha'};
for condi=1:2
    eval(['data=',conds{condi},';'])
    for triali=1:length(data.trial);
        vs=ActWgts*data.trial{1,triali};
        vs=vs-repmat(mean(vs,2),1,size(vs,2));
        pow=vs.*vs;
        pow=mean(pow,2);
        pow=pow./ns;
        spm=spm+pow;
        display(['trial ',num2str(triali)])
    end
    eval(['Nspm',conds{condi}(1:2),'=spm./ns;'])
end
[spmVG(indR),spmVG(indL);NspmVG(1),NspmVG(2)]

%% localyze pca comp
cd /home/yuval/Data/tel_hashomer/liron
load all
cfg=[];
cfg.method='pca';
comp=ft_componentanalysis(cfg,all);
cfg=[];
cfg.layout='4D248.lay';
cfg.channel=comp.label(1:5);
ft_databrowser(cfg,comp);


cfg=[];
cfg.demean='yes';
cfg.bpfilter='yes';
cfg.bpfreq=[8 13];
all=ft_preprocessing(cfg,all);
cfg=[];
cfg.method='pca';
comp=ft_componentanalysis(cfg,all);
cfg=[];
cfg.layout='4D248.lay';
cfg.channel=comp.label(1:5);
%cfg.channel={'runica001','runica002','runica003','runica004','runica005'};
ft_databrowser(cfg,comp);

%% vs by block
% RH Mu source is [1 -3.5 9]
% !abin/3dExtrema -volume alpha+orig > alpha.max
labels = {'M1R','M1L','STSR','STSL','IFGR','OccR','STSR2'};
maxima=[-35 -10 95; 30 -10 90; -60 5 40; 55 10 55;-30 -50 55;-25 45 80;-55 -20 40]; % from alpha.max
maxima=maxima(:,[2 1 3]); % RAI to PRI
maxima(:,1)=-maxima(:,1);
maxima=0.1*maxima; % mm to cm
load /home/yuval/Data/tel_hashomer/liron/all
cfg=[];
cfg.demean='yes';
cfg.bpfilter='yes';
cfg.bpfreq=[8 13];
all=ft_preprocessing(cfg,all);
samp=all.sampleinfo(:,1);
load ('/home/yuval/Data/tel_hashomer/liron/SAM/alpha,7-13Hz,Alla.mat');
boxSize=100.*[SAMHeader.XStart SAMHeader.XEnd ...
    SAMHeader.YStart SAMHeader.YEnd ...
    SAMHeader.ZStart SAMHeader.ZEnd];
[ind,~]=voxIndex(maxima,boxSize,0.5);
Wgts=ActWgts(ind,:);

% noise=Wgts-repmat(mean(Wgts,2),1,size(Wgts,2));
% noise=rand(size(Wgts))-0.5;
% noise=mean(noise.*noise,2);
for triali=1:length(samp)
    vs=Wgts*all.trial{1,triali};
    %vs=normVS(vs,noise,[]);
    pow(1:size(maxima,1),triali)=mean((vs.*vs),2);
end
SD=std(pow');
SD=repmat(SD',1,size(pow,2));
pow=pow./SD;
figure
plot(samp(1:62),pow(2,1:62),'ro')
hold on
plot(samp(63:end),pow(2,63:end),'bo')
save pow pow samp labels

% averagiing blocks
load pow
vgBlockBeg=[1;find(diff(samp(1:62))>27000)+1];
oeBlockBeg=[63;find(diff(samp(63:end))>27000)+63];
vgBlocks=[];oeBlocks=[];
for blocki=1:8
    if blocki~=8
        vgBlocks(1:size(pow,1),blocki)=mean(pow(:,vgBlockBeg(blocki):vgBlockBeg(blocki+1)-1),2);
        oeBlocks(1:size(pow,1),blocki)=mean(pow(:,oeBlockBeg(blocki):oeBlockBeg(blocki+1)-1),2);
    else
        vgBlocks(1:size(pow,1),blocki)=mean(pow(:,vgBlockBeg(blocki):62),2);
        oeBlocks(1:size(pow,1),blocki)=mean(pow(:,oeBlockBeg(blocki):124),2);
    end
end

figure
vsi=6;
bar(1:2:15,vgBlocks(vsi,:),'r')
hold on
bar(2:2:16,oeBlocks(vsi,:),'b')
title(labels(6))

