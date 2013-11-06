function aliceAlphaBsam(Afreq)
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
for sfi=1:8
    cd /home/yuval/Data/alice
    cd(sf{sfi})
    LSclean=ls('*lf*');
    megFNc=LSclean(1:end-1);
    load LRpairsEEG
    LRpairsEEG=LRpairs;
    load LRpairs
    load files/triggers
    load files/evt
    resti=100;
    % MEG
    sampBeg=trigS(find(trigV==resti));
    sampEnd=sampBeg+60*1017.23;
    samps1s=sampBeg:1017:sampEnd-100;
    trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
    meg=pow(trl,LRpairs);
    cfg=[];
    cfg.bpfilter='yes';
    cfg.bpfreq=[3 35];
    cfg.demean='yes';
    megBP=ft_preprocessing(cfg,meg);
    disp('loading SAM weights')
    [~, ~, wts]=readWeights('SAM/general,3-35Hz,alla.wts');
    vsi=find(wts(:,1)~=0);
    %     for triali=1:length(meg.trial)
    %         pow=wts*megBP.trial{1,triali};
    
    
    for triali=1:length(megBP.trial)
        %         samples=[nearest(Gavg.time,xlim(1)),nearest(Gavg.time,xlim(2))];
        %         data=squeeze(Gavg.individual(subi,:,samples(1):samples(2)));
        vs=wts*megBP.trial{1,triali}; %./repmat(ns,1,length(data.time{1,1}));
        vns=wts*meg.trial{1,triali}; 
        if triali==1
            Fs = 1017.25;                                    % Sampling frequency
            T = 1/Fs;                                        % Sample time
            L = megBP.time{1,1}(end)-megBP.time{1,1}(1);       % Length of signal
            NFFT=1000;
            f = Fs/2*linspace(0,1,NFFT/2+1);
            endF=find(f >= 200,1)-1;
            f=f(2:endF+1); % up to 200.4Hz
            avgPSD=zeros(1,length(vs));
            avgNS=avgPSD;
            noiseF1=find(f >= 110,1);
            noiseF2=find(f >= 180,1);
            fi=nearest(f,Afreq);
        end
        % t = (0:L-1)*T;                                 % Time vector
        % NFFT = 2^nextpow2(L);
        
        Pxx=zeros(NFFT,length(vs));
        Pns=Pxx;
        Pxx(:,vsi) = abs(fft(vs(vsi,:)',NFFT)/L).^2;                   % the PS
        Pns(:,vsi) = abs(fft(vns(vsi,:)',NFFT)/L).^2; 
        % frequencies vector
        vsPSD = Pxx(2:198,:); % [Pxx(2:NFFT/2+1,:)];
        vsNS  = Pns(2:198,:);
        ns=mean(vsNS(noiseF1:noiseF2,:));
        vsPSD=vsPSD(fi,:); %repmat(mean(avgPSD(noiseF1:noiseF2,:)),size(avgPSD,1),1);
        %vsPSD=Pxx(fi+1,:);
        %plot(f,vsPSD(:,11077));
        avgNS=avgNS+ns; % noise
        avgPSD=avgPSD+vsPSD;
        disp(['fft for trial ',num2str(triali)])
    end
    avgPSD=avgPSD./triali;
    avgNS=avgNS./triali;
    avgPSD=avgPSD./avgNS;
%     noiseF1=find(f >= 110,1);
%     noiseF2=find(f >= 180,1);
%     avgPSDn=avgPSD./repmat(mean(avgPSD(noiseF1:noiseF2,:)),size(avgPSD,1),1);
    avgPSD=avgPSD*1e-8;
    cd MRI
    cfg=[];
    cfg.step=5;
    cfg.boxSize=[-120 120 -90 90 -20 150];
    cfg.prefix=['rest1_',num2str(Afreq),'Hz'];
    %cfg.torig=1000*f(1); % freq, not t
    %cfg.TR=1000*(f(2)-f(1));
    VS2Brik(cfg,avgPSD');
    eval(['!@auto_tlrc -apar ortho+tlrc -input rest1_',num2str(Afreq),'Hz+orig -dxyz 5'])
    eval(['!mv rest1_',num2str(Afreq),'Hz+tlrc.BRIK ~/Copy/MEGdata/alice/func/B/rest1_',num2str(Afreq),'Hz_',num2str(sfi),'+tlrc.BRIK']);
    eval(['!mv rest1_',num2str(Afreq),'Hz+tlrc.HEAD ~/Copy/MEGdata/alice/func/B/rest1_',num2str(Afreq),'Hz_',num2str(sfi),'+tlrc.HEAD']);    
    cd ..
end



function data=pow(trl,LRpairs)
EEG=true;
if length(LRpairs)==115
    EEG=false;
end
cfg=[];
cfg.trl=trl;
cfg.channel='MEG';
if EEG
    cfg.channel='EEG';
end
cfg.demean='yes';
cfg.feedback='no';
if EEG
    data=readCNT(cfg);
else
    LSclean=ls('*lf*');
    cfg.dataset=LSclean(1:end-1);
    data=ft_preprocessing(cfg);
end






