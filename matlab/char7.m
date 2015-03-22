function [r,R]=char7


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

    cd ../
end
for condi=1:6
    for subi=1:length(Sub)
        for subj=1:length(Sub)
            i0=find(Cond(subi,:)==trigVal(Sub{subi,2},condi),1);
            i1=find(Cond(subi,:)==trigVal(Sub{subi,2},condi),1,'last');
            trli=Good(subi,:).*(Cond(subi,:)==trigVal(Sub{subi,2},condi));
            trlk=trli(i0:i1);
            j0=find(Cond(subj,:)==trigVal(Sub{subj,2},condi),1);
            j1=find(Cond(subj,:)==trigVal(Sub{subj,2},condi),1,'last');
            trlj=Good(subj,:).*(Cond(subj,:)==trigVal(Sub{subj,2},condi));
            trlk=trlk.*trlj(j0:j1);
            datai=TimeCourse(subi,i0-1+find(trlk));
            dataj=TimeCourse(subj,j0-1+find(trlk));
            R(subi,subj,condi)=corrFast(datai',dataj');
        end
    end
end
for subi=1:size(R,1)
    ii=1:size(R,1);
    ii(subi)=[];
    r(subi,:)=squeeze(mean(R(ii,subi,:)));
end
[~,~,ci]=ttest(r);
figure;
h=fill([1:6,6:-1:1]',[ci(1,1:end),ci(2,end:-1:1)]',0.9*[1 1 1]);
 set(h,'EdgeColor','None');
 hold on
 plot(mean(r))
 legend('confidence interval','mean correlation')
 xlim([0 7])
 xlabel ('condition')
 ylabel ('mean r')
 
[~,p]= ttest(r(:,3),r(:,5))