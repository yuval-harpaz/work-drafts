function charJosh1


%% make subject list
if exist('/media/My Passport/Hila&Rotem','dir')
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
    
    load data TRL
    cfg=[];
    cfg.trl=TRL;
    cfg.dataset=source;
    cfg.demean='yes';
    cfg.channel='MEG';
    %cfg.feedback='no';
    cfg.hpfilter='yes';
    cfg.hpfreq=1;
    data=ft_preprocessing(cfg);
    
%     cfg=[];
%     cfg.hpfilter='yes';
%     cfg.hpfreq=60;
%     hp=ft_preprocessing(cfg,data);
%     
%     cfg=[];
%     cfg.method='abs';
%     cfg.criterion='sd';
%     cfg.critval=3.5;
%     close all
%     good=badTrials(cfg,hp);
%     clear hp
    cfg=[];
    %cfg.trials=find(datacln.trialinfo==222);
    cfg.output       = 'pow';
    cfg.channel      = 'MEG';
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = 25:40; %change for diff. frequency bands
    cfg.feedback='no';
    %cfg.trials=good;
    cfg.keeptrials='yes';
    Fr = ft_freqanalysis(cfg, data);
    %maxFr=max(Fr.powspctrm,[],3);
    timeCourse=mean(max(Fr.powspctrm,[],3),2);
    load Fr good
    save timeCourseGamma timeCourse good
    disp(['saving FrGamma for ',Sub(subi),' #',num2str(subi)])
    save FrGamma Fr good TRL -v7.3
    clear Fr good data timeCourse TRL
    cd ../
end
end




