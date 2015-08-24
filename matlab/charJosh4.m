%% Take weighted average of power over all subjects

load Sub40
load TimeCourseGamma %change for different bands
load Good
load Cond
for subi=1:length(Sub)
        datai(subi,:)=TimeCourse(subi,:).*Good(subi,:);
end
condCourse=zeros(40,302,6);
for condi=1:6
    goodCond=zeros(40,302);
    for subi=1:length(Sub)
        i0(subi)=find(Cond(subi,:)==trigVal(Sub{subi,2},condi),1);
        i1(subi)=find(Cond(subi,:)==trigVal(Sub{subi,2},condi),1,'last');
        condCourse(subi,1:length(datai(subi,i0(subi):i1(subi))),condi)=datai(subi,i0(subi):i1(subi));
        goodCond(subi,1:length(Good(subi,i0(subi):i1(subi))))=Good(subi,i0(subi):i1(subi));
    end
    wAvg(condi,:)=squeeze(sum(condCourse(:,:,condi))./sum(goodCond));
end
condCourse(:,:,[1:2,4,6])=[];
wAvg([1:2,4,6],:)=[];

% figure;
% colors=['kcbgry'];
% for condi=1:6
%     plot(wAvg(condi,:),colors(condi))
%     hold on
% end
% legend(conds)
% title('BETA') %change for different bands

figure;
plot(wAvg(1,:))
hold on
plot(wAvg(2,:),'r')
legend('charisma','dull')
title('GAMMA POWER')



% R=zeros(40,40,242,1);
% for condi=1:2
%     for secTime=1:242
%         for subi=1:40
%             for subj=1:40
%                 R(subi,subj,secTime,condi)=corrFast(condCourse(subi,secTime:secTime+1,condi)',condCourse(subj,secTime:secTime+1,condi)');
%             end
%         end
%     end
% end

%% Recheck correlation between subjects (SHOULD BE SAME AS BEFORE)
condCourse(condCourse==0)=NaN;
R=[];
for condi=1:6
    R(:,:,condi)=corr(condCourse(:,:,condi)','rows','pairwise');
end
r=[];
for subi=1:size(R,1)
    ii=1:size(R,1);
    ii(subi)=[];
    r(subi,:)=squeeze(mean(R(ii,subi,:)));
end

% figure;plot(squeeze(mean(r)))
% title('alpha correlations over time')
% 
% corrFast(wAvg(condi,1:242)',squeeze(mean(abs(r)))')


%% Compare beta and gamma power
betabase=squeeze(mean(wAvg(5,1:30)));
adjBeta(1,:)=(wAvg(5,:)-betabase)/betabase;
gammabase=squeeze(mean(wAvgGamma(5,1:30)));
adjGamma(1,:)=(wAvgGamma(5,:)-gammabase)/gammabase;

figure;
plot(adjBeta);
hold on
plot(adjGamma,'r');
legend('beta','gamma')