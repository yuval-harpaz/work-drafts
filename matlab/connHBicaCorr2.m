%% plot ica issues

load /media/yuval/win_disk/Data/connectomeDB/MEG/posCorr
posCorr(:,:,2)=[];
% figure;
% plot(squeeze(mean(posCorr,3))','linewidth',2)
% set(gca, 'xtick',[1,2])
% set(gca, 'xticklabel', {'-0.1 to 0.1s','0.45 to 0.65s'})
% xlabel ('time window relative to R peak')
% xlim([0.5 2.5])
% ylabel('averaged correlation for 247x247 channels (r)')
% legend('Raw Data','Template Removal','ICA')
rawCor=squeeze(posCorr(1,1:2,:));
corRat=[];
for subi=1:9
    corRat(1:2,1,subi)=posCorr(2:3,1,subi)./rawCor(1,subi)-1;
    corRat(1:2,2,subi)=posCorr(2:3,2,subi)./rawCor(2,subi)-1;
end
corRat=100.*corRat;



for i=1:2
    for j=1:2
        err(i,j)=std(corRat(i,j,:))./sqrt(9);
    end
end


figure1=figure;
plot(squeeze(mean(corRat,3))','linewidth',2)
set(gca, 'xtick',[1,2])
set(gca, 'xticklabel', {'-0.1 to 0.1s','0.45 to 0.65s'})
xlabel ('time window relative to R peak')
xlim([0.5 2.5])
ylabel('change in mean correlation (%)')
legend('Template Removal','ICA','location','northwest')
title({'Effect of cleaning on inter-channel correlations','at heartbeat peak and 0.55s later'});
hold on
X=1:2;
for ind=1:2
    Y=squeeze(mean(corRat(ind,:,:),3));
    L=-err(ind,:);
    U=err(ind,:);
    errorbar(X,Y,L,U,'k','linewidth',1)
end
shift=0.05;
width=0.02;
[~,pICA_HB,conf,stat]=ttest(corRat(2,1,:),corRat(1,1,:)); % all positive
[~,pHBbl,~,stat]=ttest(corRat(1,2,:)); % all negative
[~,pICAbl,~,stat]=ttest(corRat(2,2,:));
line([2+shift,2+shift+width,2+shift+width,2+shift],[mean(corRat(1,2,:)),mean(corRat(1,2,:)),0,0],'linewidth',2,'color','k')
shift=0.11;
width=0.02;
line([2+shift,2+shift+width,2+shift+width,2+shift],[mean(corRat(2,2,:)),mean(corRat(2,2,:)),0,0],'linewidth',2,'color','k');
shift=-0.05;
width=-0.02;
line([1+shift,1+shift+width,1+shift+width,1+shift],[mean(corRat(1,1,:)),mean(corRat(1,1,:)),mean(corRat(2,1,:)),mean(corRat(2,1,:))],'linewidth',2,'color','k');

annotation(figure1,'textbox',...
    [0.786681547619047 0.744988934993085 0.0154017857142864 0.0240290456431527],...
    'String',{'**'},...
    'linestyle','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.755729166666667 0.648686030428769 0.0151041666666667 0.0197468879668063],...
    'String',{'*'},...
    'linestyle','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.264270833333333 0.18746887966805 0.0151041666666667 0.0197468879668063],...
    'String',{'*'},...
    'linestyle','none');
