subj='Char_40';
load Fr TRL good
counter=1;
takeit=true;
for trli=1:length(TRL)
    if takeit
        trl(counter,1:4)=TRL(trli,1:4);
        takeit=false;
        if trli~=length(TRL)
            if TRL(trli+1,4)~=TRL(trli,4)
                takeit=true;
            end
        end
        counter=counter+1;
    else
        takeit=true;
    end
end

[goo]=ismember(trl(:,1),TRL(good,1));
trl=trl(goo,:);
Trig2mark('All',[trl(:,1)/1017.25]');
fitMRI2hs
hs2afni
copyfile('/home/meg/SAM_BIU/docs/SuDi0812.rtw',['./',subj,'.rtw'])
afni %NUDGING
cd ..
unix(['SAMcov64 -r ',subj,' -d hb,xc,lf_c,rfhp0.1Hz -m SPMall -v'])
unix(['SAMwts64 -r ',subj,' -d hb,xc,lf_c,rfhp0.1Hz -m SPMall -c Alla -v'])
