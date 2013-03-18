function [domRT,domACC,subRT,subACC]=ambREbehav(subs)
conds={'dom','sub'};
for subi=subs
    sub=num2str(subi);
    display(sub)
    cd(['/home/yuval/Data/amb/',sub]);
    for condi=1:2
        cond=conds{condi};
        load (cond)
        trl=[];
        eval(['trl=',cond,'.cfg.previous{1,1}.previous.previous.trl;'])
        Resp=[];
        for trli=1:size(trl,1)
            %trl(trli,1)=str2num(markerFile{urLine+3+trli}(5:end));
            RS=trl(trli,5)+trl(trli,3)-trl(trli,1);
            Resp(trli,1)=trl(trli,5);
            Resp(trli,2)=trl(trli,6);
            Resp(trli,3:4)=0;
            if Resp(trli,2)==256
                if RS>50 && RS<2000
                    Resp(trli,3)=1;
                    Resp(trli,4)=1000*RS/1017.25;
                end
            end
        end
        rt=round(mean(Resp(find(Resp(:,4)>0),4)));
        eval([cond,'RT(subi)=rt;']);
        eval([cond,'ACC(subi)=mean(Resp(:,3));']);
    end
    
end
end
% behav=[DomACC',DomRT',SubACC',SubRT'];
% save /home/yuval/Data/amb/behav behav
