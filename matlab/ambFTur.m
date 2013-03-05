function ambFTur(subs)
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
        
        
        
        
        % fixFT4BIU
        
        %% reading the data
        fileName='rw_c,rfhp1.0Hz,lp';
        cfg= [];
        cfg.dataset=fileName; % change file name or path+name
        cfg.trialdef.eventtype='TRIGGER';
        if isdom
            cfg.trialdef.eventvalue=16; % all conditions.
        else
            cfg.trialdef.eventvalue=26;
        end
        cfg.trialdef.prestim=0.3;
        cfg.trialdef.poststim=0.7;
        cfg.trialdef.offset=-0.3;
        cfg.trialdef.visualtrig='visafter';
        cfg.trialdef.visualtrigwin=0.6;
        cfg.trialdef.powerline='yes'; % takes into account triggers that contain the electricity in the wall (+256).
        cfg.trialfun='BIUtrialfun';
        cfg1=ft_definetrial(cfg);
        cfg1.blc='yes';
        cfg1.continuous='yes';
        cfg1.channel={'MEG','MEGREF'};
        cfg1.blc='yes';
        cfg1.blcwindow=[-0.3,0];
        cfg1.bpfilter='yes';
        cfg1.bpfreq=[1 70];
        dataorig=ft_preprocessing(cfg1);
        save dataorigUR dataorig
        %avg=ft_timelockanalysis([],dataorig);
        % cfg=[];
        % cfg.layout='4D248.lay';
        % cfg.interactive='yes';
        % cfg.xlim = [0.15 0.15]; %time window in ms
        % cfg.electrodes = 'labels';
        % figure;
        % ft_topoplotER(cfg, avg);
        %% creating head model from template MRI and headshape
        
        %[vol,grid,mesh,M1,single]=headmodel_BIU('rw_c,rfhp1.0Hz,lp',[],[],[],'localspheres');
        % load modelSpheres vol grid mesh M1 single
        % calculating covariance for all the trials
%         cfg7                  = [];
%         cfg7.covariance       = 'yes';
%         cfg7.removemean       = 'no';
%         cfg7.channel={'MEG','MEGREF'};
%         cfg7.keeptrials='yes';
%         cov=timelockanalysis(cfg7, dataorig);
%         save covUR cov
%         hdr=read_4d_hdr_BIU(fileName);
%         grad=bti2grad_BIU(hdr);
%         grad=ft_convert_units(grad,'mm');
%         cov.grad=grad;
%         cfg8        = [];
%         cfg8.method = 'sam'; % 'mne'
%         cfg8.grid= grid;
%         cfg8.vol    = vol;
%         cfg8.lambda = 0.05;
%         cfg8.keepfilter='yes';
%         cfg.rawtrial='yes';
%         %cfg8.fixedori='robert'; % 'stephen' doesn't work; default is spinning.
%         sourceGlobal = ft_sourceanalysis(cfg8, cov);
        load sourceGlobal 
        
        
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
%         if ~exist('sMRI','var');
%             load ~/ft_BIU/matlab/files/sMRI.mat
%         end
%         MRIcr=sMRI;
%         MRIcr.transform=inv(M1)*sMRI.transform; %cr for
        load MRIcr
        cfg10 = [];
        cfg10.parameter = 'avg.pow';
        if isdom
            dom = ft_sourceinterpolate(cfg10, source,MRIcr)
            save  ../domur dom
        else
            sub = ft_sourceinterpolate(cfg10, source,MRIcr)
            save  ../subur sub
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


