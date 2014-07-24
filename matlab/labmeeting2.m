% lab meeting

% alpha asimmetry
aliceAlphaB3eeg(10);

cd /home/yuval/Data/Denis/REST
load Rest
cfg.layout='4D248.lay';
cfg.xlim=[10 10];
ft_topoplotER(cfg,Rest)

%coh LR
cd /media/Elements/MEG/talResults/Coh
load LRchans
chans=Lchannel;
chans(60:118)=Rchannel;
% cd /media/Elements/MEG/
% load('talResults/Coh/cohLRv1post_D')
% [~,chi]=ismember(chans,cohLRv1post_D.label);

[list,labels]=talPowList3(chans,10);