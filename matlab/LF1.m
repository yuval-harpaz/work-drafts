cd /home/yuval/Copy/MEGdata/alice/idan

trig=readTrig_BIU;
trig=clearTrig(trig);
restS=find(trig==100,1,'last'); % idan had 100 in the beginning too
cfg=[];
cfg.trl=[restS,restS+round(1017.23*120),0];
cfg.dataset=source;
cfg.channel='MEG';
mag=ft_preprocessing(cfg);
cfg.channel='MCxaA';
ref=ft_preprocessing(cfg);
cfg=rmfield(cfg,'trl');
refAll=ft_preprocessing(cfg);
% [four,F]=fftBasic(ref.trial{1,1},ref.fsample);
% [~,refi]=max(abs(four(:,50))./mean(abs(four(:,60:90)),2));
% ref.label(refi)
[f100,F100]=fft100(refAll.trial{1,1},ref.fsample);

Hz45i=nearest(F100,45);
Hz55i=nearest(F100,55);
[~,maxPow]=max(abs(f100(Hz45i:Hz55i)));
maxPow=F100(maxPow+Hz45i-1);
trig=readTrig_BIU;
trig=trig(restS:restS+round(1017.23*120));
trig=bitand(uint16(trig),256);
correctLF(mag.trial{1,1},mag.fsample,'time','adaptive',50,4);
correctLF(mag.trial{1,1},mag.fsample,'time','adaptive',maxPow,4);
correctLF(mag.trial{1,1},mag.fsample,ref.trial{1,1},'adaptive',maxPow,4);
correctLF(mag.trial{1,1},mag.fsample,trig,'adaptive',maxPow,4);

cfg=[];
cfg.trl=[restS,restS+round(1017.23*120),0];
cfg.dataset=source;
cfg.channel='MEG';
cfg.hpfilter='yes';
cfg.hpfreq=1;
cfg.demean='yes';
magHP=ft_preprocessing(cfg);
correctLF(magHP.trial{1,1},mag.fsample,'time','adaptive',50,4);
correctLF(magHP.trial{1,1},mag.fsample,'time',50,50,4);
% check optimal freq
% compare trig - constructed - ref
% constructed: check num cycle effect


