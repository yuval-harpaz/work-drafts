%% Empty Room Global
% global


cd /home/yuval/Data/emptyRoom2
Trig=readTrig_BIU;
ratio=[];
cfg=[];
cfg.channel='MEG';
cfg.dataset=source;
cfg.trl=[1 1 0];
dummy=ft_preprocessing(cfg);
try
    matlabpool
end

len=round(20*1.017249990200457e+03/1000*[3500 17500 35000 175000]);
load fG
for leni=2:3
    startSamp=1;
    ratio=[];
    for segi=1:len(4)/len(leni)
        cfg=[];
        cfg.channel='MEG';
        cfg.dataset=source;
        cfg.trl=[startSamp startSamp+len(leni) 0];
        data=ft_preprocessing(cfg);
        ff(1:248,1:508,segi)=abs(fftBasic(data.trial{1,1},data.fsample));
        %     f50=f(:,50);
        %     fBL=mean(f(:,[25:49 51:99 101:125]),2);
        trig=Trig(cfg.trl(1):cfg.trl(2));
        lf=correctLF(data.trial{1,1},data.fsample,trig,'GLOBAL',50,4);
        close;
        ffcl(1:248,1:508,segi)=abs(fftBasic(lf,data.fsample));
        startSamp=startSamp+len(leni);
        disp(['LEN LEN LEN ',num2str(leni),' SEG SEG SEG ',num2str(segi)])
    end
    f(1:248,1:508,leni)=mean(ff,3);
    fcl(1:248,1:508,leni)=mean(ffcl,3);
    save(['ff',num2str(leni)],'ff','ffcl')
    clear ff*
end
% endsegs=20*1017.25/1000*[3500 17500 35000 175000];
% segi=4
% trig=Trig(1:endsegs(segi));
% for chani=1:248
%     cfg.channel=dummy.label{chani,1};
%     cfg.trl=[1,endsegs(segi),0];
%     %cfg.channel=['A',num2str(chani)];
%     data=ft_preprocessing(cfg);
%     f(chani,1:508,segi)=abs(fftBasic(data.trial{1,1},data.fsample));
%     f50(chani,segi)=f(chani,50,segi);
%     fBL(chani,segi)=mean(f(chani,[25:49 51:99 101:125],segi),2);
%     lf=correctLF(data.trial{1,1},data.fsample,trig,'GLOBAL',50);
%     close;
%     fcl(chani,1:508,segi)=abs(fftBasic(lf,data.fsample));
%     fcl50(chani,segi)=fcl(chani,50,segi);
%     ratio(chani,segi)=(fcl50(chani,segi)-fBL(chani,segi))./fBL(chani,segi);
%     disp(['SEG ',num2str(segi),' CHANNEL ',num2str(chani)])
% end
% save ratioGsize ratio fcl f fBL f50
f4=load('ratioGsize','f');f4=f4.f;f4=f4(:,:,4);
f4cl=load('ratioGsize','fcl');f4cl=f4cl.fcl;f4cl=f4cl(:,:,4);
%f4BL=load('ratioGsize','fBL');f4BL=f4BL.fBL;f4BL=f4BL(:,4);



rat=squeeze(mean(ratio));
ra=mean(rat,2);
sd=std(rat,[],2);
figure;plot(reps,ra)
hold on;plot(reps,ra+sd/sqrt(35),'k.')
