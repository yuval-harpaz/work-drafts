function marikTracesSub3


cd /home/yuval/Data/epilepsy/b023
vox=[22 10 22];
cond={'sw'};
for runi=2:4
    run=num2str(runi);
    V=BrikLoad(['g2',cond{condi},run,'+orig']);
    eval([cond{condi},run,'g2=squeeze(V(vox(1)+1,vox(2)+1,vox(3)+1,:));'])
end

for runi=2:4
    run=num2str(runi);
    V=BrikLoad([cond{condi},run,'+orig']);
    eval([cond{condi},run,'=squeeze(V(vox(1)+1,vox(2)+1,vox(3)+1,:));'])
    
end
% figure;
% plot((sw1-min(sw1(1:30)))/max(sw1-min(sw1(1:30)))*max(sw1g2),'k')
% hold on
% plot(sw1g2,'r')

figure;

subplot(3,1,1)
plot(-30:10,sw2,'r')
hold on
plot(-30:10,sw2g2,'k')
xlim([-30 23])
ylim([-5 25])
legend('Amplitude','g2')

subplot(3,1,2)
plot(-30:23,sw3,'r')
hold on
plot(-30:23,sw3g2,'k')
xlim([-30 23])
ylim([-5 25])
%legend('Amplitude','g2')

subplot(3,1,3)
plot(-30:15,sw4,'r')
hold on
plot(-30:15,sw4g2,'k')
xlim([-30 23])
ylim([-5 25])
xlabel('Time (sec), ictus at t=0')
%legend('Amplitude','g2')
