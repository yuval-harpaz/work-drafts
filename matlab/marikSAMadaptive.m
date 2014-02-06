%% denoised weights
cd /home/yuval/Data/epilepsy/b162b
!SAMcov64 -d hp20_c,rfhp1.0Hz -r adapt -m gamma -v
!SAMwts64 -d hp20_c,rfhp1.0Hz -r adapt -m  gamma -c Alla -v
!cp adapt/SAM/gamma,40-130Hz,Alla.wts adapt/SAM/hp20.wts
!SAMcov64 -d hp20DN_c,rfhp1.0Hz -r adapt -m gamma -v
!SAMwts64 -d hp20DN_c,rfhp1.0Hz -r adapt -m  gamma -c Alla -v
!cp adapt/SAM/gamma,40-130Hz,Alla.wts adapt/SAM/hp20DN.wts

cd adapt/SAM
[~,~, ActWgts]=readWeights('hp20.wts');
cd ..
fn='hp20_c,rfhp1.0Hz';
hdr=ft_read_header(fn);
s1=round(hdr.Fs*115);
trl=s1:round(hdr.Fs):s1+19*hdr.Fs;
trl=trl';
trl(:,2)=trl+round(hdr.Fs);
trl(:,3)=0;
cfg=[];
cfg.trl=trl;
cfg.dataset=fn;
cfg.channel='MEG';
cfg.bpfilter='yes';
cfg.bpfreq=[40 130];
raw=ft_preprocessing(cfg);
ns=mean(abs(ActWgts),2);
pow=zeros(length(ActWgts),length(trl)-1);
for triali=1:length(trl)
    pow(:,triali)=mean(abs(ActWgts*raw.trial{1,triali}),2)./ns;
end
pow=pow.*(10^13);
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='hp20';
cfg.TR =1000;
cfg.torig = 115*1000;
VS2Brik(cfg,pow);
!3dcalc -a maskRS+orig -b hp20+orig -exp 'b*ispositive(a)' -prefix hp20Movie
!rm hp20+*
cd SAM
[~,~, ActWgts]=readWeights('hp20DN.wts');
cd ..
% denoised movie

%load hp20_new_data_100_epoch500_r3
fn='hp20DN_c,rfhp1.0Hz';
cfg=[];
cfg.trl=trl;
cfg.dataset=fn;
cfg.channel='MEG';
cfg.bpfilter='yes';
cfg.bpfreq=[40 130];
raw=ft_preprocessing(cfg);
ns=mean(abs(ActWgts),2);
pow=zeros(length(ActWgts),length(trl)-1);
for triali=1:length(trl)
    pow(:,triali)=mean(abs(ActWgts*raw.trial{1,triali}),2)./ns;
end
pow=pow.*(10^13);
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix='hp20DN';
cfg.TR =1000;
cfg.torig = 115*1000;
VS2Brik(cfg,pow);

!3dcalc -a maskRS+orig -b hp20DN+orig -exp 'b*ispositive(a)' -prefix hp20DNmovie
!rm hp20DN+*
%% try short time
marikSAMloop(130)
cd /home/yuval/Data/epilepsy/b162b
!mv adapt/MarkerFile.mrk adapt/MarkerFileOrig.mrk
