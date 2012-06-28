load dataNoMOG

cfg              = [];
cfg.keeptrials = 'yes';
cfg.output       = 'pow';
cfg.channel      = 'MEG';
cfg.method       = 'mtmconvol';
cfg.taper        ='triang'; % not required
cfg.foi          = [5:30];                            % freq of interest 3 to 100Hz
cfg.t_ftimwin    = 1./cfg.foi;   % ones(length(cfg.foi),1).*0.5;  % length of time window fixed at 0.5 sec
cfg.toi          = -0.2:0.005:0.7;                  % time window "slides" from -0.1 to 0.5 sec in steps of 0.02 sec (20 ms)
cfg.tapsmofrq  = 1;
cfg.trials='all';%[1:2];
cfg.channel='A191';
cfg.tail='beg'; % pad the template with zeros, 'beg' 'end' 'both' or [] for no padding
[TF,wlt] = freqanalysis_triang_temp(cfg, dataNoMOG);



cfgp = [];
cfgp.channel='A191';
mn=min(min(squeeze(mean(TF.powspctrm(:,1,:,:),1))));
mx=max(max(squeeze(mean(TF.powspctrm(:,1,:,:),1))));
z=abs(mx);if abs(mn)>abs(mx);z=abs(mn);end
cfgp.zlim=[-z z];
figure;ft_singleplotTFR(cfgp, TF);

%FIXME, set tics as length of triangle, not frequency.
% TFpad=TF;
% TFpad.freq=round(1000./TF.freq);
% figure;ft_singleplotTFR(cfgp, TFpad);

%% test false detection
dtest=dataNoMOG;
dtest.trial{1,1}(22,154:254)=dtest.trial{1,1}(22,154:254)+[1:51 50:-1:1];
cfg.trials=1;
[TFtest,wlt] = freqanalysis_triang_temp(cfg, dtest);
cfgp = [];
cfgp.channel='A191';
mn=min(min(squeeze(mean(TFtest.powspctrm(:,1,:,:),1))));
mx=max(max(squeeze(mean(TFtest.powspctrm(:,1,:,:),1))));
z=abs(mx);if abs(mn)>abs(mx);z=abs(mn);end
cfgp.zlim=[-z z];
figure;ft_singleplotTFR(cfgp, TFtest);


% cfgp = [];
% cfgp.layout       = '4D248.lay';
% cfgp.interactive='yes';
% ft_multiplotTFR(cfgp, TF);

%% find peaks in trials
t=TF.time;

findPeaksInTrials
post=[];negt=[];
for ti=1:342
    post=[post,peaks.trial{1,ti}.time(1,peaks.trial{1,ti}.SNR>0)];
    negt=[negt,peaks.trial{1,ti}.time(1,peaks.trial{1,ti}.SNR<0)];
end
% figure;
% plot(post,'or')
% hold on
% plot(negt,'ob')

figure;hist(post,100);
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
hold on;
hist(negt,100);
legend ('pos','neg')
title('Count of Peaks')
posSNR=[];negSNR=[];
for ti=1:342
    posSNR=[posSNR,peaks.trial{1,ti}.SNR(1,peaks.trial{1,ti}.SNR>0)];
    negSNR=[negSNR,peaks.trial{1,ti}.SNR(1,peaks.trial{1,ti}.SNR<0)];
end
figure;
plot(post,posSNR,'.r')
hold on
plot(negt,abs(negSNR),'.b')
legend ('pos','neg')
title('Absolute SNR Values')
%% unused
    freqi=10;
    % deadT=round(length(wlt{freqi})./3);
    deadT=3; %about 15ms
    SNR=squeeze(TF.powspctrm(1,1,freqi,:))';
    [SigPeaks, SigIpeaks] = findPeaks(abs(SNR),3, deadT, 'MAD'); % th in sd
    % plot(TF.time,abs(SNR))
    % hold on;
    % plot(TF.time(SigIpeaks),abs(SNR(SigIpeaks)),'mo')
    Ppos=SigIpeaks(SNR(SigIpeaks)>0);
    Pneg=SigIpeaks(SNR(SigIpeaks)<0);
    
    allSigIpeaks(1,triali).pos=Ppos;
    allSigIpeaks(1,triali).neg=Pneg;
    
    
    SNR=squeeze(TF.powspctrm(1,1,:,:));
    SNR(isnan(SNR))=0;
    for ti=1:size(SNR,2) % time index
        tempi(ti)=0;
        [a,b]=max(abs(SNR(:,ti)));
        if a
            tempi(ti)=b;
        end
    end
    for fi=1:size(SNR,1)
        peaki=find(tempi==fi);
        for numpeaks=1:length(peaki)
            if SNR(fi,peaki(numpeaks))>=1 && SNR(fi,peaki(numpeaks))>SNR(fi,peaki(numpeaks)-1) && SNR(fi,peaki(numpeaks))>SNR(fi,peaki(numpeaks)+1)
                trials{1,1}.pos
                
                
                
                [SigPeaks, SigIpeaks] = findPeaks(abs(SNR),3, deadT, 'MAD'); %
                tempi(tempi==0)=nan;
                SNR(:,tempi)
                %% find peaks in tfr mtx
                
                
                blcwin=[nearest(TF.time,-0.1),nearest(TF.time,0)];
                % for freqi=1:size(SNR,2);
                %     x=SNR(~isnan(SNR(:,freqi)),freqi);
                %     sd(freqi)=std(x);
                % end
                % for freqi=1:size(SNR,2);
                %     x=[];
                %     for triali=1:size(TF.powspctrm,1)
                %         data=squeeze(TF.powspctrm(triali,1,freqi,blcwin(1):blcwin(2)))';
                %         x=[x data];
                %     end
                %     sd(freqi)=std(x);
                % end
                sdm=vec2mat(sd,181);
                SNR=squeeze(TF.powspctrm(1,1,:,:))';
                SNRi=SNR>3.5.*sdm;
                sig=TF;
                sig.powspctrm(1,1,:,:)=SNRi';
                cfgp.trials=1;
                ft_singleplotTFR(cfgp, sig);
                
                
                SNRf=zeros(size(SNR);
                
                SNRf(
                
                
                
                
