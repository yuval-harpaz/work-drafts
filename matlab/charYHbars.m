function charYHbars(pow,band)
% pow is from /media/yuval/YuvalExtDrive/Data/Hilla_Rotem/powMed;
% band='alpha';
bands={'Delta','Theta','Alpha','Beta','Gamma'};
if exist('band','var')
    [~,bandi]=ismember(lower(band),lower(bands));
else
    bandi=1:5;
end
for bi=1:length(bandi)
    conds={'closed','open','charisma','room','dull','silent'};
    bars=mean(pow(:,:,bandi(bi)),1);
    err=std(pow(:,:,bandi(bi))./sqrt(40));
    fig1=figure;
    hold all;
    bar(bars,'w');
    errorbar(bars,err,'k','linestyle','none')
    bar(bars,'w');
    bar(3,bars(3),'b');
    bar(5,bars(5),'r');
    title(bands{bandi(bi)})
    set(gca,'XTick',1:6);
    set(gca,'XTickLabel',conds);
    hight=bars(5)*1.3;
    tall=0.95*hight;
    line([3,3,5,5],[tall,hight,hight,tall],'color','k','lineWidth',2);
    [~,p]=ttest(pow(:,3,bandi(bi)),pow(:,5,bandi(bi)))
    ylim([0,max([max(err),hight*1.4])]);
    annotation(fig1,'textbox',...
        [0.5 0.7 0.085 0.05],...
        'String',{['p=',num2str(p)]},...
        'FitBoxToText','off',...
        'LineStyle','none');
end
