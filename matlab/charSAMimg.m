cd('/media/yuval/My Passport/Hila&Rotem');
load SubOrder
subi=1;
sub=Sub{subi};
cd(sub)
cd SAM
[~, ~, wts]=readWeights('SPMall,1-40Hz,Alla.wts');
cd ..
load datacln
load Fr good
bad=true(length(datacln.trial),1);
bad(good)=false;
for condi=unique(datacln.trialinfo)
    trli=datacln.trialinfo==condi;
    for triali=