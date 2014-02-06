function [snr,signal]=matchTemp(dataVec,temp,tempZero)
% here you look for a match between a template and data. tempZero is the
% time of interest in the template (in samples), like the maximum point of the event.

numSlides=length(dataVec)-length(temp)+1; % how many times the template will be shifted to match the data
if numSlides<1
    error('the data has to be larger than the template')
end
% baseline correction (sum = 0)
tempBlc = temp-mean(temp);
% normalization (sum of squares = 1)
tempBlcNorm=tempBlc./sqrt(sum(tempBlc.*tempBlc));
% try
%     matlabpool;
% end
snr=zeros(size(dataVec));
signal=snr;
for slidei=1:numSlides
    data=dataVec(slidei:slidei+length(temp)-1);
    Proj = sum(data.*tempBlcNorm);
    Signal = Proj^2;
    Total = sum(data.*data);
    Error = Total - Signal;
    SNR=Signal/Error;
    Sign=Proj/abs(Proj);
    signal(tempZero+slidei-1)=Sign*Signal;
    snr(tempZero+slidei-1)=Sign*SNR;
end



