function [freq,fourier]=fftYH(raws,Fs)
% raws = data with raws for channels
% Fs = Sampling frequency
L = size(raws,2)/Fs;                     % Length of signal
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(raws',NFFT);
fourier=Y(1:NFFT/2+1,:);
freq = Fs/2*linspace(0,1,NFFT/2+1);
fourier=fourier';
end