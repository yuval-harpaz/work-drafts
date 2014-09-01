function LF3_b
%% random numbers
sRate=1017.23;
sRates=[sRate*2/3 sRate sRate*2];
reps=[100 500 1000 1500 2000 2500 3000 3500 4000 4500];
neg=[];
ratio=[];
% for perm=1:100
%     for i=1:10
%         disp('')
%     end
%     for i=1:10
%         disp(['PERM ',num2str(perm)])
%     end
%     for i=1:10
%         disp('')
%     end
try
    matlabtool;
end
cfg=[];
cfg.Lfreq=50;
cfg.jobs=4;
repCount=0;
permN=500;
progress=0;
for repi=1:length(reps)
    repCount=repCount+1;
    cfg.Ncycle=reps(repCount);
    
    rateCount=0;
    
    for ratei=1:length(sRates)
        progress=progress+1;
        disp([num2str(progress),' of 30'])
        rateCount=rateCount+1;
        data=rand(permN,round(100*sRates(ratei)));
        data=data-0.5;
        lf=correctLF(data,sRates(ratei),'time',cfg);
        close;
        f=abs(fftBasic(data,sRates(ratei)));
        fcl=abs(fftBasic(lf,sRates(ratei)));
        % figure;
        % plot(mean(f));hold on;plot(mean(fcl),'r')
        %lfBL=mean(fcl(:,[1:49 51:99]),2);
        fcl50=fcl(:,50);
        f50=f(:,50);
        ratio(rateCount,repCount,1:permN)=(fcl50-f50)./f50;
        % [~,p,~,stat]=ttest(f(:,50),fcl(:,50))
        %             [~,p,~,stat]=ttest(f50,fcl50)
        %             if p<0.1 && stat.tstat>0 % clean lower than raw
        %                 neg(rateCount,repCount)=true;
        %             else
        %                 neg(rateCount,repCount)=false;
        %             end
        
    end
end
cd /home/yuval/Dropbox/LF/data
save ratioYH2 ratio reps
% clear data
% C=[];
% for sRatei=1:length(sRates)
%     for repi=1:length(reps)
%         [~,~,c]=ttest(squeeze(ratio(sRatei,repi,:)),[],[],'left');
%         C(sRatei,repi)=c(2);
%     end
% end
% M=squeeze(mean(ratio,3));
% Min=min(M);
% x =  [reps,fliplr(reps)];
% %y =  [M(1,:),fliplr(C(1,:))];
% y =  [M,fliplr(C)];
%
% figure;
% line(reps,M)
% hold on
% fill(x,y,[.9 .9 .9],'linestyle','none')
% legend('s-rate 508','s-rate 678','s-rate 1017','s-rate 2035','confidence intervals')
% line(reps,M)
% xlim([100 4500])
%
%
%
% figure;plot(f(1,:),'r');hold on;plot(fcl(1,:),'g')
% ylim([0 2])
% xlim([40 110])
% title ('abs(fourier) for random numbers, ONE CHANNEL')
% figure;plot(mean(f),'r');hold on;plot(mean(fcl),'g')
% ylim([0 2])
% xlim([40 110])
% title ('abs(fourier) for random numbers, averaged over 100 CHANNELS')
% legend(num2str(sRates'))
%plot(reps,mean(squeeze(ratio(1,:,:)),2)+std(squeeze(ratio(1,:,:))')'./10,'r.')