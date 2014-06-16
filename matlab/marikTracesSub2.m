function marikTracesSub2


cd ~/Data/epilepsy/g2/movies/
%vox=[27 23 21;21 24 21];
vox=[24,25,21];
cond={'sw'};
for condi=1
    for runi=1
        run=num2str(runi);
        V=BrikLoad(['b022_g2',cond{condi},'1+orig']);
        if condi==3
            eval(['all',run,'g2=squeeze(V(vox(runi,1)+1,vox(runi,2)+1,vox(runi,3)+1,:));'])
        else
            eval([cond{condi},run,'g2=squeeze(V(vox(runi,1)+1,vox(runi,2)+1,vox(runi,3)+1,:));'])
        end
    end
end

cd ~/Data/epilepsy/meanAbs/Movies/
cond={'sw'};
for condi=1
    for runi=1
        run=num2str(runi);
        V=BrikLoad(['b022_',cond{condi},'1+orig']);
        eval([cond{condi},run,'=squeeze(V(vox(runi,1)+1,vox(runi,2)+1,vox(runi,3)+1,:));'])
    end
end
% figure;
% plot((sw1-min(sw1(1:30)))/max(sw1-min(sw1(1:30)))*max(sw1g2),'k')
% hold on
% plot(sw1g2,'r')

figure;

plot(-30:15,sw1g2,'k')
hold on
plot(-30:15,sw1,'r')
xlim([-30 23])
ylim([-5 25])
legend('Amplitude','g2')
