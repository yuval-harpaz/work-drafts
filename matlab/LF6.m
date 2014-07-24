function LF6

%% empty room long , Tal & Abeles
% short segment
cd /home/yuval/Data/emptyRoom2
Trig=readTrig_BIU;
reps=[100 500 1000 1500 2000 2500 3000 3500 4000 4500];
try
    matlabpool
end
samp100s=round(1.017249990200457e+03*100);
startSamp=1;
ratio=[];
for segi=1:35
    disp([' SEG SEG SEG ',num2str(segi)])
    cfg=[];
    cfg.channel='MEG';
    cfg.dataset=source;
    cfg.trl=[startSamp samp100s*segi 0];
    data=ft_preprocessing(cfg);
    f=abs(fftBasic(data.trial{1,1},data.fsample));
    f50=f(:,50);
    fBL=mean(f(:,[25:49 51:99 101:125]),2);
    trig=Trig(cfg.trl(1):cfg.trl(2));
    cfg=[];
    cfg.method='ADAPTIVE1';
    cfg.Lfreq=50;
    cfg.jobs=4;
    for repi=1:length(reps)
        %rateCount=0;
        cfg.Ncycles=reps(repi);
        lf=correctLF(data.trial{1,1},data.fsample,trig,cfg);
        close;
        fcl=abs(fftBasic(lf,data.fsample));
        fcl50=fcl(:,50);
        ratio(1:248,repi,segi)=(fcl50-fBL)./fBL;
        disp(num2str(repi))
    end
    startSamp=startSamp+samp100s;
end
save ratio35seg ratio reps
%% YH method, simple average
cd /home/yuval/Data/emptyRoom2

samp100s=round(1.017249990200457e+03*100);
startSamp=1;
ratio=[];
for segi=1:35
    disp([' SEG SEG SEG ',num2str(segi)])
    cfg=[];
    cfg.channel='MEG';
    cfg.dataset=source;
    cfg.trl=[startSamp samp100s*segi 0];
    data=ft_preprocessing(cfg);
    f=abs(fftBasic(data.trial{1,1},data.fsample));
    f50=f(:,50);
    fBL=mean(f(:,[25:49 51:99 101:125]),2);
    trig=Trig(cfg.trl(1):cfg.trl(2));
    cfg=[];
    cfg.method='ADAPTIVE';
    cfg.Lfreq=50;
    cfg.jobs=4;
    for repi=1:length(reps)
        %rateCount=0;
        cfg.Ncycles=reps(repi);
        lf=correctLF(data.trial{1,1},data.fsample,trig,cfg);
        close;
        fcl=abs(fftBasic(lf,data.fsample));
        fcl50=fcl(:,50);
        ratio(1:248,repi,segi)=(fcl50-fBL)./fBL;
        disp(num2str(repi))
    end
    startSamp=startSamp+samp100s;
end
save ratio35segYH ratio reps
