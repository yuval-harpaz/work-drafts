function LFsim1(reps,permN)


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
    reps=[100 200 300 400 500 1000 1500 2000 3000];
end
if isempty(reps)
    reps=[100 200 300 400 500 1000 1500 2000 3000];
end
ratio=[];
try
    matlabpool;
end
cfg=[];
cfg.Lfreq=50;
cfg.jobs=4;
repCount=0;
if ~exist('permN','var')
    permN=500;
end

cd /home/yuval/Dropbox/MEG/LF/data
% if exist('r.mat','file')
%     load r
% else
    R=rand(permN,length(sinWave));
    R=R-0.5;
    R=R.*2.*max(abs(sig))/noiseA;
%    save r R
%end
S=sig;
W=sinWave;
SW=sig+sinWave;
%SW=r+repmat(sinWave,permN,1)+repmat(sig,permN,1); % S = signal, W=wave of 50Hz, R=random noise
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
fS=abs(fftBasic(S(s1:s2),sRate));
fS50=fS(50);
fR=abs(fftBasic(R(:,s1:s2),sRate));
fR50=fR(:,50);
fSW=abs(fftBasic(SW(s1:s2),sRate));
fSW50=fSW(50);
%plot(fS,'c');hold on;plot(fSW,'k')%;plot(F3,'b')
for repi=1:length(reps)
    disp(num2str(repi))
    repCount=repCount+1;
    cfg.Ncycle=reps(repCount);
    cfg.method='adaptive';
    clS=correctLF(S,sRate,'time',cfg);
    close;
    fclS=abs(fftBasic(clS(:,s1:s2),sRate));
    fclS50=fclS(:,50);
    ratio(1,repCount)=(fclS50-fS50)./fS50; % adaptive,S simulated biological
    
    clR=correctLF(R,sRate,'time',cfg);
    close;
    fclR=abs(fftBasic(clR(:,s1:s2),sRate));
    fclR50=fclR(:,50);
    ratio(2,repCount,1:permN)=(fclR50-fR50)./fR50; % adaptive,R random noise
    
    clSW=correctLF(SW,sRate,'time',cfg);
    close;
    fclSW=abs(fftBasic(clSW(:,s1:s2),sRate));
    fclSW50=fclSW(:,50);
    ratio(3,repCount,1)=(fclSW50-fS50)./fS50; % adaptive,S+ sine wave
    
    cfg.method='adaptive1';
    
    clS=correctLF(S,sRate,'time',cfg);
    close;
    fclS=abs(fftBasic(clS(:,s1:s2),sRate));
    fclS50=fclS(:,50);
    ratio(4,repCount,1)=(fclS50-fS50)./fS50; % adaptive1,S simulated biological
    
    clR=correctLF(R,sRate,'time',cfg);
    close;
    fclR=abs(fftBasic(clR(:,s1:s2),sRate));
    fclR50=fclR(:,50);
    ratio(5,repCount,1:permN)=(fclR50-fR50)./fR50; % adaptive1,R random noise
    
    clSW=correctLF(SW,sRate,'time',cfg);
    close;
    fclSW=abs(fftBasic(clSW(:,s1:s2),sRate));
    fclSW50=fclSW(:,50);
    ratio(6,repCount,1)=(fclSW50-fS50)./fS50; % adaptive1,S+ sine wave
end
ratioDim1={'adaptive, bio','adaptive , random','adaptive , bio+sine','adaptive1 , bio','adaptive1 , random','adaptive1 , bio + sine'};
%cd /home/yuval/Dropbox/LF/data
%save ratioSim2 ratio reps ratioDim1
figure;
plot(reps,ratio)
legend(ratioDim1)
save ratioSim2 ratio reps ratioDim1
end
