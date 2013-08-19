function [Itroughs,Ipeaks,avgTC,timeCourse]=findCompLims(cfg,varargin)
% Detect limits of event related components based on minimum points
% Use as
%   [times] = findCompLims(cfg, avg1, avg2, avg3, ...)
%
% avg1 is a fieldtrip structure. put many if you want to use more than one
%   subject or conditions. can be average or grand average.
% cfg.channel is optional for restricting the search for a channel selection (say
%   posterior for visual components)
%   e.g., cfg.channel = {'A1', 'A10', 'A11', 'A12', 'A13', 'A14', 'A26', 'A27', 'A28', 'A29', 'A30', 'A31', 'A45', 'A46', 'A47', 'A48', 'A49', 'A50', 'A51', 'A52', 'A53', 'A70', 'A71', 'A72', 'A73', 'A74', 'A75', 'A76', 'A77', 'A78', 'A79', 'A80', 'A99', 'A100', 'A101', 'A102', 'A103', 'A104', 'A105', 'A106', 'A107', 'A108', 'A109', 'A110', 'A111', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A138', 'A139', 'A140', 'A141', 'A142', 'A143', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A167', 'A168', 'A169', 'A170', 'A171', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A198', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A209', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243', 'A244'};
% cfg.method can be:
%   - rms, minimum points on RMS curves
%   - yzero, see where the butterfly lines cross y=0
%   - absMean, channels are averaged after flipping upside-down channels with
%       negative correlation
%   - svd, use component analysis to take only comps with ERF
% I recommend rms and absMean methods.
% cfg.notBefore limits the first timepoint to look for components;
% cfg.notAfter limits the last timepoint to look for components;
% cfg.maxDist is the max time you want from peak to through

timeCourse=zeros(length(varargin),length(varargin{1,1}.time));
if ~isfield(cfg,'notBefore')
    cfg.notBefore=0;
end
if ~isfield(cfg,'notAfter')
    cfg.notAfter=varargin{1,1}.time(end);
end
if ~isfield(cfg,'zThr')
    cfg.zThr=1.5;
end
sampRate=1/(varargin{1,1}.time(2)-varargin{1,1}.time(1));
if ~isfield(cfg,'maxDist')
    maxDist=round(0.15*sampRate);
else
    maxDist=round(cfg.maxDist*sampRate);
end
sampNB=nearest(varargin{1,1}.time,cfg.notBefore);
sampNA=nearest(varargin{1,1}.time,cfg.notAfter);
for avgi=1:length(varargin)
    avgData=varargin{1,avgi};
    samp0=nearest(avgData.time,0);
    %% arranging channel index
    if avgi==1
        if ~isfield(cfg,'channel')
            cfg.channel=[];
        end
        if isfield(avgData,'grad') || ~isempty(find(ismember(avgData.label,'A1'), 1))
            isMEG=true;
            if isempty(cfg.channel)
                cfg.channel={'A22','A2','A104','A241','A138','A214','A71','A26','A93','A39','A125','A20','A65','A9','A8','A95','A114','A175','A16','A228','A35','A191','A37','A170','A207','A112','A224','A82','A238','A202','A220','A28','A239','A13','A165','A204','A233','A98','A25','A70','A72','A11','A47','A160','A64','A3','A177','A63','A155','A10','A127','A67','A115','A247','A174','A194','A5','A242','A176','A78','A168','A31','A223','A245','A219','A12','A186','A105','A222','A76','A50','A188','A231','A45','A180','A99','A234','A215','A235','A181','A38','A230','A91','A212','A24','A66','A42','A96','A57','A86','A56','A116','A151','A141','A120','A189','A80','A210','A143','A113','A27','A137','A135','A167','A75','A240','A206','A107','A130','A100','A43','A200','A102','A132','A183','A199','A122','A19','A62','A21','A229','A84','A213','A55','A32','A85','A146','A58','A60','A88','A79','A169','A54','A203','A145','A103','A163','A139','A49','A166','A156','A128','A68','A159','A236','A161','A121','A4','A61','A6','A126','A14','A94','A15','A193','A150','A227','A59','A36','A225','A195','A30','A109','A172','A108','A81','A171','A218','A173','A201','A74','A29','A164','A205','A232','A69','A157','A97','A217','A101','A124','A40','A123','A153','A178','A1','A179','A33','A147','A117','A148','A87','A89','A243','A119','A52','A142','A211','A190','A53','A192','A73','A226','A136','A184','A51','A237','A77','A129','A131','A198','A197','A182','A46','A92','A41','A90','A7','A23','A83','A154','A34','A17','A18','A248','A149','A118','A208','A152','A140','A144','A209','A110','A111','A244','A185','A246','A162','A106','A187','A48','A221','A196','A133','A158','A44','A134','A216'};
            end
            if strcmp(cfg.channel,'MEG');
                cfg.channel = {'A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10', 'A11', 'A12', 'A13', 'A14', 'A15', 'A16', 'A17', 'A18', 'A19', 'A20', 'A21', 'A22', 'A23', 'A24', 'A25', 'A26', 'A27', 'A28', 'A29', 'A30', 'A31', 'A32', 'A33', 'A34', 'A35', 'A36', 'A37', 'A38', 'A39', 'A40', 'A41', 'A42', 'A43', 'A44', 'A45', 'A46', 'A47', 'A48', 'A49', 'A50', 'A51', 'A52', 'A53', 'A54', 'A55', 'A56', 'A57', 'A58', 'A59', 'A60', 'A61', 'A62', 'A63', 'A64', 'A65', 'A66', 'A67', 'A68', 'A69', 'A70', 'A71', 'A72', 'A73', 'A74', 'A75', 'A76', 'A77', 'A78', 'A79', 'A80', 'A81', 'A82', 'A83', 'A84', 'A85', 'A86', 'A87', 'A88', 'A89', 'A90', 'A91', 'A92', 'A93', 'A94', 'A95', 'A96', 'A97', 'A98', 'A99', 'A100', 'A101', 'A102', 'A103', 'A104', 'A105', 'A106', 'A107', 'A108', 'A109', 'A110', 'A111', 'A112', 'A113', 'A114', 'A115', 'A116', 'A117', 'A118', 'A119', 'A120', 'A121', 'A122', 'A123', 'A124', 'A125', 'A126', 'A127', 'A128', 'A129', 'A130', 'A131', 'A132', 'A133', 'A134', 'A135', 'A136', 'A137', 'A138', 'A139', 'A140', 'A141', 'A142', 'A143', 'A144', 'A145', 'A146', 'A147', 'A148', 'A149', 'A150', 'A151', 'A152', 'A153', 'A154', 'A155', 'A156', 'A157', 'A158', 'A159', 'A160', 'A161', 'A162', 'A163', 'A164', 'A165', 'A166', 'A167', 'A168', 'A169', 'A170', 'A171', 'A172', 'A173', 'A174', 'A175', 'A176', 'A177', 'A178', 'A179', 'A180', 'A181', 'A182', 'A183', 'A184', 'A185', 'A186', 'A187', 'A188', 'A189', 'A190', 'A191', 'A192', 'A193', 'A194', 'A195', 'A196', 'A197', 'A198', 'A199', 'A200', 'A201', 'A202', 'A203', 'A204', 'A205', 'A206', 'A207', 'A208', 'A209', 'A210', 'A211', 'A212', 'A213', 'A214', 'A215', 'A216', 'A217', 'A218', 'A219', 'A220', 'A221', 'A222', 'A223', 'A224', 'A225', 'A226', 'A227', 'A228', 'A229', 'A230', 'A231', 'A232', 'A233', 'A234', 'A235', 'A236', 'A237', 'A238', 'A239', 'A240', 'A241', 'A242', 'A243', 'A244', 'A245', 'A246', 'A247', 'A248'};
            end
        elseif ~isempty(find(ismember(avgData.label,'Cz'), 1))
            isEEG=true;
            % excludes EOG and Mastoid channels
            if isempty(cfg.channel)
                cfg.channel={ 'Fp1' 'Fpz' 'Fp2' 'F7' 'F3' 'Fz' 'F4' 'F8' 'FC5' 'FC1' 'FC2' 'FC6' 'T7' 'C3' 'Cz' 'C4' 'T8' 'CP5' 'CP1' 'CP2' 'CP6' 'P7' 'P3' 'Pz' 'P4' 'P8' 'POz' 'O1' 'Oz' 'O2'};
            end
        else
            error('what is this data, EEG or MEG?')
        end
        
        for chi=1:length(cfg.channel)
            [~,ind]=ismember(cfg.channel{chi},avgData.label);
            chansi(chi)=ind;
        end
    end
    if isfield(avgData,'individual')
        avgData.avg=squeeze(mean(avgData.individual,1));
        avgData.dimord='chan_time';
        rmfield(avgData,'individual');
    end
    %% make a trace for extrema detection
    switch cfg.method
        case 'rms'
            timeCourse(avgi,:)=sqrt(mean(avgData.avg(chansi,:).*avgData.avg(chansi,:),1));
        case 'yzero'
            avg=avgData.avg(chansi,:);
            avgShift=zeros(size(avg));
            avgShift(:,2:end)=avg(:,1:end-1);
            cros=avgShift.*avg>0;
            timeCourse(avgi,:)=sum(cros);
        case 'absMean'
            data4mean=avgData.avg(chansi,:);
            %for row=2:size(data4mean,1)
            % Here we want to flip channels with negative correlations
            r=corr(data4mean(:,sampNB:sampNA)');
            rcount=size(r,1);
            [~,ri]=min(min(r));
            %[~,ci]=min(r(ri,:))
            for chani=1:size(r,1)
                if r(ri,chani)<-0.25
                    data4mean(chani,:)=-data4mean(chani,:);
                end
            end
            timeCourse(avgi,:)=abs(mean(data4mean));
        case 'svd'
            cfgc=[];
            cfgc.method='svd';
            comp=ft_componentanalysis(cfgc,avgData);
            nComp=10;
            % test which components have something after time zero
            % (large percentile 75 compared to baseline)
            test=prctile(abs(comp.trial{1,1}(1:nComp,samp0:end))',75)./prctile(abs(comp.trial{1,1}(1:nComp,1:samp0))',75);
            timeCourse(avgi,:)=mean(abs(comp.trial{1,1}(find(test>1.3),:)));
    end
end
%% find peaks on abs timecourse
if size(timeCourse,1)>1
    avgTC=mean(timeCourse);
else
    avgTC=timeCourse;
end
[peaks, Ipeaks] = findPeaks(avgTC,cfg.zThr, 50, []);
if isempty(peaks)
    error('no peaks! check threshold, check notAfter, do something!')
end
% keep peaks that are between requested limits
after=find(Ipeaks>sampNB);
peaks=peaks(after);
Ipeaks=Ipeaks(after);
before=find(Ipeaks<sampNA);
peaks=peaks(before);
Ipeaks=Ipeaks(before);
%% look for troughs
der=zeros(size(avgTC));
der(2:end-1)=diff(diff(avgTC./max(avgTC)));
maxy=max(avgTC);
for peaki=1:length(peaks);
    % check the latest: sampNB, maxDist or previous peak
    startI=Ipeaks(peaki)-maxDist;
    if sampNB>startI
        startI=sampNB;
    end
    if peaki>1
        if Ipeaks(peaki-1)>startI
            startI=Ipeaks(peaki-1);
        end
    end
    % check the earliest: sampNA, maxDist or next peak
    endI=Ipeaks(peaki)+maxDist-1;
    if sampNA<endI
        endI=sampNA;
    end
    if peaki<length(peaks)
        if Ipeaks(peaki+1)<endI
            endI=Ipeaks(peaki+1);
        end
    end
    % look for peaks in -avgTC (troughs)
    X=-avgTC(startI:endI);
    [miny, minyI] = findPeaks(X,0, 10, []);
    minyI=minyI+startI-1;
    nearZero=find(-miny<maxy/20);
    if isempty(nearZero);
        trgh1=[];
        trgh2=[];
    else
        miny=miny(nearZero);
        minyI=minyI(nearZero);
        trgh1=find(minyI<Ipeaks(peaki),1,'last');
        trgh2=find(minyI>Ipeaks(peaki),1);
    end
    if isempty(trgh1)
   
        [troughs(peaki,1),Itroughs(peaki,1)]=min(avgTC(startI:Ipeaks(peaki)));
        Itroughs(peaki,1)=Itroughs(peaki,1)+startI-1;
        warning('no trough detected by find peaks, taking min')
        disp(['before peak no. ',num2str(peaki),' at time ',num2str(avgData.time(Itroughs(peaki,1)))]);
    else
        Itroughs(peaki,1)=minyI(trgh1);
        troughs(peaki,1)=avgTC(Itroughs(peaki,1));
    end
    if isempty(trgh2)
        
        [troughs(peaki,2),Itroughs(peaki,2)]=min(avgTC(Ipeaks(peaki):endI));
        Itroughs(peaki,2)=Itroughs(peaki,2)+Ipeaks(peaki)-1;
        warning('no trough detected by find peaks, taking min')
        disp(['after peak no. ',num2str(peaki),' at time ',num2str(avgData.time(Itroughs(peaki,2)))]);
    else
        Itroughs(peaki,2)=minyI(trgh2);
        troughs(peaki,2)=avgTC(Itroughs(peaki,2));
    end
    %[miny,minyI]=min(avgTC(startI: endI));
    %minyI=minyI+startI-1;
    %         troughs(peaki)=miny;
    %         Itroughs(troughi)=minyI;
    %     elseif troughi==length(peaks)+1
    %         if length(avgData.time)-Ipeaks(end)<maxDist
    %             endI=length(avgData.time);
    %             %maxDist=length(avgData.time)-Ipeaks(end);
    %         else
    %             endI=Ipeaks(end)+maxDist-1;
    %         end
    %         [miny,minyI]=min(avgTC(Ipeaks(end):endI));
    %         minyI=minyI+Ipeaks(end)-1;
    %         troughs(troughi)=miny;
    %         Itroughs(troughi)=minyI;
    %     else
    %         Istart=Ipeaks(troughi-1);
    %         if Ipeaks(troughi)-Ipeaks(troughi-1)<maxDist
    %             Iend=Ipeaks(troughi);
    %         else
    %             Iend=Ipeaks(troughi-1)+maxDist;
    %         end
    %         [miny,minyI]=min(avgTC(Istart:Iend));
    %         minyI=minyI+Ipeaks(troughi-1)-1;
    %         troughs(troughi)=miny;
    %         Itroughs(troughi)=minyI;
    %     end
end
figure;
plot(avgData.time,avgTC)
hold on
plot(avgData.time(Ipeaks),peaks,'r.')
plot(avgData.time(Itroughs(:,1)),troughs(:,1),'go')
plot(avgData.time(Itroughs(:,2)),troughs(:,2),'kx')

legend('timecourse','peaks','troughs before','troughs after')
%     function [miny,minyI]=findTrough(avgTC,sampLim)
%         [miny,minyI]=min(avgTC(sampLim(1):sampLim(2)));
%         [miny, minyI] = findPeaks(avgTC,cfg.zThr, 50, []);
%         minyI=minyI+startI-1;
%         troughs(peaki)=miny;
%         % Itroughs(troughi)=minyI;
%     end
end



% %% detect minima as component bounderies
%
% [~,startE100]=min(rmsEEG(nearest(avgE2.time,0.045):nearest(avgE2.time,0.1)));
% startE100=startE100+nearest(avgE2.time,0.045)-1;
% [~,startE170]=min(rmsEEG(nearest(avgE2.time,0.1):nearest(avgE2.time,0.17)));
% startE170=startE170+nearest(avgE2.time,0.1)-1;
% [~,startE300]=min(rmsEEG(nearest(avgE2.time,0.17):nearest(avgE2.time,0.3)));
% startE300=startE300+nearest(avgE2.time,0.17)-1;
% [~,startE400]=min(rmsEEG(nearest(avgE2.time,0.3):nearest(avgE2.time,0.4)));
% startE400=startE400+nearest(avgE2.time,0.3)-1;
% endE400=find(diff(rmsEEG(nearest(avgE2.time,0.45):end))>-0.0055,1)+nearest(avgE2.time,0.45);
% figure;
% %% MEG
%
% [~,startM100]=min(rmsMEG(nearest(avgM2.time,0.045):nearest(avgM2.time,0.1)));
% startM100=startM100+nearest(avgM2.time,0.045)-1;
% [~,startM170]=min(rmsMEG(nearest(avgM2.time,0.1):nearest(avgM2.time,0.17)));
% startM170=startM170+nearest(avgM2.time,0.1)-1;
% [~,startM300]=min(rmsMEG(nearest(avgM2.time,0.17):nearest(avgM2.time,0.3)));
% startM300=startM300+nearest(avgM2.time,0.17)-1;
% [~,startM400]=min(rmsMEG(nearest(avgM2.time,0.3):nearest(avgM2.time,0.4)));
% startM400=startM400+nearest(avgM2.time,0.3)-1;
% endM400=find(diff(rmsMEG(nearest(avgM2.time,0.45):end))>-0.0055,1)+nearest(avgM2.time,0.45);
%
% yE=rmsEEG/max(rmsEEG);
% yM=rmsMEG/max(rmsMEG);
% figure;
% plot(avgE2.time,yE)
% hold on
% plot(avgM2.time,yM,'k')
% plot(avgE2.time([startE100,startE170,startE300,startE400,endE400]),yE([startE100,startE170,startE300,startE400,endE400]),'ro')
% plot(avgM2.time([startM100,startM170,startM300,startM400,endM400]),yM([startM100,startM170,startM300,startM400,endM400]),'go')
% legend('EEG','MEG')
% save files/times start* end* rms*
% end