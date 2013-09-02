function [Rall,Rs,Rn] = MeanPower(clean_file,fb_signal,fb_noise,ActWgts,VSindex)
% PowerSNR will calculate the mean power of:
% 1) all frequensies of data (by looking at the mean power per cycle for the VS signal) 
% 2) "signal" frequencies as was defined by the user in fb_signal
% 3) "noise" frequencies as was defined by the user in fb_noise
%
% INPUTS
% clean_file = the cleaned MEG data i.e. rs,xc,hb,lf_c,rfhp0.1Hz.
% optional inputs:
% fb_signal  = the frequecy band for the signal. default [5 30].
% fb_noise   = the frequecy band for the signal. default [100 180].
% ActWgts        = the weights matrix for the VS calculation
% VSindex     = If one wish to plot a selected VS, put its index here (as
%               it is in ActWgts, and the PSD of this VS will be plotted.
%               SNR
%
% OUTPUTS
% the function will draw the SNR of the channels. or of a selected VS (as
% in VSindex).
% In case the user give ActWgts, the function will return 3 vectors:
% Rall = mean power of all data freq.
% Rs   = mean power of the "signal" freq.
% Rn   = mean power of the "noise" freq.



lll = 1; % this is the portion that will be taken from the data for analysis.
% for example if lll=2, the first half of the data will be used for
% analysis.i.e.  1: hdr.epoch_data{1,1}.pts_in_epoch/lll
% for all data , use lll=1;

fprintf('Starting PowerSNR\n');

if ~exist('fb_signal','var')
    fb_signal = [5 30];
end
if ~exist('fb_noise','var')
    fb_noise = [100 180];
end

pdf1 = pdf4D(clean_file);
BadChans=[];
%% reading the Channels data and plotting it's SNR

hdr = pdf1.header;
chim = channel_index(pdf1, 'meg', 'name');% MEG channels
chir = channel_index(pdf1, 'ref', 'name');% reference channels

% lat = lat2ind(pdf1, 1, [0 hdr.epoch_data{1,1}.epoch_duration])
MEG1=read_data_block(pdf1,[1 round(hdr.epoch_data{1,1}.pts_in_epoch/lll)],chim);% /10 i.e. taking only the first 1/10 of the data???
%REF1=read_data_block(pdf1,[1 hdr.epoch_data{1,1}.pts_in_epoch],chir);
samplingRate=get(pdf1,'dr');

% % computing the power spectra for each channel
% [AllPSDmeg1, F1] = allSpectra(MEG1,samplingRate,0.25,'FFT');
% 
% m=meanWnan(AllPSDmeg1,2); % finding bad channels
% if isempty(BadChans);
%     BadChans=find(m>(6*median(meanWnan(AllPSDmeg1,2))));
% end;
% BadChans
% psd1=AllPSDmeg1;
% psd1(BadChans,:)=NaN; % excluding Bad Channles
% 
% PSD = sqrt(meanWnan(psd1));
% % calculating the SNR
% SSi = find(F1 >= fb_signal(1),1,'first');% index of fb_signal(1)
% SEi = find(F1 >= fb_signal(2),1,'first');% index of fb_signal(1)
% NSi = find(F1 >= fb_noise(1),1,'first');% index of fb_signal(1)
% NEi = find(F1 >= fb_noise(2),1,'first');% index of fb_signal(1)
% Psignal = mean(PSD(SSi:SEi));
% Pnoise = mean(PSD(NSi:NEi));
% 
% SNR = Psignal/Pnoise;
% 
% % plotting the Channels PSD and the selected bands for noise and signal
% if ~exist('VSindex','var')
%     figure;
%     semilogx(F1,PSD,'k'); hold on;
%     % gray patch of signal freq. band
%     aa = fb_signal(1);bb = fb_signal(2);% frequency band of signal
%     cc = min(PSD);dd = max(PSD);
%     patch([ aa aa bb bb aa],[cc dd dd cc cc],[.9 .9 .9],'EdgeColor','none');alpha(.8);% coloring fb_signal in gray
%     
%     % gray patch of Noise freq. band
%     ee = fb_noise(1);ff = fb_noise(2);% frequency band of signal
%     patch([ ee ee ff ff ee],[cc dd dd cc cc],[.6 .6 .6],'EdgeColor','none');alpha(.8);% coloring fb_noise in gray
%     
%     set(gca, 'fontsize', 16);
%     xlabel ('Frequency Hz');
%     ylabel('SQRT(PSD), T/sqrt(Hz)');
%     
%     title(['Mean PSD for all channels, SNR=',num2str(Psignal),'/',num2str(Pnoise),'=',num2str(SNR)]);
%     legend('PSD','Signal band','Noise band');
% end
%% Calculating the fft for the  VS, then PSD for the VS and SNR for each VS

% this part will be valid only if the user give an ActWgts

if exist('ActWgts','var')
    
    MEG1= double(MEG1);
    % general variables
    Fs = samplingRate;                               % Sampling frequency
    T = 1/Fs;                                        % Sample time
    L = double(hdr.epoch_data{1,1}.pts_in_epoch/lll);% Length of signal
    t = (0:L-1)*T;                                   % Time vector
    NFFT = 2^nextpow2(L);                            % Next power of 2 from length of VS
    f = Fs/2*linspace(0,1,NFFT/2+1);                 % frequencies vector
    
    % finding the index for signal and noise calculation
    vsSSi = find(f >= fb_signal(1),1,'first');% index of fb_signal(1)
    vsSEi = find(f >= fb_signal(2),1,'first');% index of fb_signal(1)
    vsNSi = find(f >= fb_noise(1) ,1,'first');% index of fb_signal(1)
    vsNEi = find(f >= fb_noise(2) ,1,'first');% index of fb_signal(1)
    
    % calculating the MEG fft and multipy by wts to get the VS fft
    if ~exist('VSindex','var')
        % MEG FFT, channel by channel
        MEGfft = zeros(size(MEG1,1),NFFT);
        for ch = 1:size(MEG1,1)
            disp(['channel ',num2str(ch)]); 
            MEGfft(ch,:) = fft(MEG1(ch,:),NFFT,2)/L;% MEG fft, normlized to the signal length
        end
        for i = 1:size(ActWgts,1)
            if isequal(ActWgts(i,:),zeros(1,248))
                % skipping VS outside the hull
                Rs(i) = 0;Rn(i) = 0;Rall(i) = 0;
                continue
            end
            % count the current VS 
            disp(['VS ',num2str(i)]); 
            % calc the VS fft and PSD
            x = ActWgts(i,:)*MEGfft;    % VS fft
            Pxx = abs(x).^2;            % calculating the VS PSD
            Rs(i) = mean(Pxx(vsSSi:vsSEi));
            Rn(i) = mean(Pxx(vsNSi:vsNEi));
            Rall(i) = mean(Pxx);
        end
        
    else % calc and plot only one selected VS as in VSindex
        x = ActWgts(VSindex,:)*MEG1;% calc the VS
        Pxx = abs(fft(x,NFFT)/L).^2;% the PSD
        % calculating the PSD of all, signal and noise
        Rs   = mean(Pxx(vsSSi:vsSEi));
        Rn   = mean(Pxx(vsNSi:vsNEi));
        Rall = mean(Pxx);
        % Plot single-sided amplitude spectrum.
        vsPSD = [0,Pxx(2:NFFT/2+1)];% putting 0 in the first bin
        figure;
        semilogx(f,vsPSD,'k'); hold on;
        % gray patch of signal freq. band
        aa = fb_signal(1);bb = fb_signal(2);% frequency band of signal
        cc = min(vsPSD);dd = max(vsPSD);
        patch([ aa aa bb bb aa],[cc dd dd cc cc],[.9 .9 .9],'EdgeColor','none');alpha(.8);% coloring fb_signal in gray
        
        % gray patch of Noise freq. band
        ee = fb_noise(1);ff = fb_noise(2);% frequency band of signal
        patch([ ee ee ff ff ee],[cc dd dd cc cc],[.6 .6 .6],'EdgeColor','none');alpha(.8);% coloring fb_noise in gray
        set(gca, 'fontsize', 16);
        xlabel ('Frequency Hz');
        ylabel('PSD');
        
        title(['PSD for VS ',num2str(VSindex),' Rall=',num2str(Rall),', Rs=',num2str(Rs),', Rn= ',num2str(Rn)]);
        legend('PSD','Signal band','Noise band');
        
        axis([10^-1 10^3 cc dd])

    end
end
end

