function [data100,data102]=LFeegAlice(subFold) %#ok<STOUT>
cd /home/yuval/Data/alice
cd(subFold)
load files/evt
for resti=[100,102];
    sampBeg=round(evt(evt(:,3)==resti,1)*1024); %#ok<NODEF>
    sampEnd=sampBeg+60*1024;
    %samps1s=sampBeg:1024:sampEnd-1;
    trl=[sampBeg,sampEnd,0];
    cfg=[];
    cfg.trl=trl;
    cfg.channel='EEG';
    cfg.demean='yes';
    eval(['data',num2str(resti),'=readCNT(cfg);'])
end
[f,F]=fftBasic(data100.trial{1,1},data100.fsample);
f=abs(f);
f=abs(fftBasic(data100.trial{1,1},data100.fsample));
figure
plot(f')
xlim([0 110])
f=abs(fftBasic(data102.trial{1,1},data102.fsample));
figure
plot(f')
xlim([0 110])
