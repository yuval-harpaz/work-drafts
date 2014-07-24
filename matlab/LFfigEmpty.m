function LFfigEmpty


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
figure;
plot(reps,mean(rat),'k','linewidth',2)
set(gca,'FontSize',16,'FontName','Times')
set(gca,'XTick',ticks);
set(gca,'YTick',-1:2);
hold on
fill(x,y,[.9 .9 .9],'linestyle','none')
plot(reps,mean(rat),'k','linewidth',2)
%ylim([-1 0.2]);
legend ('mean MEG','Conf Int','location','northwest')
ylabel('Ratio of Change in PSD');
xlabel('N cycles')
box off
