function charR1(timewin,freq,method)


%% make subject list
if exist('/media/My Passport/Hila&Rotem','dir')
    cd ('/media/My Passport/Hila&Rotem')
else
    [~,w]=unix('echo $USER');
    cd (['/media/',w(1:end-1),'/My Passport/Hila&Rotem'])
end
load SubOrder

if ~existAndFull('timewin');
    timewin=1;
end
if ~existAndFull('freq');
    freq=8:12;
end
if ~existAndFull('method');
    method='max';
end
sampwin=1017.25*timewin;
ovrlp=1017.25*timewin/2;
%% cleaning line frequency (25min per subject)
source='hb,xc,lf_c,rfhp0.1Hz';
trigVal=[202 204 220 230 240 250;202 204 240 230 220 250];
conds={'closed','open','charism','room','dull','silent'};

for subi=1:length(Sub)
    cd (Sub{subi})
    disp(['reading trigger ',Sub{subi}])
    trig=readTrig_BIU(source);
    trig=bitset(uint16(trig),12,0);
    trig=bitset(uint16(trig),9,0);
    trigSamp=trigOnset(trig);
    trigSamp(2,:)=trig(trigSamp);
    TRL=[];
    for condi=1:length(trigVal)
        condSamp=trigSamp(1,find(trigSamp(2,:)==trigVal(1,condi)));
        if length(condSamp)==1
            condSamp(2)=condSamp(1)+round(1017.25*121);
        end
        trl1=condSamp(1):sampwin:condSamp(2);
        trl2=(condSamp(1)+ovrlp):sampwin:condSamp(2);
        trl=round(sort([trl1';trl2']));
        trl(:,2)=trl+round(sampwin)-1;
        trl(:,3)=0;
        trl(:,4)=trigVal(1,condi);
        trl=trl(1:end-2,:);
        TRL((size(TRL,1)+1):(size(TRL,1)+size(trl,1)),1:4)=trl;
    end
    cfg=[];
    cfg.trl=TRL;
    cfg.dataset=source;
    cfg.demean='yes';
    cfg.channel='MEG';
    cfg.feedback='no';
    data=ft_preprocessing(cfg);
    if timewin>=5
        good=1:length(data.trial);
    else
        cfg=[];
        cfg.method='abs';
        cfg.criterion='sd';
        cfg.critval=3.5;
        close all
        good=badTrials(cfg,data);
    end
    cfg=[];
    %cfg.trials=find(datacln.trialinfo==222);
    cfg.output       = 'pow';
    cfg.channel      = 'MEG';
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = freq;
    cfg.feedback='no';
    %cfg.trials=good;
    cfg.keeptrials='yes';
    Fr = ft_freqanalysis(cfg, data);
    %maxFr=max(Fr.powspctrm,[],3);
    if strcmp(method,'max')
        timeCourse=mean(max(Fr.powspctrm,[],3),2);
    else
        timeCourse=mean(mean(Fr.powspctrm,[],3),2);
    end
    clear Fr data
    cond=TRL(:,4);
    TimeCourse{subi,1}=timeCourse';
    Good{subi,1}=false(size(timeCourse))';
    Good{subi,1}(good)=true;
    Cond{subi,1}=cond';
    cd ../
end
for condi=1:6
    for subi=1:length(Sub)
        for subj=1:length(Sub)
            i0=find(Cond{subi,1}==trigVal(Sub{subi,2},condi),1);
            i1=find(Cond{subi,1}==trigVal(Sub{subi,2},condi),1,'last');
            trli=Good{subi,:}.*(Cond{subi,1}==trigVal(Sub{subi,2},condi));
            trlk=trli(i0:i1);
            j0=find(Cond{subj,1}==trigVal(Sub{subj,2},condi),1);
            j1=find(Cond{subj,1}==trigVal(Sub{subj,2},condi),1,'last');
            trlj=Good{subj,:}.*(Cond{subj,1}==trigVal(Sub{subj,2},condi));
            ni=length(trlk);
            nj=length(j0:j1);
            if ni==nj
                trlk=trlk.*trlj(j0:j1);
            elseif ni<nj
                trlk=trlk.*trlj(j0:(j1-nj+ni));
            else
                trlk=trlk(1:end-ni+nj).*trlj(j0:j1); 
            end
            datai=TimeCourse{subi,1}(i0-1+find(trlk));
            dataj=TimeCourse{subj,1}(j0-1+find(trlk));
            R(subi,subj,condi)=corrFast(datai',dataj');
        end
    end
end
for subi=1:size(R,1)
    ii=1:size(R,1);
    ii(subi)=[];
    r(subi,:)=squeeze(mean(R(ii,subi,:)));
end
[~,~,ci]=ttest(r);
figure;
h=fill([1:6,6:-1:1]',[ci(1,1:end),ci(2,end:-1:1)]',0.9*[1 1 1]);
set(h,'EdgeColor','None');
hold on
plot(mean(r))
legend('confidence interval','mean correlation')
xlim([0 7])
xlabel ('condition')
ylabel ('mean r')

[~,p]= ttest(r(:,3),r(:,5))



