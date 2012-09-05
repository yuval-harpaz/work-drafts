% mergeEegMeg
cd /home/yuval/Data/eeg
cfg=[];
cfg.demean='yes';
cfg.hpfilter='yes';
cfg.hpfreq=1;
data=readCNT(cfg);

evt=readTrg;
events=evt(find(evt(:,3)==1),1); %#ok<FNDSB>
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
events=evt(find(evt(:,3)==1),1); %#ok<FNDSB>
evt1017=round(events*1017.25);
samp=findEegMegSamp(onset,evt1017);
t1=events(samp(1,3));
t2=events(samp(end,3));
cfg=[];
cfg.demean='yes';
cfg.hpfilter='yes';
cfg.hpfreq=1;
eeg=readCNT(cfg);
s1eeg=nearest(eeg.time{1,1},t1);
s2eeg=nearest(eeg.time{1,1},t2);
srEeg=(s2eeg-s1eeg)/(t2-t1);
s1meg=samp(1,2);s2meg=samp(end,2);
srMeg=(s2meg-s1meg)/(t2-t1);

%look for segments according to jump in eeg data
x=mean(abs(diff(eeg.trial{1,1}')),2);
xx=diff(x);
segEndSamp=find(xx>50)+1;
segEndSamp(end+1,1)=length(eeg.time{1,1});
segBegSamp(1,1)=1;
segBegSamp(2:size(segEndSamp,1))=segEndSamp(1:end-1)+1;
segEndSamp=segEndSamp';

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


% find nearest eeg sample
timediff=t0meg-t0eeg;
rsEEG = resampEEG4MEG(eeg.trial{1,1},timediff,srEEG,srMEG,length(trig));


rsEEG=rsEEG./1000; % from mV to V
%baseline correction for the first 10s
m=mean(rsEEG(:,1:10240),2);
mMat=repmat(m,1,size(rsEEG,2));
rsEEG=rsEEG-mMat;
save rsEEG rsEEG
for li=1:34
    labels{li,1}=['E',num2str(li)]; %#ok<SAGROW>
end
% rescaling according to units per bits in the config
pdf=pdf4D(megFN);
header = get(pdf, 'Header');
chi=channel_index(pdf,'EEG');
config = get(pdf, 'config');
for ch = 1:34
    chan_no = header.channel_data{chi(ch)}.chan_no;
    scale(ch) = config.channel_data{chan_no}.units_per_bit;
end
scFac=round(log10(median(scale)));
rsEEGsc=rsEEG*10^scFac;
maxVal=max(max(abs(rsEEG)));
fac=(2^15-1)./maxVal;
facP=floor(log10(fac))
rsEEGsc=rsEEGsc*10^facP;
%plot(rsEEGsc(1,1:10172))
rewritePDF(rsEEGsc,labels,'c,rfhp1.0Hz','2');

% scount=0;
% tic
% for sampi=startSamp:endSamp
%     scount=scount+1;
%     currMegTime=(sampi-1)./srMeg;
%     currEegTime=timediff+currMegTime;
%     eegSamps(scount)=nearest(eeg.time{1,1},currEegTime);
%     newEEG(:,sampi)=eeg.trial{1,1}(:,eegSamps(scount));
%     if sampi==1000
%         t1000=toc;
%         esttime=round(t1000.*(endSamp-startSamp)/1000/60);
%         display(['estimated time ',num2str(esttime),'min']);
%     end
% end
% save newEEG newEEG eegSamps
