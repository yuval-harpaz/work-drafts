cd /home/yuval/Data/Sasha
load subs
for subi=1:length(subs)
    hdr=ft_read_header(subs{subi});
    sRate=hdr.Fs;
    
    samp1=31000;%round(sRate*3);
    samp1Last=samp1+60*sRate;
    epoched=samp1+round(sRate):round(sRate):samp1Last;
    
    
    cfn=subs{subi};
    
    cfg=[];
    cfg.dataset=cfn;
    cfg.trl=epoched';
    cfg.trl(:,2)=cfg.trl+round(sRate);
    cfg.trl(:,3)=0;
    cfg.channel='MEGMAG';
    cfg.blc='yes';
    cfg.feedback='no';
    meg=ft_preprocessing(cfg);
    cfg=[];
    cfg.method='var';
    cfg.criterion='sd';
    cfg.critval=3;
    good=badTrials(cfg,meg,0);
    cfg=[];
    cfg.trials=good;
    cfg.output       = 'pow';
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = [3 6 9 10 11 12 15 20 25 30 40 50 60 70 80 90 100];
    cfg.feedback='no';
    %cfg.keeptrials='yes';
    megFr = ft_freqanalysis(cfg, meg);
    cfg=[];
    cfg.xlim=[9 9];
    cfg.layout = 'neuromag306mag.lay';
    cfg.interactive='yes';
    figure;
    ft_topoplotER(cfg,megFr)
    title(num2str(subi))
    save (['meg',num2str(subi)],'meg')
    save (['megFr',num2str(subi)],'megFr')
end

% checking planar for Tal's data
cd /home/yuval/Copy/MEGdata/alpha/tal
[stat,figure1,R,L]=aliceHemPlot('Closed',10,[0 1e-26],'paired-ttest','max');
[stat,figure1,R,L]=aliceHemPlot('Open',10,[0 1e-26],'paired-ttest','max');

load Open
load Closed
load grad
cfg=[];
cfg.method='distance';
cfg.grad=grad;
cfg.neighbourdist = 0.07; % default is 0.04m
neighbours = ft_prepare_neighbours(cfg);
neighbours=neighbours(1:248);


Closed.grad=grad;
cfg=[];
cfg.planarmethod   = 'orig';
cfg.neighbours     = neighbours;
cfg.layout='4D248.lay';
[interp] = ft_megplanar(cfg, Closed);
cfg=[];
cfg.combinegrad  = 'yes';
dom_cp = ft_combineplanar(cfg, interp)
cfgp = [];
cfgp.xlim=[0.1 0.1];
cfgp.layout = '4D248.lay';
figure;
ft_topoplotER(cfgp,dom_cp)
title('planar')
figure;
ft_topoplotER(cfgp,dom)
title('raw')

%% grads

cd /home/yuval/Data/Sasha
load subs
for subi=1:length(subs)
    hdr=ft_read_header(subs{subi});
    sRate=hdr.Fs;
    
    samp1=31000;%round(sRate*3);
    samp1Last=samp1+60*sRate;
    epoched=samp1+round(sRate):round(sRate):samp1Last;
    
    
    cfn=subs{subi};
    
    cfg=[];
    cfg.dataset=cfn;
    cfg.trl=epoched';
    cfg.trl(:,2)=cfg.trl+round(sRate);
    cfg.trl(:,3)=0;
    cfg.channel='MEGGRAD';
    cfg.blc='yes';
    cfg.feedback='no';
    meg=ft_preprocessing(cfg);
    cfg=[];
    cfg.method='var';
    cfg.criterion='sd';
    cfg.critval=3;
    good=badTrials(cfg,meg,0);
    cfg=[];
    cfg.trials=good;
    cfg.output       = 'pow';
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = [3 6 9 10 11 12 15 20 25 30 40 50 60 70 80 90 100];
    cfg.feedback='no';
    %cfg.keeptrials='yes';
    megFr = ft_freqanalysis(cfg, meg);
%     cfg=[];
%     cfg.xlim=[9 9];
%     cfg.layout = 'neuromag306planar.lay';
%     cfg.interactive='yes';
%     figure;
%     ft_topoplotER(cfg,megFr)
    title(num2str(subi))
    save (['grad',num2str(subi)],'meg')
    save (['gradFr',num2str(subi)],'megFr')
end

%% test head position
cd /home/yuval/Copy/MEGdata/alice
subs={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
for subi=1:8
    cd (subs{subi})
    load avgLR
    eval(['grad',num2str(subi),'=avgM10LR.grad;']);
    clear avg*
    cd ..
end
for subi=1:8
    eval(['origin(subi,1:3)=fitsphere(grad',num2str(subi),'.chanpos(1:248,:));'])
end
LR={'left','right'}
mo=1000*mean(origin(:,2));
disp('the )


