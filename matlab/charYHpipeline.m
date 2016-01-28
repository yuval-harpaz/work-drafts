%% averaged power over time
powMed=charYH2('max','max');
load('/media/yuval/YuvalExtDrive/Data/Hilla_Rotem/powMed_max_max.mat')
charYHbars(powMed);

%% timecourse, sensor space
R=charYH13('max','max');
% audio
[R,P]=charYH4('max', 'max', 1, false);
% concatenated
charYH14(300);
%% SAM
charYHtlrc
% make Brik time series
charYH5;
% make Brik R per subject
charYH6;
% ttest one cond
charYH7('closed','Delta')
% permutations one condition
charYH8
% permutations 2 conditions
charYH9
% correlate each subject with the audio
charYH10;
% permutations
charYH11
% average subject R
charYH12


%% improve r, sensor level
powMed=charYH2('sum','sum');
R=charYH13('sum','sum');
[R,P]=charYH4('sum', 'sum', 1, false);

%% average power, source level
charYH15

%% local correlation
V=BrikLoad('/media/yuval/YuvalExtDrive/Data/Hilla_Rotem/charisma_dull_Beta_R_TT+tlrc');
V=V(:,:,:,1);
% 2 18 15
[~,zi]=max(max(max(V)));
[~,yi]=max(max(max(V,[],3)));
[~,xi]=max(max(max(V,[],3),[],2));
for subi=1:40
    V=BrikLoad(['/media/yuval/YuvalExtDrive/Data/Hilla_Rotem/Char_',num2str(subi),'/YH/charisma_Beta+tlrc']);
    vectors(subi,1:size(V,4))=V(xi,yi,zi,:);
    prog(subi)
end
Vectors=vectors;
medians=median(Vectors,2);
for subi=1:40
    vectors(subi,Vectors(subi,:)>3*medians(subi))=nan;
end
r=corr(vectors','rows','pairwise');
r(logical(eye(40)))=nan;
rr=mean(nanmean(r));

rseg=[];
win=8;
startSamp=1:win/2:(length(vectors)-win);
for segi=1:length(startSamp)
    r=corr(vectors(:,startSamp(segi):startSamp(segi)+win-1)','rows','pairwise');
    r(logical(eye(40)))=nan;
    rseg(segi)=nanmean(nanmean(r));
end
[maxr,maxi]=nanmax(rseg)
figure;
plot(vectors','k')
hold on
plot(startSamp(maxi):startSamp(maxi)+win-1,vectors(:,startSamp(maxi):startSamp(maxi)+win-1)')
plot(nanmean(vectors),'y')
title(['r = ',num2str(maxr)])


% Gamma
V=BrikLoad('/media/yuval/YuvalExtDrive/Data/Hilla_Rotem/charisma_dull_Gamma_R_TT+tlrc');
V=V(:,:,:,1);
% 2 18 15
[~,zi]=max(max(max(V)));
[~,yi]=max(max(max(V,[],3)));
[~,xi]=max(max(max(V,[],3),[],2));
for subi=1:40
    V=BrikLoad(['/media/yuval/YuvalExtDrive/Data/Hilla_Rotem/Char_',num2str(subi),'/YH/charisma_Gamma+tlrc']);
    vectors(subi,1:size(V,4))=V(xi,yi,zi,:);
    prog(subi)
end
Vectors=vectors;
medians=median(Vectors,2);
for subi=1:40
    vectors(subi,Vectors(subi,:)>3*medians(subi))=nan;
end
r=corr(vectors','rows','pairwise');
r(logical(eye(40)))=nan;
rr=mean(nanmean(r));

rseg=[];
win=30;
startSamp=1:win/2:(length(vectors)-win);
for segi=1:length(startSamp)
    r=corr(vectors(:,startSamp(segi):startSamp(segi)+win-1)','rows','pairwise');
    r(logical(eye(40)))=nan;
    rseg(segi)=nanmean(nanmean(r));
end
[maxr,maxi]=nanmax(rseg)
figure;
plot(vectors','k')
hold on
plot(startSamp(maxi):startSamp(maxi)+win-1,vectors(:,startSamp(maxi):startSamp(maxi)+win-1)')
plot(nanmean(vectors),'y')
title(['r = ',num2str(maxr)])