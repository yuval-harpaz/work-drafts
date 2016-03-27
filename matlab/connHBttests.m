
cd /media/yuval/win_disk/Data/connectomeDB/MEG
load posCorr1_70
posCorrHB(2,:)=[];
posCorrRaw(2,:)=[];
posCorrSSP(2,:)=[];
posCorrICA2(2,:)=[];
disp(['HCP time 0: ',num2str(mean(posCorrRaw(:,1))),' (',num2str(std(posCorrRaw(:,1))),...
    '). time 0.3: ',num2str(mean(posCorrRaw(:,4))),' (',num2str(std(posCorrRaw(:,4))),')'])

disp(['Time 0, template: ',num2str(mean(posCorrHB(:,1))),' (',num2str(std(posCorrHB(:,1))),...
    '). ICA: ',num2str(mean(posCorrICA2(:,1))),' (',num2str(std(posCorrICA2(:,1))),')',...
    ' SSP: ',num2str(mean(posCorrSSP(:,1))),' (',num2str(std(posCorrSSP(:,1))),')'])


[~,p,~,stat]=ttest((posCorrSSP(:,1)+posCorrHB(:,1))./2,posCorrICA2(:,1));

[~,p,~,stat]=ttest((posCorrHB(:,4)+posCorrHB(:,1))./2,posCorrICA2(:,4));


disp(['HCP time 0: ',num2str(mean(posCorrRaw(:,1))),' (',num2str(std(posCorrRaw(:,1))),...
    '). time 0.3: ',num2str(mean(posCorrRaw(:,4))),' (',num2str(std(posCorrRaw(:,4))),')'])


clear posCorr*
cd /home/yuval/Data/OMEGA
load posCorr2
%SD=flipud([std(posCorrRaw);std(posCorrICA1);std(posCorrHB);std(posCorrSSP)]);
%SE=SD./sqrt(size(posCorrHB,1));

disp(['HCP time 0: ',num2str(mean(posCorrRaw(:,1))),' (',num2str(std(posCorrRaw(:,1))),...
    '). time 0.3: ',num2str(mean(posCorrRaw(:,4))),' (',num2str(std(posCorrRaw(:,4))),')'])

disp(['Time 0, template: ',num2str(mean(posCorrHB(:,1))),' (',num2str(std(posCorrHB(:,1))),...
    '). ICA: ',num2str(mean(posCorrICA1(:,1))),' (',num2str(std(posCorrICA1(:,1))),')',...
    ' SSP: ',num2str(mean(posCorrSSP(:,1))),' (',num2str(std(posCorrSSP(:,1))),')'])
disp(['Time 300ms, template: ',num2str(mean(posCorrHB(:,4))),' (',num2str(std(posCorrHB(:,4))),...
    '). ICA: ',num2str(mean(posCorrICA1(:,4))),' (',num2str(std(posCorrICA1(:,4))),')',...
    ' SSP: ',num2str(mean(posCorrSSP(:,4))),' (',num2str(std(posCorrSSP(:,4))),')'])

clear
cd /media/yuval/win_disk/Data/connectomeDB/MEG
load posCorr70
posCorrHB(2,:)=[];
posCorrRaw(2,:)=[];
posCorrSSP(2,:)=[];
posCorrICA2(2,:)=[];
% [~,p,~,stat]=ttest(mean(posCorrSSP(:,3:7),2),mean(posCorrRaw(:,3:7),2));
% [~,p,~,stat]=ttest(mean(posCorrSSP(:,3:7),2),mean(posCorrICA2(:,3:7),2));
% [~,p,~,stat]=ttest(mean(posCorrSSP(:,3:7),2),mean(posCorrHB(:,3:7),2));
% [~,p,~,stat]=ttest(mean(posCorrHB(:,3:7),2),mean(posCorrICA2(:,3:7),2));

[~,p,~,stat]=ttest(mean(posCorrSSP(:,3:7),2),mean(posCorrRaw(:,3:7),2));
[~,p,~,stat]=ttest(mean(posCorrHB(:,3:7),2),mean(posCorrRaw(:,3:7),2));
[~,p,~,stat]=ttest(mean(posCorrICA2(:,3:7),2),mean(posCorrRaw(:,3:7),2));

%% now CTF