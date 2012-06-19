function [trials,pI,nI,pP,nP,asip,allSigIpeaks]=findTempInTrials(template,data,chani,trialInd,tPos,tNeg,limSNR,limSig,deadT)

try
    if isempty(limSig)
        limSig=0;
    end
catch
    limSig=0;
end
try
    if isempty(limSNR)
        limSNR=1;
    end
catch
    limSNR=1;
end
try
    if isempty(deadT)
        deadT=0;
    end
catch
    deadT=0;
end
t=data.time{1,1};   
tmp=template;
if length(chani)==2
    tmp=2.*tmp;
end
tmpBlc = tmp-mean(tmp);
tmplt=tmpBlc./sqrt(sum(tmpBlc.*tmpBlc));
allSigIpeaks={};
asip=[];nI=[];pI=[];nP=[];pP=[];
trials=trialInd;
trials(2,:)=data.trialinfo;
for triali=1:length(data.trial)
    x=[];
    if length(chani)==2 % signal is difference between two channels
        x1=data.trial{1,triali}(chani(1),:); %'A191'
        x2=data.trial{1,triali}(chani(2),:); %'A215'
        x=x1-x2;
    else
        x=data.trial{1,triali}(chani,:);
    end
    [SNR,SigX]=fitTemp(x,tmplt);
    %plot(SNR);
    [SigPeaks, SigIpeaks] = findPeaks(SigX,3, deadT, 'MAD');
    asip=[asip,SigIpeaks];
    Ppos=SigIpeaks(x(SigIpeaks)>0);
    Pneg=SigIpeaks(x(SigIpeaks)<0);
    pP=[pP Ppos];nP=[nP Pneg];
    allSigIpeaks(1,triali).all=SigIpeaks;
    allSigIpeaks(1,triali).pos=Ppos;
    allSigIpeaks(1,triali).neg=Pneg;
    SNRpeaks = SNR(SigIpeaks);
    I= SigIpeaks(SigPeaks>limSig & SNRpeaks'>limSNR);
    Ipos=I(x(I)>0);
    Ineg=I(x(I)<0);
    pI=[pI Ipos];nI=[nI Ineg];
    try
        s=[];
        s=Pneg(nearest(t(Pneg),tNeg));
        trials(3,triali)=t(s);
        trials(4,triali)=x(s);
    catch me
        display(['no neg peaks on trial:          ',num2str(triali)])
    end
    try
        s=[];
        s=Ineg(nearest(t(Ineg),tNeg));
        trials(5,triali)=t(s);
        trials(6,triali)=x(s);
    catch me
        display(['no filtered neg peaks on trial: ',num2str(triali)])
    end
    try
        s=[];
        s=Ppos(nearest(t(Ppos),tPos));
        trials(7,triali)=t(s);
        trials(8,triali)=x(s);
    catch me
        display(['no pos peaks on trial:          ',num2str(triali)])
    end
    try
        s=[];
        s=Ipos(nearest(t(Ipos),tPos));
        trials(9,triali)=t(s);
        trials(10,triali)=x(s);
    catch me
        display(['no filtered pos peaks on trial: ',num2str(triali)])
    end
end
