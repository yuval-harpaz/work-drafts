cd /home/yuval/Data/alice

cd idan

% clean HB + XC channels, then XC
correctHB;
correctXC('hb_c,rfDC');
% clean HB + but not the XC channels, then XC
correctXC('hbnoxc_c,rfDC');
% clean XC and then HB
correctXC;
correctHB('xc_c,rfDC');

load XCclean
XCclean=XCclean(:,1:101725);
load XC
XC=XC(:,1:101725);
load HBtimes
HBtimes=HBtimes(HBtimes<98);

figure;plot(XC(1,:)-mean(XC(1,:)));hold on;plot(XCclean(1,:),'c');plot(HBtimes*1017.25,0,'.r')

[avgXC,times]=meanHB(XC,1017.25,HBtimes);
avgXCc=meanHB(XCclean,1017.25,HBtimes);
figure;
plot(avgXC','k')
hold on
plot(avgXCc','g')

%% the order (XC HB) doesn't matter much
% Check all the cleaned files where you have best average
% Check time locked alpha before / after
avgHBxh=meanHB('xc,hb_c,rfDC',1017.25,HBtimes);
avgHBhx=meanHB('hb,xc_c,rfDC',1017.25,HBtimes);
avgHBhxn=meanHB('xc,hbnoxc_c,rfDC',1017.25,HBtimes);
avgHB=meanHB('c,rfDC',1017.25,HBtimes);
avgHBh=meanHB('hb_c,rfDC',1017.25,HBtimes);
figure;
plot(times,mean(avgHB),'r')
hold on
plot(times,mean(avgHBh),'b')
plot(times,mean(avgHBhx),'g')
plot(times,mean(avgHBxh),'k')
plot(times,mean(avgHBhxn),'m')

%% time frequency
cd /home/yuval/copy2/MEGdata/alice/idan
load HBtimes
HBtimes=HBtimes(HBtimes<98);
trl=round(HBtimes*1017.25)'-406;
trl(:,2)=round(HBtimes*1017.25)'+1017;
trl(:,3)=-406;
cfg=[];
cfg.dataset='c,rfDC';
cfg.demean='yes';
cfg.trl=trl;
cfg.channel={'MEG','X4','X5','X6'};
data=ft_preprocessing(cfg);
cfg.dataset='hb,xc_c,rfDC';
datahbxc=ft_preprocessing(cfg);
cfg.dataset='hb_c,rfDC';
datahb=ft_preprocessing(cfg);


cfg              = [];
cfg.output       = 'pow';
%cfg.channel      = 'MEG';
cfg.method       = 'mtmconvol';
cfg.taper        = 'hanning';
cfg.foi          = 2:45;                            % freq of interest 3 to 100Hz
%cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.2;  % length of time window fixed at 0.5 sec
cfg.t_ftimwin    = 1./cfg.foi;  % 1 cycle per window
cfg.toi          = data.time{1}(203:51:1300);                    % time window "slides" from -0.1 to 0.5 sec in steps of 0.02 sec (20 ms)
%cfg.trials=1:3;
%cfg.channel='A54';
%cfg.feedback='no';
cfg.tapsmofrq=2;
TF = ft_freqanalysis(cfg, data);
TFhb = ft_freqanalysis(cfg, datahb);
TFhbxc = ft_freqanalysis(cfg, datahbxc);

TFfig=TF;
TFfig.powspctrm=TF.powspctrm-TFhb.powspctrm;
cfg=[];
%cfg.baseline=[-inf -0.2];
%cfg.baselinetype = 'relative'; %or 'absolute'
cfg.layout='4D248.lay';
figure;
ft_multiplotTFR(cfg, TFfig);
TFfig.powspctrm=TFhb.powspctrm-TFhbxc.powspctrm;
figure;
ft_multiplotTFR(cfg, TFfig);

TFmeg=squeeze(mean(mean(TFfig.powspctrm(1:248,8:11,:))));
TFxc=squeeze(mean(mean(TFfig.powspctrm(249:end,8:11,:))));
figure;plot(TF.time,TFmeg)
figure;plot(TF.time,TFxc)

imagesc(squeeze(TF.powspctrm(250,:,:)))
RRR=zeros(248,3);
for trli=1:length(data.trial)
    RRR=RRR+corr(data.trial{1}(1:248,:)',data.trial{1}(249:end,:)');
end
RRR=RRR./trli;
figure;
figure;topoplot248(RRR(:,1));
figure;topoplot248(RRR(:,2));
figure;topoplot248(RRR(:,3));
%% Amyg 8 5

cd /media/yuval/win_disk/Data/Amyg
cd 8
[~,HBtimes]=correctHB;
HBtimes=HBtimes(1:end-3);
trl=round(HBtimes*1017.25)'-406;
trl(:,2)=round(HBtimes*1017.25)'+1017;
trl(:,3)=-406;
cfg=[];
cfg.dataset='c,rfhp0.1Hz';
cfg.demean='yes';
cfg.trl=trl;
cfg.channel={'MEG','X4','X5','X6'};
data=ft_preprocessing(cfg);

cfg              = [];
cfg.output       = 'pow';
cfg.method       = 'mtmconvol';
cfg.taper        = 'hanning';
cfg.foi          = 2:45;                            % freq of interest 3 to 100Hz
%cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.2;  % length of time window fixed at 0.5 sec
cfg.t_ftimwin    = 1./cfg.foi;  % 1 cycle per window
cfg.toi          = data.time{1}(203:51:1300);                    % time window "slides" from -0.1 to 0.5 sec in steps of 0.02 sec (20 ms)
cfg.tapsmofrq=2;
TF = ft_freqanalysis(cfg, data);

cfg=[];
cfg.baseline=[-inf -0.2];
cfg.baselinetype = 'relative'; %or 'absolute'
cfg.layout='4D248.lay';
cfg.channel={'MEG','-A204','-A74'};
figure;
ft_multiplotTFR(cfg, TF);

[~,badi]=ismember({'A204','A74'},data.label);
cfg=[];
cfg.channel={'MEG','-A204','-A74'};
avgHBh=ft_timelockanalysis([],data);
avgHBh.avg(badi,:)=[];
avgHBh.label(badi)=[];
figure;plot(avgHBh.time,avgHBh.avg(1:end-3,:))
figure;plot(avgHBh.time,avgHBh.avg(end-2:end,:))
plot(abs(fftBasic(avgHBh.avg(247:249,408:end),1017))');
save avgHBh avgHBh
