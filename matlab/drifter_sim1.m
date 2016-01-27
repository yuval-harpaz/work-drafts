clear
dt     = 0.001;          % Sampling rate (in seconds)
T      = 0:dt:10;     % Time instants
f      = 60 / 60;      % 72 beats per minute, constant frequency
freqlist=55:65;
N=1; % number of harmonics
% Make reference data with fundamental signal + one harmonic
ref_data  = 1*sin(1*2*pi*f*T);% + ...
    % 2*cos(2*2*pi*f*T);

% Make true slow brain signal
%brain_data = cumsum(0.05*randn(size(T)));
alpha = 0.5*sin(1*2*pi*10*T);
brain_data=zeros(size(alpha));
for ii=1000:1000:length(alpha)
    try
        iii=ii+round(rand(1)*500);
        brain_data(iii+1:iii+100)=alpha(1:100);
    end
end
brain_data=brain_data(1:length(alpha));

% Make simulated brain data (random walk + oscillators)
true_data =  brain_data + ref_data;
rand_noise=0.05*randn(size(true_data));
% Add noise to true data
obs_data = true_data + rand_noise;
%Set up DRIFTER and run it

% Provide two structures: "data" and "refdata" such that
data.data = obs_data;
data.dt = dt;

% And for each reference signal
refdata{1}.dt = dt;
refdata{1}.freqlist = freqlist; % Vector of possible frequencies in bpm
refdata{1}.frequencies=freqlist;
refdata{1}.data = ref_data;  % NOTE: If this is left out, the data.data
refdata{1}.N=N;
% is used.

% Run DRIFTER
[datao,refdatao] = drifter(data,refdata);
figure;
plot(T,obs_data'-squeeze(datao.noise),'g')
hold on
plot(T,ref_data)

% All the parameters are now visible in the structures
% 'data' and 'refdata'.
% DRIFTER version: 20120417           :                        Up to date.
% Kalman filtering                    :                              Done.
% RTS smoother                        :                              Done.
% Visualize result

% The following code is only for providing a visual interpretation
% of the estimation results. Three figures are shown:
% (1) the brain signal (the true signal, a noisy observation of it,
% the DRIFTER estimate, and the DRIFTER estimate with the measurement
% noise added back to it), (2) The estimated periodic noise component,
% (3) The stimated frequency trajectory.

% figure(1); clf
% subplot(2,2,[1 2]); hold on
% plot(T,brain_data,'--k', ...
%     T,squeeze(datao.data),'-g', ...
%     T,squeeze(datao.estimate),'-b', ...
%     T,squeeze(datao.estimate+datao.noise),'-r')
% legend('True data','Observed data','Estimate','Estimate+white noise')
% title('\bf Results'); xlabel('Time [s]');
% subplot(223); hold on
% plot(T,squeeze(refdatao{1}.estimate),'-b')
% title([refdatao{1}.name ' Estimate'])
% xlabel('Time [s]');
% subplot(224); hold on
% plot(T,refdata{1}.FF,'-b')
% ylim([min(refdatao{1}.freqlist) max(refdatao{1}.freqlist)])
% title([refdatao{1}.name ' Frequency'])
% xlabel('Time [s]'); ylabel('Freq (bpm)')