% for subi=1:length(Sub)
%     subn=Sub{subi,1};
%     copyfile(['/media/My Passport/Hila&Rotem/',subn,'/Fr*'],['/home/meg/Hilla_Rotem/',subn])
% end

trigVal=[202 204 220 230 240 250;202 204 240 230 220 250];
conds={'closed','open','charisma','room','dull','silent'};
load Sub40

lowFreq=1:7;
alphaFreq=8:12;
betaFreq=13:24;
gammaFreq=25:40;

for band=1:4
    
    switch band
        case 1
            bandFreq=lowFreq;
            Four='FrLow.mat';
        case 2
            bandFreq=alphaFreq;
            Four='Fr.mat';
        case 3
            bandFreq=betaFreq;
            Four='FrBeta.mat';
        case 4
            bandFreq=gammaFreq;
            Four='FrGamma.mat';
    end
    
    dataBand=zeros(40,6,5,302,248);
    for freq=1:length(bandFreq)
        for subi=1:length(Sub)
            cd(Sub{subi,1})
            load(Four)
            cond=TRL(:,4);
            clear TRL
            if subi==1
                Good=zeros(40,1674);
                Good(subi,good)=1;
                Cond=cond';
            else
                Cond(subi,:)=cond;
                Good(subi,good)=1;
            end
            for chan=1:248
                datai(:,chan)=Fr.powspctrm(:,chan,freq).*Good(subi,:)';
            end
            for condi=1:6
                i0=find(Cond(subi,:)==trigVal(Sub{subi,2},condi),1);
                i1=find(Cond(subi,:)==trigVal(Sub{subi,2},condi),1,'last');
                %trli=Good(subi,:).*(Cond(subi,:)==trigVal(Sub{subi,2},condi));
                %trlk=trli(i0:i1);
                %datai=Fr.powspctrm(i0-1+find(trlk),:,freq);
                %dataBand(subi,condi,freq,1:size(datai,1),:)=datai;
                dataBand(subi,condi,freq,1:length(i0:i1),:)=datai(i0:i1,:);
            end
            clear datai
            cd ../
            disp([Sub{subi,1},' complete']);
        end
        disp(['Frequency ',num2str(bandFreq(freq)),' processed']);
    end
    dataBand(dataBand==0)=NaN;
%     dataBandavg=squeeze(nanmean(dataBand,4));
%     for subi=1:40
%         for condi=1:6
%             for chan=1:248
%                 [maxval,maxi]=max(dataBandavg(subi,condi,:,chan));
%                 dataBandmaxval(subi,condi,chan)=maxval;
%                 dataBandmaxi(subi,condi,chan)=maxi;
%             end
%         end
%     end
%     dataBandmaxi=bandFreq(dataBandmaxi);

    switch band
        case 1
            dataL=dataBand;
%             dataLavg=dataBandavg;
%             dataLmaxval=dataBandmaxval;
%             dataLmaxi=dataBandmaxi;
        case 2
            dataA=dataBand;
%             dataAavg=dataBandavg;
%             dataAmaxval=dataBandmaxval;
%             dataAmaxi=dataBandmaxi;
        case 3
            dataB=dataBand;
%             dataBavg=dataBandavg;
%             dataBmaxval=dataBandmaxval;
%             dataBmaxi=dataBandmaxi;
        case 4
            dataG=dataBand;
%             dataGavg=dataBandavg;
%             dataGmaxval=dataBandmaxval;
%             dataGmaxi=dataBandmaxi;
    end
    clear dataBand %dataBandavg dataBandmaxval dataBandmaxi
end

%save dataT dataT dataTavg dataTmaxval dataTmaxi dataTord