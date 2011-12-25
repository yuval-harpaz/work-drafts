
fileName='c,rfhp0.1Hz';
% cleanPeriods=findCleanPeriods(fileName);
% goodPeriods=sumGoodPeriods(fileName,cleanPeriods,[]);

for segi=1:size(goodPeriods,2)
    p=pdf4D(fileName);
    cleanCoefs = createCleanFile(p, fileName,...
        'byLF',256 ,'Method','Adaptive',...
        'xClean',[4,5,6],...
        'CleanPartOnly',[goodPeriods(1,segi) goodPeriods(2,segi)],...
        'chans2ignore',[74,204],...
        'outFile','temp2',...
        'noQuestions',1,...
        'byFFT',0,...
        'HeartBeat',[],... % for automatic HB cleaning change 0 to []
        'maskTrigBits', []);
    if exist('temp1','file')
        !rm temp1
    end
    !mv temp2 temp1
    fileName='temp1';
    %close all
end
eval(['!mv temp1 per_',fileName]);
p=pdf4D(fileName);
hdr=get(p,'header');
lat=[1 hdr.epoch_data{1,1}.pts_in_epoch];
chi=channel_index(p,'MEG','name');
orig=mean(read_data_block(p,lat,chi),1);
p=pdf4D(['per_',fileName]);
clean=mean(read_data_block(p,lat,chi),1);
plot(orig,'r');hold on;plot(clean,'g');
