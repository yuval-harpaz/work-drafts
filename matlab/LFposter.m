



%% Fig 1

fact=0.1;
% http://fieldtrip.fcdonders.nl/faq/why_is_there_a_residual_50hz_line-noise_component_after_applying_a_dft_filter
% sampling rate
fs = 1017;
% time
t = (1:10170)/fs;
% frequency (Hz)
f = 50;         
% increasing amplitude
amp = (1:10170)/fs;
% 50 Hz sine with increasing amplitude
s1 = amp.*sin(2*pi*f*t);
%plot(t, s1, 'b');
% dftfilter: fit 50 Hz sine (with constant amplitude)
avgamp = mean(amp);
s2 = avgamp.*sin(2*pi*f*t);
%hold on; plot(t, s2, 'r');
s3 = s1-s2;

fig1=figure; plot(t, s3/5, 'k','linewidth',2);
% bandstopfilter: remove 4.9 to 5.1 Hz 
s4 = ft_preproc_bandstopfilter(s1, fs,[50-fact 50+fact] , 2);
hold on; plot(t, s4, 'm','linewidth',2);
set(gca,'FontSize',15,'FontName','Times','linewidth',2)
xlim([0 6])
l1=legend('50Hz DFT filter (10s)','49.9-50.1 Notch filter')
set(l1,'box','off')
xlabel('Time (s)')
ylabel('Residual Artifact')
title('Simulated Filter Distortion')
box off
saveas(fig1,'~/Desktop/poster/fig1.tif')
%% Fig 2
cd /home/yuval/Data/emptyRoom2
trl=1:1017:1017*100;
trl=trl';
trl(:,2)=trl+1017;
trl(:,3)=0;
cfg=[];
cfg.trl=trl;
cfg.channel='A185';%'A149';
cfg.demean='yes';
cfg.dataset=source;
data=ft_preprocessing(cfg)
% f=fftBasic(data.trial{1,1},data.fsample);
% f50=abs(f(:,50));
% cfg=[];
% cfg.interactive='yes';
% topoplot248(f50,cfg);
fact=2;
cfg=[];
cfg.bsfilter='yes';
cfg.bsfreq=[50-fact 50+fact];
bs=ft_preprocessing(cfg,data);
cfg=[];
cfg.dftfilter='yes';
cfg.dftfreq=50;
dft=ft_preprocessing(cfg,data);
for triali=1:100;
    if triali==1
        F1=abs(fftBasic(data.trial{1,triali},data.fsample));
        F2=abs(fftBasic(bs.trial{1,triali},data.fsample));
        F3=abs(fftBasic(dft.trial{1,triali},data.fsample));
    else
        F1=F1+abs(fftBasic(data.trial{1,triali},data.fsample));
        F2=F2+abs(fftBasic(bs.trial{1,triali},data.fsample));
        F3=F3+abs(fftBasic(dft.trial{1,triali},data.fsample));
    end
end
f=F1/100;
f(2,:)=F2/100;
f(3,:)=F3/100;

fig2=figure;plot(f','linewidth',2);
xlim([0 75])
set(gca,'FontSize',15,'FontName','Times','linewidth',2)
title('50Hz Artifact for Empty Room MEG')
xlabel('Hz')
ylabel('PSD')
l2=legend('Raw','Notch 48-52','DFT (1s)');
set(l2,'location','NorthWest','box','off')
box off
saveas(fig2,'~/Desktop/poster/fig2.tif')

%% Fig 3, ref channel
cfg=[];
cfg.trl=[1,101725,0];
cfg.channel='MCxaA';%'A149';
cfg.demean='yes';
cfg.dataset=source;
data=ft_preprocessing(cfg);
chanLF=data.trial{1,1};
time=data.time{1,1};
% cfg.channel='MEG';%'A149';
% data=ft_preprocessing(cfg);
% time=data.time{1,1};
% data=data.trial{1,1};
% data(end+1,:)=chanLF;
% [cleanData,whereUp,noiseSamp,Artifact]=correctLF(data,1017.25,chanLF);
[cleanRef,WU,~,Artifact]=correctLF(chanLF,1017.25);
Art=Artifact(1:200);
WU=WU(WU<200);
time=time(1:200);
chLF=chanLF(1:200);
clnRef=cleanRef(1:200);
avg=[2.89119737381359e-13,7.79861182648340e-13,1.07857073207176e-12,8.64481527901416e-13,9.18944765707920e-13,1.04312821954690e-12,1.02630245229774e-12,1.31582818958519e-12,1.22139113018672e-12,4.21806970346207e-13,-2.10098555011177e-13,-7.49795644003205e-13,-1.17914559436105e-12,-1.04310532734657e-12,-1.03721395225933e-12,-1.15760672704210e-12,-9.74597051332109e-13,-1.12901840861876e-12,-1.11480504540830e-12,-3.64048602290936e-13,1.73204407664864e-13,5.88017810807483e-13;]
figure;
plot(time,chLF,'r','linewidth',2)
set(gca,'fontname','times','fontsize',15)
hold on
plot(time(WU(1):WU(1)+19),avg(1:20),'b','linewidth',2)
plot(time,clnRef,'g','linewidth',2)
for WUi=1:10
    line(time([WU(WUi),WU(WUi)]),[min(chLF),max(chLF)],'color','k','linewidth',2,'linestyle','--')
end
legend('noisy channel','average 50Hz wave','cleaned channel','zero crossing');
