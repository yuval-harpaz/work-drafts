%% plot peaks distribution
%   A '^' shaped template 100ms wide (10Hz) is fitted to unaveraged trials
% (one channel only). Signed SNR curves are created for each trial. SNR 
% peaks and throughs represent timing of transient activity in the raw
% data. The timing of these events is displayed for each trial and as a
% histogram for all the trials

cd /home/yuval/Data/Amyg/1
load datacln;
cfg              = [];
cfg.keeptrials = 'yes';
cfg.output       = 'pow';
cfg.channel      = 'A191';
cfg.method       = 'mtmconvol';
cfg.foi          = 10;    % freq of interest
cfg.t_ftimwin    = 1./cfg.foi;
cfg.toi          = -0.2:0.001:0.5;
cfg.tapsmofrq  = 1;
cfg.trials='all';%[1:2];
cfg.tail=[]; % pad the template with zeros, 'beg' 'end' 'both' or [] for no padding
cfg.feedback = 'no';
[TF,wlt] = freqanalysis_triang_temp(cfg, datacln);

peaks=peaksInTrials1freq(TF,wlt);

[~,chani]=ismember('A191',peaks.label);
post=[];negt=[];
posTri=[];negTri=[];
for ti=1:length(peaks.chan{1,chani}.trial)
    try
        p=peaks.chan{1,chani}.trial{1,ti}.time(1,peaks.chan{1,chani}.trial{1,ti}.SNR>0);
        post=[post,p];
        posTri=[posTri,ti.*ones(size(p))];
    end
    
    try
        n=peaks.chan{1,chani}.trial{1,ti}.time(1,peaks.chan{1,chani}.trial{1,ti}.SNR<0);
        negt=[negt,n];
        negTri=[negTri,ti.*ones(size(n))];
    end
end

[n1,x1]=hist(post,50);
[n2,x2]=hist(negt,50);

figure;
h1=bar(x1,n1,'hist');
hold on
h2=bar(x2,n2,'hist');
set(h2,'edgecolor','k')
set(h2,'facecolor','k')
set(h1,'edgecolor','k')
set(h1,'facecolor','w')
legend ('pos','neg')
ylim([0 75]);
title('Count of Peaks by time bins')
xlabel ('Latency')
ylabel('Number of Events')

figure;
h3=plot(post,posTri,'d','markerfacecolor','w','markeredgecolor','k');
hold on
h4=plot(negt,negTri,'d','markerfacecolor','k','markeredgecolor','k');
ylabel('Trial Number')
xlabel ('Latency')
xlim([-0.1 0.5])
ylim([0 max(negTri)])
legend ('pos','neg')
title('Distribution of Peaks by latency and trials')