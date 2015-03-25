%% make subject list
cd /home/yuval/Data/marik/som1



%% cleaning line frequency (25min per subject)

for runi=2:3
    cd (num2str(runi))
    close all;
    correctLF;
    saveas(1,'lf.png')
    close
    cd ../
end

%% clean building vibrations (5min per subject)
for runi=1:3
    cd (num2str(runi))
    p=pdf4D('lf_c,rfhp0.1Hz');
    cleanCoefs = createCleanFile(p, 'lf_c,rfhp0.1Hz',...
        'byLF',0 ,...
        'xClean',[4,5,6],...
        'byFFT',0,...
        'HeartBeat',0);
    cd ../
end
%% cleaning heartbeat (5min per subject)
for runi=1:3
    cd (num2str(runi))
    close all;
    clean=correctHB;
    saveas(1,'HBraw.fig')
    saveas(2,'HBmean.png')
    close all;
    rewrite_pdf(clean,[],[],'hb,xc,lf');
    cd ../
end
%% averaging
fn='hb,xc,lf_c,rfhp0.1Hz';
cond={'hand2','foot2','foot1'};
for runi=1:3
    cd (num2str(runi))
    trig=readTrig_BIU(fn);
    trig=clearTrig(trig);
    evt=trigOnset(trig);
    
    trl=evt'-103;
    trl(:,2)=trl+410;
    trl(:,3)=-103;
    cfg.trl=trl;
    cfg.dataset=fn;
    cfg.channel='MEG';
    cfg.bpfilter='yes';
    cfg.bpfreq=[1 20];
    data=ft_preprocessing(cfg);
    data.trialinfo=trig(evt)';
    %good=badTrials(data);
    for condi=1:3
        cfg=[];
        cfg.trials=find(data.trialinfo==condi*2);
        avg=ft_timelockanalysis(cfg,data);
        eval(['avg',num2str(runi),'_',cond{condi},'=correctBL(avg,[-0.1 0]);'])
    end
    cd ../
end
clear avg
save avgFilt avg*
close all
figure;
plot(avg1_foot1.time,avg1_hand2.avg,'g')
hold on
plot(avg1_foot1.time,avg1_foot2.avg,'r')
plot(avg1_foot1.time,avg1_foot1.avg,'k')
legend(cond)
title('position1')
figure;
plot(avg1_foot1.time,avg2_hand2.avg,'g')
hold on
plot(avg1_foot1.time,avg2_foot2.avg,'r')
plot(avg1_foot1.time,avg2_foot1.avg,'k')
legend(cond)
title('position2')
figure;
plot(avg1_foot1.time,avg3_hand2.avg,'g')
hold on
plot(avg1_foot1.time,avg3_foot2.avg,'r')
plot(avg1_foot1.time,avg3_foot1.avg,'k')
legend(cond)
title('position3')

%% save unaveraged data
fn='hb,xc,lf_c,rfhp0.1Hz';
cond={'hand2','foot2','foot1'};
for runi=1:3
    cd (num2str(runi))
    trig=readTrig_BIU(fn);
    trig=clearTrig(trig);
    evt=trigOnset(trig);
    
    trl=evt'-103;
    trl(:,2)=trl+410;
    trl(:,3)=-103;
    cfg.trl=trl;
    cfg.dataset=fn;
    cfg.channel='MEG';
    cfg.bpfilter='yes';
    cfg.bpfreq=[1 20];
    data=ft_preprocessing(cfg);
    data.trialinfo=trig(evt)';
    %good=badTrials(data);
    data=correctBL(data,[-0.1 0]);
    for condi=1:3
        eval(['data',num2str(runi),'_',cond{condi},'=data;'])
        eval(['data',num2str(runi),'_',cond{condi},'.trial=data',num2str(runi),'_',cond{condi},'.trial(data.trialinfo==condi*2);'])
        eval(['data',num2str(runi),'_',cond{condi},'.time=data',num2str(runi),'_',cond{condi},'.time(data.trialinfo==condi*2);'])
        eval(['data',num2str(runi),'_',cond{condi},'.sampleinfo=data',num2str(runi),'_',cond{condi},'.sampleinfo(data.trialinfo==condi*2,:);'])
        eval(['data',num2str(runi),'_',cond{condi},'.trialinfo=data',num2str(runi),'_',cond{condi},'.trialinfo(data.trialinfo==condi*2);'])

    end
    cd ../
end
clear data
save dataFilt data*
close all