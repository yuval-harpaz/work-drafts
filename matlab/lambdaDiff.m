%% test, find temp on averaged data.
cd /home/yuval/Data/MOI704
load temp
load data
load trialinfo
% now for all data
chan={'A191','A215'}; % or A191 and A199
[~,chi]=ismember(chan,data.label);

cfg=[];
cfg.trials=trialinfo;
cfg.hpfilter='yes';
cfg.hpfreq=1;
dataNoMOG=ft_preprocessing(cfg,data);
t=dataNoMOG.time{1,1};
% tmplt=tempPad;


%figure;hold on;
[trials,pI,nI,pP,nP,asip]=findTempInTrials(tempPad,dataNoMOG,chi,trialinfo,0.195,0.145)
% tmpBlc = temp-mean(temp);
% tmp=tempPad;
% tmp=2.*tmp;
% tmpBlc = tmp-mean(tmp);
% tmplt=tmpBlc./sqrt(sum(tmpBlc.*tmpBlc));
% 
% limSNR = 1;    limSig = 0;
% allSigIpeaks={};
% asip=[];nI=[];pI=[];nP=[];pP=[];
% trials=trialinfo;
% trials(2,:)=dataNoMOG.trialinfo;
% for triali=1:length(dataNoMOG.trial)
%     x=[];
%     x1=dataNoMOG.trial{1,triali}(chi(1),:); %'A191'
%     x2=dataNoMOG.trial{1,triali}(chi(2),:); %'A215'
%     x=x1-x2;
%     [SNR,SigX]=fitTemp(x,tmplt);
%     %plot(SNR);
%     [SigPeaks, SigIpeaks] = findPeaks(SigX,3, 0, 'MAD');
%     asip=[asip,SigIpeaks];
%     Ppos=SigIpeaks(x(SigIpeaks)>0);
%     Pneg=SigIpeaks(x(SigIpeaks)<0);
%     pP=[pP Ppos];nP=[nP Pneg];
%     allSigIpeaks{triali}=SigIpeaks;
%     SNRpeaks = SNR(SigIpeaks);
%     I= SigIpeaks(SigPeaks>limSig & SNRpeaks'>limSNR);
%     Ipos=I(x(I)>0);
%     Ineg=I(x(I)<0);
%     pI=[pI Ipos];nI=[nI Ineg];
%     try
%         s=[];
%         s=Pneg(nearest(t(Pneg),0.145));
%         trials(3,triali)=t(s);
%         trials(4,triali)=x(s);
%     catch me
%         display(num2str(triali))
%     end
%     try
%         s=[];
%         s=Ineg(nearest(t(Ineg),0.145));
%         trials(5,triali)=t(s);
%         trials(6,triali)=x(s);
%     catch me
%         display(num2str(triali))
%     end
% end

save tempPadDiffData trials

open ttests

c210=trials(2,:)==210;c220=trials(2,:)==220;c200=trials(2,:)==200;
halfwin=0.02;
p145ms=((0.145-halfwin)<trials(3,:) & trials(3,:)<(0.145+halfwin));sum(p145ms)

figure;hist(trials(3,(p145ms & c200)),5);ylim([0 20]);
figure;hist(trials(3,(p145ms & c210)),5);ylim([0 20]);
figure;hist(trials(3,(p145ms & c220)),5);ylim([0 20]);

figure;hist(trials(4,(p145ms & c200)));ylim([0 20]);
figure;hist(trials(4,(p145ms & c210)));ylim([0 20]);
figure;hist(trials(4,(p145ms & c220)));ylim([0 20]);
tbl=[trials(4,(p145ms & c200))',trials(4,(p145ms & c210))'];
[h,p]=ttest(trials(4,(p145ms & c200))',trials(4,(p145ms & c210))')
% see distribution of peaks
% figure;hist(data.time{1,1}(asip),50)

figure;
hist(data.time{1,1}(pI),25);
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
hold on;
hist(data.time{1,1}(nI),25)
legend('positive','negative')
title('good fit points')

figure;
hist(data.time{1,1}(pP),25);
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
hold on;
hist(data.time{1,1}(nP),25)
legend('positive','negative')
title('peaks on signal trace')
% find peaks in signal and SNR and decide on cutoff limits