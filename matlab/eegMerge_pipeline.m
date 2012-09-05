eegFile='/home/yuval/Data/eeg/20120802_0954.cnt';
megFile='/home/yuval/Data/eeg/2/c,rfhp1.0Hz';
% consider using srMeg=1017.277
%% read eeg data
cfg=[];
cfg.dataset=eegFile;
cfg.demean='yes';
cfg.hpfilter='yes';
cfg.hpfreq=1;
eeg=readCNT(cfg);
evt=readTrg(eegFile);
events=evt(find(evt(:,3)==1),1); %#ok<FNDSB>
evt1017=round(events*1017.25);
%% read meg trigger
trig=readTrig_BIU(megFile);
trig=bitand(uint16(trig),1024);
trigSh=trig(2:end);trigSh(end+1)=0;
onset=find(trigSh-trig>0);onset=onset+1;
%% match samples on eeg and meg and calc "real"  sampling rate for MEG
samp=findEegMegSamp(onset,evt1017);
t1=events(samp(1,3));
t2=events(samp(end,3));
s1eeg=nearest(eeg.time{1,1},t1);
s2eeg=nearest(eeg.time{1,1},t2);
srEeg=eeg.fsample;%(s2eeg-s1eeg)/(t2-t1);
s1meg=samp(1,2);s2meg=samp(end,2);
srMeg=(s2meg-s1meg)/(t2-t1);

%% look for segments according to jump in eeg data to get start time of seg
x=mean(abs(diff(eeg.trial{1,1}')),2);
xx=diff(x);
segEndSamp=find(xx>50)+1;
segEndSamp(end+1,1)=length(eeg.time{1,1});
segBegSamp(1,1)=1;
segBegSamp(2:size(segEndSamp,1))=segEndSamp(1:end-1)+1;
segEndSamp=segEndSamp';
% see when the eeg and meg started compared to the first common trigger
segNum=find(segBegSamp<s1eeg,1);
t0eeg=(segBegSamp(segNum)-s1eeg-1)/srEeg;
t0meg=-s1meg/srMeg;
timediff=t0meg-t0eeg;
%% resample eeg to match MEG time
rsEEG = resampEEG4MEG(eeg.trial{1,1},timediff,srEeg,srMeg,length(trig));
%% scale EEG to match config.units_per_bit and short format
rsEEG=rsEEG./1000; % from mV to V
%baseline correction for the first 10s
m=mean(rsEEG(:,1:10240),2);
mMat=repmat(m,1,size(rsEEG,2));
rsEEG=rsEEG-mMat;

for li=1:34
    labels{li,1}=['E',num2str(li)]; %#ok<SAGROW>
end
% rescaling according to units per bits in the config
pdf=pdf4D(megFile);
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
facP=floor(log10(fac));
rsEEGsc=rsEEGsc*10^facP;
%plot(rsEEGsc(1,1:10172))

rewritePDF(rsEEGsc,labels,megFile);