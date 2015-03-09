function char5


%% make subject list
if exist('/media/My Passport/Hila&Rotem')
    cd ('/media/My Passport/Hila&Rotem')
else
    [~,w]=unix('echo $USER');
    cd (['/media/',w(1:end-1),'/My Passport/Hila&Rotem'])
end
load Sub



timewin=1;
sampwin=round(1017.25*timewin);
ovrlp=round(1017.25*timewin/2);
%% cleaning line frequency (25min per subject)
source='hb,xc,lf_c,rfhp0.1Hz';
trigVal=[202 204 220 230 240 250];
conds={'closed','open','charism','room','dull','silent'};

for subi=1:length(Sub)
    cd (Sub{subi})
    disp(['load ',Sub{subi}])
    load data
    cfg=[];
    %cfg.trials=find(datacln.trialinfo==222);
    cfg.output       = 'pow';
    cfg.channel      = 'MEG';
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = 8:12;
    cfg.feedback='no';
    %cfg.trials=good;
    cfg.keeptrials='yes';
    Fr = ft_freqanalysis(cfg, data);
    %maxFr=max(Fr.powspctrm,[],3);
    timeCourse=mean(max(Fr.powspctrm,[],3),2);
    save timeCourse timeCourse good
    save Fr Fr good TRL -v7.3
    clear Fr data
    cd ../
end




