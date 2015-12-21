function [R,P]=charYH4(chanMethod, freqMethod, start, lots)
% chanMethod='max'; % 'mean' 'min'
% freqMethod = 'max'; % 'mean'
% start = 5; at which sample to start (5 = 2.5s)
% lots =true; for lots of figures;
if ~exist('lots','var')
    lots=false;
end
if ~existAndFull('start')
    start=1;
end
bands={'Delta','Theta','Alpha','Beta','Gamma'};
freqs=[1,4;4,8;8,13;13,25;25,40];
trigVal=[202 204 220 230 240 250;202 204 240 230 220 250];
conds={'closed','open','charisma','room','dull','silent'};
cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem
[charAud,sRate]=wavread('char.wav');
charAud=max(abs(charAud'));
wini=1;
for timei=1:sRate/2:length(charAud)
    try % fails in the end
        audioChar(wini)=mean(charAud(timei:timei+sRate));
        wini=wini+1;
    end
end
[dullAud,sRate]=wavread('dull.wav');
dullAud=max(abs(dullAud'));
wini=1;
for timei=1:sRate/2:length(dullAud)
    try % fails in the end
        audioDull(wini)=mean(dullAud(timei:timei+sRate));
        wini=wini+1;
    end
end
%% average power per condition per band    

for condi=[3,5]
    for bandi=1:5
        for subi=1:40
            load(['Char_',num2str(subi),'/YH/',conds{condi},'_',bands{bandi},'_',freqMethod,'_',chanMethod])
            if subi==1
                Pow=nan(40,size(pow,2));
            end
%             Pow(subi,:)=pow;
%             PowNan=Pow;
%             PowNan(Pow>(median(Pow(:))*4))=nan;
            PowNan=pow;
            PowNan(pow>(median(pow)*4))=nan;
            Pow(subi,:)=PowNan;
%             figure;
%             plot(Pow')
%             hold on
%             plot(PowNan','k')
%             line([1,243],[median(Pow(:))*4,median(Pow(:))*4],'color','m')
        end
        PowAvg=nanmean(Pow);
        PowAvg=PowAvg(start:end);
        if condi==3
            aud=audioChar(start:end);
        else
            aud=audioDull(start:end);
        end
        [R(condi,bandi),P(condi,bandi)]=corr(PowAvg(1:length(aud))',aud');
        if lots
            figure;
            plot((PowAvg-min(PowAvg))./(max(PowAvg)-min(PowAvg)),'k');
            hold on;
            plot((aud-min(aud))./(max(aud)-min(aud)),'g')
            legend(bands{bandi},'Audio')
            title({conds{condi},['p = ',num2str(P(condi,bandi)),' R = ',num2str(R(condi,bandi))]})
            pause;
        end
        
    end
end
%save (['R_',freqMethod,'_',chanMethod], 'R')
figure;
plot([1:5],R(3,:),'sb')
hold on
plot([1:5],R(5,:),'or')
xlim([0,6])
plot(1.15,R(3,1),'*k')
legend('Charisma','Dull','Sig')
plot(1.15,R(3,1),'*w')
sig=find(P(3,:)<0.05);
if ~ isempty(sig)
    plot(sig+0.15,R(3,sig),'*k')
end
sig=find(P(5,:)<0.05);
if ~ isempty(sig)
    plot(sig+0.15,R(5,sig),'*k')
end
set(gca,'XTick',1:5);
set(gca,'XTickLabel',bands);
ylabel('correlation (r)')
title('Correlation with Audio')
