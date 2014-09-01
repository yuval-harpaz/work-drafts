function LFsim1(reps)


%% epilepsy, fit 31Hz peak to 50Hz

%a=load('example_b.asc')
% [f,F]=fftBasic(a',200);
% plot(F,abs(f))
cd /home/yuval/Data/epilepsy/b162b/1
fn='c,rfhp1.0Hz';
hdr=ft_read_header(fn);
t1=139;
t2=145;
tdif=t2-t1+1;
sRate=round(hdr.Fs);
cfg=[];
%cfg.trl=[t1*sRate t2*sRate 0];
cfg.demean='yes';
cfg.dataset=['hb_',fn];
cfg.channel={'A132','A133','A134','A160','A161','A162'};
cfg.bpfilter='yes';
cfg.bpfreq=[3 40];
data=ft_preprocessing(cfg);
%fraw=abs(fftBasic(data.trial{1,1},data.fsample));
sig=mean(data.trial{1,1});

sig=sig-mean(sig);
%figure;plot(abs(fftBasic(x,678.17)))
sRate=1.6*678.17;
t1=139/1.6;
t2=145/1.6;
s1=round(sRate*t1);
s2=round(sRate*t2);
%% sine
noiseA=16;
t=data.time{1,1}/1.6;
clear data
A=max(abs(sig))/noiseA; % amplitude of artifact 1/noiseA of signal
f=pi*2*50;
sinWave=A*sin(f*t);
%plot(t,y)


%%
if ~exist('reps','var')
    reps=[100 500 1000 1500 2000 2500 3000 3500 4000 4500];
end
ratio=[];
try
    matlabpool;
end
cfg=[];
cfg.Lfreq=50;
cfg.jobs=4;
repCount=0;
permN=500;
cd /home/yuval/Dropbox/LF/data
if exist('r.mat','file')
    load r
else
    r=rand(permN,length(sinWave));
    r=r-0.5;
    r=r.*2.*max(abs(sig))/noiseA;
    save r r
end
% allSig=r+repmat(sinWave,permN,1)+repmat(sig,permN,1); %
% fSig=abs(fftBasic(sig(:,s1:s2),sRate));
% fSig50=fSig(:,50);
% %clear sig
% f=abs(fftBasic(allSig(:,s1:s2),sRate));
% f50=f(:,50);
% noise=r+repmat(sinWave,permN,1);
% rf=abs(fftBasic(r(:,s1:s2),sRate));
% rf50=rf(:,50);
% fWave=abs(fftBasic(sinWave,sRate));
% fW50=fWave(50);
F1=abs(fftBasic(sig(1,s1:s2),sRate));
F2=abs(fftBasic(r(1,s1:s2),sRate));
F3=abs(fftBasic(r(1,s1:s2)+sig(1,s1:s2),sRate));
plot(F1,'c');hold on;plot(F2,'k');plot(F3,'b')
for repi=1:length(reps)
    disp(num2str(repi))
    repCount=repCount+1;
    cfg.Ncycle=reps(repCount);
    cfg.method='adaptive';
    lf=correctLF(allSig,sRate,'time',cfg);
    close;
    fcl=abs(fftBasic(lf(:,s1:s2),sRate));
    fcl50=fcl(:,50);
    
    figure;
    plot(f(1,:),'r')
    hold on
    plot(mean(fcl),'b')
    plot(fSig,'g')
    ratio(1,repCount,1:permN)=(fcl50-fSig50)./fSig50; % adaptive, all signals(simulated biological 50Hz+rand+50Hz noise)
    
    rlf=correctLF(r,sRate,'time',cfg);
    close;
    rfcl=abs(fftBasic(rlf(:,s1:s2),sRate));
    rfcl50=rfcl(:,50);
    %     figure;
    %     plot(mean(rf),'r')
    %     hold on
    %     plot(mean(rfcl),'b')
    ratio(3,repCount,1:permN)=(rfcl50-rf50)./rf50; % adaptive, noise (rand+50Hz)
    
    rlf=correctLF(r,sRate,'time',cfg);
    close;
    rfcl=abs(fftBasic(rlf(:,s1:s2),sRate));
    rfcl50=rfcl(:,50);
    ratio(3,repCount,1:permN)=(rfcl50-rf50)./rf50; % adaptive, noise (rand+50Hz)
    
    cfg.method='adaptive1';
    lf1=correctLF(allSig,sRate,'time',cfg);
    close;
    fcl1=abs(fftBasic(lf1(:,s1:s2),sRate));
    fcl50_1=fcl1(:,50);
    ratio(2,repCount,1:permN)=(fcl50_1-f50)./f50; % adaptive1, all signals
    
    rlf1=correctLF(r+repmat(sinWave,permN,1),sRate,'time',cfg);
    close;
    rfcl1=abs(fftBasic(rlf1(:,s1:s2),sRate));
    rfcl50_1=rfcl1(:,50);
    ratio(4,repCount,1:permN)=(rfcl50_1-rf50)./rf50; % adaptive1, noise
    
    nlf1=correctLF(noise,sRate,'time',cfg);
    close;
    nfcl=abs(fftBasic(nlf1(:,s1:s2),sRate));
    nfcl50=rfcl(:,50);
    ratio(6,repCount,1:permN)=(nfcl50-rf50)./rf50; % adaptive, noise (rand+50Hz)
end
ratioDim1={'adaptive, all signals(simulated biological 50Hz+rand+50Hz noise)','adaptive1, all signals','adaptive, noise (rand+50Hz)','adaptive1, noise'};
cd /home/yuval/Dropbox/LF/data
%save ratioSim ratio reps ratioDim1
end
