function figure1=LFfigEmpty2


%% empty room
cd /home/yuval/Data/emptyRoom2
load ratio35seg
rat=squeeze(mean(ratio,3));
Cpos=[];
Cneg=[];
% for chani=1:248
%     for repi=1:length(reps)
%         [~,p,c]=ttest(squeeze(ratio(chani,repi,:)));
%         Cneg(chani,repi)=c(1);
%         Cpos(chani,repi)=c(2);
%     end
% end
for chani=1:248
    for repi=1:length(reps)
        Cm(chani,repi)=mean(squeeze(ratio(chani,repi,:)));
    end
end
x=[reps,fliplr(reps)];
y=[min(Cm),fliplr(max(Cm))];
ticks=reps(1:2:end);
figure1=figure('Position',[400,200,500,700]);
subplot(2,1,2)
plot(reps,mean(rat),'k','linewidth',2)
set(gca,'FontSize',16,'FontName','Times')
set(gca,'XTick',ticks);
set(gca,'YTick',-1:2);
hold on
fill(x,y,[.9 .9 .9],'linestyle','none')
plot(reps,mean(rat),'k','linewidth',2)
%ylim([-1 0.2]);
legend ('mean MEG','Conf Int','location','southeast')
ylabel('(50Hz-BL)/BL')
xlabel({'N cycles',' '})
box off
title('ADAPTIVE1 (Tal & Abeles, 2013)')
subplot(2,1,1)
cd /home/yuval/Data/emptyRoom2
load ratio35segYH
rat=squeeze(mean(ratio,3));
Cpos=[];
Cneg=[];
% for chani=1:248
%     for repi=1:length(reps)
%         [~,p,c]=ttest(squeeze(ratio(chani,repi,:)));
%         Cneg(chani,repi)=c(1);
%         Cpos(chani,repi)=c(2);
%     end
% end
for chani=1:248
    for repi=1:length(reps)
        Cm(chani,repi)=mean(squeeze(ratio(chani,repi,:)));
    end
end
x=[reps,fliplr(reps)];
y=[min(Cm),fliplr(max(Cm))];
ticks=reps(1:2:end);
plot(reps,mean(rat),'k','linewidth',2)
set(gca,'FontSize',16,'FontName','Times')
set(gca,'XTick',ticks);
set(gca,'YTick',-1:2);
hold on
fill(x,y,[.9 .9 .9],'linestyle','none')
plot(reps,mean(rat),'k','linewidth',2)
%ylim([-1 0.2]);
%legend ('mean MEG','Conf Int','location','northwest')
ylabel('(50Hz-BL)/BL')
xlabel('N cycles')
title('ADAPTIVE (simple average)')
box off

