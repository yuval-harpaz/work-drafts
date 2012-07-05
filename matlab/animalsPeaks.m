cd /home/yuval/Data/Amyg
% grnAvg
AVG=zeros(1,401);
for subi=1:12
    sub=num2str(subi);
    cd(sub)
    load TF100
    SNR=[];
    SNR(1:length(TF.label),1:length(t))=squeeze(mean(TF.powspctrm,1)); %avg SNR trace over trials
    avgSNR=mean(abs(SNR),1);
    AVG(subi,:)=avgSNR;
    cd ..
end
AVG=mean(AVG,1);
[~,pkAVG]=max(AVG);pkAvg=t(pkAVG);

for subi=1:12
    sub=num2str(subi);
    cd(sub)
    load TF100
    if ~exist('peaks.mat','file')
        peaks=peaksInTrials1freq(TF,wlt);
        save peaks peaks
    end
    t1=nearest(t,0);
    SNR=[];
    SNR(1:length(TF.label),1:length(t))=squeeze(mean(TF.powspctrm,1)); %avg SNR trace over trials
    avgSNR=mean(abs(SNR),1);
    [pv, pi] = findPeaks(avgSNR,0.1, 30, 'MAD');
    p100=pi(nearest(t(pi),pkAvg));
    [~,Pi]=max(SNR(:,p100));
    [~,Ni]=min(SNR(:,p100));
    chP=TF.label{Pi};
    chN=TF.label{Ni};
    cfg=[];
    cfg.xlim=[t(p100) t(p100)];
    cfg.layout='4D248.lay';
    cfg.highlight  = 'labels';
    cfg.highlightchannel={chP,chN};
    h=figure;
    subplot(1,2,1);
    ft_topoplotER(cfg,TF);
    subplot(1,2,2);
    plot(t,avgSNR);
    hold on;
    plot(t(p100),avgSNR(p100),'ro');
    title(['SUB ',sub]);
    saveas(h,'chansel.png');
    win100=[t(p100-20) t(p100+20)];
    save win win100 chP chN
    
%     for chani=[Pi Ni];
%         posSNR=[];negSNR=[];
%         for ti=1:length(peaks.chan{1,chani}.trial)
%             try
%                 posSNR=[posSNR,peaks.chan{1,chani}.trial{1,ti}.SNR(1,peaks.chan{1,chani}.trial{1,ti}.SNR>0)];
%             end
%             try
%                 negSNR=[negSNR,peaks.chan{1,chani}.trial{1,ti}.SNR(1,peaks.chan{1,chani}.trial{1,ti}.SNR<0)];
%             end
%         end
%     end
    cd ..
    
end

subi=12;
pk=0.116;
sub=num2str(subi);
cd(sub)
load TF100
t1=nearest(t,0);
SNR=[];
SNR(1:length(TF.label),1:length(t))=squeeze(mean(TF.powspctrm,1)); %avg SNR trace over trials
avgSNR=mean(abs(SNR),1);
[pv, pi] = findPeaks(avgSNR,0.1, 30, 'MAD');
p100=nearest(t,pk);
[~,Pi]=max(SNR(:,p100));
[~,Ni]=min(SNR(:,p100));
chP=TF.label{Pi};
chN=TF.label{Ni};
cfg=[];
cfg.xlim=[t(p100) t(p100)];
cfg.layout='4D248.lay';
cfg.highlight  = 'labels';
cfg.highlightchannel={chP,chN};
h=figure;
subplot(1,2,1);
ft_topoplotER(cfg,TF);
subplot(1,2,2);
plot(t,avgSNR);
hold on;
plot(t(p100),avgSNR(p100),'ro');
title(['SUB ',sub]);

[~,chani]=ismember(chN,peaks.label);
post=[];negt=[];
for ti=1:length(peaks.chan{1,chani}.trial)
    try
        post=[post,peaks.chan{1,chani}.trial{1,ti}.time(1,peaks.chan{1,chani}.trial{1,ti}.SNR>0)];
    end
    try
        negt=[negt,peaks.chan{1,chani}.trial{1,ti}.time(1,peaks.chan{1,chani}.trial{1,ti}.SNR<0)];
    end
end

figure;hist(post,25);
h1 = findobj(gca,'Type','patch');
set(h1,'FaceColor','r')
hold on;
hist(negt,25);
legend ('pos','neg')
title('Count of Peaks')


saveas(h,'chansel2.png');
win100=[t(p100-20) t(p100+20)];
save win win100 chP chN