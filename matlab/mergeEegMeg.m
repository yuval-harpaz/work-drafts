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

cd /home/yuval/Data/eeg
megFN='2/c,rfhp1.0Hz';
trig=readTrig_BIU(megFN);
trig=bitand(uint16(trig),1024);
trigSh=trig(2:end);trigSh(end+1)=0;
onset=find(trigSh-trig>0);onset=onset+1;

evt=readTrg;
events=evt(find(evt(:,3)==1),1);
evt1017=round(events*1017.25);
samp=findEegMegSamp(onset,evt1017);
t1=events(samp(1,3));
t2=events(samp(end,3));
eeg=readCNT;
s1eeg=nearest(eeg.time{1,1},t1);
s2eeg=nearest(eeg.time{1,1},t2);
srEeg=(s2eeg-s1eeg)/(t2-t1);
s1meg=samp(1,2);s2meg=samp(end,2);
srMeg=(s2meg-s1meg)/(t2-t1);

% cfg=[];
% cfg.resamplefs = srMeg;
% cfg.detrend='no';
% eegRS = ft_resampledata(cfg, eeg);



%look for segments
x=mean(diff(eeg.trial{1,1}'),2);
xx=diff(x);
segEndSamp=find(xx>50)+1;
segEndSamp(end+1,1)=length(eeg.time{1,1});
segBegSamp(1,1)=1;
segBegSamp(2:size(segEndSamp,1))=segEndSamp(1:end-1)+1;

% sEndMeg=length(trig);
% sEndEeg=

% see who started first, eeg or meg
segNum=find(segBegSamp<s1eeg,1);
t0eeg=(segBegSamp(segNum)-s1eeg-1)/srEeg;
t0meg=-s1meg/srMeg;
% t0eeg=-s1eeg/srEeg;
if t0eeg<t0meg
    eegFirst=true;
else
    eegFirst=false;
end
if eegFirst
    startTime=t0meg;
else
    startTime=t0eeg;
end
startSamp=s1meg+startTime*srMeg+1;
newEEG=ones(size(eeg.trial{1,1},1),length(trig));
if ~eegFirst
    newEEG(:,1:startSamp)=0;
end

% see who finished first

t3eeg=(segEndSamp(segNum)-s1eeg)/srEeg;
t3meg=(length(trig)-s1meg)/srMeg;
    
if t3eeg>t3meg
    eegLast=true;
else
    eegLast=false;
end
if eegLast
    endTime=t3meg;
else
    endTime=t3eeg;
end
endSamp=s1meg+endTime*srMeg;
newEEG=ones(size(eeg.trial{1,1},1),length(trig));
% zero beginning or end if eeg is not first or last
if ~eegFirst
    newEEG(:,1:startSamp)=0;
end
if ~eegLast
    newEEG(:,endSamp:end)=0;
end
% find nearest eeg sample
timediff=t0meg-t0eeg;

scount=0;
tic
for sampi=startSamp:endSamp
    scount=scount+1;
    currMegTime=(sampi-1)./srMeg;
    currEegTime=timediff+currMegTime;
    eegSamps(scount)=nearest(eeg.time{1,1},currEegTime);
    newEEG(:,sampi)=eeg.trial{1,1}(:,currEegSamp);
    if sampi==1000
        t1000=toc;
        esttime=round(t1000.*(endSamp-startSamp)/1000/60);
        display(['estimated time ',num2str(esttime),'min']);
    end
end
