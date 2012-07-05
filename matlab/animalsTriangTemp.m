
cd /home/yuval/Data/Amyg
for subi=2:12;
    eval(['cd ',num2str(subi)]);
    load datacln;
    cfg              = [];
    cfg.keeptrials = 'yes';
    cfg.output       = 'pow';
    cfg.channel      = 'MEG';
    cfg.method       = 'mtmconvol';
    cfg.taper        ='triang'; % not required
    cfg.foi          = 10;                            % freq of interest 3 to 100Hz
    cfg.t_ftimwin    = 1./cfg.foi;   % ones(length(cfg.foi),1).*0.5;  % length of time window fixed at 0.5 sec
    cfg.toi          = -0.2:0.001:0.2;                  % time window "slides" from -0.1 to 0.5 sec in steps of 0.02 sec (20 ms)
    cfg.tapsmofrq  = 1;
    cfg.trials='all';%[1:2];
    cfg.channel='all';
%     cfg.tail='beg'; % pad the template with zeros, 'beg' 'end' 'both' or [] for no padding
%     [TF,wlt] = freqanalysis_triang_temp(cfg, datacln);
%     save TF100pad TF wlt
%     clear TF
    cfg.tail=[]; % pad the template with zeros, 'beg' 'end' 'both' or [] for no padding
    [TF,wlt] = freqanalysis_triang_temp(cfg, datacln);
    save TF100 TF wlt
    clear TF
    display(['done with ',num2str(subi)]);
    cd ..
end