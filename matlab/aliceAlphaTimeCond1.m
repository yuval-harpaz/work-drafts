%% averaging
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
%conditions={'8' '10' '12' '20' '100' '102';'read' 'tamil' 'read' 'loud' 'rest1' 'rest2'};
for sfi=1:length(sf)
    subFold=sf{sfi};
    cd /home/yuval/Data/alice
    cd(subFold)
    load timeTopoCond
    timeTopoMEGread(1:248,sfi)=(timeTopoMEG(:,1)+timeTopoMEG(:,3))./2;
    timeTopoEEGread(1:30,sfi)=(timeTopoEEG(:,1)+timeTopoEEG(:,3))./2;
    fftTopoMEGread(1:248,sfi)=(fftTopoMEG(:,1)+fftTopoMEG(:,3))./2;
    fftTopoEEGread(1:30,sfi)=(fftTopoEEG(:,1)+fftTopoEEG(:,3))./2;
    
    timeTopoMEGtamil(1:248,sfi)=timeTopoMEG(:,2);
    timeTopoEEGtamil(1:30,sfi)=timeTopoEEG(:,2);
    fftTopoMEGtamil(1:248,sfi)=fftTopoMEG(:,2);
    fftTopoEEGtamil(1:30,sfi)=fftTopoEEG(:,2);
    
    timeTopoMEGloud(1:248,sfi)=timeTopoMEG(:,4);
    timeTopoEEGloud(1:30,sfi)=timeTopoEEG(:,4);
    fftTopoMEGloud(1:248,sfi)=fftTopoMEG(:,4);
    fftTopoEEGloud(1:30,sfi)=fftTopoEEG(:,4);
    
    timeTopoMEGrest1(1:248,sfi)=timeTopoMEG(:,5);
    timeTopoEEGrest1(1:30,sfi)=timeTopoEEG(:,5);
    fftTopoMEGrest1(1:248,sfi)=fftTopoMEG(:,5);
    fftTopoEEGrest1(1:30,sfi)=fftTopoEEG(:,5);
    
    timeTopoMEGrest2(1:248,sfi)=timeTopoMEG(:,6);
    timeTopoEEGrest2(1:30,sfi)=timeTopoEEG(:,6);
    fftTopoMEGrest2(1:248,sfi)=fftTopoMEG(:,6);
    fftTopoEEGrest2(1:30,sfi)=fftTopoEEG(:,6);
    
end
timeTopoMEGrest=(timeTopoMEGrest1+timeTopoMEGrest2)./2;
timeTopoEEGrest=(timeTopoEEGrest1+timeTopoEEGrest2)./2;
fftTopoMEGrest=(fftTopoMEGrest1+fftTopoMEGrest2)./2;
fftTopoEEGrest=(fftTopoEEGrest1+fftTopoEEGrest2)./2;
load /home/yuval/Copy/MEGdata/alice/timeTopoCond20
%% figures
cfg=[];
cfg.zlim=[0 40];
figure;topoplot248(mean(timeTopoMEGrest,2),cfg);title('rest')
figure;topoplot248(mean(timeTopoMEGread,2),cfg);title('read')
figure;topoplot248(mean(timeTopoMEGtamil,2),cfg);title('tamil')
figure;topoplot248(mean(timeTopoMEGloud,2),cfg);title('loud')
figure;topoplot248(mean(timeTopoMEGwbw,2),cfg);title('wbw')

cfg.zlim=[0 5e-11];
figure;topoplot248(mean(fftTopoMEGrest,2),cfg);title('rest')
figure;topoplot248(mean(fftTopoMEGread,2),cfg);title('read')
figure;topoplot248(mean(fftTopoMEGtamil,2),cfg);title('tamil')
figure;topoplot248(mean(fftTopoMEGloud,2),cfg);title('loud')
figure;topoplot248(mean(fftTopoMEGwbw,2),cfg);title('wbw') % too weak, must be an error
cfg=[];
cfg.zlim=[0 50];
figure;topoplot30(mean(timeTopoEEGrest,2),cfg);title('rest')
figure;topoplot30(mean(timeTopoEEGread,2),cfg);title('read')
figure;topoplot30(mean(timeTopoEEGtamil,2),cfg);title('tamil')
figure;topoplot30(mean(timeTopoEEGloud,2),cfg);title('loud')
figure;topoplot30(mean(timeTopoEEGwbw,2),cfg);title('wbw')
cfg.zlim=[0 1200];
figure;topoplot30(mean(fftTopoEEGrest,2),cfg);title('rest')
figure;topoplot30(mean(fftTopoEEGread,2),cfg);title('read')
figure;topoplot30(mean(fftTopoEEGtamil,2),cfg);title('tamil')
figure;topoplot30(mean(fftTopoEEGloud,2),cfg);title('loud')
figure;topoplot30(mean(fftTopoEEGwbw,2),cfg);title('wbw')
%% ttest all channels
[~,p]=ttest(mean(timeTopoMEGrest1),mean(timeTopoMEGrest2))
[~,p]=ttest(mean(timeTopoEEGrest1),mean(timeTopoEEGrest2))
[~,p]=ttest(mean(timeTopoMEGrest),mean(timeTopoMEGread))    %* !!
[~,p]=ttest(mean(timeTopoEEGrest),mean(timeTopoEEGread))
[~,p]=ttest(mean(timeTopoMEGrest),mean(timeTopoMEGwbw))
[~,p]=ttest(mean(timeTopoMEGread),mean(timeTopoMEGwbw))
[~,p]=ttest(mean(timeTopoMEGloud),mean(timeTopoMEGwbw))

[~,p]=ttest(mean(fftTopoMEGrest1),mean(fftTopoMEGrest2))
[~,p]=ttest(mean(fftTopoEEGrest1),mean(fftTopoEEGrest2))
[~,p]=ttest(mean(fftTopoMEGrest),mean(fftTopoMEGread));     %*
[~,p]=ttest(mean(fftTopoEEGrest),mean(fftTopoEEGread));     %**

[~,p]=ttest(mean(timeTopoMEGtamil),mean(timeTopoMEGread)); 
[~,p]=ttest(mean(timeTopoEEGtamil),mean(timeTopoEEGread));
[~,p]=ttest(mean(fftTopoMEGtamil),mean(fftTopoMEGread)); 
[~,p]=ttest(mean(fftTopoEEGtamil),mean(fftTopoEEGread));

[~,p]=ttest(mean(timeTopoEEGloud),mean(timeTopoEEGread))    %**
[~,p]=ttest(mean(fftTopoEEGloud),mean(fftTopoEEGread))      %*
[~,p]=ttest(mean(timeTopoMEGloud),mean(timeTopoMEGread))    %** !!!
[~,p]=ttest(mean(fftTopoMEGloud),mean(fftTopoMEGread))      %**

%% left right
load LRpairs
load plotwts
[~,Li]=ismember(LRpairs(:,1),wts.label);
[~,Ri]=ismember(LRpairs(:,2),wts.label);

[~,p]=ttest(mean(timeTopoMEGloud(Li,:)),mean(timeTopoMEGread(Li,:))) %**
[~,p]=ttest(mean(timeTopoMEGloud(Ri,:)),mean(timeTopoMEGread(Ri,:))) %**
[~,p]=ttest(mean(timeTopoMEGrest(Li,:)),mean(timeTopoMEGread(Li,:))) %*
[~,p]=ttest(mean(timeTopoMEGrest(Ri,:)),mean(timeTopoMEGread(Ri,:))) %*
%% anterior posterior left right
anteriorR = {'A54', 'A55', 'A81', 'A82', 'A83', 'A112', 'A113', 'A114', 'A115', 'A144', 'A145', 'A146', 'A171', 'A172', 'A173', 'A174', 'A175', 'A193', 'A194', 'A209', 'A210', 'A211', 'A227', 'A228', 'A244', 'A245', 'A246', 'A247', 'A248'};
posteriorR =  {'A51', 'A52', 'A77', 'A78', 'A79', 'A107', 'A108', 'A109', 'A110', 'A139', 'A140', 'A141', 'A142', 'A167', 'A168', 'A169', 'A170', 'A188', 'A189', 'A190', 'A191', 'A206', 'A207', 'A208', 'A225'};
[~,pairi]=ismember(anteriorR,LRpairs(:,2));
anteriorL=LRpairs(pairi,1);
[~,pairi]=ismember(posteriorR,LRpairs(:,2));
posteriorL=LRpairs(pairi,1);


[~,Ri]=ismember(anteriorR,wts.label);
[~,Li]=ismember(anteriorL,wts.label);
[~,p]=ttest(mean(timeTopoMEGloud(Li,:)),mean(timeTopoMEGread(Li,:))) %*
[~,p]=ttest(mean(timeTopoMEGloud(Ri,:)),mean(timeTopoMEGread(Ri,:))) %**

[~,RiP]=ismember(posteriorR,wts.label);
[~,LiP]=ismember(posteriorL,wts.label);
[~,p]=ttest(mean(timeTopoMEGloud(LiP,:)),mean(timeTopoMEGread(LiP,:))) %***
[~,p]=ttest(mean(timeTopoMEGloud(RiP,:)),mean(timeTopoMEGread(RiP,:))) %**

tableMeanM=[mean(timeTopoMEGloud(Li,:))',mean(timeTopoMEGloud(Ri,:))',mean(timeTopoMEGloud(LiP,:))',mean(timeTopoMEGloud(RiP,:))',mean(timeTopoMEGread(Li,:))',mean(timeTopoMEGread(Ri,:))',mean(timeTopoMEGread(LiP,:))',mean(timeTopoMEGread(RiP,:))',mean(timeTopoMEGtamil(Li,:))',mean(timeTopoMEGtamil(Ri,:))',mean(timeTopoMEGtamil(LiP,:))',mean(timeTopoMEGtamil(RiP,:))',mean(timeTopoMEGrest(Li,:))',mean(timeTopoMEGrest(Ri,:))',mean(timeTopoMEGrest(LiP,:))',mean(timeTopoMEGrest(RiP,:))'];
tableMaxM=[max(timeTopoMEGloud(Li,:))',max(timeTopoMEGloud(Ri,:))',max(timeTopoMEGloud(LiP,:))',max(timeTopoMEGloud(RiP,:))',max(timeTopoMEGread(Li,:))',max(timeTopoMEGread(Ri,:))',max(timeTopoMEGread(LiP,:))',max(timeTopoMEGread(RiP,:))',max(timeTopoMEGtamil(Li,:))',max(timeTopoMEGtamil(Ri,:))',max(timeTopoMEGtamil(LiP,:))',max(timeTopoMEGtamil(RiP,:))',max(timeTopoMEGrest(Li,:))',max(timeTopoMEGrest(Ri,:))',max(timeTopoMEGrest(LiP,:))',max(timeTopoMEGrest(RiP,:))'];
tableMeanMf=[mean(fftTopoMEGloud(Li,:))',mean(fftTopoMEGloud(Ri,:))',mean(fftTopoMEGloud(LiP,:))',mean(fftTopoMEGloud(RiP,:))',mean(fftTopoMEGread(Li,:))',mean(fftTopoMEGread(Ri,:))',mean(fftTopoMEGread(LiP,:))',mean(fftTopoMEGread(RiP,:))',mean(fftTopoMEGtamil(Li,:))',mean(fftTopoMEGtamil(Ri,:))',mean(fftTopoMEGtamil(LiP,:))',mean(fftTopoMEGtamil(RiP,:))',mean(fftTopoMEGrest(Li,:))',mean(fftTopoMEGrest(Ri,:))',mean(fftTopoMEGrest(LiP,:))',mean(fftTopoMEGrest(RiP,:))'];
tableMaxMf=[max(fftTopoMEGloud(Li,:))',max(fftTopoMEGloud(Ri,:))',max(fftTopoMEGloud(LiP,:))',max(fftTopoMEGloud(RiP,:))',max(fftTopoMEGread(Li,:))',max(fftTopoMEGread(Ri,:))',max(fftTopoMEGread(LiP,:))',max(fftTopoMEGread(RiP,:))',max(fftTopoMEGtamil(Li,:))',max(fftTopoMEGtamil(Ri,:))',max(fftTopoMEGtamil(LiP,:))',max(fftTopoMEGtamil(RiP,:))',max(fftTopoMEGrest(Li,:))',max(fftTopoMEGrest(Ri,:))',max(fftTopoMEGrest(LiP,:))',max(fftTopoMEGrest(RiP,:))'];
titles={'loudAntL','loudAntR','loudPostL','loudPostR','silentAntL','silentAntR','silentPostL','silentPostR','tamilAntL','tamilAntR','tamilPostL','tamilPostR','restAntL','restAntR','restPostL','restPostR'};
%rescale
tableMaxMf=tableMaxMf*10^12;
tableMeanMf=tableMeanMf*10^12;
%% EEG
cd /home/yuval/Copy/MEGdata/alice
load LRpairsEEG
load ploteeg
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
%conditions={'8' '10' '12' '20' '100' '102';'read' 'tamil' 'read' 'loud' 'rest1' 'rest2'};
for sfi=1:length(sf)
    subFold=sf{sfi};
    cd /home/yuval/Data/alice
    cd(subFold)
    load timeTopoCond
    timeTopoEEGrest1(1:30,sfi)=timeTopoEEG(:,5);
    fftTopoEEGrest1(1:30,sfi)=fftTopoEEG(:,5);
    timeTopoEEGrest2(1:30,sfi)=timeTopoEEG(:,6);
    fftTopoEEGrest2(1:30,sfi)=fftTopoEEG(:,6);
    cd ..
end
timeTopoEEGrest=(timeTopoEEGrest1+timeTopoEEGrest2)./2;
fftTopoEEGrest=(fftTopoEEGrest1+fftTopoEEGrest2)./2;
noM=[1:12,14:18,20:32];


[~,Li]=ismember(LRpairs(:,1),eeg.label);
[~,Ri]=ismember(LRpairs(:,2),eeg.label);
% for i=[1:5,7:13]
%     [~,p(i)]=ttest(timeTopoEEGrest(find(Li(i)==noM),:),timeTopoEEGrest(find(Ri(i)==noM),:));
% end
li=[];ri=[];
for i=[3,5];
    li=[li,find(Li(i)==noM)];
    ri=[ri,find(Ri(i)==noM)];
end

pli=[];pri=[];
for i=9:13
    pli=[pli,find(Li(i)==noM)];
    pri=[pri,find(Ri(i)==noM)];
end
Li=li;Ri=ri;LiP=pli;RiP=pri;
tableMeanE=[mean(timeTopoEEGloud(Li,:))',mean(timeTopoEEGloud(Ri,:))',mean(timeTopoEEGloud(LiP,:))',mean(timeTopoEEGloud(RiP,:))',mean(timeTopoEEGread(Li,:))',mean(timeTopoEEGread(Ri,:))',mean(timeTopoEEGread(LiP,:))',mean(timeTopoEEGread(RiP,:))',mean(timeTopoEEGtamil(Li,:))',mean(timeTopoEEGtamil(Ri,:))',mean(timeTopoEEGtamil(LiP,:))',mean(timeTopoEEGtamil(RiP,:))',mean(timeTopoEEGrest(Li,:))',mean(timeTopoEEGrest(Ri,:))',mean(timeTopoEEGrest(LiP,:))',mean(timeTopoEEGrest(RiP,:))'];
tableMaxE=[max(timeTopoEEGloud(Li,:))',max(timeTopoEEGloud(Ri,:))',max(timeTopoEEGloud(LiP,:))',max(timeTopoEEGloud(RiP,:))',max(timeTopoEEGread(Li,:))',max(timeTopoEEGread(Ri,:))',max(timeTopoEEGread(LiP,:))',max(timeTopoEEGread(RiP,:))',max(timeTopoEEGtamil(Li,:))',max(timeTopoEEGtamil(Ri,:))',max(timeTopoEEGtamil(LiP,:))',max(timeTopoEEGtamil(RiP,:))',max(timeTopoEEGrest(Li,:))',max(timeTopoEEGrest(Ri,:))',max(timeTopoEEGrest(LiP,:))',max(timeTopoEEGrest(RiP,:))'];
tableMeanEf=[mean(fftTopoEEGloud(Li,:))',mean(fftTopoEEGloud(Ri,:))',mean(fftTopoEEGloud(LiP,:))',mean(fftTopoEEGloud(RiP,:))',mean(fftTopoEEGread(Li,:))',mean(fftTopoEEGread(Ri,:))',mean(fftTopoEEGread(LiP,:))',mean(fftTopoEEGread(RiP,:))',mean(fftTopoEEGtamil(Li,:))',mean(fftTopoEEGtamil(Ri,:))',mean(fftTopoEEGtamil(LiP,:))',mean(fftTopoEEGtamil(RiP,:))',mean(fftTopoEEGrest(Li,:))',mean(fftTopoEEGrest(Ri,:))',mean(fftTopoEEGrest(LiP,:))',mean(fftTopoEEGrest(RiP,:))'];
tableMaxEf=[max(fftTopoEEGloud(Li,:))',max(fftTopoEEGloud(Ri,:))',max(fftTopoEEGloud(LiP,:))',max(fftTopoEEGloud(RiP,:))',max(fftTopoEEGread(Li,:))',max(fftTopoEEGread(Ri,:))',max(fftTopoEEGread(LiP,:))',max(fftTopoEEGread(RiP,:))',max(fftTopoEEGtamil(Li,:))',max(fftTopoEEGtamil(Ri,:))',max(fftTopoEEGtamil(LiP,:))',max(fftTopoEEGtamil(RiP,:))',max(fftTopoEEGrest(Li,:))',max(fftTopoEEGrest(Ri,:))',max(fftTopoEEGrest(LiP,:))',max(fftTopoEEGrest(RiP,:))'];




% [~,p]=ttest(mean(timeTopoEEGrest(li,:)),mean(timeTopoEEGrest(ri,:)))
% [~,p]=ttest(mean(timeTopoEEGread(li,:)),mean(timeTopoEEGread(ri,:)))
% [~,p]=ttest(mean(timeTopoEEGtamil(li,:)),mean(timeTopoEEGtamil(ri,:)))
% 
% 
% 
% cfg=[];
% cfg.zlim=[0 100];
% cfg.highlight='on';
% cfg.highlightchannel={'CP1','CP2','CP5','CP6','P3','P4','P7','P8','O1','O2'};
% figure;topoplot30(mean(timeTopoEEGrest,2),cfg);title('rest')    
