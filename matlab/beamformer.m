function [powLR,R]=beamformer(cfg,data,data_cov)
% you must give data with averaged data (fieldtrip) and cfg.latency such as
% [0.09 0.11]
%
% optional
% cfg.grid (LR symmetric around origin, y axis)
% cfg.vol (singlesphere type)
% cfg.labda ('5%' default)
% data_cov (N by N cov matrix). If not given, cov will be computed for all
% the averaged data.
% cfg.noise = 'wts';
% powLR is normalized activity
% R is the explained variance for each dipole pair, this is before
% beamforming.
% cfg.wtsmethod should be '1by1', 'pairs' didn't work so far

cfg.wtsmethod='1by1';
cfg.nonlinear='no';

cfg.method='pinv';
if ~isfield(cfg,'symmetry')
    cfg.symmetry='no'; % 'y' for y axis symmetry, the only one supported
end
if ~isfield(cfg,'grid')
    [~,cfg.grid,cfg.vol]=sphereGrid([],10,[],4);
else
    cfg.grid=ft_convert_units(cfg.grid,'mm');
    try
        cfg.vol=ft_convert_units(cfg.vol,'mm');
    catch
        error('if you give grid you have to give vol too')
    end
end
if ~exist('data_cov','var')
    data_cov=[];
end
if isfield(cfg,'lambda')
    lambda=cfg.lambda;
else
    lambda=[];
end
if isempty(lambda)
    lambda='5%';
end
if isempty(data_cov)
    data_cov=cov(data.avg(1:248,:)');
end
if ischar(lambda) && lambda(end)=='%'
    ratio = sscanf(lambda, '%f%%');
    ratio = ratio/100;
    lambda = ratio * trace(data_cov)/size(data_cov,1);
end
if ~isfield(cfg,'noise')
    cfg.noise='wts';
end
%cfg.latency=[0.09 0.11];
%if ~isfield(cfg,'ori')
[~,R,mom]=dipolefitBIU(cfg,data);
XX=sqrt(1./sum(mom.^2,2));
XX(XX==Inf)=0; % this is about normalizing the moment to have vector length of 1
ori=mom.*repmat(XX,1,3);

inv_cov = pinv(data_cov + lambda * eye(size(data_cov)));

if size(cfg.noise)==size(data_cov)
    noise_cov=cfg.noise;
else
    Noise = svd(data_cov);
    Noise = Noise(end);
    % estimated noise floor is equal to or higher than lambda
    Noise = max(Noise, lambda);
    noise_cov = Noise * eye(size(data_cov));
end
lambdaNoise=ratio * trace(noise_cov)/size(noise_cov,1);
inv_noise = pinv(noise_cov + lambdaNoise * eye(size(noise_cov)));
%Noise=mean((weights * noise_cov * weights'));
t1=nearest(data.time,cfg.latency(1));
t2=nearest(data.time,cfg.latency(2));
% noise_data=rand(size(data.avg(1:248,t1:t2)))*2-1;
powLR=zeros(size(cfg.grid.pos,1),1);
disp('computing weights for source : ')


weights=zeros(length(mom),248);
noise=[];
for voxi=1:length(mom)
    opt_vox_or  = ori(voxi,:);
    if isempty(cfg.grid.leadfield{voxi})
        powLR(voxi)=0;
    else
        gain        = cfg.grid.leadfield{voxi} * opt_vox_or';
        trgain_invC = gain' * inv_cov;
        weights(voxi,1:248)  = trgain_invC / (trgain_invC * gain);
        if ischar(cfg.noise) % compute noise from weights
            if strcmp(cfg.noise,'wts')
                noise  = mean(abs(weights(voxi,:)));
            else
                error('unknown noise method')
            end
        elseif size(cfg.noise)==size(data_cov) % use noise_cov to compute noise
            trgain_invC = gain' * inv_noise;
            weightsNoise  = trgain_invC / (trgain_invC * gain);
            noise=abs(mean(weightsNoise * data.avg(1:248,t1:t2)));
        elseif size(cfg.noise,1)==size(data_cov,1) % use noise data to compute noise
            noise=abs(mean(weights(voxi,1:248) * cfg.noise));
        elseif cfg.noise==0; % no noise normalizations, raw VS
            noise=1;
        else
            error('something went wrong when assessing noise')
        end
        powLR(voxi)=abs(mean(weights(voxi,1:248) * data.avg(1:248,t1:t2)))./noise;
        prog(voxi)
    end
end

powLR(isnan(powLR))=0;

% moment(isnan(moment))=0;
% noise=mean(abs(weights),2);
% noise(isnan(noise))=0;
% pow=moment'./noise;
% pow(isnan(pow))=0;
if length(cfg.grid.pos)<20000
    disp('   ')
    disp('   ')
    disp('plotting')
    hs=ft_read_headshape('hs_file');
    figure;
    scatter3pnt(cfg.grid.pos(cfg.grid.inside,:),25,powLR(cfg.grid.inside,:));
    hold on
    scatter3pnt(hs.pnt*1000,5,'k');
    view([-90 0])
end

% %% checking R for individual sources
% R1=zeros(size(R));
% for voxi=1:length(mom)
%     opt_vox_or  = mom(voxi,:);
%     gain        = cfg.grid.leadfield{voxi} * opt_vox_or';
%     R1(voxi)=corrFast(gain,mean(data.avg(1:248,t1:t2),2)).^2;
% end

