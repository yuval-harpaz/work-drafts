cd /home/yuval/Data/epilepsy/b162b/1
fn='c,rfhp1.0Hz';

p=pdf4D(fn);
cleanCoefs = createCleanFile(p, fn,'byLF',[] ,'byFFT',0,'HeartBeat',[])
fn=['lf_',fn];
tracePlot_BIU(125,135,fn); % activity starts
figure;
tracePlot_BIU(135,145,fn); % 141s repetitive spikes

hdr=ft_read_header(fn);

cfg=[];
cfg.trl=[1:round(hdr.Fs):hdr.nSamples-round(hdr.Fs)]';
cfg.trl(:,2)=cfg.trl+round(hdr.Fs);
cfg.trl(:,3)=0;
cfg.demean='yes';
cfg.dataset=fn;
cfg.channel='MEG';
data=ft_preprocessing(cfg);

cfg=[];
cfg.method='pca';
comp=ft_componentanalysis(cfg,data);
cfg.trials=1:120;
cfg=[];
cfg.layout='4D248.lay';
ft_databrowser(cfg,comp);

cfg=[];
cfg.demean = 'yes';
cfg.component=[4,5];
datapca=ft_rejectcomponent(cfg,comp)

cfg=[];
cfg.output       = 'pow';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = [5:125];
cfg.feedback='no';
cfg.keeptrials='yes';
megFr = ft_freqanalysis(cfg, datapca);
cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
cfg.trials=135:140;
cfg.xlim=[34 34];
cfg.interpolation      = 'linear';
figure;
ft_topoplotER(cfg,megFr);
cfg.trials=141:151;
cfg.xlim=[34 34];

figure;
ft_topoplotER(cfg,megFr);

cd ..
!SAMcov -d lf_c,rfhp1.0Hz -r 1 -m Spikes -v
!SAMwts -d lf_c,rfhp1.0Hz -r 1 -m Spikes -c Global -v
!SAMepi -d lf_c,rfhp1.0Hz -r 1 -m Spikes -v

%% gamma
load megFr
cfg=[];
cfg.trials=125:135;
hf1=ft_freqdescriptives(cfg,megFr);
cfg.trials=115:125;
bl=ft_freqdescriptives(cfg,megFr);
hfN=hf1;
hfN.powspectrm=hf1.powspctrm./bl.powspctrm;
cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
cfg.xlim=[34 34];
cfg.interpolation      = 'linear';
figure;
ft_topoplotER(cfg,hfN); % 30-75Hz
bl=115:124;
start=125:134;
spikes=135:144;
Trig2mark('baseline',bl,'start',start,'spikes',spikes)

!SAMcov64 -d lf_c,rfhp1.0Hz -r 1 -m SPMgamma -v
!SAMwts64 -d lf_c,rfhp1.0Hz -r 1 -m  SPMgamma -c starta -v
cd 1/SAM
[~,~, ActWgts]=readWeights('SPMgamma,30-75Hz,starta.wts');
cd ..
load datapca
cfg=[];
cfg.bpfilter='yes';
cfg.bpfreq=[30 75];
g=ft_preprocessing(cfg,datapca);



ictal=zeros(length(ActWgts),1);
for tri=125:134
    ictal=ictal+mean(abs(ActWgts*g.trial{1,tri}),2);
end
ictal=ictal./10;
preictal=zeros(length(ActWgts),1);
for tri=115:124
    preictal=preictal+mean(abs(ActWgts*g.trial{1,tri}),2);
end
preictal=preictal./10;

nai=(ictal-preictal)./preictal;
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='gamma';
VS2Brik(cfg,nai);
!3dSkullStrip -input ortho+orig -prefix mask -mask_vol -skulls -o_ply ortho
!3dresample -master gamma+orig -prefix maskRS -inset mask+orig
!3dcalc -a maskRS+orig -b gamma+orig -exp 'b*ispositive(a)' -prefix gammaMasked

% ictal=zeros(length(ActWgts),1);
% inside=find(ActWgts(:,1));
% cnt=0;
% utest
% cfg=[];
% cfg.step=5;
% cfg.boxSize=[-120 120 -90 90 -20 150];
% cfg.prefix='gammaU';
% VS2Brik(cfg,ictal);

%%  Nolte

!SAMcov -d lf_c,rfhp1.0Hz -r 1 -m SpikesNolte -v
!SAMwts -d lf_c,rfhp1.0Hz -r 1 -m SpikesNolte -c Global -v
!SAMepi -d lf_c,rfhp1.0Hz -r 1 -m SpikesNolte -v