function [r,R]=charJosh3

% c=1;
% for subi=1:40
%     if subi==15
%         Sub{c,1}=['char_',num2str(subi)];
%     else
%         Sub{c,1}=['Char_',num2str(subi)];
%     end
%     Sub{c,2}= ~mod(subi,2)+1;
%     c=c+1;
% end
%% make subject list
if exist('/media/My Passport/Hila&Rotem','dir')
    cd ('/media/My Passport/Hila&Rotem')
else
    [~,w]=unix('echo $USER');
    cd (['/media/',w(1:end-1),'/My Passport/Hila&Rotem'])
end

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

%% Calculate correlations between subjects
load TimeCourseGamma
load Sub40
load Good
load Cond

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
r=[];
for subi=1:size(R,1)
    ii=1:size(R,1);
    ii(subi)=[];
    r(subi,:)=squeeze(mean(R(ii,subi,:)));
end

%Check for significance
[~,p]=ttest(r(:,1),r(:,2));
pOpenClosed=p;
[~,p]=ttest(r(:,3),r(:,5));
pCharDull=p;

%Graph correlations
[~,~,ci]=ttest(r);
figure;
h=fill([1:6,6:-1:1]',[ci(1,1:end),ci(2,end:-1:1)]',0.9*[1 1 1]);
 set(h,'EdgeColor','None');
 hold on
 plot(mean(r))
 title({'GAMMA';'Significance of char vs. dull = ';pCharDull})
 legend('confidence interval','mean correlation')
 xlim([0 7])
 ylabel ('mean r')
 set(gca,'XTick',1:6);
set(gca,'XTickLabel',conds);


%% Power comparison

load resultsGamma

%Check for significance
boring=mean([results(:,2),results(:,4),results(:,5),results(:,6)],2);
[~,p]=ttest(boring,results(:,1));
pClosedboring=p;
[~,p]=ttest(boring,results(:,3));
pCharboring=p;
[~,p]=ttest(results(:,3),results(:,5));
pChardull=p;


bars=squeeze(mean(results,1));
err=std(results)./sqrt(40);
figure, hold all;
bar(bars,'w');
errorbar(bars,err,'k','linestyle','none')
bar(bars,'w');
bar(1,bars(1),'b');
bar(3,bars(3),'r');
title({'MEAN GAMMA';'Significance of char vs. dull = ';pChardull})
set(gca,'XTick',1:6);
set(gca,'XTickLabel',conds);