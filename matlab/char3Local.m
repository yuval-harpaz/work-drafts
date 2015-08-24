%% make subject list
cd ('/media/My Passport/Hila&Rotem')
load Sub



timewin=1;
sampwin=round(1017.25*timewin);
ovrlp=round(1017.25*timewin/2);
%% cleaning line frequency (25min per subject)
source='hb,xc,lf_c,rfhp0.1Hz';
trigVal=[202 204 220 230 240 250];
conds={'closed','open','charism','room','dull','silent'};
TRL=[];
for subi=1:length(Sub)
    cd (Sub{subi})
    trig=readTrig_BIU(source);
    trig=bitset(uint16(trig),12,0);
    trig=bitset(uint16(trig),9,0);
    trigSamp=trigOnset(trig);
    trigSamp(2,:)=trig(trigSamp);
    for condi=1:length(trigVal)
        condSamp=trigSamp(1,find(trigSamp(2,:)==trigVal(condi)));
        if length(condSamp)==1
            condSamp(2)=condSamp(1)+1017.25*121;
        end
        trl1=condSamp(1):sampwin:condSamp(2);
        trl2=(condSamp(1)+ovrlp):sampwin:condSamp(2);

        trl=sort([trl1';trl2']);
        trl(:,2)=trl+sampwin-1;
        trl(:,3)=0;
        trl(:,4)=trigVal(condi);
        TRL((size(TRL,1)+1):(size(TRL,1)+size(trl,1)),1:4)=trl;
    end
    cfg=[];
    cfg.trl=TRL;
    cfg.dataset=source;
    cfg.demean='yes';
    cfg.channel='MEG';
    data=ft_preprocessing(cfg);
    good=badTrials([],data,0);
    cfg=[];
    %cfg.trials=find(datacln.trialinfo==222);
    cfg.output       = 'pow';
    cfg.channel      = 'MEG';
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = 8:12;
    cfg.feedback='no';
    cfg.trials=good;
    cfg.keeptrials='yes';
    Fr = ft_freqanalysis(cfg, data);
    maxFr=max(Fr.powspctrm,[],3);
    cd ../
end




