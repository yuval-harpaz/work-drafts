function [fcl50,f50,fcl,f]=LFtestNcyc(data,trials,LFchan,method,samp,sRate,hpFreq)
if ~exist('sRate','var')
    sRate=678.17;
end
if exist('hpFreq','var')
    lf=correctLF(data,sRate,LFchan,method,50,[],hpFreq);
else
    lf=correctLF(data,sRate,LFchan,method,50);
end
close
%lf=lf(:,samp(1,1):samp(end,2));
flim=80;
for trli=trials
    samples=samp(trli,1):samp(trli,2);
    samples=samples-samp(1,1)+1;
    ff=fftBasic(data(1,samples),sRate);
    f(trli,1:flim)=abs(ff(1:flim));
    ff=fftBasic(lf(1,samples),sRate);
    fcl(trli,1:flim)=abs(ff(1:flim));
end
fcl=mean(fcl,1);
f=mean(f,1);
% figure;
% plot(f,'r');
% hold on
% plot(fcl,'g')
f50=f(50);
fcl50=fcl(50);
end
