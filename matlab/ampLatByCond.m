function trialinfo=ampLatByCond(trialinfo,peaks,timewini,data,chani,smooth,snrThr)
timewini=num2str(timewini);
for triali=1:length(trialinfo)
    cond=num2str(trialinfo(triali,1));
    try
    eval(['spki=find(peaks.cond',cond,'pos.timewin{1,',timewini,'}(:,1)==',num2str(triali),');']);
    catch
        eval(['spki=find(peaks.cond',cond,'neg.timewin{1,',timewini,'}(:,1)==',num2str(triali),');']);
    end
    if isempty(spki)
        trialinfo(triali,2:3)=NaN;
    else
        try
        eval(['snr=peaks.cond',cond,'pos.timewin{1,',timewini,'}(spki,3);'])
        catch
            eval(['snr=peaks.cond',cond,'neg.timewin{1,',timewini,'}(spki,3);'])
        end
        if abs(snr)>snrThr
            try
            eval(['peakT=peaks.cond',cond,'pos.timewin{1,',timewini,'}(spki,2);'])
            catch
                eval(['peakT=peaks.cond',cond,'neg.timewin{1,',timewini,'}(spki,2);'])
            end
            peakS=nearest(data.time{1,1},peakT);
            sWin=peakS-smooth:peakS+smooth;
            trialinfo(triali,2)=mean(data.trial{1,triali}(chani,sWin));
            trialinfo(triali,3)=peakT;
        else
            trialinfo(triali,2:3)=NaN;
        end
    end
end