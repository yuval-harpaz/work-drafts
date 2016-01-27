dt     = 0.001;          % Sampling rate (in seconds)
T      = 0:dt:100;     % Time instants
f      = 72 / 60;      % 72 beats per minute, constant frequency

% Make reference data with fundamental signal + one harmonic
ref_data  = 1*sin(1*2*pi*f*T) + ...
    2*cos(2*2*pi*f*T);

% Make true slow brain signal
brain_data = cumsum(0.05*randn(size(T)));

% Make simulated brain data (random walk + oscillators)
true_data =  brain_data + ...
    .2*sin(1*2*pi*f*T) + ...
    .1*cos(2*2*pi*f*T);

% Add noise to true data
obs_data = true_data + 0.05*randn(size(true_data));
%Set up DRIFTER and run it

% Provide two structures: "data" and "refdata" such that
data.data = obs_data;
data.dt = dt;

% And for each reference signal
refdata{1}.dt = dt;
refdata{1}.freqlist = 60:90; % Vector of possible frequencies in bpm
refdata{1}.data = ref_data;  % NOTE: If this is left out, the data.data
% is used.

% Run DRIFTER
[data,refdata] = drifter(data,refdata);

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

figure(1); clf
subplot(2,2,[1 2]); hold on
plot(T,brain_data,'--k', ...
    T,squeeze(data.data),'-g', ...
    T,squeeze(data.estimate),'-b', ...
    T,squeeze(data.estimate+data.noise),'-r')
legend('True data','Observed data','Estimate','Estimate+white noise')
title('\bf Results'); xlabel('Time [s]');
subplot(223); hold on
plot(T,squeeze(refdata{1}.estimate),'-b')
title([refdata{1}.name ' Estimate'])
xlabel('Time [s]');
subplot(224); hold on
plot(T,refdata{1}.FF,'-b')
ylim([min(refdata{1}.freqlist) max(refdata{1}.freqlist)])
title([refdata{1}.name ' Frequency'])
xlabel('Time [s]'); ylabel('Freq (bpm)')