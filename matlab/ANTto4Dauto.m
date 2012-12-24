function ANTto4Dauto(run)
% mergeEegMeg
% cd to where the eeg data is. there should be run folders with meg: 1,2...

% method='first2'; % first1 first2 last1 last2 firstAndLast2
% run='3';
% megFN='c,rfhp1.0Hz';
% segBegSamp=[1,round((10*60+29.038)*1024),round((23*60+44.578)*1024),round((36*60+28.374)*1024)];
if ~ischar(run)
    run=num2str(run);
end
method='first2';
if exist([run,'/c,rfhp0.1Hz'],'file')
    megFN='c,rfhp0.1Hz';
elseif exist([run,'/c,rfhp1.0Hz'],'file')
    megFN='c,rfhp1.0Hz';
else
    error('default filename not found, please use ANTto4D')
end
LS=ls;
if length(findstr(LS,'.cnt'))~=1
    error('there has to be 1 cnt file. use ANTto4D to specify which one')
else
    eegFN=ls('*.cnt');
    eegFN=eegFN(1:end-1);
end
if length(findstr(LS,'.seg'))~=0
    error('segmented eeg, use ANTto4D')
else
    segBegSamp=1;
end
srEeg=1024;
srMeg=1017.278;
hdrEEG=ft_read_header(eegFN);


hdrMEG=ft_read_header([run,'/',megFN]);

% choose method of syncing
% first2 = first matched pair, last2 = last matched pair, firstAndLast2 =
% calculate sr based on trigger matching
% FIXME: needs detection of wrong matches in samp.

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
if ~exist([run,'/samp.mat'],'file')
    evt1017=round(events*1017.25);
    display('reading trig')
    trig=readTrig_BIU([run,'/',megFN]);
    TRIG=bitand(uint16(trig),1024);
    if isempty(find(TRIG))
        TRIG=bitand(uint16(trig),4096);
    end
    trigSh=TRIG(2:end);trigSh(end+1)=0;
    onset=find(trigSh-TRIG>0);onset=onset+1;
    % onset is the sample in which the MEG trig had 1024 onset
    samp=findEegMegSamp(onset,evt1017);
    if isempty(samp)
        error('no match found, samp is empty')
    end
    save([run,'/samp'],'samp')
else
    load ([run,'/samp'])
end
%%
switch method
    case 'first2'
        t1=events(samp(1,3));
        s1eeg=nearest(eeg.time{1,1},t1);
        s1meg=samp(1,2);
    case 'last2'
        t1=events(samp(end,3));
        s1eeg=nearest(eeg.time{1,1},t1);
        s1meg=samp(end,2);
    case 'firstAndLast2'
        t1=events(samp(1,3));
        t2=events(samp(end,3));
        s1meg=samp(1,2);
        s2meg=samp(end,2);
        s1eeg=nearest(eeg.time{1,1},t1);
        s2eeg=nearest(eeg.time{1,1},t2);
        srEeg=(s2eeg-s1eeg)/(t2-t1);
        if ~srEeg==1024
            error('eeg sampling rate should be 1024, please check')
        end
        srMeg=(s2meg-s1meg)/(t2-t1);
        if ~round(srMeg)==1017
            error('MEG sr should be about 1017')
        end
        eval(['!echo run ',run,' MEG sr = ',num2str(srMeg),' >> LOGsr.txt'])
end
% s1eeg=nearest(eeg.time{1,1},t1);
% s1meg=samp(1,2);
segNum=find(segBegSamp<s1eeg,1);

t0eeg=(segBegSamp(segNum)-s1eeg-1)/srEeg;
t0meg=-s1meg/srMeg;
% find nearest eeg sample
timediff=t0meg-t0eeg;
rsEEG = resampEEG4MEG(eeg.trial{1,1},timediff,srEeg,srMeg,hdrMEG.nSamples);


rsEEG=rsEEG./1000; % from mV to V
%baseline correction for the first 10s
m=mean(rsEEG(:,1:10240),2);
mMat=repmat(m,1,size(rsEEG,2));
rsEEG=rsEEG-mMat;
if ~exist([run,'/','rsEEG'],'file')
    save ([run,'/','rsEEG'],'rsEEG')
end
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
% scale according to range of data (quartiles) to fit short format
qrtl=quantile(rsEEG',[0.25 0.75]);
qrScale=10*mean(abs(median(qrtl')));
fac=(2^15-1)./qrScale;
facP=floor(log10(fac));
rsEEGsc=rsEEGsc*10^facP;
% cleanup and writing to file
clear eeg mMat rsEEG 
display('writing eeg to a new MEG file')
rewritePDF(rsEEGsc,labels,[run,'/',megFN]);
clear rsEEGsc
%% comparing eeg and meg
display('plotting')
cfg=[];
cfg.channel={'E1','E2','E3','E4','E5','E6','E7','E8','E9','E10','E11','E12','E13','E14','E15','E16','E17','E18','E19','E20','E21','E22','E23','E24','E25','E26','E27','E28','E29','E30','E31','E32','E33','E34'};
cfg.dataset=[run,'/rw_c,rfhp1.0Hz'];
cfg.trl=[1,hdrMEG.nSamples,0];
if hdrMEG.nSamples>1017250
    cfg.trl=[1,1017250,0]; %take 1000sec or else RAM overflows
    display('only taking 1000sec')
end
cfg.demean='yes';
cfg.feedback='none';
% cfg.bpfilter='yes';
% cfg.bpfreq=[1 40];
eeg=ft_preprocessing(cfg);
eegRMS=sqrt(mean(eeg.trial{1,1}.*eeg.trial{1,1},1));
E1=eeg.trial{1,1}(1,1:10172);
clear eeg
cfg.channel='MEG';
meg=ft_preprocessing(cfg);
time=meg.time{1,1};
megRMS=sqrt(mean(meg.trial{1,1}.*meg.trial{1,1},1));
clear meg
figure;
plot(time,megRMS/mean(megRMS));hold on;plot(time,eegRMS/mean(eegRMS),'g')
cr=corr(smooth(megRMS',20),smooth(eegRMS',20));
title(['RMS for EEG and MEG. corr = ',num2str(cr)])
legend('MEG','EEG');
% check scale issues
figure;
plot(time(1:10172),E1)
title('channel E1 (Fp1), first 10sec')

