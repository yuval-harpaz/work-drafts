% reading the BRIK noise files and plotting a hist for each

[~, Vsvd,~,~] = BrikLoad ('svd_noise+orig');
vsvd=Vsvd(:);
vsvd=vsvd(vsvd>0);
[nsvd,xsvd] = hist(vsvd,100);
figure;hold on;bar(xsvd,nsvd);;

[~, Vcov,~,~] = BrikLoad ('cov_noise+orig');
vcov=Vcov(:);
vcov=vcov(vcov>0);
[ncov,xcov] = hist(vcov,100);
bar(xcov,ncov,'r');

[~, Vempty,~,~] = BrikLoad ('empty_noise+orig');
vempty=Vempty(:);
vempty=vempty(vempty>0);
[nempty,xempty] = hist(vempty,100);
bar(xempty,nempty,'g');

legend('svd','cov','empty');

figure;hold on; 
scatter(xsvd,nsvd,'.b');
scatter(xcov,ncov,'.r');
scatter(xempty,nempty,'.g');
legend('svd','cov','empty');
