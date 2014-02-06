cd /media/Elements/Kirsten/data/patients/Pat_10_12035ah/01_Input_no_noisereduction/01
load data
sRate=1017.25;
segs=10171:10170:length(data);
[four,freq]=fftBasic(data(:,1:10170),sRate,0.001);
four=mean(four(:,1:170000));
freq=freq(1:170000);
%four=zeros(size(fourier));
for segi=segs(1:end-1);
    [fourier,~]=fftBasic(data(:,segi:segi+10170),sRate,0.001);
    four=four+mean(abs(fourier(:,1:170000)));
    disp([num2str(segi),' ',num2str(length(data))]);
end
four(1:nearest(freq,40))=0;
[p,I]=findPeaks(abs(four),3,10000);
freqs=freq(I);
meanFreq=(freqs(1)+freqs(2)/2+freqs(3)/3)/3;
freq50=freqs(1);
save meanFreq meanFreq
