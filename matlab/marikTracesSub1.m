function marikTracesSub1


cd ~/Data/epilepsy/g2/movies/
vox=[17 24 17];
cond={'sw'};
for condi=1
    for runi=1:3
        run=num2str(runi);
        V=BrikLoad(['g2',cond{condi},run,'+orig']);
        if condi==3
            eval(['all',run,'g2=squeeze(V(vox(1)+1,vox(2)+1,vox(3)+1,:));'])
        else
            eval([cond{condi},run,'g2=squeeze(V(vox(1)+1,vox(2)+1,vox(3)+1,:));'])
        end
    end
end

cd ~/Data/epilepsy/meanAbs/Movies/
cond={'sw'};
for condi=1
    for runi=1:3
        run=num2str(runi);
        V=BrikLoad([cond{condi},run,'+orig']);
        eval([cond{condi},run,'=squeeze(V(vox(1)+1,vox(2)+1,vox(3)+1,:));'])
    end
end
% figure;
% plot((sw1-min(sw1(1:30)))/max(sw1-min(sw1(1:30)))*max(sw1g2),'k')
% hold on
% plot(sw1g2,'r')
figure;
subplot(3,1,1)
plot(-30:15,sw1,'r')
hold on
plot(-30:15,sw1g2,'k')
xlim([-30 23])
ylim([-5 25])
legend('Amplitude','g2')

subplot(3,1,2)
plot(-30:15,sw2,'r')
hold on
plot(-30:15,sw2g2,'k')
xlim([-30 23])
ylim([-5 25])
%legend('Amplitude','g2')

subplot(3,1,3)
plot(-30:15,sw3,'r')
hold on
plot(-30:15,sw3g2,'k')
xlim([-30 23])
ylim([-5 25])
xlabel('Time (sec), ictus at t=0')