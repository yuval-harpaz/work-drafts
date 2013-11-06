function aliceAlphaBdics(Afreq)
noiseFreq=175;
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
    
    cfg                        = [];
    cfg.feedback               = 'no';
    cfg.grad = meg.grad;
    cfg.headshape='hs_file';
    cfg.singlesphere='yes';
    cfg.feedback='no';
    vol  = ft_prepare_localspheres_BIU(cfg);
    %     showHeadInGrad([],'m');
    %     hold on;
    %     ft_plot_vol(vol);
    cfg                 = [];
    cfg.grad            = meg.grad;
    cfg.vol             = vol;
    cfg.reducerank      = 2;
    cfg.channel         = 'MEG';
    cfg.grid.resolution = 0.01;   % use a 3-D grid with a 1 cm resolution
    cfg.feedback='no';
    [grid] = ft_prepare_leadfield(cfg);
    
    
    % cfg = [];
    % cfg.method    = 'mtmfft';
    % cfg.output    = 'powandcsd';
    % cfg.tapsmofrq = 1;
    % cfg.foilim    = [10 10];
    % megCSD = ft_freqanalysis(cfg, meg);
    cfg=[];
    cfg.output       = 'powandcsd';
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = [Afreq noiseFreq];
    cfg.feedback='no';
    %cfg.keeptrials='yes';
    megCSD = ft_freqanalysis(cfg, meg);
    
    
    
    cfg              = [];
    cfg.method       = 'dics';
    cfg.frequency    = Afreq;
    cfg.grid         = grid;
    cfg.vol          = vol;
    cfg.dics.projectnoise = 'yes';
    cfg.dics.lambda       = 0;
    cfg.feedback='no';
    src = ft_sourceanalysis(cfg, megCSD);
    cfg.frequency    = noiseFreq;
    noise=ft_sourceanalysis(cfg, megCSD);
    src.nai=src.avg.pow./noise.avg.pow;
    %src.nai(isnan(src.nai))=0;
    
    %!3dcopy MRI/ortho+orig MRI/ortho.nii
    %% sourceplot (upside down)
    % mri=ft_read_mri('MRI/ortho.nii');
    % cfg = [];
    % cfg.parameter = 'nai';
    % inai = sourceinterpolate(cfg, src,mri);
    % cfg=[];
    % %cfg.funparameter='avg.pow';
    % cfg.interactive='yes';
    % cfg.funparameter='nai';
    % ft_sourceplot(cfg,inai);
    
    %% Brik
    %mat=reshape(src.nai,19,19,19);
    nfn=['rest1_',num2str(Afreq),'Hz_dics'];
    cd MRI
    cfg=[];
    cfg.boxSize=1000*[min(src.pos(:,1)),max(src.pos(:,1)),min(src.pos(:,2)),max(src.pos(:,2)),min(src.pos(:,3)),max(src.pos(:,3))];
    cfg.step=10;
    cfg.prefix=nfn;
    ft2Brik(cfg,src.nai')
    
    eval(['!@auto_tlrc -apar ortho+tlrc -input ',nfn,'+orig -dxyz 5'])
    eval(['!mv ',nfn,'+tlrc.BRIK ~/Copy/MEGdata/alice/func/B/',nfn,'_',num2str(sfi),'+tlrc.BRIK']);
    eval(['!mv ',nfn,'+tlrc.HEAD ~/Copy/MEGdata/alice/func/B/',nfn,'_',num2str(sfi),'+tlrc.HEAD']);
    cd ..
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






