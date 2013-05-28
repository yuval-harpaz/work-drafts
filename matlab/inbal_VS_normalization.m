function [vs , factor, prefix] = inbal_VS_normalization(normalization_method, ActWgts, Data, BLtime, Covdir)

% This function will apply a normalization on your VS, according to what you 
% define in normalization_method:
% normalization_method == 1 for power; VS^2/cov of wts
% normalization_method == 2 for pseudoZ; Z = (VS - Baseline_mean)/Basline_sem ,over trials
% normalization_method == 3 for Zscore; Z = (VS - mean)/sem ,over
%                         concatenated data
% normalization_method == 4 for SNR; using the SNR from the noise cov matrix and 
%                         the Sum cov matrix, and doing VS*SNR
% normalization_method == 5 for WTS; using VS/mean(abs(wts))
% normalization_method == 6 for SAMerf; doing the following- the baseline offset is removed from the source waveforms, using the mean
%                         of the pre-stimulus interval; for the *signal* we use the band-limited average;
%                         for the *noise* we divide our trials to ‘even’ and ‘odd’ groups, and do an average
%                         of ‘-odd+even’. SNR = RMS(signal)/RMS(noise), and we do VS*SNR.
% normalization_method == 7 for Z_SAMerf: doing both zscore and then multipling by the SNR which is calculated like in SAMerf
%
% INPUTS
% normalization_method = 1 or 2 or ...
% ActWgts = the wts you want to use, better to use the same wts for all
%           your data.
% Data    = field trip struct of your data
% BLtime  = [-0.2 0]; time in sec befor the onset
% Covdir  = string of the SAM cov dir, note - you must have there Noise.cov
%           and Sum.cov for running normalization_method == 4
% 
% OUTPUTS
% vs:     are your VS after the normalization
% factor: constant or vector (SNR) used to change the scale of all your VS, 
%         for constant: vs = vs/factor; usually to a range that can be displayed in AFNI. 
%         for vector (SNR) : vs=vs*SNR
%         If factor = []; no multipication was used
% prefix: is the name og the normalization method that was used

if normalization_method == 4
    disp('Make sure you have ~/bin/readcov_inbal.py');
end

% Applying the normalization
if normalization_method == 1
    % power i.e. normelizing by the wts mean and var: VS^2/cov of wts
    prefix = 'Power_';
    % estimate noise
    ns=ActWgts;
    % using the (vs^2 / cov) i.e zscore^2
    ns1=ns-repmat(mean(ns,2),1,size(ns,2));% subtracting the mean wts (over the 248 channels) of each vs
    ns1=ns1.*ns1;% ^2
    ns1=mean(ns1,2);% covariance of vs
    
    % creating an average struct using field trip
    avgData=ft_timelockanalysis([],Data);
    % applying a baseline correction
    avgData=correctBL(avgData,BLtime);
    
    vs=(ActWgts*avgData.avg).*(ActWgts*avgData.avg);% VS^2
    % normalize by the wts
    ns1=repmat(ns1,1,size(vs,2));
    vs=vs./ns1;% VS^2/cov of wts
    % fixing the values so I can see them in AFNI
    factor = max(max(vs));% - min(min(vsA));
    vs = vs/factor;
    
elseif normalization_method == 2
    % pseudoZ, i.e normalize with the *baseline* mean and sem
    prefix = 'pseudoZ_';
    factor =[];
    
    % creating an average struct using field trip
    avgData=ft_timelockanalysis([],Data);
    % applying a baseline correction
    avgData=correctBL(avgData,BLtime);
    
    mean_A = ActWgts*avgData.avg;% mean over trials
    % se_A = sqrt(ActWgts.^2*avgData.var)./sqrt(size(Data.cfg.trl,1));% generating standard error over trials
    % Zscore_ was using the [offset,0]sec for the normalization, as following
    onsetind = -Data.cfg.trl(1,3);
    vs = (mean_A - repmat(mean(mean_A(:,1:onsetind),2),[1 size(mean_A,2)]))./repmat(std(mean_A(:,1:onsetind),[],2),[1,size(mean_A,2)]);
    % NOTE, the std in the denominator here is on the averaged signal, over times befor onset.

elseif normalization_method == 3
    % Zscore, i.e normalize with the VS mean and sem, using all trials and
    % all times i.e. concatenating all data to one long vector and using
    % it's mean and std.
    prefix = 'Zscore_';
    factor =[];
    
    % creating an average struct using field trip
    avgData=ft_timelockanalysis([],Data);
    % applying a baseline correction
    avgData=correctBL(avgData,BLtime);
      
    % VS
    VSsignal = (ActWgts*avgData.avg);
    
    % concatenated channels data
    sumch = 0;
    sumch2 = 0;
    numSamples = 0;
    h=waitbar(0, 'Calculating mean and std');
    for k = 1:length(Data.trial)
        vsData = ActWgts*Data.trial{k};
        sumch  = sumch  + sum(vsData, 2);
        sumch2 = sumch2 + sum(vsData.^2, 2);
        numSamples = numSamples + size(Data.trial{k}, 2);
        waitbar(k/length(Data.trial), h);
    end
    close(h);
    
    % std and mean of VS
    M = sumch/numSamples;
    STD = sqrt(sumch2/numSamples - M.^2);
    
    % Zscore calculation on all data
    vs = (VSsignal - repmat(M(:),[1 size(VSsignal,2)]))./repmat(STD(:),[1,size(VSsignal,2)]);
    
    % OLD: 
    % mean_A = ActWgts*avgData.avg;% mean over trials
    % se_A = sqrt(ActWgts.^2*avgData.var)./sqrt(size(Data.cfg.trl,1));% generating standard error over *trials*
    % Z will be using all time fragment [offset end]sec for normlizing:
    % This way, there is NO comparison between channels, but each channel can be compared to itself between different times.
    % vs = (mean_A - repmat(mean(mean_A,2),[1 size(mean_A,2)]))./repmat(std(mean_A,[],2),[1,size(mean_A,2)]);
    % NOTE, here the std in the denominator is over time! not over trials.
       
elseif normalization_method == 4 
    % SNR from the noise cov matrix and the Sum cov matrix
    prefix = 'SNR_';
    factor =[];
    % reading the Noise.Cov and Sum.Cov matrix
    cd(Covdir);
    if ~exist('Noise.mat', 'file') % if the file does not exist, we will create it
        !python ~/bin/readcov_inbal.py Noise.cov
        Cns = load('Noise.txt');
        figure; subplot(1,2,1);imagesc(Cns);title('Noise covariance matrix');
        subplot(1,2,2);imagesc(Cns - Cns');title('covNoise - covNoise^T should be zerose');
        save Noise Cns
    else
        load('Noise.mat');
    end
    if ~exist('Sum.mat', 'file') % if the file does not exist, we will create it
        !python ~/bin/readcov_inbal.py Sum.cov
        Csig = load('Sum.txt');
        figure; subplot(1,2,1);imagesc(Csig);title('Sum covariance matrix');
        subplot(1,2,2);imagesc(Csig - Csig');title('covSum - covSum^T should be zerose');
        save Sum Csig
    else
        load('Sum.mat');
    end

    cd ../..;
    % creating the normalization vector SNR
    for c=1:size(ActWgts,1)
        Signal(c) = ActWgts(c,:)*Csig*ActWgts(c,:)';
        Noise(c) = ActWgts(c,:)*Cns*ActWgts(c,:)';
    end
    SNR = Signal./ Noise;
    factor = SNR;
    
    % creating an average struct using field trip
    avgData=ft_timelockanalysis([],Data);
    % applying a baseline correction
    avgData=correctBL(avgData,BLtime);

    vs=(ActWgts*avgData.avg);
    vs=vs.*repmat(SNR(:),[1,size(vs,2)]);

elseif normalization_method == 5
    % WTS: using mean(abs(wts))
    prefix = 'WTS_';
    % norm vector
    wts = mean(abs(ActWgts),2);
    
    % creating an average struct using field trip
    avgData=ft_timelockanalysis([],Data);
    % applying a baseline correction
    avgData=correctBL(avgData,BLtime);
    
    vs=(ActWgts*avgData.avg);
    vs=vs./repmat(wts,[1,size(vs,2)]);%
    % fixing the values so I can see them in AFNI
    factor = max(max(vs));% - min(min(vsC));
    vs = vs/factor;
    
elseif normalization_method == 6
    % SAMerf: the baseline offset is removed from the source waveforms, using the mean
    % of the pre-stimulus interval; for the *signal* we use the band-limited average;
    % for the *noise* we divide our trials to ‘even’ and ‘odd’ groups, and do an average
    % of ‘-odd+even’. SNR = RMS(signal)/RMS(noise)
    prefix = 'SAMerf_';
    
    % SIGNAL
    % creating an average struct using field trip
    avgData=ft_timelockanalysis([],Data);
    % applying a baseline correction
    avgData=correctBL(avgData,BLtime);
    
    % NOISE
    NoiseData = Data;
    for i = 1:2:size(NoiseData.trial,2)
        NoiseData.trial{1,i} = NoiseData.trial{1,i}.*(-1);
    end
    % creating an average struct using field trip
    avgNoise=ft_timelockanalysis([],NoiseData);
    % applying a baseline correction
    avgNoise=correctBL(avgNoise,BLtime);
    
    % VS
    VSsignal = (ActWgts*avgData.avg);
    VSnoise =  (ActWgts*avgNoise.avg);
    
    % SNR by using RMS
    RMSsignal = rms(VSsignal,2);
    RMSnoise = rms(VSnoise,2);
    SNR = RMSsignal./ RMSnoise ;
    factor = SNR;
    
    vs=VSsignal.*repmat(SNR(:),[1,size(VSsignal,2)]);
    % figure; plot(SNR);
    
    elseif normalization_method == 7
    % Z_SAMerf: doing both zscore and then multipling by the SNR which is calculated like in SAMerf
    prefix = 'Z_SAMerf_';
    
    % SIGNAL
    % creating an average struct using field trip
    avgData=ft_timelockanalysis([],Data);
    % applying a baseline correction
    avgData=correctBL(avgData,BLtime);
    
    % NOISE
    NoiseData = Data;
    for i = 1:2:size(NoiseData.trial,2)
        NoiseData.trial{1,i} = NoiseData.trial{1,i}.*(-1);
    end
    % creating an average struct using field trip
    avgNoise=ft_timelockanalysis([],NoiseData);
    % applying a baseline correction
    avgNoise=correctBL(avgNoise,BLtime);
    
    % VS
    VSsignal = (ActWgts*avgData.avg);% mean over trials
    VSnoise =  (ActWgts*avgNoise.avg);% mean over trials
    
    % SNR by using RMS
    RMSsignal = rms(VSsignal,2);
    RMSnoise = rms(VSnoise,2);
    SNR = RMSsignal./ RMSnoise ;
    factor = SNR;
   
    % concatenated channels data
    % Channels = [];
    sumch = 0;
    sumch2 = 0;
    numSamples = 0;
    h=waitbar(0, 'Calculating mean and std');
    for k = 1:length(Data.trial)
        vsData = ActWgts*Data.trial{k};
        sumch  = sumch  + sum(vsData, 2);
        sumch2 = sumch2 + sum(vsData.^2, 2);
        numSamples = numSamples + size(Data.trial{k}, 2);
        waitbar(k/length(Data.trial), h);
        % Channels = [Channels, Data.trial{k}];
    end
    close(h);
    
    % std and mean of VS
    M = sumch/numSamples;
    STD = sqrt(sumch2/numSamples - M.^2);
    % STD = std(ActWgts*Channels,[],2);
    % z calculation
    vs = (VSsignal - repmat(M(:),[1 size(VSsignal,2)]))./repmat(STD(:),[1,size(VSsignal,2)]);
    vs=vs.*repmat(SNR(:),[1,size(VSsignal,2)]);
end

% for the reproducibility do:
% figure; clf; imagesc(TimeLine,1:size(VSsignal,1),VSsignal./se_A);


% OLD     % doing a zscore and multiply by SNR
%     % Zscore, using all time fragment [offset end]sec for normlizing:
%     % VS - mean over time / std over time
%     N = sqrt(size(Data.cfg.trl,1)); % sqrt(number of trials)
%     %sm_A = sqrt(mean(ActWgts.^2*avgData.var,2));% generating standard mean over trials & time
%     sm_b = std(VSsignal,[],2)*N;
%     vs = (VSsignal - repmat(mean(VSsignal,2),[1 size(VSsignal,2)]))./repmat(sm_b,[1,size(VSsignal,2)]);
%     vs=vs.*repmat(SNR(:),[1,size(VSsignal,2)]);