function ANTsync(run,drift,trigVal)
% mergeEegMeg
% cd to where the eeg data is. there should be run folders with meg: 1,2...

% method='first2'; % first1 first2 last1 last2 firstAndLast2
% run='3';
% megFN='c,rfhp1.0Hz';
% segBegSamp=[1,round((10*60+29.038)*1024),round((23*60+44.578)*1024),round((36*60+28.374)*1024)];
% drift here is the samples allowed for eeg and meg triggers to be apart
% (in 2 sec anyway), default is 3 samples.
% if asked, looks for a certain trigger value in the data.
if ~exist('drift','var')
    drift=3;
end
if isempty(drift)
    drift=3;
end
if ~ischar(run)
    run=num2str(run);
end
method='firstAndLast2';
if exist(['MEG/',run,'/c,rfhp0.1Hz'],'file')
    megFN='c,rfhp0.1Hz';
elseif exist([run,'/c,rfhp1.0Hz'],'file')
    megFN='c,rfhp1.0Hz';
else
    try
        cd MEG
        cd(run)
        megFN=source;
        cd ../..
    catch
        error('default filename not found, please use ANTto4D')
    end
end
cd EEG
LS=ls;
if length(findstr(LS,'.cnt'))~=1
    error('there has to be 1 cnt file. use ANTto4D to specify which one')
else
    eegFN=ls('*.cnt');
    eegFN=eegFN(1:end-1);
end
if length(findstr(LS,'.seg'))~=0
    warning('segmented eeg, use ANTto4D')
end
segBegSamp=1;
% end
srEeg=1024;
srMeg=1017.278;
hdrEEG=ft_read_header(eegFN);

trig=readTrig_BIU(['../MEG/',run,'/',megFN]);
hdrMEG.nSamples=length(trig);
% hdrMEG=ft_read_header([run,'/',megFN]); %it got stuck once

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
    save eeg eeg -v7.3
else
    display('loading eeg.mat')
    load eeg.mat
end

%if ~exist('events.mat','file')
    evt=readTrg;
    if exist('trigVal','var');
        events=evt(find(evt(:,3)==trigVal),1);
    else
        events=evt(find(evt(:,3)==1),1); %#ok<FNDSB>
    end
    % events is the time in which the .trg file had event value 1
    save events events
%else
    load events
%end
if ~exist(['../MEG/',run,'/samp.mat'],'file')
    evt1017=round(events*1017.25);
    %display('reading trig')
    %trig=readTrig_BIU([run,'/',megFN]);
    if exist('trigVal','var')
        TRIG=bitand(uint16(trig),trigVal);
    else
        TRIG=bitand(uint16(trig),1024);
        if isempty(find(TRIG,1))
            TRIG=bitand(uint16(trig),4096);
        end
    end
    trigSh=TRIG(2:end);trigSh(end+1)=0;
    onset=find(trigSh-TRIG>0);onset=onset+1;
    % onset is the sample in which the MEG trig had 1024 onset
    if exist('trigVal','var')
        samp=findEegMegSampExp(onset,evt1017,drift);
    else
        samp=findEegMegSamp(onset,evt1017,drift);
    end
    if isempty(samp)
        error('no match found, samp is empty')
    end
    save(['../MEG/',run,'/samp'],'samp')
else
    load (['../MEG/',run,'/samp'])
end
%%
if ~exist('trigVal','var')
    if isempty(find(diff(samp)>101725))
        method='first2';
        warning('did not find sync events more than 100sec apart, using first2 triggers')
    end
end
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
if ~exist(['../MEG/',run,'/','rsEEG'],'file')
    save (['../MEG/',run,'/','rsEEG'],'rsEEG')
end
% for li=1:34
%     labels{li,1}=['E',num2str(li)]; %#ok<SAGROW>
% end
% % rescaling according to units per bits in the config
% pdf=pdf4D([run,'/',megFN]);
% header = get(pdf, 'Header');
% chi=channel_index(pdf,'EEG');
% config = get(pdf, 'config');
% for ch = 1:34
%     chan_no = header.channel_data{chi(ch)}.chan_no;
%     scale(ch) = config.channel_data{chan_no}.units_per_bit;
% end
% scFac=round(log10(median(scale)));
% rsEEGsc=rsEEG*10^scFac;
% % scale according to range of data (quartiles) to fit short format
% qrtl=quantile(rsEEG',[0.25 0.75]);
% qrScale=10*mean(abs(median(qrtl')));
% fac=(2^15-1)./qrScale;
% facP=floor(log10(fac));
% rsEEGsc=rsEEGsc*10^facP;
% % cleanup and writing to file
% clear eeg mMat rsEEG 
% display('writing eeg to a new MEG file')
% rewritePDF(rsEEGsc,labels,[run,'/',megFN]);
% clear rsEEGsc
%% comparing eeg and meg
% display('plotting')
% cfg=[];
% cfg.channel={'E1','E2','E3','E4','E5','E6','E7','E8','E9','E10','E11','E12','E13','E14','E15','E16','E17','E18','E19','E20','E21','E22','E23','E24','E25','E26','E27','E28','E29','E30','E31','E32','E33','E34'};
% cfg.dataset=[run,'/rw_',megFN];
% cfg.trl=[1,hdrMEG.nSamples,0];
% if hdrMEG.nSamples>1017250
%     cfg.trl=[1,1017250,0]; %take 1000sec or else RAM overflows
%     display('only taking 1000sec')
% end
% cfg.demean='yes';
% cfg.feedback='none';
% % cfg.bpfilter='yes';
% % cfg.bpfreq=[1 40];
% eeg=ft_preprocessing(cfg);
eegRMS=sqrt(mean(rsEEG.*rsEEG,1));
E1=rsEEG(1,1:10172);
lat=[1 length(trig)];
clear eeg mMat rsEEG trig
cd ../MEG
cd(run)
p=pdf4D(megFN);
chi=channel_index(p,'MEG');
data=read_data_block(p,lat,chi);
%time=meg.time{1,1};
time=1/srMeg:1/srMeg:(lat(2)/srMeg);
megRMS=sqrt(mean(data.*data,1));
clear data
figure;
plot(time,megRMS/mean(megRMS));hold on;plot(time,eegRMS/mean(eegRMS),'g')
cr=corr(smooth(megRMS',20),smooth(eegRMS',20));
title(['RMS for EEG and MEG. corr = ',num2str(cr)])
legend('MEG','EEG');
% check scale issues
figure;
plot(time(1:10172),E1)
title('channel E1 (Fp1), first 10sec')
% movefile([run,'/',megFN],[run,'_',megFN]);
% movefile([run,'/','rw_',megFN],[run,'/',megFN]);
% display(['orig file is ./',run,'_',megFN]);

