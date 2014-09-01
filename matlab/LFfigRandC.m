function figure1=LFfigRandC

cd /home/yuval/Dropbox/LF
load data/ratio
rat=squeeze(mean(ratio(2:4,:,:),3));
C=[];
sRate=1017.23;
sRates=[sRate*2/3 sRate sRate*2];
for sRatei=1:length(sRates)
    for repi=1:length(reps)
        [~,p,c]=ttest(squeeze(ratio(sRatei,repi,:)),[],[],'left');
        C(sRatei,repi)=c(2);
    end
end
x=[reps(1:9),fliplr(reps(1:9))];
Cnn=-100*ones(size(C));
Cnn(rat<0)=C(rat<0);
maxC=max(Cnn);
y=[max(rat(:,1:9)),fliplr(maxC(1:9))];
y(8)=rat(2,8);
figure1=figure('Position',[400,200,500,700]);
subplot(2,1,2)
plot(reps,rat(1,:),'color',[0 0 1],'linewidth',2)
set(gca,'FontSize',16,'FontName','Times');
ticks=reps(1:2:end);
set(gca,'XTick',ticks);
%set(gca,'YTick',-0.6:0.2:0);
set(gca,'YTick',-0.6:0.3:1);
hold on
plot(reps,rat(2,:),'color',[1 0 0],'linewidth',2)
plot(reps,rat(3,:),'color',[0 1 0],'linewidth',2)
fill(x,y,[.9 .9 .9],'linestyle','none')
plot(reps,rat(1,:),'color',[0 0 1],'linewidth',2)
plot(reps,rat(2,:),'color',[1 0 0],'linewidth',2)
plot(reps,rat(3,:),'color',[0 1 0],'linewidth',2)
%plot(100:4500,0,'b')
ylim([-0.7 1.2])
legend1=legend ('678Hz','1017Hz','2035Hz','Conf Int');
hy=ylabel('Ratio of Change in PSD');
hx=xlabel('N cycles');
set(legend1,'box','off');
box off

load data/ratioYH
rat=squeeze(mean(ratio,3));
C=[];
sRate=1017.23;
sRates=[sRate*2/3 sRate sRate*2];
reps=[100 500 1000 1500 2000 2500 3000 3500 4000 4500];
x=[reps,fliplr(reps)];
for sRatei=1:length(sRates)
    for repi=1:length(reps)
        [~,p,c]=ttest(squeeze(ratio(sRatei,repi,:)));
        Cneg(sRatei,repi)=c(2);
        Cpos(sRatei,repi)=c(1);
    end
end
maxC=max([Cpos;Cneg]);
minC=min([Cpos;Cneg]);
y=[minC,fliplr(maxC)];
title('ADAPTIVE1 (Tal & Abeles, 2013)')
subplot(2,1,1)
plot(reps,rat(1,:),'Color',[0 0 1],'linewidth',2)
set(gca,'FontSize',16,'FontName','Times')
ticks=reps(1:2:end);
set(gca,'XTick',ticks);
set(gca,'YTick',-0.6:0.3:1);
hold on
plot(reps,rat(2,:),'color',[1 0 0],'linewidth',2)
plot(reps,rat(3,:),'color',[0 1 0],'linewidth',2)
fill(x,y,[.9 .9 .9],'linestyle','none')
plot(reps,rat(1,:),'Color',[0 0 1],'linewidth',2)
plot(reps,rat(2,:),'color',[1 0 0],'linewidth',2)
plot(reps,rat(3,:),'color',[0 1 0],'linewidth',2)
%plot(100:4500,0,'b')
ylim([-0.8 1.2])
% legend1=legend ('678Hz','1017Hz','2035Hz','Conf Int');
hy=ylabel('Ratio of Change in PSD');
hx=xlabel('N cycles');
% set(legend1,'Position',[0.8 0.6 0.2 0.2],'box','off');
box off
title('ADAPTIVE (simple average)')

