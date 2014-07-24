function tpCoh

cd /media/Elements/MEG/talResults/Coh
load LRchans
chans=Lchannel;
chans(60:118)=Rchannel;
% cd /media/Elements/MEG/
% load('talResults/Coh/cohLRv1post_D')
% [~,chi]=ismember(chans,cohLRv1post_D.label);

[list,labels]=tpReadData(chans,10);