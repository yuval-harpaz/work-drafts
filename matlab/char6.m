function char6


%% make subject list
if exist('/media/My Passport/Hila&Rotem')
    cd ('/media/My Passport/Hila&Rotem')
else
    [~,w]=unix('echo $USER');
    cd (['/media/',w(1:end-1),'/My Passport/Hila&Rotem'])
end
load Sub
load Char_1/data TRL
cond=TRL(:,4);
clear TRL
for subi=1:length(Sub)
    cd(Sub{subi})
    load timeCourse
    if subi==1
        TimeCourse=timeCourse';
    else
        TimeCourse(subi,:)=timeCourse;
    end
    cd ../
end
trigVal=[202 204 220 230 240 250];
conds={'closed','open','charism','room','dull','silent'};
for condi=1:6
    trli=find(cond==trigVal(condi));
    results(1:size(TimeCourse,1),condi)=mean(TimeCourse(:,trli),2);
end
plot(results,'.')
legend(conds)

[~,p]=ttest(results(:,1),results(:,2))
xlabel('SUBJECT')
ylabel('ALPHA per Second')
