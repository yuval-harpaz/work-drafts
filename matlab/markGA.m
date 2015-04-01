function markGA
% foi is a vector of desired frequencies

if ~exist('sub1','dir')
    try
        cd /media/yuval/My_Passport/Mark_threshold_visual_detection/MEG_data/
    catch
        try
            cd /home/yuval/Data/mark
        catch
            error('cd to mark directory')
        end
    end
end
%% compute phase

for subi=1:22
    folder=['sub',num2str(subi)];
    cd (folder)
    load datafinal
    corri= find(datafinal.trialinfo(:,4)==2);
    missi= find(datafinal.trialinfo(:,4)==0);
    nTrl=min([length(corri),length(missi)]);
    hdr=ft_read_header(source);
    datafinal.grad=hdr.grad;
    cfg=[];
    cfg.bpfilter='yes';
    cfg.bpfreq=[3 40];
    cfg.bpfiltord     = 2;
    cfg.demean='yes';
    cfg.baselinewindow=[-0.2 0];
    cfg.trials=corri(1:nTrl);
    dataC=ft_preprocessing(cfg,datafinal)
    cfg.trials=missi(1:nTrl);
    dataM=ft_preprocessing(cfg,datafinal)
    
    eval(['miss',num2str(subi),'=ft_timelockanalysis([],dataM);'])
    eval(['corr',num2str(subi),'=ft_timelockanalysis([],dataC);'])
    
    disp(['done ',folder])
    cd ..
end
strm=[];
strc=[];
for subi=1:22
    strm=[strm,',miss',num2str(subi)];
    strc=[strc,',corr',num2str(subi)];
end
cfg=[];
eval(['GAmiss=ft_timelockgrandaverage(cfg',strm,');'])
eval(['GAcorr=ft_timelockgrandaverage(cfg',strc,');'])
save GA GA*
cfg=[];
cfg.xlim=[0.11 0.11];
cfg.layout='4D248.lay';
cfg.zlim=[-3e-14 3e-14];
figure;ft_topoplotER(cfg,GAcorr,GAmiss);
cfg.
cfg=[];
cfg.keepindividual='yes';
eval(['GAmiss=ft_timelockgrandaverage(cfg',strm,');'])
eval(['GAcorr=ft_timelockgrandaverage(cfg',strc,');'])
save GAki GA*

