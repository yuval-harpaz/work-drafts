%% connectomeDB

% to use all default options and save data to file
correctHB;

% cancel the 5 size categories approach with ampLinThr=0, use 1 size
% template for all heartbeat
% use 1Hz highpass filter
% ignore channel A2
% requesting output arguments cancel the saving to file. save 4D data with
% rewrite_pdf (pdf is another name for 4D-Neuroimaging data format. another
% name used in this context is magnes file format).
% 
fn='c,rfDC';
cfg=[];
cfg.badChan=2; %A2 
cfg.ampLinThr=0;
cfg.dataFiltFreq=1;
[data1cat,HBtimes,~,~,~,Rtopo]=correctHB(fn,[],[],[],cfg);
rewrite_pdf(data1cat,[],[],'1cat')
