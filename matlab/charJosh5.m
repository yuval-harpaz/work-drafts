%% Moving Mean

load TimeCourseGamma
load Good
load Cond
load Sub40

for subi=1:length(Sub)
    datai(subi,:)=TimeCourse(subi,:).*Good(subi,:);
end
movAvgCond=zeros(40,49,5);
for condi=[3,5]
    condCourse=zeros(40,302);
    goodCond=zeros(40,302);
    for subi=1:length(Sub)
        i0(subi)=find(Cond(subi,:)==trigVal(Sub{subi,2},condi),1);
        i1(subi)=find(Cond(subi,:)==trigVal(Sub{subi,2},condi),1,'last');
        condCourse(subi,1:length(datai(subi,i0(subi):i1(subi))))=datai(subi,i0(subi):i1(subi));
        goodCond(subi,1:length(Good(subi,i0(subi):i1(subi))))=Good(subi,i0(subi):i1(subi));
        for tscale=1:floor((i1(subi)-i0(subi)-8)/5+1)
            tstart=1+5*(tscale-1);
            movAvgCond(subi,tscale,condi)=sum(condCourse(subi,tstart:(tstart+9)))/sum(goodCond(subi,tstart:(tstart+9)));
        end
    end
    movAvg(condi,:)=nansum(movAvgCond(:,:,condi))./(sum(movAvgCond(:,:,condi)~=0)-sum(isnan(movAvgCond(:,:,condi))));
end
movAvgCond(:,:,[1:2,4])=[];
movAvg([1:2,4],:)=[];

%Correlation testing on smoothed data
movAvgCond(movAvgCond==0)=NaN;
R=[];
R(:,:,1)=corr(movAvgCond(:,:,1)','rows','pairwise');
R(:,:,2)=corr(movAvgCond(:,:,2)','rows','pairwise');
r=[];
for subi=1:size(R,1)
    ii=1:size(R,1);
    ii(subi)=[];
    r(subi,:)=squeeze(mean(R(ii,subi,:)));
end
mean(r)
% figure;plot(r)
% legend('charisma','dull')
% title('BETA CORR')

%Check correlation difference for significance
[~,p]=ttest(r(:,1),r(:,2));

%Plot smoothed graph
timescale=[1:length(movAvg(1,:))].*2.5;
figure;
plot(timescale,movAvg(1,:))
%plot(movAvg(1,:))
hold on
plot(timescale,movAvg(2,:),'r')
%plot(movAvg(2,:),'r')
legend('charisma','dull')
title({'SMOOTHED GAMMA (MEAN)';'Significance of corr. char vs. dull = ';p})



%% Moving Median

movMedCond=zeros(40,49,5);
for condi=[3,5]
    condCourse=zeros(40,302);
    goodCond=zeros(40,302);
    for subi=1:length(Sub)
        i0(subi)=find(Cond(subi,:)==trigVal(Sub{subi,2},condi),1);
        i1(subi)=find(Cond(subi,:)==trigVal(Sub{subi,2},condi),1,'last');
        condCourse(subi,1:length(datai(subi,i0(subi):i1(subi))))=datai(subi,i0(subi):i1(subi));
        goodCond(subi,1:length(Good(subi,i0(subi):i1(subi))))=Good(subi,i0(subi):i1(subi));
        for tscale=1:floor((i1(subi)-i0(subi)-8)/5+1)
            tstart=tscale+5*(tscale-1);
            movMedCond(subi,tscale,condi)=median(condCourse(subi,tstart:(tstart+9)));
        end    
    end
    movMed(condi,:)=sum(movMedCond(:,:,condi))./sum(movMedCond(:,:,condi)~=0);
end
movMedCond(:,:,[1:2,4])=[];
movMed([1:2,4],:)=[];

%Correlation testing on smoothed data
movMedCond(movMedCond==0)=NaN;
R=[];
R(:,:,1)=corr(movMedCond(:,:,1)','rows','pairwise');
R(:,:,2)=corr(movMedCond(:,:,2)','rows','pairwise');
r=[];
for subi=1:size(R,1)
    ii=1:size(R,1);
    ii(subi)=[];
    r(subi,:)=squeeze(mean(R(ii,subi,:)));
end
mean(r)
% figure;plot(r)
% legend('charisma','dull')
% title('BETA CORR')

%Check correlation difference for significance
[~,p]=ttest(r(:,1),r(:,2));

%Plot smoothed graph
figure;
plot(movMed(1,:))
hold on
plot(movMed(2,:),'r')
legend('charisma','dull')
title({'SMOOTHED BETA (MEDIAN)';'Significance of corr. char vs. dull = ';p})