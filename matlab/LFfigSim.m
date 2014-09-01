function LFfigSim


%% empty room
cd /home/yuval/Dropbox/LF/data
load ratioSim
plot(reps,mean(ratio,3)')
legend(ratioDim1)



% rat=squeeze(mean(ratio,3)); %#ok<NODEF>
% 
% % for chani=1:4
% %     for repi=1:length(reps)
% %         Cm(chani,repi)=mean(squeeze(ratio(chani,repi,:)));
% %     end
% % end
% x=[reps,fliplr(reps)];
% y=[min(Cm),fliplr(max(Cm))];
% ticks=reps(1:2:end);
% figure;
% plot(reps,mean(rat),'k','linewidth',2)
% set(gca,'FontSize',16,'FontName','Times')
% set(gca,'XTick',ticks);
% set(gca,'YTick',-1:2);
% hold on
% fill(x,y,[.9 .9 .9],'linestyle','none')
% plot(reps,mean(rat),'k','linewidth',2)
% %ylim([-1 0.2]);
% legend ('mean MEG','Conf Int','location','northwest')
% ylabel('Ratio of Change in PSD');
% xlabel('N cycles')
% box off
