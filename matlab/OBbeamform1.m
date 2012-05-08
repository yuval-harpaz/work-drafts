function source=OBbeamform1(data,timewin,method,MRI,filter)
% data = averaged or raw
% timewin=[0.043657 0.075163];
% method = lcmv, sam or SAM to run with weights of SAMwts
% filter is the output of the function wts2filter or after running
% ft_sourceanalysis with keepfilter=yes
avg=false;
if ~exist('headmodel.mat','file')
    [vol,grid,mesh,M1]=headmodel_BIU([],[],[],[],'localspheres');
    save headmodel vol grid mesh M1
else
    load headmodel
end
data.grad=ft_convert_units(data.grad,'mm');
if isfield(data,'avg')
    avg=true;
end
if strcmp(method,'SAM')
    if ~exist('filter','var')
        error('SAM needs filter')
    end
elseif exist('filter','var')
    warning('filter is used')
end


if exist('filter','var')
    load source
    source.avg.filter=filter;
    if ~avg
        data=timelockanalysis([],data);
    end
else
    %    if ~avg
    cfg                  = [];
    cfg.covariance       = 'yes';
    cfg.removemean       = 'yes';
    if ~avg
        cfg.keeptrials='yes';
        
        if length(data.trial)>100
            cfg.trials=1:100;% memory failed on virtual machine
        end
    end
    cov=timelockanalysis(cfg, data);
    cfg8        = [];
    cfg8.method = method;
    cfg8.grid= grid;
    cfg8.vol    = vol;
    cfg8.lambda = 0.05;
    %cfg.channel={'MEG','MEGREF'};
    cfg8.keepfilter='yes';
    source = ft_sourceanalysis(cfg8, cov);
    if ~avg
        data=timelockanalysis([],data);
    end
end
%end
%if avg && ~exist('filter','var')
%     cfg                  = [];
%     cfg.covariance       = 'yes';
%     cfg.removemean       = 'no';
%     cfg.covariancewindow = [(timewin(1)-timewin(2)) 0];
%     %cfg.channel='MEG';
%     covpre=ft_timelockanalysis(cfg, data);
%     cfg.covariancewindow = [timewin(1) timewin(2)];
%     covpst=ft_timelockanalysis(cfg, data);
%     cfg8        = [];
%     cfg8.method = method;
%     cfg8.grid= grid;
%     cfg8.vol    = vol;
%     cfg8.lambda = 0.05;
%     cfg8.keepfilter='no';
%     spre = ft_sourceanalysis(cfg8, covpre);
%     source = ft_sourceanalysis(cfg8, covpst);
%     source.avg.nai=(source.avg.pow-spre.avg.pow)./spre.avg.pow;
% else
samp1=nearest(data.time,timewin(1));
sampEnd=nearest(data.time,timewin(2));
noise1=nearest(data.time,timewin(1)-timewin(2));
noiseEnd=nearest(data.time,0);
pow=zeros(1,length(source.pos));
noise=pow;
sourceAvg=struct;sourceAvg.mom={};
% multiply filter by data
for i=1:size(grid.inside,1)
    m = grid.inside(i);
    if ~isempty(source.avg.filter{m})
        sourceAvg.mom{m} = source.avg.filter{m}*data.avg;
        
    end
end
% calculating pow and nai
for i=1:size(grid.inside,1)
    m = source.inside(i);
    if ~isempty(source.avg.filter{m})
        pow(m) = mean((sourceAvg.mom{m}(1,samp1:sampEnd)).^2);
        noise(m) = mean((sourceAvg.mom{m}(1,noise1:noiseEnd)).^2);
        if strcmp(method,'lcmv');
            for yzi=2:3
                pow(m)=pow(m)+mean((sourceAvg.mom{m}(yzi,samp1:sampEnd)).^2);
                noise(m) = noise(m)+mean((sourceAvg.mom{m}(yzi,noise1:noiseEnd)).^2);
            end
        end
    end
end


nai=(pow-noise)./noise;
source.avg.pow=pow;source.avg.nai=nai;source.avg.noise=noise;
%end
% interpolate and plot
% load ~/ft_BIU/matlab/LCMV/pos
cfg10 = [];
cfg10.parameter = 'avg.nai';
inai = sourceinterpolate(cfg10, source,MRI);
cfg9 = [];
cfg9.interactive = 'yes';
cfg9.funparameter = 'avg.nai';
cfg9.method='ortho';
%cfg.funcolorlim = [0 50];
figure;ft_sourceplot(cfg9,inai);
end
