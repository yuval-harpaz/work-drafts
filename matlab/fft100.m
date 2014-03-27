function [fourier,freq]=fft100(rows,Fs,keepSegments)
% rows = data with rows for channels
% Fs = Sampling frequency
if ~exist('keepSegments','var')
    keepSegments=false;
end
L = size(rows,2)/Fs;                     % Length of signal
NFFT = round(Fs*100); % this gives bins of roughly  1Hz
secCount=1;
for seci=1:NFFT:(size(rows,2)-NFFT)
    if seci==1
        Y = fft(rows',NFFT);
    else
        secCount=secCount+1;
        if keepSegments
            Y(:,secCount)=fft(rows(:,seci:seci+NFFT)',NFFT);
        else
            Y = Y+fft(rows(:,seci:seci+NFFT)',NFFT);
        end
    end
end
if ~keepSegments
    Y=Y./secCount; % average over seconds
end
fourier=Y(1:floor(NFFT/2)+1,:);
freq = Fs/2*linspace(0,1,NFFT/2+1);
fourier=fourier';
freq=freq(2:end);
fourier=fourier(:,2:end);
end