function LFtestNcyc(data,trials,LFchan,method)

lf=correctLF(data,[],[],'ADAPTIVE',50,4);
lf=lf(:,samp(1,1):samp(end,2));
LF=raw;
for trli=1:46
    samples=samp(trli,1):samp(trli,2);
    samples=samples-samp(1,1)+1;
    LF.trial{1,trli}(:,:)=lf(:,samples);
end
fclRef=[];

for icti=1:46
        ff=fftBasic(LF.trial{1,icti}(161,:),rawLF.fsample);
        fclRef(icti,1:flim)=abs(ff(1:flim));
end
