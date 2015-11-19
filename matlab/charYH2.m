function powMed=charYH2(freqMethod, chanMethod)
% chanMethod='max'; % 'mean' 'min'
% freqMethod = 'max'; % 'mean'
bands={'Delta','Theta','Alpha','Beta','Gamma'};
freqs=[1,4;4,8;8,13;13,25;25,40];
trigVal=[202 204 220 230 240 250;202 204 240 230 220 250];
conds={'closed','open','charisma','room','dull','silent'};
cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem

%% average power per condition per band    
for subi=1:40
    cd (['Char_',num2str(subi)])
    load FrYH
    oddEven=subi-ceil(subi/2)*2+2;
    TRL=[];
    try
        load Fr TRL good
    catch
        load data TRL good
    end
    for condi=1:6
        trli=TRL(:,4)==trigVal(oddEven,condi);
        for bandi=1:5
            data=abs(Fr(:,trli,freqs(bandi,1):freqs(bandi,2)));
            switch freqMethod
                case 'max'
                    pow=max(data,[],3);
            end
            switch chanMethod
                case 'max'
                    pow=max(pow,[],1);
            end
            if ~exist('YH','dir')
                mkdir YH
            end
            %load(['YH/',conds{condi},'_',bands{bandi},'_',freqMethod,'_',chanMethod])
            powMed(subi,condi,bandi)=median(pow);
            save(['YH/',conds{condi},'_',bands{bandi},'_',freqMethod,'_',chanMethod],'pow')
        end
    end
    save YH/TRL TRL
    save YH/good good
    cd ../
    disp(['DONE SUB ',num2str(subi)])
end
save (['powMed_',freqMethod,'_',chanMethod], 'powMed')
