function LFsim2(reps,SNR)

if ~exist('reps','var')
    reps=[100 200 300 400 500 1000 1500 2000 3000 4000];
end
if isempty(reps)
    reps=[100 200 300 400 500 1000 1500 2000 3000 4000];
end
ratio=[];
try
    matlabpool;
end
cfg=[];
cfg.Lfreq=50;
cfg.jobs=4;
repCount=0;
% if ~exist('permN','var')
%     permN=500;
% end
% if isempty(permN)
%     permN=500;
% end
if ~exist('SNR','var')
    SNR=[0.25, 0.5, 1,2,4,8,16,32];
end
if isempty(SNR)
    SNR=[0.25, 0.5, 1,2,4,8,16,32];
end
%% epilepsy, fit 31Hz peak to 50Hz

%a=load('example_b.asc')
% [f,F]=fftBasic(a',200);
% plot(F,abs(f))
cd /home/yuval/Data/epilepsy/b162b/1
fn='c,rfhp1.0Hz';
hdr=ft_read_header(fn);
t1=139;
t2=145;

sRate=hdr.Fs;
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
%sRate=1.6*678.17;
% t1=139/1.6;
% t2=145/1.6;
s1=round(sRate*t1);
s2=round(sRate*t2);
%% sine
%for SNRi=1:length(SNR)

%noiseA=SNR(SNRi);
t=data.time{1,1};
clear data
A=max(abs(sig(1,1:678))); % amplitude of artifact 1/noiseA of signal
f=pi*2*31;
sinWave=A*sin(f*t);
%plot(t,y)


%%


cd /home/yuval/Dropbox/MEG/LF/data
% R=rand(length(SNR),length(sinWave));
% R=R-0.5;
% R=R.*2.*max(abs(sig))./repmat(SNR',1,length(sinWave)); % each channel different SNR
S=sig;%./repmat(SNR',1,length(sinWave));
%W=sinWave;
SW=repmat(sig,length(SNR),1)+repmat(sinWave,length(SNR),1)./repmat(SNR',1,length(sinWave));
fS=abs(fftBasic(S(s1:s2),sRate));
fS50=fS(31);
%fR=abs(fftBasic(R(:,s1:s2),sRate));
%fR50=fR(:,50);
fSW=abs(fftBasic(SW(:,s1:s2),sRate));
fSW50=fSW(:,31);
%plot(fS,'c');hold on;plot(fSW,'k')%;plot(F3,'b')
cfg=[];
cfg.Lfreq=31;
for repi=1:length(reps)
    disp(num2str(repi))
    repCount=repCount+1;
    cfg.Ncycle=reps(repCount);
    cfg.method='adaptive';
    
    clSW=correctLF(SW,sRate,'time',cfg);
    close;
    fclSW=abs(fftBasic(clSW(:,s1:s2),sRate));
    fclSW50=fclSW(:,31);
    ratio(1,repCount,1:length(SNR))=(fclSW50-fS50)./fS50; % adaptive,S+ sine wave
    
    cfg.method='adaptive1';
    
    clSW=correctLF(SW,sRate,'time',cfg);
    close;
    fclSW=abs(fftBasic(clSW(:,s1:s2),sRate));
    fclSW50=fclSW(:,31);
    ratio(2,repCount,1:length(SNR))=(fclSW50-fS50)./fS50; % adaptive1,S+ sine wave
end
ratioSW=(fSW50-fS50)/fS50; % the ratio between dirty and original signals
snr={'0.25','0.5','1','2','4','8','16','32'};

figure;
plot(reps,squeeze(ratio(1,:,:)))
title('adaptive')
figure;
plot(reps,squeeze(ratio(2,:,:)),'lineWidth',2)
legend(snr)
title('adaptive1')
save ratioSim2 ratio reps snr ratioSW
end
