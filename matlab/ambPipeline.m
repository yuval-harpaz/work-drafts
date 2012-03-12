% ambPipeline

%% run SAM beamforming for M170
% creates dom and sub.mat files for every subject
% cov for the whole trial
% weights applied on the averaged data
ambFT([1:25]);

%% grand averaging
% it also has statistics after grand averaging, I don't know if this part works.
ambGrAvg(1:25)

%% statistics M170
% runs montecarlo. if stat exists already only plots the statistics.
[cfg1,probplot,cfg2,statplot]=ambMonte('M350','subp','domp',0.995);

% by cluster
%[cfg1,probplot,cfg2,statplot]=ambMonteClust('Clust','subp','domp',0.95);
[cfg1,probplot,cfg2,statplot]=ambMonteClust('Cl01_M170','subp','domp',0.95,0.01);
%% now for M350

% aplying global weights on averaged data for 235-390ms
ambSAMbyTimeWin([1:25],[0.235 0.39],'M350')

% grandaveraging
ambGrAvg1([1:25],'M350')

% statistics
[cfg1,probplot,cfg2,statplot]=ambMonte('M350','M350subp','M350domp',0.995)
% statistics by cluster
[cfg1,probplot,cfg2,statplot]=ambMonteClust('Cl01_M350','M350subp','M350domp',0.95,0.01);

%% M350 main effect for hemisphere
% merge sub and dom
ambMergeSources('M350','pow');
% get the pretrigger noise value
ambGrAvg1([1:25],'M350','noise');
% merge the two noise conditions
ambMergeSources('M350','noise');
% change noise field to pow
load M350domsubN
for subi=1:25;
    M350domsubN.trial(1,subi).pow=M350domsubN.trial(1,subi).noise;
    %[M350domsubN.trial(1,subi)]=rmfield(M350domsubN.trial(1,subi),'noise');
end
save M350domsubN M350domsubN %  I was unable to remove noise field, identical to pow now.
[cfg1,probplot,cfg2,statplot]=ambMonteClust('Cl01_M350_ME','M350domsubp','M350domsubN',0.95,0.01);

[cfg1,probplot,cfg2,statplot]=ambMonteClust('Cl005_M350_ME','M350domsubp','M350domsubN',0.95,0.005);

%% masking
% create mask by:
% [source,intsource,grid,mesh]=makeMask('iskull');
% intsource1=intsource;
% cfg.keepindividual     = 'yes';
% cfg.parameter          = 'pow';
% Msk=ft_sourcegrandaverage(cfg,intsource,intsource1);
% inside=Msk.inside;outside=Msk.outside;
% save mask_innerskull inside outside
load /home/yuval/Data/amb/mask
% now there are masks for inner skull and cortex in ft_BIU/matlab/files
load M350domsubp
M350maskedp=M350domsubp;
M350maskedp.inside=inside;
M350maskedp.outside=outside;
save M350maskedp M350maskedp
load M350domsubN
M350maskedN=M350domsubN;
M350maskedN.inside=inside;
M350maskedN.outside=outside;
save M350maskedN M350maskedN
[cfg1,probplot,cfg2,statplot]=ambMonteClust('Cl005_M350masked_ME','M350maskedp','M350maskedN',0.95,0.005);
[cfg1,probplot,cfg2,statplot]=ambMonteClust('Cl01_M350masked_ME','M350maskedp','M350maskedN',0.95,0.01);

