function LF7_b

%% YH method, simple average before and after
cd /home/yuval/Data/emptyRoom2
Trig=readTrig_BIU;
reps=1000;
try
    matlabpool
end
samp100s=round(1.017249990200457e+03*100);
startSamp=1;
for segi=1:35
    disp([' SEG SEG SEG ',num2str(segi)])
    cfg=[];
    cfg.channel='MEG';
    cfg.dataset=source;
    cfg.trl=[startSamp samp100s*segi 0];
    data=ft_preprocessing(cfg);
%     s0=1;
    s1=round(1000*1017/50);
%     s2=round(2*1000*1017/50);
%     s3=round(3*1000*1017/50);
%     s10=length(data.time{1,1});
%     s9=s10-s1;
    %f1=abs(fftBasic(data.trial{1,1}(:,s0:s1),data.fsample));
    %f2=abs(fftBasic(data.trial{1,1}(:,s1+1:s2),data.fsample));
    %f3=abs(fftBasic(data.trial{1,1}(:,s2+1:s3),data.fsample));
    %f10=abs(fftBasic(data.trial{1,1}(:,s9+1:s10),data.fsample));
    
    %f50=f(:,50);
    %fBL=mean(f(:,[25:49 51:99 101:125]),2);
    trig=Trig(cfg.trl(1):cfg.trl(2));
    cfg=[];
    cfg.method='ADAPTIVE1';
    cfg.Lfreq=50;
    cfg.jobs=4;
    
    %rateCount=0;
    cfg.Ncycles=reps;
    lf=correctLF(data.trial{1,1},data.fsample,trig,cfg);
    close;
    startS=1:s1:samp100s;
    startS=startS(1:end-1);
    for parti=1:5
        f=abs(fftBasic(data.trial{1,1}(:,startS(parti):(startS(parti)+s1)),data.fsample));
        fcl=abs(fftBasic(lf(:,startS(parti):(startS(parti)+s1)),data.fsample));
        %fcl1(1:248,1:508,segi)=abs(fftBasic(lf(:,s0:s1),data.fsample));
        %fcl2(1:248,1:508,segi)=abs(fftBasic(lf(:,s1+1:s2),data.fsample));
        %fcl3(1:248,1:508,segi)=abs(fftBasic(lf(:,s1+1:s2),data.fsample));
        %fcl10(1:248,1:508,segi)=abs(fftBasic(lf(:,s9+1:s10),data.fsample));
        %         fcl50=fcl(:,50);
        %ratio1(1:248,segi)=(fcl1(:,50)-mean(f1(:,125:145),2))./mean(f1(:,125:145),2);
        %ratio2(1:248,segi)=(fcl2(:,50)-mean(f2(:,125:145),2))./mean(f2(:,125:145),2);
        %ratio3(1:248,segi)=(fcl3(:,50)-mean(f3(:,125:145),2))./mean(f3(:,125:145),2);
        %ratio10(1:248,segi)=(fcl10(:,50)-mean(f10(:,125:145),2))./mean(f10(:,125:145),2);
        ratio(segi,parti)=mean((fcl(:,50)-mean(f(:,125:145),2))./mean(f(:,125:145),2));
        ratio2(segi,parti)=(mean(fcl(:,50))-mean(mean(f(:,125:145),2)))./mean(mean(f(:,125:145),2));
        %         disp(num2str(repi))
    end
    startSamp=startSamp+samp100s;
end
%save ratio1000all ratio*
