function ambFTsource(subs)
%FIXME designed to test different source loc methods
cd /home/yuval/Data/amb
%load 25DM.mat
%load 25SM.mat
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
        load dataorig
        
        load modelSpheres
        %% calculating covariance for all the trials
        cfg7                  = [];
        cfg7.covariance       = 'yes';
        cfg7.removemean       = 'no';
        cfg7.channel={'MEG','MEGREF'};
        cfg7.keeptrials='yes';
        cov=timelockanalysis(cfg7, dataorig);
        save cov cov
        hdr=read_4d_hdr_BIU(fileName);
        grad=bti2grad_BIU(hdr);
        grad=ft_convert_units(grad,'mm');
        cov.grad=grad;
        cfg8        = [];
        cfg8.method = 'sam'; % 'mne'
        cfg8.grid= grid;
        cfg8.vol    = vol;
        cfg8.lambda = 0.05;
        cfg8.keepfilter='yes';
        cfg.rawtrial='yes';
        %cfg8.fixedori='robert'; % 'stephen' doesn't work; default is spinning.
        sourceGlobal = ft_sourceanalysis(cfg8, cov);
        save sourceGlobal sourceGlobal
        
        
        %% reconstructing source trace
        
        trialN     = size(dataorig.trial,2);
        [sensN tN] = size(dataorig.trial{1});
        srcN 	   = length(sourceGlobal.inside);
        
        % for every trial
        % for i=1:srcN,
        %     m = sourceGlobal.inside(i);
        %     if ~isempty(sourceGlobal.avg.filter{m}),
        %         fprintf('beamforming source %d/%d\n',i,srcN);
        %
        %         %beamforming
        %         for j = 1:trialN,
        %             sourceGlobal.trial(j).mom{m} =...
        %                 sourceGlobal.avg.filter{m}*dataorig.trial{j};
        %         end
        %
        %     end
        % end
        
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
        timewin=[0.15 0.235];
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
        if ~exist('sMRI','var');
            load ~/ft_BIU/matlab/files/sMRI.mat
        end
        MRIcr=sMRI;
        MRIcr.transform=inv(M1)*sMRI.transform; %cr for
        save MRIcr MRIcr
        cfg10 = [];
        cfg10.parameter = 'all';
        if isdom
            dom = ft_sourceinterpolate(cfg10, source,MRIcr)
            save  ../dom dom
        else
            sub = ft_sourceinterpolate(cfg10, source,MRIcr)
            save  ../sub sub
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


