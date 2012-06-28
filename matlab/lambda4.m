cd /home/yuval/Data/MOI704
load dataNoMOG
load trialinfo
t=dataNoMOG.time{1,1};
[~,chi]=ismember('A191',dataNoMOG.label);
figure;
ylm=80;
%%
load tempAlpha
[~,time0]=max(abs(tempPad));
[~,~,~,pP,nP,~,alpha]=findTempInTrials(tempPad,time0,dataNoMOG,chi,trialinfo,0.115,[],[],[],30);
subplot(3,4,1)
hist(t(pP),100);title('Alpha padded template')
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
ylim([0 ylm])
subplot(3,4,2)
hist(t(nP),100);title('Alpha padded template')
ylim([0 ylm])

[~,time0]=max(abs(temp));
[~,~,~,pP,nP,~,alpha]=findTempInTrials(temp,time0,dataNoMOG,chi,trialinfo,0.115,[],[],[],30);
subplot(3,4,3)
hist(t(pP),100);title('Alpha template')
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
ylim([0 ylm])
subplot(3,4,4)
hist(t(nP),100);title('Alpha template')
ylim([0 ylm])
%%
load tempM150 % equals to load temp
[~,time0]=max(abs(tempPad));
[~,~,~,pP,nP,~,M150]=findTempInTrials(tempPad,time0,dataNoMOG,chi,trialinfo,[],0.145,[],[],30);
subplot(3,4,5)
hist(t(pP),100);title('150ms padded template')
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
ylim([0 ylm])
subplot(3,4,6)
hist(t(nP),100);title('150ms padded template');
ylim([0 ylm])
[~,time0]=max(abs(temp));
[~,~,~,pP,nP,~,M150]=findTempInTrials(temp,time0,dataNoMOG,chi,trialinfo,[],0.145,[],[],30);
subplot(3,4,7)
hist(t(pP),100);title('150ms template')
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
ylim([0 ylm])
subplot(3,4,8)
hist(t(nP),100);title('150ms template');
ylim([0 ylm])
%%
load temp195ms
[~,time0]=max(abs(tempPad));
[~,~,~,pP,nP,~,alpha]=findTempInTrials(tempPad,time0,dataNoMOG,chi,trialinfo,0.195,[],[],[],30);
subplot(3,4,9)
hist(t(pP),100);title('195ms padded template')
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
ylim([0 ylm])
subplot(3,4,10)
hist(t(nP),100);title('195ms padded template')
ylim([0 ylm])

[~,time0]=max(abs(temp));
[~,~,~,pP,nP,~,alpha]=findTempInTrials(temp,time0,dataNoMOG,chi,trialinfo,0.195,[],[],[],30);
subplot(3,4,11)
hist(t(pP),100);title('195ms template')
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r')
ylim([0 ylm])
subplot(3,4,12)
hist(t(nP),100);title('195ms template')
ylim([0 ylm])