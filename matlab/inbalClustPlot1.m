function [xsvd,nsvd,xcov,ncov,xempty,nempty]=inbalClustPlot1(experiment)
% [xsvd,nsvd,xcov,ncov,xempty,nempty]=inbalClustPlot1('S')
for subi=1:5
    disp(['SUB ',num2str(subi)])
    disp('reading svd data')
    cd /media/YuvalExtDrive/Inbal_Yuval_project
    cd (num2str(subi))
    % reading the BRIK noise files and plotting a hist for each
    [~, V,~,~] = BrikLoad (['svd',experiment,'_noise+orig']);
    vsvd=V(:);
    vsvd=vsvd(vsvd>0);
    [nsvd(subi,1:100),xsvd(subi,1:100)] = hist(vsvd,100);
    clear vsvd
%     figure;hold on;bar(xsvd,nsvd);

    disp('reading cov data')
    % reading the BRIK noise files and plotting a hist for each
    [~, V,~,~] = BrikLoad (['cov',experiment,'_noise+orig']);
    vcov=V(:);
    vcov=vcov(vcov>0);
    [ncov(subi,1:100),xcov(subi,1:100)] = hist(vcov,100);
    clear vcov
    
    disp('reading empty data')
    % reading the BRIK noise files and plotting a hist for each
    [~, V,~,~] = BrikLoad (['empty',experiment,'_noise+orig']);
    vempty=V(:);
    vempty=vempty(vempty>0);
    [nempty(subi,1:100),xempty(subi,1:100)] = hist(vempty,100);
    clear vempty
    figure;hold on; 
    scatter(1:100,nsvd(subi,:),'.b');
    scatter(1:100,ncov(subi,:),'.r');
    scatter(1:100,nempty(subi,:),'.g');
    legend('svd','cov','empty');
    title(['SUB ',num2str(subi)]);
    
end

% figure;hold on; 
% scatter(xsvd(1,:),nsvd(1,:),'.b');
% scatter(xcov(1,:),ncov(1,:),'.r');
% scatter(xempty(1,:),nempty(1,:),'.g');
% legend('svd','cov','empty');

