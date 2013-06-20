function [wordS,rowS]=findSaccade(eog,thrRow,thrWord)
% finds saccades in eog data
% thresholds (in std) have to be given for raws and words.
leng=150;
temp=[-ones(1,leng),0,ones(1,leng)]; % R to L saccade template
tmplt=temp./sqrt(sum(temp.*temp)); % normalize template
[SNR,SigX,sigSign]=fitTemp(eog,tmplt,leng+1);
SNRsigned=SNR.*sigSign./max(SNR);
SigX=SigX.*sigSign./max(SigX);
eogNorm=eog./max(abs(eog));
plot(SNRsigned)
hold on
plot(SigX,'k')
plot(eogNorm,'g')
[rowSig,rowS]=findPeaks(-SigX,thrRow,2000);

[wordSNR,wordS]=findPeaks(SNRsigned,thrWord,100);
wordS=wordS(find(SigX(wordS)<0.1));
plot(rowS,-rowSig,'r.')
plot(wordS,SNRsigned(wordS),'ro')


%Signal = (sum(eog.*temp))^2;