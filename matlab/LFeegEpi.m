function LFeegEpi

cd /home/yuval/Data/epilepsy/p006/1

cfg=[];
cfg.dataset=source;
cfg.trl=[1,3,0];
data=ft_preprocessing(cfg);
cfg=[];
cfg.dataset=source;
cfg.channel=data.label(275:308);
data=ft_preprocessing(cfg);
[f,F]=fftBasic(data.trial{1,1},data.fsample);
f=abs(f);
figure
plot(f')
trig=readTrig_BIU;
dataLF=correctLF(data.trial{1,1},data.fsample,trig,'GLOBAL',50,4);
dataLF=correctLF(data.trial{1,1},data.fsample,trig,'ADAPTIVE',50,4);
dataLF=correctLF(data.trial{1,1},data.fsample,[],'ADAPTIVE',50,4);