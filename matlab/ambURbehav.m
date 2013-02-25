function [DomRT,DomACC,SubRT,SubACC]=ambURbehav(subs)
conds={'Dom','Sub'};
for subi=subs
    sub=num2str(subi);
    display(sub)
    cd(['/home/yuval/Data/amb/',sub]);
    for condi=1:2
        cond=conds{condi};
        load ([cond,'UR'],'UR','Resp')
        rt=round(mean(Resp(find(Resp(:,4)>0),4)));
        eval([cond,'RT(subi)=rt;'])
        eval([cond,'ACC(subi)=mean(Resp(:,3));'])
    end
    
end
end
behav=[DomACC',DomRT',SubACC',SubRT'];
save /home/yuval/Data/amb/behav behav
