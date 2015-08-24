c=1;
for subi=1:40
    if subi==15
        Sub{c,1}=['char_',num2str(subi)];
    else
        Sub{c,1}=['Char_',num2str(subi)];
    end
    Sub{c,2}= ~mod(subi,2)+1;
    c=c+1;
end

%% Get timecourses and average power for each condition

trigVal=[202 204 220 230 240 250;202 204 240 230 220 250];
conds={'closed','open','charism','room','dull','silent'};
for subi=1:length(Sub)
    cd(Sub{subi,1})
    load timeCourse
    load data TRL
    cond=TRL(:,4);
    clear TRL
    if subi==1
        TimeCourse=timeCourse';
        Good=false(size(timeCourse))';
        Good(good)=true;
        Cond=cond';
    else
        TimeCourse(subi,:)=timeCourse;
        Good(subi,good)=true;
        Cond(subi,:)=cond;
    end
    for condi=1:6
        trli=find(Good(subi,:)'.*(cond==trigVal(Sub{subi,2},condi)));
        results(subi,condi)=mean(TimeCourse(subi,trli),2);
    end
    cd ../
end
% save results results
% save TimeCourse TimeCourse