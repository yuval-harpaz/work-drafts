function aliceAlphaB1(subFold)
cd /home/yuval/Data/alice
cd(subFold)
LSclean=ls('*lf*');
megFNc=LSclean(1:end-1);
load LRpairsEEG
LRpairsEEG=LRpairs;
load LRpairs
load files/triggers
load files/evt
resti=102;
% EEG
sampBeg=round(evt(find(evt(:,3)==resti),1)*1024);
sampEnd=sampBeg+60*1024;
samps1s=sampBeg:1024:sampEnd-1;
trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
eeg=pow(trl,LRpairsEEG);
% title(num2str(resti))
% MEG
sampBeg=trigS(find(trigV==resti));
sampEnd=sampBeg+60*1017.23;
samps1s=sampBeg:1017:sampEnd-100;
trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
meg=pow(trl,LRpairs);
% title(num2str(resti))
% clear eegFr eegLR eegCoh megFr megLR megCoh
% save fr eegFr* eegLR* eegCoh* megFr* megLR* megCoh*
% end
%% resample and run component analysis
cfg=[];
cfg.bpfilter='yes';
cfg.bpfreq=[5 15];
cfg.demean='yes';
megBP=ft_preprocessing(cfg,meg);
eegBP=ft_preprocessing(cfg,eeg);
cfg=[];
cfg.detrend='no';
%cfg.resamplefs=300;
% trim filter artifact, take 0.1 to 0.9
time=[0.100000000000000,0.103333333333333,0.106666666666667,0.110000000000000,0.113333333333333,0.116666666666667,0.120000000000000,0.123333333333333,0.126666666666667,0.130000000000000,0.133333333333333,0.136666666666667,0.140000000000000,0.143333333333333,0.146666666666667,0.150000000000000,0.153333333333333,0.156666666666667,0.160000000000000,0.163333333333333,0.166666666666667,0.170000000000000,0.173333333333333,0.176666666666667,0.180000000000000,0.183333333333333,0.186666666666667,0.190000000000000,0.193333333333333,0.196666666666667,0.200000000000000,0.203333333333333,0.206666666666667,0.210000000000000,0.213333333333333,0.216666666666667,0.220000000000000,0.223333333333333,0.226666666666667,0.230000000000000,0.233333333333333,0.236666666666667,0.240000000000000,0.243333333333333,0.246666666666667,0.250000000000000,0.253333333333333,0.256666666666667,0.260000000000000,0.263333333333333,0.266666666666667,0.270000000000000,0.273333333333333,0.276666666666667,0.280000000000000,0.283333333333333,0.286666666666667,0.290000000000000,0.293333333333333,0.296666666666667,0.300000000000000,0.303333333333333,0.306666666666667,0.310000000000000,0.313333333333333,0.316666666666667,0.320000000000000,0.323333333333333,0.326666666666667,0.330000000000000,0.333333333333333,0.336666666666667,0.340000000000000,0.343333333333333,0.346666666666667,0.350000000000000,0.353333333333333,0.356666666666667,0.360000000000000,0.363333333333333,0.366666666666667,0.370000000000000,0.373333333333333,0.376666666666667,0.380000000000000,0.383333333333333,0.386666666666667,0.390000000000000,0.393333333333333,0.396666666666667,0.400000000000000,0.403333333333333,0.406666666666667,0.410000000000000,0.413333333333333,0.416666666666667,0.420000000000000,0.423333333333333,0.426666666666667,0.430000000000000,0.433333333333333,0.436666666666667,0.440000000000000,0.443333333333333,0.446666666666667,0.450000000000000,0.453333333333333,0.456666666666667,0.460000000000000,0.463333333333333,0.466666666666667,0.470000000000000,0.473333333333333,0.476666666666667,0.480000000000000,0.483333333333333,0.486666666666667,0.490000000000000,0.493333333333333,0.496666666666667,0.500000000000000,0.503333333333333,0.506666666666667,0.510000000000000,0.513333333333333,0.516666666666667,0.520000000000000,0.523333333333333,0.526666666666667,0.530000000000000,0.533333333333333,0.536666666666667,0.540000000000000,0.543333333333333,0.546666666666667,0.550000000000000,0.553333333333333,0.556666666666667,0.560000000000000,0.563333333333333,0.566666666666667,0.570000000000000,0.573333333333333,0.576666666666667,0.580000000000000,0.583333333333333,0.586666666666667,0.590000000000000,0.593333333333333,0.596666666666667,0.600000000000000,0.603333333333333,0.606666666666667,0.610000000000000,0.613333333333333,0.616666666666667,0.620000000000000,0.623333333333333,0.626666666666667,0.630000000000000,0.633333333333333,0.636666666666667,0.640000000000000,0.643333333333333,0.646666666666667,0.650000000000000,0.653333333333333,0.656666666666667,0.660000000000000,0.663333333333333,0.666666666666667,0.670000000000000,0.673333333333333,0.676666666666667,0.680000000000000,0.683333333333333,0.686666666666667,0.690000000000000,0.693333333333333,0.696666666666667,0.700000000000000,0.703333333333333,0.706666666666667,0.710000000000000,0.713333333333333,0.716666666666667,0.720000000000000,0.723333333333333,0.726666666666667,0.730000000000000,0.733333333333333,0.736666666666667,0.740000000000000,0.743333333333333,0.746666666666667,0.750000000000000,0.753333333333333,0.756666666666667,0.760000000000000,0.763333333333333,0.766666666666667,0.770000000000000,0.773333333333333,0.776666666666667,0.780000000000000,0.783333333333333,0.786666666666667,0.790000000000000,0.793333333333333,0.796666666666667,0.800000000000000,0.803333333333333,0.806666666666667,0.810000000000000,0.813333333333333,0.816666666666667,0.820000000000000,0.823333333333333,0.826666666666667,0.830000000000000,0.833333333333333,0.836666666666667,0.840000000000000,0.843333333333333,0.846666666666667,0.850000000000000,0.853333333333333,0.856666666666667,0.860000000000000,0.863333333333333,0.866666666666667,0.870000000000000,0.873333333333333,0.876666666666667,0.880000000000000,0.883333333333333,0.886666666666667,0.890000000000000,0.893333333333333,0.896666666666667,0.900000000000000];
cfg.time={};
for ti=1:length(meg.trial)
    cfg.time{1,ti}=time;
end
eegRS=ft_resampledata(cfg,eegBP);
megRS=ft_resampledata(cfg,megBP);




% look for mu in MEG

cfg=[];
cfg.output       = 'pow';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = [9:11,120];
cfg.feedback='no';
cfg.keeptrials='yes';
megFr = ft_freqanalysis(cfg, meg);
eegFr = ft_freqanalysis(cfg, eeg);
[~,maxch]=max(max(mean(megFr.powspctrm(:,:,1:3),1),[],3));
[~,maxfri]=max(mean(squeeze(megFr.powspctrm(:,maxch,1:3)),1));
maxfr=megFr.freq(maxfri);
cfg=[];
cfg.layout='4D248.lay';
cfg.highlight='labels';
cfg.xlim=[maxfr maxfr];
cfg.highlightchannel=megFr.label(maxch);
ft_topoplotER(cfg,megFr);

% correlation between max alpha MEG channel and each EEG channel
for chi=1:length(eegRS.label)
    rt=0;
    for triali=1:length(eegRS.trial)
        rt=rt+corr(eegRS.trial{1,triali}(chi,:)',megRS.trial{1,triali}(maxch,:)');
    end
    R(chi)=rt/length(eegRS.trial);
end
R=abs(R);
[~,i]=max(R);
maxR=eeg.label{i};
r=R;
clear R
% correlation between max alpha MEG and EEG fft
for chi=1:length(eegRS.label)
    R(chi)=corr(eegFr.powspctrm(:,chi,maxfri),megFr.powspctrm(:,maxch,maxfri));
end
R(R<0)=0;
[v,i]=max(abs(R));
maxRf=eeg.label{i};
eegR=eegFr;
eegR.powspctrm=mean(eegFr.powspctrm,1);
R(isnan(R))=0;
eegR.powspctrm(1,:,maxfri)=R;
cfg=[];
cfg.layout='WG32.lay';
cfg.highlight='labels';
cfg.xlim=[maxfr maxfr];
cfg.zlim=[0 1];
cfg.highlightchannel=maxRf;
figure;
ft_topoplotER(cfg,eegR);
colorbar
title('fft corr')

figure;
cfg.highlightchannel=maxR;
r(isnan(r))=0;
eegR.powspctrm(1,:,maxfri)=r;
ft_topoplotER(cfg,eegR);
colorbar
title('raw corr')
% %cfg.method='fastica';
% %cfg.method='pca';
% %cfg.numcomponent=40;
% megCA=ft_componentanalysis([],megRS);
% cfg=[];
% cfg.layout='4D248.lay';
% cfg.channel = {megCA.label{1:5}};
% cfg=ft_databrowser(cfg,megCA);
% %FrCA = ft_freqanalysis(cfg, megCA);
% 
% 
% 
% eegRSm=eegRS;
% eegRSm.label{end+1,1}='MEGcomp';
% for triali=1:length(megCA.trial)
%     eegRSm.trial{1,triali}(end+1,:)=megCA.trial{1,triali}(2,:);
% end
% 
% cfg=[];
% cfg.method='pca';
% eegPCA=ft_componentanalysis(cfg,eegRSm);
% eegICA=ft_componentanalysis([],eegRSm);
% cfg.method='fastica';
% eegFICA=ft_componentanalysis(cfg,eegRSm);
% 
% cfg=[];
% cfg.layout='WG32.lay';
% cfg.channel = {eegFICA.label{7}};
% cfg=ft_databrowser(cfg,eegFICA);
% 
% 
% for triali=4 %1:length(megCA.trial)
%     X=real(eegFICA.trial{1,4}(:,:)');
%     Y=megCA.trial{1,4}(2,:)';
%     cr=corr(X,Y);
%     [~,compi]=max(cr);
%     
% end
% 
% plot(eegPCA.time{1,1},eegPCA.trial{1,4}(33,:))
% 
% 




function data=pow(trl,LRpairs)
EEG=true;
if length(LRpairs)==115
    EEG=false;
end
cfg=[];
cfg.trl=trl;
cfg.channel='MEG';
if EEG
    cfg.channel='EEG';
end
cfg.demean='yes';
cfg.feedback='no';
if EEG
    data=readCNT(cfg);
else
    LSclean=ls('*lf*');
    cfg.dataset=LSclean(1:end-1);
    data=ft_preprocessing(cfg);
end
% cfg=[];
% %cfg.trials=find(datacln.trialinfo==222);
% cfg.output       = 'pow';
% %    cfg.channel      = 'MEG';
% cfg.method       = 'mtmfft';
% cfg.taper        = 'hanning';
% cfg.foi          = 1:100;
% cfg.feedback='no';
% Fr = ft_freqanalysis(cfg, data);
% LR=Fr;
% LR.powspctrm=zeros(size(Fr.powspctrm));
% for pairi=1:length(LRpairs)
%     chL=find(ismember(LR.label,LRpairs(pairi,1)));
%     chR=find(ismember(LR.label,LRpairs(pairi,2)));
%     LR.powspctrm(chR,:)=Fr.powspctrm(chR,:)-Fr.powspctrm(chL,:);
%     LR.powspctrm(chL,:)=Fr.powspctrm(chL,:)-Fr.powspctrm(chR,:);
% end
%
% cfg           = [];
% cfg.method    = 'mtmfft';
% cfg.output    = 'fourier';
% cfg.tapsmofrq = 1;
% cfg.foi=1:100;
% freq          = ft_freqanalysis(cfg, data);
% % coherence Left - Right
% %load ~/ft_BIU/matlab/files/LRpairs
% cfg=[];
% cfg.channelcmb=LRpairs;
% cfg.method    = 'coh';
% cohLR          = ft_connectivityanalysis(cfg, freq);
% % prepare for powspctrm display
% coh={};
% coh.label=data.label;
% coh.dimord='chan_freq';
% coh.freq=cohLR.freq;
% %coh.grad=data.grad;
% cohspctrm=ones(248, size(cohLR.cohspctrm,2));
% for cmbi=1:length(LRpairs);
%     chi=find(strcmp(cohLR.labelcmb{cmbi,1},data.label));
%     cohspctrm(chi,:)=cohLR.cohspctrm(cmbi,:);
%     chi=find(strcmp(cohLR.labelcmb{cmbi,2},data.label));
%     cohspctrm(chi,:)=cohLR.cohspctrm(cmbi,:);
% end
% coh.powspctrm=cohspctrm;


% cfg=[];
% cfg.xlim=[9 9];
% cfg.layout='WG32.lay';
% ft_topoplotER(cfg,coh);


% plot results for alpha
% figure;
% for freqi=9:12
%     subplot(1,4,freqi-8)
%     cfg = [];
%     cfg.xlim = [freqi freqi];
%     cfg.zlim=[-0.2 0.2];
%     cfg.layout='WG32.lay';
%     %cfg.layout       = '4D248.lay';
%     %cfg.interactive='yes';
%     ft_topoplotER(cfg, eegLR);
% end





