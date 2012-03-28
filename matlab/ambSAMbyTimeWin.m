function ambSAMbyTimeWin(subs,timewin,prefix,interp)
% I first used ambFT for the M170.
% ambSAMbyTimeWin([1:25],[0.235 0.39],'M350')
% interp=1 to interpolate
cd /home/yuval/Data/amb
%load 25DM.mat
%load 25SM.mat
if ~exist('interp','var')
    interp=[];
end
if isempty(interp)
    interp=1;
end
    
isdom=0;
for subi=subs
    substr=num2str(subi);
    cd(substr);
    for diri=[1 3];
        dirstr=num2str(diri);
        cd(dirstr)
        if exist('Dom.mrk','file')
            isdom=1;
        else
            isdom=0;
        end
        % fixFT4BIU
        
        %% loading the data
        load dataorig
        load sourceGlobal
        if interp==1
            load MRIcr % coregistered MRI from template
        end
        
        %% reconstructing source trace
        
        trialN     = size(dataorig.trial,2);
        [sensN tN] = size(dataorig.trial{1});
        srcN 	   = length(sourceGlobal.inside);
        
        %% SAMerf, apply the spatial filter (weights) on the averaged data
        avgData=ft_timelockanalysis([],dataorig);
%        EMSEdata=DM.re(1:1017,:,subi)';
%        ismeg=ismember(dataorig.label,dataorig.grad.label(1:248,1));
        for i=1:srcN,
            m = sourceGlobal.inside(i);
            if ~isempty(sourceGlobal.avg.filter{m})
%                sourceAvg.mom{m} = sourceGlobal.avg.filter{m}(1,ismeg)*EMSEdata;
                sourceAvg.mom{m} = sourceGlobal.avg.filter{m}*avgData.avg;

            end
        end
        
        % calculating NAI, dividing data of interest by noise
%        timewin=[0.15 0.235];
        samp1=nearest(avgData.time,timewin(1));
        sampEnd=nearest(avgData.time,timewin(2));
        noise1=nearest(avgData.time,timewin(1)-timewin(2));
        noiseEnd=nearest(avgData.time,0);
        pow=zeros(1,length(sourceGlobal.pos));
        noise=pow;
        for i=1:srcN,
            m = sourceGlobal.inside(i);
            if ~isempty(sourceGlobal.avg.filter{m})
                pow(m) = mean((sourceAvg.mom{m}(1,samp1:sampEnd)).^2);
                noise(m) = mean((sourceAvg.mom{m}(1,noise1:noiseEnd)).^2);
            end
        end
        nai=(pow-noise)./noise;
        source=sourceGlobal;source.avg.pow=pow;source.avg.nai=nai;source.avg.noise=noise;
        cfg10 = [];
        cfg10.parameter = 'all';
        if isdom
            if interp==1
                dom = ft_sourceinterpolate(cfg10, source,MRIcr)
            else
                dom=source;
            end
            save(['../',prefix,'dom'],'dom');
        else
            if interp==1
                sub = ft_sourceinterpolate(cfg10, source,MRIcr)
            else
                sub=source
            end
            save  (['../',prefix,'sub'], 'sub');
        end
        cd ..
    end
    cd ..
end

% cfg9 = [];
% cfg9.interactive = 'yes';
% cfg9.funparameter = 'avg.nai';
% cfg9.method='ortho';
% figure;ft_sourceplot(cfg9,inai)


