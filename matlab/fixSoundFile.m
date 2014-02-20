function [A, newFs] = fixSoundFile(varargin) 

% fix audio files to use with the new sound card in the MEG - insert a
% trigger wave to the right channel and rewrite the new file to the current
% directory.
% use as:
% [A, newFs] = fixSoundFile('-parameter_name', parameter_value);
% EXAMPLE: 
% [A, newFs] = fixSoundFile('-soundFileName', 'mySound.wav', '-prefix', 'fix_', '-showFig',1) 

% INPUTS:
% '-soundFileName'   - String containing the name of the sound file (must be
%                       defined).
% '-squareAmp'       - Amplitude of the square wave (Default = -1).
% '-minPeakHeight'   - Minimum peak height to find in the original sound
%                       file. (Default = 0.4).
% '-minPeakDistance' - Minimum distance (in seconds) between peaks to find in the
%                       original sound file (Default = [] - meaning find the first peak that
%                       exceeds the minPeakHeight).
% '-newFs'          - new sampling rate for the new sound file (Default =
%                   same as the original).
% '-showFig'        - 1, or 0 - Show figurew of the new sound file (Default = 1).
% '-squareDuration' - Duration of the square wave in seconds (Default =
%                   0.01)
% '-prefix'         - prefix for the new sound file generated (Default =
%                   'trig_'
% '-playSound'      - 1 or 0 - play the new sound file (Default = 0).
% 
% OUTPUTS:
% A     - A matrix of the new sound file
% newFs - sampling rate of the new sound file
% 
% NOTES: 
%   - You must be in the directory of the sound files. 
%   - The function process_varargin.m must be in your Matlab path. 


% process input arguments
okargs=        {'-soundFileName'  '-squareAmp'  '-minPeakHeight' '-minPeakDistance'  '-newFs'  '-showFig' '-squareDuration' '-prefix'  '-playSound'};
default_values={ []               ,-1           ,0.4             ,[]                 ,[]       ,1         ,0.01             ,'trig_'   ,0};
okargs = lower(okargs);
keyvalue = process_varargin('fixSoundFile', okargs, default_values, varargin);
soundFileName = keyvalue{1};
squareAmp = keyvalue{2};
minPeakHeight = keyvalue{3};
minPeakDistance   = keyvalue{4};
newFs = keyvalue{5};
showFig   = keyvalue{6};
squareDuration = keyvalue{7};
prefix = keyvalue{8};
playSound = keyvalue{9};

% read the sound file
[A, Fs] = wavread(soundFileName);
A(:,2) = 0;
lenSoundFile = length(A(:,1));

% find peaks in the original sound file
if isempty(minPeakDistance) 
   [pks, locs] = findpeaks(A(:,1), 'minpeakheight', minPeakHeight, 'npeaks', 1);
else
    minPeakDistance = minPeakDistance*Fs;
   [pks, locs] = findpeaks(A(:,1), 'minpeakheight', minPeakHeight, 'minpeakdistance', minPeakDistance);
end

% insert a square wave to the Left channel
A((locs+1): (locs+1)+squareDuration*Fs,2) = squareAmp;

if isempty(newFs)
    newFs = Fs;
end
 % write new sound file
newFileName = [prefix soundFileName];
fprintf('writing new sound file: %s\n', newFileName);
wavwrite(A, newFs, 16, newFileName);

if playSound
    sound(A, Fs)
end

if showFig
   figure
   plot(A)
   set(gca,'fontsize',14)
   title(sprintf('New Sound FileWith Trigger: %s', newFileName));
   xlabel('Sample #')
   ylabel('Amplitude')
   axis tight
end






