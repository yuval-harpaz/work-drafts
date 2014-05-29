function marikTraces


cd ~/Data/epilepsy/g2/movies/
vox=[17 24 17];
cond={'seg','sw','_'};
for condi=1:3
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
cond={'seg','sw','all'};
for condi=1:3
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

subplot(2,3,1)
plot(-30:15,sw1g2,'k')
hold on
plot(-30:15,all1g2,'r')
plot(-30:15,seg1g2,'b')
xlim([-30 15])
legend('SW','GLOBAL','SEG')

subplot(2,3,2)
plot(-30:15,sw2g2,'k')
hold on
plot(-30:15,all2g2,'r')
plot(-30:15,seg2g2,'b')
xlim([-30 15])
subplot(2,3,3)
plot(-30:15,sw3g2,'k')
hold on
plot(-30:15,all3g2,'r')
plot(-30:15,seg3g2,'b')
xlim([-30 15])
subplot(2,3,4)
plot(-30:15,sw1,'k')
hold on
plot(-30:15,all1,'r')
plot(-30:15,seg1,'b')
xlim([-30 15])
subplot(2,3,5)
plot(-30:15,sw2,'k')
hold on
plot(-30:15,all2,'r')
plot(-30:15,seg2,'b')
xlim([-30 15])
subplot(2,3,6)
plot(-30:15,sw3,'k')
hold on
plot(-30:15,all3,'r')
plot(-30:15,seg3,'b')
xlim([-30 15])