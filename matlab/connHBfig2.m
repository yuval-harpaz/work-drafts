

load /media/yuval/win_disk/Data/Amyg/8/avgHBh
f=abs(fftBasic(avgHBh.avg(:,408:end),1017));
X=avgHBh.time;
MEG=avgHBh.avg(1:246,:);
XC=avgHBh.avg(247:end,:);

Xf=1:50;
MEGf=f(1:246,1:50);
XCf=f(247:249,1:50);

meanMEG=mean(MEG);
figure;
%set(gca, );
set(gcf,'color','w')
%plot(X,meanMEG./max(meanMEG),'k','linewidth',2);
plot(X,MEG(1,:)./max(max(meanMEG)),'k','linewidth',2);
hold on
plot(X,-XC(2,:)./max(XC(2,:))./2,'w','linewidth',2)
plot(X,MEG./max(max(meanMEG)),'k','linewidth',2);
plot(X,-XC(2,:)./max(XC(2,:))./2,'w','linewidth',2)
set(gca, 'color', [0.7 0.7 0.7],'ytick',[],'fontweight','bold','linewidth',2);
xlabel('Time (s)')
ylabel('Normalized amplitude')
l1=legend('MEG','Acceleration');
set(l1,'box','off','fontweight','bold')
box off
% htext=findobj(get(l1,'children'),'type','text');
% set(htext,'fontsize',2,'fontweight','bold');





