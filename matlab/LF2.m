
% test epilepsy
%% surface - time frequency A161
cd /home/yuval/Data/epilepsy/b162b/1
hdr=ft_read_header(source);
t=121;
samp=round((t-30.5)*hdr.Fs);
samp(1,2)=samp+677;
for trli=2:46
    samp(trli,1)=samp(trli-1,2)+1;
    samp(trli,2)=samp(trli,1)+677;
end

time=-30:15;

cfg=[];
cfg.demean='yes';
cfg.trl=samp;
cfg.trl(:,3)=-678/2;
cfg.dataset=source;
cfg.channel='MEG';
raw=ft_preprocessing(cfg);
cfg.trl=[samp(1,1) samp(end,2) -round(30.5*hdr.Fs)];
rawCont=ft_preprocessing(cfg);


cfg=[];
%cfg.trials=find(datacln.trialinfo==222);
cfg.output       = 'pow';
cfg.channel      = 'MEG';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = 1:100;
cfg.feedback='no';
%cfg.keeptrials='yes';
FrAll = ft_freqanalysis(cfg, raw);

% make cfg for plot
cfgp = [];
cfgp.xlim = [50 50];
cfgp.layout       = '4D248.lay';
cfgp.interactive='yes';
cfgp.trials=43;
%figure;ft_topoplotER(cfgp, FrAll);
[~,chi]=ismember('A161',raw.label)
cfg=[];
cfg.demean='yes';
cfg.trl=samp;
cfg.trl(:,3)=-678/2;
cfg.dataset=['lf_',source];
cfg.channel='MEG';
rawLF=ft_preprocessing(cfg);
f=[];fcl=[];
flim=80
for icti=1:46
        ff=fftBasic(rawLF.trial{1,icti}(146,:),rawLF.fsample);
        fcl(icti,1:flim)=abs(ff(1:flim));
        ff=fftBasic(raw.trial{1,icti}(146,:),raw.fsample);
        f(icti,1:flim)=abs(ff(1:flim));
end


figure1 = figure('Colormap',...
    [0 0 0.5625;0 0 1;0 0.5 1;0 1 1;0.125 1 0.875;0.25 1 0.75;0.375 1 0.625;0.5 1 0.5;0.625 1 0.375;0.75 1 0.25;0.875 1 0.125;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.998214304447174 0 0;0.996428549289703 0 0;0.994642853736877 0 0;0.992857158184052 0 0;0.991071403026581 0 0;0.989285707473755 0 0;0.987500011920929 0 0;0.985714256763458 0 0;0.983928561210632 0 0;0.982142865657806 0 0;0.98035717010498 0 0;0.97857141494751 0 0;0.976785719394684 0 0;0.975000023841858 0 0;0.973214268684387 0 0;0.971428573131561 0 0;0.969642877578735 0 0;0.967857122421265 0 0;0.966071426868439 0 0;0.964285731315613 0 0;0.962499976158142 0 0;0.960714280605316 0 0;0.95892858505249 0 0;0.95714282989502 0 0;0.955357134342194 0 0;0.953571438789368 0 0;0.951785743236542 0 0;0.949999988079071 0 0;0.948214292526245 0 0;0.946428596973419 0 0;0.944642841815948 0 0;0.942857146263123 0 0;0.941071450710297 0 0;0.939285695552826 0 0;0.9375 0 0;0.5 0 0]);
axes1 = axes('Parent',figure1,'CLim',[0 3.23970682905768e-10]);
box(axes1,'on');
hold(axes1,'all');
xlim(axes1,[-30 15]);
ylim(axes1,[1 80]);
surface('Parent',axes1,'ZData',f','YData',1:80,'XData',time,'CData',f');
% surface('ZData',f','YData',1:80,'XData',time,'CData',f');
figure2 = figure('Colormap',...
    [0 0 0.5625;0 0 1;0 0.5 1;0 1 1;0.125 1 0.875;0.25 1 0.75;0.375 1 0.625;0.5 1 0.5;0.625 1 0.375;0.75 1 0.25;0.875 1 0.125;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.998214304447174 0 0;0.996428549289703 0 0;0.994642853736877 0 0;0.992857158184052 0 0;0.991071403026581 0 0;0.989285707473755 0 0;0.987500011920929 0 0;0.985714256763458 0 0;0.983928561210632 0 0;0.982142865657806 0 0;0.98035717010498 0 0;0.97857141494751 0 0;0.976785719394684 0 0;0.975000023841858 0 0;0.973214268684387 0 0;0.971428573131561 0 0;0.969642877578735 0 0;0.967857122421265 0 0;0.966071426868439 0 0;0.964285731315613 0 0;0.962499976158142 0 0;0.960714280605316 0 0;0.95892858505249 0 0;0.95714282989502 0 0;0.955357134342194 0 0;0.953571438789368 0 0;0.951785743236542 0 0;0.949999988079071 0 0;0.948214292526245 0 0;0.946428596973419 0 0;0.944642841815948 0 0;0.942857146263123 0 0;0.941071450710297 0 0;0.939285695552826 0 0;0.9375 0 0;0.5 0 0]);
axes2 = axes('Parent',figure2,'CLim',[0 3.23970682905768e-10]);
box(axes2,'on');
hold(axes2,'all');
xlim(axes2,[-30 15]);
ylim(axes2,[1 80]);
surface('Parent',axes2,'ZData',f','YData',1:80,'XData',time,'CData',fcl');


%% compare methods
% fcl is for trig 
% fcl 50 is adaptive with 50 cycles
lf=correctLF(rawCont.trial{1,1},rawCont.fsample,'time',50,50,4);
LF=raw;
for trli=1:46
    samples=samp(trli,1):samp(trli,2);
    samples=samples-samp(1,1)+1;
    LF.trial{1,trli}(:,:)=lf(:,samples);
end
fcl50=[];
flim=80;
for icti=1:46
        ff=fftBasic(LF.trial{1,icti}(146,:),rawLF.fsample);
        fcl50(icti,1:flim)=abs(ff(1:flim));
end
% adaptive 256
lf=correctLF(rawCont.trial{1,1},rawCont.fsample,'time','ADAPTIVE',50,4);
LF=raw;
for trli=1:46
    samples=samp(trli,1):samp(trli,2);
    samples=samples-samp(1,1)+1;
    LF.trial{1,trli}(:,:)=lf(:,samples);
end
fcl256=[];

for icti=1:46
        ff=fftBasic(LF.trial{1,icti}(146,:),rawLF.fsample);
        fcl256(icti,1:flim)=abs(ff(1:flim));
end
% find 0-crossing
lf=correctLF(source,[],[],'ADAPTIVE',50,4);
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

f_ictal=[];



figure;
plot(mean(f(31:45,:),1),'r')
hold on;
plot(mean(fcl(31:45,:),1),'b')
plot(mean(f(1:30,:),1),'k')
plot(mean(fcl(1:30,:),1),'c')
legend('ictal raw','ictal clean','preictal raw','preictal clean')


figure;
plot(mean(f(31:46,:),1),'r')
hold on;
plot(mean(fcl(31:46,:),1),'b')
plot(mean(fcl50(31:46,:),1),'c')
plot(mean(fcl256(31:46,:),1),'g')
%plot(mean(fclRef(31:46,:),1),'y')
legend('raw','trig','50 cycles','256 cycles')
%% old
lf=correctLF(rawCont.trial{1,1},rawCont.fsample,'time',50,50,4);
LF=raw;
for trli=1:46
    samples=samp(trli,1):samp(trli,2);
    samples=samples-samp(1,1)+1;
    LF.trial{1,trli}(:,:)=lf(:,samples);
end
LF=correctBL(LF);
FrLF = ft_freqanalysis(cfg, LF);
figure;ft_topoplotER(cfgp, FrLF);
figure;plot(time,FrAll.powspctrm(:,chi,50),'r')
hold on
plot(time,FrLF.powspctrm(:,chi,50),'k')

trig=readTrig_BIU;
trig=trig(samp(1,1):samp(end,2));
trig=bitand(uint16(trig),256);
lfTrig=correctLF(rawCont.trial{1,1},rawCont.fsample,trig,'adaptive',50);
LFtrig=raw;
for trli=1:46
    samples=samp(trli,1):samp(trli,2);
    samples=samples-samp(1,1)+1;
    LFtrig.trial{1,trli}(:,:)=lfTrig(:,samples);
end
LFtrig=correctBL(LFtrig);
FrLFtrig = ft_freqanalysis(cfg, LFtrig);
plot(time,FrLFtrig.powspctrm(:,chi,50),'g')


trig=readTrig_BIU;
%trig=trig(samp(1,1):samp(end,2));
trig=bitand(uint16(trig),256);
lfTrigG=correctLF(source,[],trig,'GLOBAL',50);
lfTrigG=lfTrigG(:,samp(1,1):samp(end,2));
LFtrigG=raw;
for trli=1:46
    samples=samp(trli,1):samp(trli,2);
    samples=samples-samp(1,1)+1;
    LFtrigG.trial{1,trli}(:,:)=lfTrigG(:,samples);
end
for chani=1:248;
    LFtrigG.label{chani,1}=['A',num2str(chani)];
end
LFtrigG=correctBL(LFtrigG);
FrLFtrigG = ft_freqanalysis(cfg, LFtrigG);
plot(time,FrLFtrigG.powspctrm(:,166,50),'m')
figure;ft_topoplotER(cfgp, FrLFtrigG);
figure;ft_topoplotER(cfgp, FrAll);
FrDif=FrAll;
bl=mean(FrAll.powspctrm(1:30,:,:),1);
for trli=31:46
   FrDif.powspctrm(trli,:,:)= FrDif.powspctrm(trli,:,:)-bl;
end
cfgp.zlim=[-0.5*1e-26 0.5*1e-26];
figure;ft_topoplotER(cfgp, FrDif);
figure;ft_topoplotER(cfgp, FrLFtrigG,FrDif);

p=pdf4D(source);
createCleanFile(p,source,'byLF',256,'method','phasePrecession');

cfg=[];
cfg.demean='yes';
cfg.trl=samp;
cfg.trl(:,3)=-678/2;
cfg.dataset=['lf_',source];
cfg.channel='MEG';
rawLF=ft_preprocessing(cfg);
rawLF=correctBL(rawLF);
cfg=[];
%cfg.trials=find(datacln.trialinfo==222);
cfg.output       = 'pow';
cfg.channel      = 'MEG';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = 1:100;
cfg.feedback='no';
cfg.keeptrials='yes';
FrLFccf = ft_freqanalysis(cfg, rawLF);

plot(time,FrLFccf.powspctrm(:,chi,50),'k')

for bli=1:30
    if bli==1
        [fA245_1,F]=fftBasic(raw.trial{1,bli}(64,:),raw.fsample);
        [fA161_1,F]=fftBasic(raw.trial{1,bli}(146,:),raw.fsample);
    else
        fA245_1=fA245_1+fftBasic(raw.trial{1,bli}(64,:),raw.fsample);
        fA161_1=fA161_1+fftBasic(raw.trial{1,bli}(146,:),raw.fsample);
    end
end
fA245_1=abs(fA245_1)./30;
fA161_1=abs(fA161_1)./30;
for icti=31:46
    if icti==31
        [fA245_2,F]=fftBasic(raw.trial{1,icti}(64,:),raw.fsample);
        [fA161_2,F]=fftBasic(raw.trial{1,icti}(146,:),raw.fsample);
    else
        fA245_2=fA245_2+fftBasic(raw.trial{1,icti}(64,:),raw.fsample);
        fA161_2=fA161_2+fftBasic(raw.trial{1,icti}(146,:),raw.fsample);
    end
end
fA245_2=abs(fA245_2)./16;
fA161_2=abs(fA161_2)./16;


for bli=1:30
    if bli==1
        [fA245_1lf,F]=fftBasic(rawLF.trial{1,bli}(64,:),raw.fsample);
        [fA161_1lf,F]=fftBasic(rawLF.trial{1,bli}(146,:),raw.fsample);
    else
        fA245_1lf=fA245_1lf+fftBasic(rawLF.trial{1,bli}(64,:),raw.fsample);
        fA161_1lf=fA161_1lf+fftBasic(rawLF.trial{1,bli}(146,:),raw.fsample);
    end
end
fA245_1lf=abs(fA245_1lf)./30;
fA161_1lf=abs(fA161_1lf)./30;
for icti=31:46
    if icti==31
        [fA245_2lf,F]=fftBasic(rawLF.trial{1,icti}(64,:),raw.fsample);
        [fA161_2lf,F]=fftBasic(rawLF.trial{1,icti}(146,:),raw.fsample);
    else
        fA245_2lf=fA245_2lf+fftBasic(rawLF.trial{1,icti}(64,:),raw.fsample);
        fA161_2lf=fA161_2lf+fftBasic(rawLF.trial{1,icti}(146,:),raw.fsample);
    end
end
fA245_2lf=abs(fA245_2lf)./16;
fA161_2lf=abs(fA161_2lf)./16;
figure;
% plot(F,abs(fA245_1),'b')
% hold on
% plot(F,abs(fA245_2),'r')

figure;
plot(F,abs(fA161_1),'r')
hold on
plot(F,abs(fA161_2),'k')
plot(F,abs(fA161_1lf),'b')
plot(F,abs(fA161_2lf),'g')
legend('BLraw','ICTraw','BLclean','ICTclean')


for bli=1:30
    if bli==1
        [f_1,F]=fftBasic(raw.trial{1,bli},raw.fsample);
        f_1=abs(f_1).^2;
    else
        f_1=f_1+abs(fftBasic(raw.trial{1,bli},raw.fsample)).^2;
    end
end
f_1=f_1./30;
for icti=31:46
    if icti==31
        f_2=fftBasic(raw.trial{1,icti},raw.fsample);
        f_2=abs(f_2).^2;
    else
        f_2=f_2+abs(fftBasic(raw.trial{1,icti},raw.fsample)).^2;
    end
end
f_2=f_2./16;

for bli=1:30
    if bli==1
        [fcl_1,F]=fftBasic(rawLF.trial{1,bli},rawLF.fsample);
        fcl_1=abs(fcl_1).^2;
    else
        fcl_1=fcl_1+abs(fftBasic(rawLF.trial{1,bli},rawLF.fsample)).^2;
    end
end
fcl_1=fcl_1./30;
for icti=31:46
    if icti==31
        fcl_2=fftBasic(rawLF.trial{1,icti},rawLF.fsample);
        fcl_2=abs(fcl_2).^2;
    else
        fcl_2=fcl_2+abs(fftBasic(rawLF.trial{1,icti},rawLF.fsample)).^2;
    end
end
fcl_2=fcl_2./16;
fftRaw=FrAll;
fftRaw.powspctrm=[];
fftRaw.powspctrm(1,1:248,1:339)=f_1;
fftRawIct=FrAll;
fftRawIct.powspctrm=[];
fftRawIct.powspctrm(1,1:248,1:339)=f_2;
fftCl=FrAll;
fftCl.powspctrm=[];
fftCl.powspctrm(1,1:248,1:339)=fcl_1;
fftClIct=FrAll;
fftClIct.powspctrm=[];
fftClIct.powspctrm(1,1:248,1:339)=fcl_2;
fftRawDif=fftRaw;
fftRawDif.powspctrm=fftRawIct.powspctrm-fftRaw.powspctrm;
cfgp.zlim=[0 1e-21];
figure;ft_topoplotER(cfgp, fftCl,fftClIct,fftRaw,fftRawIct);
cfgp.zlim=[0 5*1e-22];
figure;ft_topoplotER(cfgp,fftClIct,fftRawDif);
freq=50;
for icti=1:46
        ff=fftBasic(rawLF.trial{1,icti}(146,:),rawLF.fsample);
        fcl(icti)=abs(ff(freq)).^2;
        ff=fftBasic(raw.trial{1,icti}(146,:),raw.fsample);
        f(icti)=abs(ff(freq)).^2;
end
figure;plot(time,fcl)
hold on
plot(time,f,'r')


% check again with adaptive, time etc