
load ~/ft_BIU/matlab/ploteeg
load ~/ft_BIU/matlab/plotwts
load LRpairsEEG
LRpairsEEG=LRpairs([1:5 7:13],:);
load LRpairs;
timeStatMEG=ones(248,1);
timeStatEEG=ones(30,1);
fftStatMEG=ones(248,1);
fftStatEEG=ones(30,1);
cd /home/yuval/Copy/MEGdata/alice
load timeTopo
for chi=1:115
    [~,Li]=ismember(LRpairs{chi,1},wts.label);
    [~,Ri]=ismember(LRpairs{chi,2},wts.label);
    [~,p]=ttest(timeTopoMEG(Li,:),timeTopoMEG(Ri,:));
    timeStatMEG([Li,Ri],1)=p;
    [~,p]=ttest(fftTopoMEG(Li,:),fftTopoMEG(Ri,:));
    fftStatMEG([Li,Ri],1)=p;
end
chans=eeg.label([1:12,14:18,20:32]);
for chi=1:12
    [~,Li]=ismember(LRpairsEEG{chi,1},chans);
    [~,Ri]=ismember(LRpairsEEG{chi,2},chans);
    [~,p]=ttest(timeTopoEEG(Li,:),timeTopoEEG(Ri,:));
    timeStatEEG([Li,Ri],1)=p;
    [~,p]=ttest(fftTopoEEG(Li,:),fftTopoEEG(Ri,:));
    fftStatEEG([Li,Ri],1)=p;
end
cfg=[];
cfg.highlight = 'on';
cfg.highlightchannel = find(timeStatMEG<0.05);
figure;
topoplot248(mean(timeTopoMEG,2),cfg)
cfg=[];
cfg.highlight = 'on';
cfg.highlightchannel = find(timeStatEEG<0.05);
figure;
topoplot30(mean(timeTopoEEG,2),cfg)

% [~,Li]=ismember(LRpairsEEG(:,1),chans);
% [~,Ri]=ismember(LRpairsEEG(:,2),chans);
% [~,pEEG]=ttest(mean(timeTopoEEG(Li,:)),mean(timeTopoEEG(Ri,:)));
% [~,pEEGfft]=ttest(mean(fftTopoEEG(Li,:)),mean(fftTopoEEG(Ri,:)));
% [~,Li]=ismember(LRpairs(:,1),wts.label);
% [~,Ri]=ismember(LRpairs(:,2),wts.label);
% [~,pMEG]=ttest(mean(timeTopoMEG(Li,:)),mean(timeTopoMEG(Ri,:)));
% [~,pMEGfft]=ttest(mean(fftTopoMEG(Li,:)),mean(fftTopoMEG(Ri,:)));

[~,LiM]=ismember(LRpairs(:,1),wts.label);
[~,RiM]=ismember(LRpairs(:,2),wts.label);
[~,LiE]=ismember(LRpairsEEG(:,1),chans);
[~,RiE]=ismember(LRpairsEEG(:,2),chans);
Nmeg=3;
Neeg=3;
for subi=1:8
    figure;
    topoplot248(timeTopoMEG(:,subi));
    title(['time ',num2str(subi)])
    figure;
    topoplot30(timeTopoEEG(:,subi));
    title(['time ',num2str(subi)])
    figure;
    topoplot248(fftTopoMEG(:,subi));
    title(['fft ',num2str(subi)])
    figure;
    topoplot30(fftTopoEEG(:,subi));
    title(['fft ',num2str(subi)])
    v=sort(timeTopoMEG(LiM,subi),'descend');
    timeML(subi)=mean(v(1:Nmeg));
    v=sort(timeTopoMEG(RiM,subi),'descend');
    timeMR(subi)=mean(v(1:Nmeg));
    v=sort(timeTopoEEG(LiE,subi),'descend');
    timeEL(subi)=mean(v(1:Neeg));
    v=sort(timeTopoEEG(RiE,subi),'descend');
    timeER(subi)=mean(v(1:Neeg));
    v=sort(fftTopoMEG(LiM,subi),'descend');
    fftML(subi)=mean(v(1:Nmeg));
    v=sort(fftTopoMEG(RiM,subi),'descend');
    fftMR(subi)=mean(v(1:Nmeg));
    v=sort(fftTopoEEG(LiE,subi),'descend');
    fftEL(subi)=mean(v(1:Neeg));
    v=sort(fftTopoEEG(RiE,subi),'descend');
    fftER(subi)=mean(v(1:Neeg));
end
[fftMR;fftML]
[~,p]=ttest(fftMR,fftML)
[timeMR;timeML]
[~,p]=ttest(timeMR,timeML)

[~,p]=ttest(fftER,fftEL)
[~,p]=ttest(timeER,timeEL)

           
    