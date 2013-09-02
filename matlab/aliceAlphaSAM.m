function aliceAlphaSAM(subFold,wts)
if ~exist('wts','var')
    wts='';
end
if isempty(wts)
    wts='general,3-35Hz,alla.wts';
    filt='';
else
    filti=findstr(wts,',');
    filt=wts(filti(1)+1:filti(2)-1);
end

cd /home/yuval/Data/alice
cd(subFold)
cd SAM
% load noiseNormCov
[~, ~, ActWgts]=readWeights(wts);
cd ..
vsi=find(ActWgts(:,1)~=0);

LSclean=ls('*lf*');
megFNc=LSclean(1:end-1);
load LRpairsEEG
LRpairsEEG=LRpairs;
load LRpairs
load files/triggers
load files/evt
%if ~exist('MRI/Nseg16+orig.BRIK','file')
    for piskai=2:2:18
        % EEG
        load(['files/seg',num2str(piskai)])
        sampBeg=samps(find(samps(:,2)==1,1),1);
        sampEnd=samps(find(samps(:,2)==1,1,'last'),1);
        samps1s=sampBeg:1024:sampEnd;
        trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
        %[eegFr,eegLR,eegCoh]=pow(trl,LRpairsEEG);
        % title(num2str(piskai))
        %eval(['eegFr',num2str(piskai),'=eegFr'])
        %eval(['eegLR',num2str(piskai),'=eegLR'])
        %eval(['eegCoh',num2str(piskai),'=eegCoh'])
        % MEG
        startSeeg=round(evt(find(evt(:,3)==piskai),1)*1024);
        endSeeg=round(evt(find(evt(:,3)==piskai)+1,1)*1024);
        startSmeg=trigS(find(trigV==piskai));
        endSmeg=trigS(find(trigV==piskai)+1);
        megSR=(endSmeg-startSmeg)/((endSeeg-startSeeg)/1024);
        if round(megSR)~=1017
            error('problem detecting MEG sampling rate')
        end
        trlMEG=round((trl(:,1)-startSeeg)/1024*megSR)+startSmeg;
        trlMEG(:,2)=trlMEG+1017;
        trlMEG(:,3)=zeros(length(trl),1);
        %[megFr,megLR,megCoh]=pow(trlMEG,LRpairs);
        
        
        cfg=[];
        cfg.trl=trlMEG;
        cfg.channel='MEG';
        cfg.demean='yes';
        cfg.feedback='no';
        LSclean=ls('*lf*');
        cfg.dataset=LSclean(1:end-1);
        data=ft_preprocessing(cfg);
        pow(data,ActWgts,vsi,piskai,filt);
        %vs(isnan(vs))=0;
        %make 3D image
        
        
        %     cfg=[];
        %     %cfg.trials=find(datacln.trialinfo==222);
        %     cfg.output       = 'pow';
        %     %    cfg.channel      = 'MEG';
        %     cfg.method       = 'mtmfft';
        %     cfg.taper        = 'hanning';
        %     cfg.foi          = 1:100;
        %     cfg.feedback='no';
        %     Fr = ft_freqanalysis(cfg, data);
        %
        %
        %     eval(['megFr',num2str(piskai),'=megFr'])
        %     eval(['megLR',num2str(piskai),'=megLR'])
        %     eval(['megCoh',num2str(piskai),'=megCoh'])
    end
%end
%if ~exist('MRI/Nseg102+orig.BRIK','file')
    load files/evt
    for resti=[100,102];
        % EEG
        sampBeg=round(evt(find(evt(:,3)==resti),1)*1024);
        sampEnd=sampBeg+60*1024;
        samps1s=sampBeg:1024:sampEnd-1;
        trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
        %[eegFr,eegLR,eegCoh]=pow(trl,LRpairsEEG);
        % title(num2str(resti))
        %             eval(['eegFr',num2str(resti),'=eegFr'])
        %             eval(['eegLR',num2str(resti),'=eegLR'])
        %             eval(['eegCoh',num2str(resti),'=eegCoh'])
        % MEG
        sampBeg=trigS(find(trigV==resti));
        sampEnd=sampBeg+60*1017.23;
        samps1s=sampBeg:1017:sampEnd-100;
        trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
        %[megFr,megLR,megCoh]=pow(trl,LRpairs);
        % title(num2str(resti))
        %             eval(['megFr',num2str(resti),'=megFr'])
        %             eval(['megLR',num2str(resti),'=megLR'])
        %             eval(['megCoh',num2str(resti),'=megCoh'])
        cfg=[];
        cfg.trl=trl;
        cfg.channel='MEG';
        cfg.demean='yes';
        cfg.feedback='no';
        LSclean=ls('*lf*');
        cfg.dataset=LSclean(1:end-1);
        data=ft_preprocessing(cfg);
        pow(data,ActWgts,vsi,resti,filt);
    end
%end
% clear eegFr eegLR eegCoh megFr megLR megCoh
% save fr eegFr* eegLR* eegCoh* megFr* megLR* megCoh*
cd MRI
eval(['!~/abin/3dcalc -a Nseg',filt,'2+orig -b Nseg',filt,'4+orig -c Nseg',filt,'8+orig -d Nseg',filt,'12+orig -e Nseg',filt,'14+orig -f Nseg',filt,'16+orig -prefix N',filt,'alice -exp "(a+b+c+d+e+f)/6"'])
eval(['!~/abin/3dcalc -a Nseg',filt,'100+orig -b Nseg',filt,'102+orig -prefix N',filt,'rest -exp "(a+b)/2"'])
end



function pow(data,ActWgts,vsi,piskai,filt)
for triali=1:length(data.trial)
    %         samples=[nearest(Gavg.time,xlim(1)),nearest(Gavg.time,xlim(2))];
    %         data=squeeze(Gavg.individual(subi,:,samples(1):samples(2)));
    vs=ActWgts*data.trial{1,triali}; %./repmat(ns,1,length(data.time{1,1}));
    if triali==1
        Fs = 1017.25;                                    % Sampling frequency
        T = 1/Fs;                                        % Sample time
        L = data.time{1,1}(end)-data.time{1,1}(1);       % Length of signal
        NFFT=1000;
        f = Fs/2*linspace(0,1,NFFT/2+1);
        endF=find(f >= 200,1)-1;
        f=f(2:endF+1); % up to 200.4Hz
        avgPSD=zeros(endF,length(vs));
    end
    % t = (0:L-1)*T;                                 % Time vector
    % NFFT = 2^nextpow2(L);
    
    Pxx=zeros(NFFT,length(vs));
    Pxx(:,vsi) = abs(fft(vs(vsi,:)',NFFT)/L).^2;                   % the PS
    
    % frequencies vector
    vsPSD = Pxx(2:198,:); % [Pxx(2:NFFT/2+1,:)];
    %plot(f,vsPSD(:,11077));
    
    avgPSD=avgPSD+vsPSD;
    disp(num2str(triali))
end
avgPSD=avgPSD./triali;
noiseF1=find(f >= 110,1);
noiseF2=find(f >= 180,1);
avgPSDn=avgPSD./repmat(mean(avgPSD(noiseF1:noiseF2,:)),size(avgPSD,1),1);
cd MRI
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
cfg.prefix=['Nseg',filt,num2str(piskai)];
cfg.torig=1000*f(1); % freq, not t
cfg.TR=1000*(f(2)-f(1));
VS2Brik(cfg,avgPSDn');
cd ..
% eval(['!echo "cd ',pwd,'" >> ~/alice2tlrc'])
% eval(['!echo "@auto_tlrc -apar ortho+tlrc -input ',prefix,'+orig -dxyz 5" >> ~/alice2tlrc'])
% eval(['!echo "mv ',prefix,'+tlrc.HEAD /home/yuval/Copy/MEGdata/alice/func/',prefix,'_',num2str(subi),'+tlrc.HEAD" >> ~/alice2tlrc']);
% eval(['!echo "mv ',prefix,'+tlrc.BRIK /home/yuval/Copy/MEGdata/alice/func/',prefix,'_',num2str(subi),'+tlrc.BRIK" >> ~/alice2tlrc']);
end



% cfg           = [];
% cfg.method    = 'mtmfft';
% cfg.output    = 'fourier';
% cfg.tapsmofrq = 1;
% cfg.foi=1:100;
% freq          = ft_freqanalysis(cfg, data);
% coherence Left - Right
%load ~/ft_BIU/matlab/files/LRpairs
% cfg=[];
% cfg.channelcmb=LRpairs;
% cfg.method    = 'coh';
% cohLR          = ft_connectivityanalysis(cfg, freq);
% prepare for powspctrm display
% coh={};
% coh.label=data.label;
% coh.dimord='chan_freq';
% coh.freq=cohLR.freq;
% %coh.grad=data.grad;
% cohspctrm=ones(248, size(cohLR.cohspctrm,2));
% for cmbi=1:length(LRpairs);
%     chi=find(strcmp(cohLR.labelcmb{cmbi,1},data.label));
%     cohspctrm(chi,:)=cohLR.cohspctrm(cmbi,:);
%     chi=find(strcmp(cohLR.labelcmb{cmbi,2},data.label));
%     cohspctrm(chi,:)=cohLR.cohspctrm(cmbi,:);
% end
% coh.powspctrm=cohspctrm;


