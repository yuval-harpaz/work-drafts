function char6


%% make subject list
if exist('/media/My Passport/Hila&Rotem','dir')
    cd ('/media/My Passport/Hila&Rotem')
else
    [~,w]=unix('echo $USER');
    cd (['/media/',w(1:end-1),'/My Passport/Hila&Rotem'])
end
load SubOrder19
% load Char_1/data TRL
% cond=TRL(:,4);
% clear TRL
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

% figure;
% plot(results,'.')
% legend(conds)

%[~,p]=ttest(results(:,1),results(:,2))
% xlabel('SUBJECT')
% ylabel('ALPHA per Second')
PSC=zeros(size(results));
for condi=[1 3 4 5 6]
    PSC(:,condi)=100*(results(:,condi)-results(:,2))./results(:,2);
end
figure;
plot(PSC,'.')
legend(conds)
xlabel('SUBJECT')
ylabel('percent signal change')
[~,p]=ttest(PSC)
%[~,p]=ttest(results(:,3),results(:,5))
[~,p]=ttest(PSC(:,3),PSC(:,5))