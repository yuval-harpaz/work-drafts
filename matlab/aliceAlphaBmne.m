function aliceAlphaBmne(Afreqs)
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
for sfi=1:8
    cd /home/yuval/Data/alice
    cd(sf{sfi})
    LSclean=ls('*lf*');
    megFNc=LSclean(1:end-1);
    load LRpairsEEG
    LRpairsEEG=LRpairs;
    load LRpairs
    load files/triggers
    load files/evt
    resti=100;
    % MEG
    sampBeg=trigS(find(trigV==resti));
    sampEnd=sampBeg+60*1017.23;
    samps1s=sampBeg:1017:sampEnd-100;
    trl=[samps1s',samps1s'+1024,zeros(size(samps1s'))];
    meg=pow(trl,LRpairs);
    cfg=[];
    cfg.bsfilter='yes';
    cfg.bsfreq=Afreqs;
    megNotch=ft_preprocessing(cfg,meg);
    if ~exist('seg.mat','file')
        mri=ft_read_mri('MRI/ortho.nii');
        cfg           = [];
        cfg.coordsys  = '4d';
        cfg.output    = {'skullstrip' 'brain'};
        seg           = ft_volumesegment(cfg, mri);
    else
        load seg.mat
    end
    cfg           = [];
    cfg.method    = 'singleshell';
    vol           = ft_prepare_headmodel(cfg,seg);
    
    
    
    cfg = [];
    cfg.covariance = 'yes';
    % cfg.covariancewindow = [-inf 0];
    cfg.keeptrials='yes';
    cov = ft_timelockanalysis(cfg, meg);
    
    covnoise = ft_timelockanalysis(cfg, megNotch);
%     cov=covnoise;
%     cov.trial=cov.trial;
    
    cfg = [];
    cfg.channel ='MEG';
    cfg.grid.pos = vol.bnd.pnt;
    cfg.grid.inside = [1:size(vol.bnd.pnt,1)]';
    cfg.vol = vol;
    cfg.grad=ft_convert_units(meg.grad,'cm');
    leadfield = ft_prepare_leadfield(cfg);
    
    
    
    cfg=[];
    cfg.method = 'mne';
    cfg.grid = leadfield;
    cfg.vol = vol;
    % cfg.mne.lambda = 1.2e9;
    cfg.mne.lambda = 3;
    cfg.mne.prewhiten = 'yes';
    cfg.mne.scalesourcecov = 'yes';
    covnoise.grad=ft_convert_units(meg.grad,'cm')
    cov.grad=ft_convert_units(meg.grad,'cm')
%    cfg.singletrial   = 'yes';%   construct filter from average, apply to single trials
%    cfg.rawtrial='yes';
    cfg.keepfilter='yes';
    sourceFilt = ft_sourceanalysis(cfg,covnoise);
    cfg.grid.filter=sourceFilt.avg.filter;
    cfg.rawtrial='yes';
    clear leadfield meg megNotch
    if exist('mneFilt.mat','file')
        load mneFilt
    else
        sourcenoise = ft_sourceanalysis(cfg,covnoise);
        ns=ft_sourcedescriptives([],sourcenoise);
        save mneFilt cfg ns
        disp('run it again, memory issues')
        return
    end

    source=ft_sourceanalysis(cfg,cov);
    src=ft_sourcedescriptives([],source);
    clear source
    
    
    figure;
    bnd.pnt=vol.bnd.pnt;
    bnd.tri=vol.bnd.tri;
    pow=mean(src.avg.pow-ns.avg.pow,2);
    pow=pow./max(pow);
    ft_plot_mesh(bnd, 'vertexcolor', pow);
    hs=ft_read_headshape('hs_file');
    hs=ft_convert_units(hs,'cm');
    hold on
    plot3pnt(hs.pnt,'.')
    save mne hs pow bnd
end



function data=pow(trl,LRpairs)
EEG=true;
if length(LRpairs)==115
    EEG=false;
end
cfg=[];
cfg.trl=trl;
cfg.channel='MEG';
if EEG
    cfg.channel='EEG';
end
cfg.demean='yes';
cfg.feedback='no';
if EEG
    data=readCNT(cfg);
else
    LSclean=ls('*lf*');
    cfg.dataset=LSclean(1:end-1);
    data=ft_preprocessing(cfg);
end






