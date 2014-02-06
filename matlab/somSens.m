fn='c,rfhp0.1Hz';
p=pdf4D(fn);
cleanCoefs = createCleanFile(p, fn,...
    'byLF',[] ,'method','ADAPTIVE',...
    'xClean',[4,5,6],...
    'byFFT',0,...
    'outLierMargin',25,...
    'HeartBeat',[]);
% data=correctLF;
% rewrite_pdf(data,[],[],'lf');
% fn='lf_c,rfhp1.0Hz';
% data=correctHB(fn);
% rewrite_pdf(data,[],[],'lf,hb');
fn='xc,hb,lf_c,rfhp0.1Hz';
trig=readTrig_BIU(fn);
trig=clearTrig(trig);
hdr=ft_read_header(fn);
sRate=hdr.Fs;
% timesR=find(trig==2)./sRate;
% timesL=find(trig==4)./sRate;

cfg=[];
cfg.trl=find(trig);
cfg.trl=cfg.trl'-round(sRate*0.15);
cfg.trl(:,2)=cfg.trl+round(sRate*0.5);
cfg.trl(:,3)=-round(sRate*0.15);
cfg.dataset=fn;
cfg.channel='MEG';
cfg.demean='yes';
%cfg.blcwindow=[-0.15 0];
%cfg.bpfilter='yes';
%cfg.bpfreq=[3 35];
cfg.hpfilter='yes';
cfg.hpfreq=110;
cfg.padding=0.5;
hp=ft_preprocessing(cfg);
good=badTrials(hp);
trialinfo=trig(logical(trig))';
trialinfo=trialinfo(good);
cfg.trl=cfg.trl(good,:);
cfg.blcwindow=[-0.15 0];
cfg.bpfilter='yes';
cfg.bpfreq=[3 35];
cfg.hpfilter='no';
all=ft_preprocessing(cfg);
good=badTrials(all);

Ri=trialinfo(good)==2;
Ri=good(Ri);
cfg=[];
cfg.trials=Ri;
R=ft_timelockanalysis(cfg,all); %right index finger
Li=trialinfo(good)==4;
Li=good(Li);
cfg.trials=Li;
L=ft_timelockanalysis(cfg,all); 
cfg=[];
cfg.interactive='yes';
cfg.layout='4D248.lay';
cfg.xlim=[0.05 0.05];
cfg.ylim=[-1e-13 1e-13];
cfg.zlim=cfg.ylim;
ft_topoplotER(cfg,R)
figure;
ft_topoplotER(cfg,L)
timesR=all.sampleinfo(Ri,1)/sRate-all.time{1,1}(1);
timesL=all.sampleinfo(Li,1)/sRate-all.time{1,1}(1);
times=all.sampleinfo(good,1)/sRate-all.time{1,1}(1);

Trig2mark('Left',timesL','Right',timesR','all',times')
!cp ~/SAM_BIU/docs/SuDi0812.rtw ./som.rtw
%!3dTagalign -master ~/brainhull/master+orig -prefix ./ortho anat+orig
%!3dSkullStrip -input ortho+orig -prefix mask -mask_vol -skulls -o_ply ortho
%!meshnorm ortho_brainhull.ply > hull.shape
cd ..
createPARAM('somAll','ERF','all',[0.05 0.25],'all',[-0.2 0],[3 35],[-0.2 0.5]);
!SAMcov64 -r som -d xc,hb,lf_c,rfhp0.1Hz -m somAll -v
!SAMwts64 -r som -d xc,hb,lf_c,rfhp0.1Hz -m somAll -c alla -v
%!SAMerf -r som -d lf,hb_c,rfhp1.0Hz -m somR -v

cd som/SAM
[~, ~, ActWgts]=readWeights(['somAll,3-35Hz,alla.wts']);
ns=mean(abs(ActWgts),2);
Lvs=(ActWgts*L.avg)./repmat(ns,1,size(L.avg,2));
scale=log10(mean(abs(Lvs(Lvs(:,1)>0)),2));scale=-round(mean(scale));
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='L';
cfg.torig=round(L.time(1)*1000);
cfg.TR=1000/sRate;
VS2Brik(cfg,abs(Lvs.*10^scale));
cfg.prefix='R';
Rvs=(ActWgts*R.avg)./repmat(ns,1,size(L.avg,2));
VS2Brik(cfg,abs(Rvs.*10^scale));


