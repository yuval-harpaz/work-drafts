% mergeEegMeg
cd /home/yuval/Data/eeg
data=readCNT;
cfg=[];
cfg.resamplefs = 1017.25;
cfg.detrend='no';
dataRS = ft_resampledata(cfg, data);
evt=readTrg;
events=evt(find(evt(:,3)==1),1);
% events is the time in which the .trg file had event value 1
evt1017=round(events*1017.25);

trig=readTrig_BIU('2/c,rfhp1.0Hz');
trig=bitand(uint16(trig),1024);
trigSh=trig(2:end);trigSh(end+1)=0;
onset=find(trigSh-trig>0);onset=onset+1;
% onset is the sample in which the MEG trig had 1024 onset
samp=findEegMegSamp(onset,evt1017);

save samp samp
%% fixme, find real sampling rate by comparing faraway trigs

    
