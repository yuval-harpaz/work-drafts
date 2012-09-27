function peaks=peaks1c1f(cfg,data)
% requires:
% data = a fieldtrip data sturcture
% cfg.channel = 'A191';  just one channel here
% cfg.deadSamples = 60;  not to find two peaks within this sample range
% cfg.template = a vector with template data, unnormalized

% cfg1.feedback='no';
% cfg1.channel=cfg.channel;
% dataAvg=ft_timelockanalysis(cfg1,data);

peaks=struct;
peaks.label{1,1}=cfg.channel;
peaks.wlt{1,1}=cfg.template;
% baseline correction for the template
tapBlc = peaks.wlt{1,1}-mean(peaks.wlt{1,1});
% normalizing the template
tmplt=tapBlc./sqrt(sum(tapBlc.*tapBlc));
% find max point for the template
[~,time0]=max(tmplt);
t=data.time{1,1};

for triali=1:length(data.trial)
    x=data.trial{1,triali};
    [SNR,~,sigSign]=fitTemp(x,tmplt,time0);
    SNRn=SNR.*sigSign;
    peaks.chan{1,1}.trial{1,triali}.time=[];
    peaks.chan{1,1}.trial{1,triali}.SNR=[];
    peaks.chan{1,1}.trial{1,triali}.wlti=1;
    try %#ok<TRYNC>
        [~, SigIpeaks] = findPeaks(abs(SNRn),1,cfg.deadSamples, 'MAD');
        if ~isempty(SigIpeaks)
            peaks.chan{1,1}.trial{1,triali}.time=t(SigIpeaks);
            peaks.chan{1,1}.trial{1,triali}.SNR=SNRn(SigIpeaks);
        end
    end
    if isempty(peaks.chan{1,1}.trial{1,triali}.time)
        display(['nothoing for trial ',num2str(triali)]);
    end
end