function ambURsourceloc(subs)
cd /home/yuval/Data/amb
%load 25DM.mat
%load 25SM.mat
isdom=0;
filtChanInd=[6,8,20,21,23,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,150,151,154,155,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271];
for subi=subs
    substr=num2str(subi);
    cd(substr);
    load m170dom
    load m170sub
    load URc
    for diri=[1 3];
        dirstr=num2str(diri);
        cd(dirstr)
        if exist('Dom.mrk','file')
            isdom=1;
        else
            isdom=0;
        end
        load sourceGlobal
        %load modelSpheres
        load MRIcr
        srcN 	   = length(sourceGlobal.inside);
                %% SAMerf, apply the spatial filter (weights) on the averaged data
        if isdom
            avgData=ft_timelockanalysis([],DomURc);
        else
            avgData=ft_timelockanalysis([],SubURc);
        end
%        EMSEdata=DM.re(1:1017,:,subi)';
%        ismeg=ismember(dataorig.label,dataorig.grad.label(1:248,1));
        for i=1:srcN,
            m = sourceGlobal.inside(i);
            if ~isempty(sourceGlobal.avg.filter{m})
%                sourceAvg.mom{m} = sourceGlobal.avg.filter{m}(1,ismeg)*EMSEdata;
                sourceAvg.mom{m} = sourceGlobal.avg.filter{m}(1,filtChanInd)*avgData.avg;

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
%         save MRIcr MRIcr

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


