%% make subject list
cd /home/yuval/Data/marik/som2



%% cleaning line frequency (25min per subject)

for runi=1:3
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
cond={'handR','handL','footL'};
for runi=1:3
    cd (num2str(runi))
    trig=readTrig_BIU(fn);
    trig=clearTrig(trig);
    evt=trigOnset(trig);
    
    trl=evt'-103;
    trl(:,2)=trl+410;
    trl(:,3)=-103;
    cfg=[];
    cfg.trl=trl;
    cfg.dataset=fn;
    cfg.channel='MEG';
    cfg.hpfilter='yes';
    cfg.hpfreq=60;%[1 20];
    data=ft_preprocessing(cfg);
    trialinfo=trig(evt)';
    cfg=[];
    cfg.method='var';
    criterion='median'
    cfg.critval=0.5;
    [good,bad]=badTrials(cfg,data,1);
    title(['run ',num2str(runi)])
    trialinfo=trialinfo(good,:);
    cfg=[];
    cfg.trl=trl(good,:);
    cfg.dataset=fn;
    cfg.channel='MEG';
    cfg.bpfilter='yes';
    cfg.bpfreq=[1 20];
    data=ft_preprocessing(cfg);
    cfg=[];
    cfg.method='var';
    criterion='median'
    cfg.critval=3;
    [good,bad]=badTrials(cfg,data,1);
    title(['run ',num2str(runi)])
    for condi=1:3
        trials=find(trialinfo==condi*2);
        trials=trials(ismember(trials,good));
        trials=trials(1:250);
        cfg=[];
        cfg.trials=trials(1:250)
        avg=ft_timelockanalysis(cfg,data);
        eval(['avg',num2str(runi),'_',cond{condi},'=correctBL(avg,[-0.1 0]);'])
    end
    cd ../
end
clear avg
save avgFilt avg*
close all
figure;
plot(avg1_footL.time,avg1_footL.avg,'g')
hold on
plot(avg1_footL.time,avg2_footL.avg,'r')
plot(avg1_footL.time,avg3_footL.avg,'k')

s=nearest(avg1_footL.time,0.075);
figure;topoplot248(avg1_footL.avg(:,s))
figure;topoplot248(avg2_footL.avg(:,s))
figure;topoplot248(avg3_footL.avg(:,s))


figure;
plot(avg1_footL.time,avg1_handL.avg,'g')
hold on
plot(avg1_handL.time,avg2_handL.avg,'r')
plot(avg1_handL.time,avg3_handL.avg,'k')

s=nearest(avg1_handL.time,0.03);
figure;topoplot248(avg1_handL.avg(:,s))
figure;topoplot248(avg2_handL.avg(:,s))
figure;topoplot248(avg3_handL.avg(:,s))

figure;
plot(avg1_footL.time,avg1_handR.avg,'g')
hold on
plot(avg1_handR.time,avg2_handR.avg,'r')
plot(avg1_handR.time,avg3_handR.avg,'k')

s=nearest(avg1_handR.time,0.03);
figure;topoplot248(avg1_handR.avg(:,s))
figure;topoplot248(avg2_handR.avg(:,s))
figure;topoplot248(avg3_handR.avg(:,s))

[dataR, cfgR]=marikViUnite(avg1_handR,avg2_handR,avg3_handR);
[srcR]=marikViMNE(dataR,cfgR,[0.02 0.03]);

[dataL, cfgL]=marikViUnite(avg1_handL,avg2_handL,avg3_handL);
[srcL]=marikViMNE(dataL,cfgL,[0.02 0.03]);

dataLR=dataL;
dataLR.dataU.avg=dataL.dataU.avg+dataR.dataU.avg;
dataLR.data1.avg=dataL.data1.avg+dataR.data1.avg;
dataLR.data2.avg=dataL.data2.avg+dataR.data2.avg;
dataLR.data3.avg=dataL.data3.avg+dataR.data3.avg;
cfgLR=cfgL;
[srcLR]=marikViMNE(dataLR,cfgLR,[0.02 0.03]);


