%% sub 1 had no c,* only hb_c,*
cd /home/yuval/Data/Amyg
cd 1
correctLF('hb_c,rfhp0.1Hz');
p=pdf4D('lf_hb_c,rfhp0.1Hz');
cleanCoefs = createCleanFile_fhb(p, 'lf_hb_c,rfhp0.1Hz','byLF',0,'byFFT',0,'HeartBeat',0,'xClean',[4,5,6]);


%% clean 2:12
cd /home/yuval/Data/Amyg
fileName='c,rfhp0.1Hz';
for subi=4:12
    fold=num2str(subi);
    cd(fold)
    close all
    correctLF('c,rfhp0.1Hz');
    saveas(1,'lf.png')
    cfg=[];
    cfg.badChan=204;
    close all
    correctHB([],[],[],[],cfg);
    saveas(1,'hb1.fig')
    saveas(2,'hb2.png')
    p=pdf4D('hb_lf_c,rfhp0.1Hz');
    cleanCoefs = createCleanFile_fhb(p, 'hb_lf_c,rfhp0.1Hz','byLF',0,'byFFT',0,'HeartBeat',0,'xClean',[4,5,6]);
    !mv xc,hb_lf_c,rfhp0.1Hz xc,hb,lf_c,rfhp0.1Hz
    cd ..
end
%% clean folders
for subi=1:12
    fold=num2str(subi);
    cd(fold)
    if exist('xc,hb,lf_c,rfhp0.1Hz','file')
        !rm hb_*
        !rm lf_*
    else
        warning(num2str(subi))
    end
    cd ..
end
%% clean muscle and read trials
for subi=1:12;
    sub=num2str(subi);
    fileName='xc,hb,lf_c,rfhp0.1Hz';
    cd (['/home/yuval/Data/Amyg/',sub])
    trig=readTrig_BIU(fileName);
    find(trig==102,1,'last')
    trigVis=bitand(uint16(trig),2048);
    
    trigShift=zeros(size(trigVis));
    trigShift(2:end)=trigVis(1:end-1);
    events=find((double(trigVis)-trigShift)>0);
    good=diff(events)<3000;
    trl=unique([events(good),events(find(good)+1)])';
    trl=trl-203;
    trl(:,2)=trl+203+509;
    trl(:,3)=-203;
    save trl trl
    cfg=[];
    cfg.channel='MEG';%{'MEG','-A74','-A204'};
    cfg.demean='yes';
    cfg.baselinewindow=[-0.2 0];
    cfg.trl=trl;
    cfg.datafile=fileName;
    cfg.padding=0.5;
    cfg.hpfilter='yes';
    cfg.hpfreq=60;
    data=ft_preprocessing(cfg);
    
    close all
    cfg=[];
    cfg.badChan={'A204','A74'};
    %cfg.criterion='fixed';
    %cfg.critval=1.15e-13;
    cfg.criterion='median';
    cfg.critval=0.2;
    good=badTrials(cfg,data);
    saveas(1,'muscle.png');
    
    cfg=[];
    cfg.channel='MEG';%{'MEG','-A74','-A204'};
    cfg.demean='yes';
    cfg.baselinewindow=[-0.2 0];
    cfg.trl=trl(good,:);
    cfg.datafile=fileName;
    cfg.padding=0.5;
    cfg.bpfilter='yes';
    cfg.bpfreq=[1 40];
    data=ft_preprocessing(cfg);
    
    save dataAll data
end
%% component analysis
load LRpairs
for subi=6:12;
    sub=num2str(subi);
    fileName='xc,hb,lf_c,rfhp0.1Hz';
    cd (['/home/yuval/Data/Amyg/',sub])
    load dataAll
    % detect trials with low frequencies for ica to detect blinks component
    cfg=[];
    cfg.lpfilter='yes';
    cfg.lpfreq=15;
    cfg.demean='yes';
    cfg.baselinewindow=[-0.2 0];
    dataLP=ft_preprocessing(cfg,data);
    % check right front - left front trace for blink trials
    front = {'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A16', 'A17', 'A18', 'A19', 'A20', 'A21', 'A22', 'A23', 'A33', 'A34', 'A35', 'A36', 'A37', 'A38', 'A39', 'A40', 'A41', 'A42', 'A56', 'A57', 'A58', 'A59', 'A60', 'A61', 'A62', 'A63', 'A64', 'A65', 'A66', 'A67', 'A83', 'A84', 'A85', 'A86', 'A87', 'A88', 'A89', 'A90', 'A91', 'A92', 'A93', 'A94', 'A95', 'A96', 'A114', 'A115', 'A116', 'A117', 'A118', 'A119', 'A120', 'A121', 'A122', 'A123', 'A124', 'A125', 'A126', 'A127', 'A128', 'A146', 'A147', 'A148', 'A149', 'A150', 'A151', 'A152', 'A153', 'A154', 'A155', 'A156', 'A173', 'A174', 'A175', 'A176', 'A177', 'A178', 'A179', 'A193', 'A194', 'A195', 'A196', 'A211', 'A212', 'A213', 'A227', 'A228', 'A229', 'A230', 'A231', 'A246', 'A247', 'A248'};
    Lchan=LRpairs(ismember(LRpairs(:,1),front),1);
    Rchan=LRpairs(ismember(LRpairs(:,2),front),2);
    [~,Li]=ismember(Lchan,dataLP.label);
    [~,Ri]=ismember(Rchan,dataLP.label);
    LR=[];
    for triali=1:length(dataLP.trial)
        LR(triali)=range(mean(dataLP.trial{triali}(Li,:))-mean(dataLP.trial{triali}(Ri,:)));
    end
    bad=find(LR>1.2e-12);
%     if isempty(bad)
%         bad=1:length(LR)
    % run comp analysis on bad trials
    cfg=[];
    cfg.channel={'MEG','-A74','-A204'};
    cfg.numcomponent=15;
    cfg.trials=bad;
    comp=ft_componentanalysis(cfg,dataLP);
    cfg=[];
    cfg.layout='4D248.lay';
    cfg.channel = {comp.label{1:5}};
    comppic=ft_databrowser(cfg,comp);
    
    % look for blink topography
    [~,Li]=ismember(Lchan,comp.topolabel);
    [~,Ri]=ismember(Rchan,comp.topolabel);
    LR=[];
    for compi=1:15
        LR(compi)=max([abs(max(comp.topo(Li,compi))-min(comp.topo(Ri,compi))) abs(min(comp.topo(Li,compi))-max(comp.topo(Ri,compi)))]);
    end
    [~,MOGcomp]=max(LR); % this component is blink
    % run comp analysis on real data
    cfg = [];
    cfg.topolabel = comp.topolabel;
    cfg.unmixing=comp.unmixing;
    comp1     = ft_componentanalysis(cfg, data);
    % find bad channels
    for triali=1:length(comp1.trial)
        LR(triali)=range(comp1.trial{triali}(MOGcomp,:));
    end
    thr=1.5*median(LR)
    good=LR<thr;%(2e-11);
    ratio=num2str(length(find(good))/length(LR));
    
%     figure;
%     plot(LR)
%     hold on
%     plot(find(good),LR(find(good)),'.k')

    cfg=[];
    cfg.trials=good;
    avg=ft_timelockanalysis(cfg,data);
    close all
    figure;
    vec=zeros(1,248);
    [~,ii]=ismember(comp.topolabel,data.label);
    vec(ii)=comp.topo(:,MOGcomp);
    topoplot248(vec);
    title(ratio)
    saveas(1,'blink.png')
    save avgAll avg good
end
%% reject some other trials, 1-40Hz
for subi=1:12;
    sub=num2str(subi);
    fileName='xc,hb,lf_c,rfhp0.1Hz';
    cd (['/home/yuval/Data/Amyg/',sub])
    load dataAll
    load avgAll
    data.trial=data.trial(good);
    data.time=data.time(good);
    data.sampleinfo=data.sampleinfo(good,:);
    %close all
    cfg=[];
    cfg.badChan={'A204','A74'};
    %cfg.criterion='fixed';
    %cfg.critval=1.15e-13;
    cfg.criterion='median';
    cfg.critval=0.5;
    good=badTrials(cfg,data);
    title(num2str(subi));
    cfg=[];
    cfg.trials=good;
    sampleinfo=data.sampleinfo(good,:);
    avg=ft_timelockanalysis(cfg,data);
    save avgAll1 avg sampleinfo
end

%% fix bad channels
for subi=1:12;
    sub=num2str(subi);
    fileName='xc,hb,lf_c,rfhp0.1Hz';
    cd (['/home/yuval/Data/Amyg/',sub])
    load avgAll1
    
    [~,chi]=ismember({'A75','A73'},avg.label);
    avg.avg(171,:)=mean(avg.avg(chi,:));
    [~,chi]=ismember({'A186','A187','A220','A221'},avg.label);
    avg.avg(36,:)=mean(avg.avg(chi,:));
%     figure;
%     topoplot248(avg.avg(:,322))
%     title(sub)
    save avgFixed avg
end
%% grand average
str='Gavg=ft_timelockgrandaverage(cfg';
for subi=1:12;
    sub=num2str(subi);
    fileName='xc,hb,lf_c,rfhp0.1Hz';
    cd (['/home/yuval/Data/Amyg/',sub])
    load avgFixed
    eval(['avg',sub,'=avg']);
    str=[str,',avg',sub];
end
str(end+1:end+2)=');';
cd ..

cfg=[];
cfg.keepindividual='yes';
eval(str)

str(1)='g';
cfg=[];
eval(str)
save Gavg Gavg gavg
cfg=[];
cfg.interactive='yes';
cfg.xlim=[0.11 0.11];
cfg.layout='4D248.lay';
ft_topoplotER(cfg,gavg)
