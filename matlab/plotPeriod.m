function plotPeriod(fileName,cleanPeriods,chan,goodPeriod,pad)
% plots the noisy period following the good period indexed by period
p=pdf4D(fileName);
%sampleRate=get(p,'dr');
% PAD=round(pad.*sampleRate);
noisePeriodStart=cleanPeriods{1,chan}(2,goodPeriod);
if goodPeriod+1>length(cleanPeriods{1,chan})
    error(['no noise after period ',num2string(goodPeriod)])
end
noisePeriodEnd=cleanPeriods{1,chan}(1,(goodPeriod+1));
%timeline=periodt(1):(1/sampleRate):periodt(2);

lat=lat2ind(p,1,[noisePeriodStart-pad noisePeriodEnd+pad]);
data=read_data_block(p,lat,channel_index(p,'MEG','name'));
timeline=lat(1):lat(2);
timeline=timeline/1017.25;
figure;
plot(timeline,data,'k');
hold on;
plot(timeline,data(chan,:),'r');
end