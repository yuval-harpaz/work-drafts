%% stats
load LRpairs
cd /home/yuval/Data/Denis/REST
load timeTopoMEG
load ~/ft_BIU/matlab/plotwts.mat
for i=1:17;figure;topoplot248(timeTopoMEG(:,i),[],1);title(num2str(i));end
% all channels
for i=1:248
    chans{i,1}=['A',num2str(i)];
end
[~,Li]=ismember(LRpairs(:,1),chans);
[~,Ri]=ismember(LRpairs(:,2),chans);
L=mean(timeTopoMEG(Li,:),1);
R=mean(timeTopoMEG(Ri,:),1);
[~,P]=ttest(L,R);

% % anterior 
% [~,pairi]=ismember( {'MEG1121', 'MEG1131', 'MEG1141', 'MEG1221', 'MEG1231', 'MEG1311', 'MEG1321', 'MEG1331', 'MEG1341', 'MEG1411', 'MEG1441','MEG2211', 'MEG2221', 'MEG2231', 'MEG2411', 'MEG2421', 'MEG2431', 'MEG2441', 'MEG2641'},LRpairs(:,2));
% %[~,pairi]=ismember( {'MEG2211', 'MEG2221', 'MEG2231', 'MEG2411', 'MEG2421', 'MEG2431', 'MEG2441', 'MEG2641'},LRpairs(:,2));
% 
% %[~,pairi]=ismember({'MEG1121', 'MEG1131', 'MEG1141', 'MEG1221', 'MEG1231', 'MEG1311', 'MEG1321', 'MEG1331', 'MEG1341', 'MEG1411', 'MEG1441'},LRpairs(:,2));
% [~,Ri]=ismember(LRpairs(pairi,2),plotNeuromag.label)
% [~,Li]=ismember(LRpairs(pairi,1),plotNeuromag.label)
% L=mean(timeTopoMEG1(Li,:),1);
% R=mean(timeTopoMEG1(Ri,:),1);
% L=max(timeTopoMEG1(Li,:));
% R=max(timeTopoMEG1(Ri,:));
% [~,P]=ttest(L,R);
% %end

% chan by chan
P=ones(1,248);
for chani=1:115
    Li=str2num(LRpairs{chani,1}(2:end));
    Ri=str2num(LRpairs{chani,2}(2:end));
    [~,P(Li)]=ttest(timeTopoMEG(Li,:),timeTopoMEG(Ri,:));
    P(Ri)=P(Li);
end
cfg=[];
cfg.highlight='labels';
cfg.highlightchannel=find(P<0.001);
topoplot248(mean(timeTopoMEG,2),cfg,1);
