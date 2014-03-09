%% make average image of last 15 seconds (ictal onset)
cd /home/yuval/Data/epilepsy/b162b/1
[V,info]=BrikLoad('91s+orig');
cd /home/yuval/Data/epilepsy/b022/Movies
adapt1=BrikLoad('b162b_adapt1+orig');
adapt1=mean(adapt1(:,:,:,31:end),4);
OptTSOut.Prefix = 'adapt1Avg';
OptTSOut.Scale = 1;
OptTSOut.verbose = 1;
WriteBrik (adapt1, info,OptTSOut);
adapt2=BrikLoad('adapt2+orig');
adapt2=mean(adapt2(:,:,:,31:end),4);
OptTSOut.Prefix = 'adapt2Avg';
WriteBrik (adapt2, info,OptTSOut);
adapt3=BrikLoad('adapt3+orig');
adapt3=mean(adapt3(:,:,:,31:end),4);
OptTSOut.Prefix = 'adapt3Avg';
WriteBrik (adapt3, info,OptTSOut);
cd /home/yuval/Data/epilepsy/b022/ictus
g2_1=BrikLoad('g2ictus+orig');
g2_1=mean(g2_1(:,:,:,31:end),4);
OptTSOut.Prefix = 'g2_1Avg';
OptTSOut.Scale = 1;
OptTSOut.verbose = 1;
WriteBrik (g2_1, info,OptTSOut);

cd /home/yuval/Data/epilepsy/b162b/1
g2_1=BrikLoad('g21+orig');
g2_1=mean(g2_1(:,:,:,31:end),4);
OptTSOut.Prefix = 'g2_1Avg';
WriteBrik (g2_1, info,OptTSOut);

all1=BrikLoad('b162b_all1+orig');
all1=mean(all1(:,:,:,31:end),4);
OptTSOut.Prefix = 'all1Avg';
WriteBrik (all1, info,OptTSOut);
all2=BrikLoad('all2+orig');
all2=mean(all2(:,:,:,31:end),4);
OptTSOut.Prefix = 'all2Avg';
WriteBrik (all2, info,OptTSOut);
all3=BrikLoad('all3+orig');
all3=mean(all3(:,:,:,31:end),4);
OptTSOut.Prefix = 'all3Avg';
WriteBrik (all3, info,OptTSOut);

%% check max distance

!3dExtrema -volume -closure all3Avg+orig
 glob=[5.00     45.00     75.00;25.00     35.00     80.00;35.00     35.00     75.00];
 adap=[30.00     40.00     80.00; 30.00     35.00     75.00;25.00     35.00     75.00];
 
 % check max 10vox overlap, a for adaptive
[~,a1]=sort(adapt1(:),'descend');
a1=a1(1:10);
 [~,a2]=sort(adapt2(:),'descend');
a2=a2(1:10);
 [~,a3]=sort(adapt3(:),'descend');
a3=a3(1:10);
ol=sum(ismember(a1,a2)); % 4
ol=sum(ismember(a2,a3)); % 6
ol=sum(ismember(a1,a3)); % 7
sum(ismember(a1(ismember(a1,a2)),a3)) % 4
[~,ind]=ismember(a1,a2);
ind=a1(ind(ind>0)); %vox ind [35593;35544;35641;37453;]
common=zeros(size(adapt1(:)));
common(ind)=1;
C = reshape(common,49,37,35);
OptTSOut.Prefix = 'common';
WriteBrik (C, info,OptTSOut);
%g for global
[~,g1]=sort(all1(:),'descend');
g1=g1(1:10);
 [~,g2]=sort(all2(:),'descend');
g2=g2(1:10);
 [~,g3]=sort(all3(:),'descend');
g3=g3(1:10);
ol=sum(ismember(g1,g2)); % 0
ol=sum(ismember(g2,g3)); % 1, vox ind 37454
ol=sum(ismember(g1,g3)); % 0
%% SNR
% adaptive
vec=adapt1(:);
[A1,a1]=sort(vec,'descend');
a1=a1(1:10);A1=A1(1:10);
vec(a1)=0;
vec=vec(vec>0);
a1SNR=median(A1)/median(vec);
vec=adapt2(:);
[A2,a2]=sort(vec,'descend');
a2=a2(1:10);A2=A2(1:10);
vec(a2)=0;
vec=vec(vec>0);
a2SNR=median(A2)/median(vec);
vec=adapt3(:);
[A3,a3]=sort(vec,'descend');
a3=a3(1:10);A3=A3(1:10);
vec(a3)=0;
vec=vec(vec>0);
a3SNR=median(A3)/median(vec);
% global
vec=all1(:);
[A1,a1]=sort(vec,'descend');
a1=a1(1:10);A1=A1(1:10);
vec(a1)=0;
vec=vec(vec>0);
g1SNR=median(A1)/median(vec);
vec=all2(:);
[A2,a2]=sort(vec,'descend');
a2=a2(1:10);A2=A2(1:10);
vec(a2)=0;
vec=vec(vec>0);
g2SNR=median(A2)/median(vec);
vec=all3(:);
[A3,a3]=sort(vec,'descend');
a3=a3(1:10);A3=A3(1:10);
vec(a3)=0;
vec=vec(vec>0);
g3SNR=median(A3)/median(vec);
% seg
vec=seg1(:);
[A1,a1]=sort(vec,'descend');
a1=a1(1:10);A1=A1(1:10);
vec(a1)=0;
vec=vec(vec>0);
s1SNR=median(A1)/median(vec);
vec=seg2(:);
[A2,a2]=sort(vec,'descend');
a2=a2(1:10);A2=A2(1:10);
vec(a2)=0;
vec=vec(vec>0);
s2SNR=median(A2)/median(vec);
vec=seg3(:);
[A3,a3]=sort(vec,'descend');
a3=a3(1:10);A3=A3(1:10);
vec(a3)=0;
vec=vec(vec>0);
s3SNR=median(A3)/median(vec);
%% seg1
seg1=BrikLoad('b162b_seg1+orig');
seg1=mean(seg1(:,:,:,31:end),4);
OptTSOut.Prefix = 'seg1Avg';
WriteBrik (seg1, info,OptTSOut); % max at 20.00     35.00     80.00 
!3dExtrema -volume -closure seg1Avg+orig
seg2=BrikLoad('b162b_seg2+orig');
seg2=mean(seg2(:,:,:,31:end),4);
OptTSOut.Prefix = 'seg2Avg';
WriteBrik (seg2, info,OptTSOut); % 20.00     35.00     75.00
seg3=BrikLoad('b162b_seg3+orig');
seg3=mean(seg3(:,:,:,31:end),4);
OptTSOut.Prefix = 'seg3Avg';
WriteBrik (seg3, info,OptTSOut); % 

%% b022
cd /home/yuval/Data/epilepsy/b022/ictus
[V,info]=BrikLoad('33s+orig');
cd /home/yuval/Data/epilepsy/b022/Movies
adapt1=BrikLoad('b022_adapt1+orig');
adapt1=mean(adapt1(:,:,:,31:end),4);
OptTSOut.Prefix = 'b022_adapt1Avg';
OptTSOut.Scale = 1;
OptTSOut.verbose = 1;
WriteBrik (adapt1, info,OptTSOut);
all1=BrikLoad('b022_all1+orig');
all1=mean(all1(:,:,:,31:end),4);
OptTSOut.Prefix = 'b022_all1Avg';
WriteBrik (all1, info,OptTSOut);
seg1=BrikLoad('b022_seg1+orig');
seg1=mean(seg1(:,:,:,31:end),4);
OptTSOut.Prefix = 'b022_seg1Avg';
WriteBrik (seg1, info,OptTSOut); 