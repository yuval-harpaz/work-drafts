% mergeEegMeg
% cd to where the eeg data is. there should be run folders with meg: 1,2...
run='4';
megFN='c,rfhp1.0Hz';
segBegSamp=[1,round((10*60+29.038)*1024),round((23*60+44.578)*1024),round((36*60+28.374)*1024)];
hdr=ft_read_header('20121018_1240.cnt');
segEndSamp=[segBegSamp(2)-1,segBegSamp(3)-1,segBegSamp(4)-1,hdr.nsample];


if ~exist('eeg.mat','file')
    cfg=[];
    cfg.demean='yes';
    cfg.bpfilter='yes';
    cfg.bpfreq=[1 400];
    eeg=readCNT(cfg);
    display('saving eeg ft structure')
    save eeg eeg
else
    display('loading eeg.mat')
    load eeg.mat
end

if ~exist('events.mat','file')
    evt=readTrg;
    events=evt(find(evt(:,3)==1),1); %#ok<FNDSB>
    % events is the time in which the .trg file had event value 1
    save events events
else
    load events
end

evt1017=round(events*1017.25);
display('reading trig')
trig=readTrig_BIU([run,'/',megFN]);
trig=bitand(uint16(trig),1024);
trigSh=trig(2:end);trigSh(end+1)=0;
onset=find(trigSh-trig>0);onset=onset+1;
% onset is the sample in which the MEG trig had 1024 onset
samp=findEegMegSamp(onset,evt1017);
if ~exist([run,'/samp.mat'],'file')
    save([run,'/samp'],'samp')
end
%% find real sampling rate by comparing faraway trigs

t1=events(samp(1,3));
t2=events(samp(end,3));
s1eeg=nearest(eeg.time{1,1},t1);
segNum=find(segBegSamp<s1eeg,1);
if ~t1==t2
    
    s2eeg=nearest(eeg.time{1,1},t2);
    srEeg=(s2eeg-s1eeg)/(t2-t1);
    s1meg=samp(1,2);s2meg=samp(end,2);
    srMeg=(s2meg-s1meg)/(t2-t1);
    s1eeg=nearest(eeg.time{1,1},t1);
    % % look for segments according to jump in eeg data
    % x=mean(abs(diff(eeg.trial{1,1}')),2);
    % xx=diff(x);
    % segEndSamp=find(xx>50)+1;
    % segEndSamp(end+1,1)=length(eeg.time{1,1});
    % segBegSamp(1,1)=1;
    % segBegSamp(2:size(segEndSamp,1))=segEndSamp(1:end-1)+1;
    % segEndSamp=segEndSamp';
    
    % see who started first, eeg or meg
   
    
    % t0eeg=-s1eeg/srEeg;
%     if t0eeg<t0meg
%         eegFirst=true;
%     else
%         eegFirst=false;
%     end
%     if eegFirst
%         startTime=t0meg;
%     else
%         startTime=t0eeg;
%     end
%     startSamp=s1meg+startTime*srMeg+1;
%     % see who finished first
%     
%     t3eeg=(segEndSamp(segNum)-s1eeg)/srEeg;
%     t3meg=(length(trig)-s1meg)/srMeg;
%     
%     if t3eeg>t3meg
%         eegLast=true;
%     else
%         eegLast=false;
%     end
%     if eegLast
%         endTime=t3meg;
%     else
%         endTime=t3eeg;
%     end
%     endSamp=s1meg+endTime*srMeg;
else
    srEeg=1024;
    srMeg=1017.278;
end
t0eeg=(segBegSamp(segNum)-s1eeg-1)/srEeg;
t0meg=-s1meg/srMeg;
% find nearest eeg sample
timediff=t0meg-t0eeg;
rsEEG = resampEEG4MEG(eeg.trial{1,1},timediff,srEeg,srMeg,length(trig));


rsEEG=rsEEG./1000; % from mV to V
%baseline correction for the first 10s
m=mean(rsEEG(:,1:10240),2);
mMat=repmat(m,1,size(rsEEG,2));
rsEEG=rsEEG-mMat;
save ([run,'/','rsEEG'],'rsEEG')
for li=1:34
    labels{li,1}=['E',num2str(li)]; %#ok<SAGROW>
end
% rescaling according to units per bits in the config
pdf=pdf4D([run,'/',megFN]);
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
display('writing eeg to new file')
rewritePDF(rsEEGsc,labels,[run,'/',megFN]);

%comparing eeg and meg
cfg=[];
cfg.channel={'E1','E2','E3','E4','E5','E6','E7','E8','E9','E10','E11','E12','E13','E14','E15','E16','E17','E18','E19','E20','E21','E22','E23','E24','E25','E26','E27','E28','E29','E30','E31','E32','E33','E34'};
cfg.dataset='c,rfhp1.0Hz';
hdr=ft_read_header(cfg.dataset);
cfg.trl=[1,hdr.nSamples,0];
cfg.demean='yes';
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
eeg=ft_preprocessing(cfg);
cfg.channel='MEG';
meg=ft_preprocessing(cfg);
megRMS=sqrt(mean(meg.trial{1,1}.*meg.trial{1,1},1));
eegRMS=sqrt(mean(eeg.trial{1,1}.*eeg.trial{1,1},1));

plot(megRMS/mean(megRMS));hold on;plot(eegRMS/mean(eegRMS),'g')
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
