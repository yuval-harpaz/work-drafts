bands={'Delta','Theta','Alpha','Beta','Gamma'};
freqs=[1,4;4,8;8,13;13,25;25,40];
trigVal=[202 204 220 230 240 250;202 204 240 230 220 250];
conds={'closed','open','charisma','room','dull','silent'};
cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem
%% reading the data and run fft
cfg=[];
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.padding=1;
cfg.demean='yes';
cfg.dataset='hb,xc,lf_c,rfhp0.1Hz';
cfg.feedback='no';
cfg.channel='MEG';
for subi=1:40
    Fr=nan(248,1674,40);
    %Src=nan(63455,1674,5);
    cd (['Char_',num2str(subi)])
    load Fr TRL
    cfg.trl=TRL;
    data=ft_preprocessing(cfg);
    for trli=1:1674
        fr=fftBasic(data.trial{trli},data.fsample);
        Fr(:,trli,:)=fr(:,1:40);
    end
    save FrYH Fr
    cd ../
    disp(['done ',num2str(subi)])
end
%% average power per condition per band    
for subi=1:40
    cd (['Char_',num2str(subi)])
    load FrYH
    for condi=1:6
        for bandi=1:
        data=Fr(
    