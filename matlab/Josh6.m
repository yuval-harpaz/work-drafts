%Correlations over entire video course
for condi=1:6
    R=[];
    R=corr(squeeze(datafix(1:condlength(condi),[1:36,38:40],condi)),'rows','pairwise');
    r=[];
    for subi=1:size(R,1)
        ii=1:size(R,1);
        ii(subi)=[];
        r(subi,:)=squeeze(mean(R(ii,subi,:)));
    end
    rtot(:,condi)=squeeze(r);
end

%Correlations over video without first 20 time blocks
for condi=1:6
    R=[];
    R=corr(squeeze(datafix(100:condlength(condi)-4,[1:36,38:40],condi)),'rows','pairwise');
    r=[];
    for subi=1:size(R,1)
        ii=1:size(R,1);
        ii(subi)=[];
        r(subi,:)=squeeze(mean(R(ii,subi,:)));
    end
    rpart(:,condi)=squeeze(r);
end
[~,p]=ttest2(rtot(:,1),rpart(:,1))
[~,p]=ttest2(rtot(:,2),rpart(:,2))
[~,p]=ttest2(rtot(:,3),rpart(:,3))
[~,p]=ttest2(rtot(:,4),rpart(:,4))
[~,p]=ttest2(rtot(:,5),rpart(:,5))
[~,p]=ttest2(rtot(:,6),rpart(:,6))