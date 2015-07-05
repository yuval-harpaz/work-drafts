function pow=beamformer_symmetric(cfg,data,data_cov)

cfg.nonlinear='no';
cfg.symmetry='y';
cfg.method='pinv';
if ~isfield(cfg,'grid')
    [~,cfg.grid,cfg.vol]=sphereGrid([],10,[],4);
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

%cfg.latency=[0.09 0.11];

[dip2,r,mom]=dipolefitBIU(cfg,data);
%mom1=mom(1,:);
XX=sqrt(1./sum(mom.^2,2));
XX(XX==Inf)=0; % this is about normalizing the moment to have vector length of 1
ori=mom.*repmat(XX,1,3);


inv_cov = pinv(data_cov + lambda * eye(size(data_cov)));
Noise = svd(data_cov);
Noise = Noise(end);
% estimated noise floor is equal to or higher than lambda
Noise = max(Noise, lambda);
noise_cov = Noise * eye(size(data_cov));
Noise=mean((weights * noise_cov * weights'));
t1=nearest(data.time,cfg.latency(1));
t2=nearest(data.time,cfg.latency(2));
noise_data=rand(size(data.avg(1:248,t1:t2)))*2-1;

weights=zeros(length(mom),248);
noise=[];
for voxi=1:length(mom)
    opt_vox_or  = ori(voxi,:);
    gain        = cfg.grid.leadfield{voxi} * opt_vox_or';
    trgain_invC = gain' * inv_cov;
    weights(voxi,1:248)  = trgain_invC / (trgain_invC * gain);
    %pow(voxi)=weights * all_cov * weights';
    
    noise(voxi)  = abs(mean(weights(voxi,:) * noise_data));
    moment(voxi)=abs(mean(weights(voxi,:) * data.avg(1:248,t1:t2)));
    %         SAMweights  = trgain_invC / (trgain_invC * gain);
    %         % remember all output details for this dipole
    %         dipout.pow(voxi)    = SAMweights * all_cov * SAMweights';
    %         dipout.noise(voxi)  = SAMweights * noise_cov * SAMweights';
    %         dipout.ori{voxi}    = opt_vox_or;
    %         dipout.filter{voxi} = SAMweights;
    %         dipout.mom{voxi} = SAMweights * data.avg(1:248,:);
    prog(voxi)
end
disp('')
disp('plotting')
%     POSL(subi)=dip2.grid_index(1);
%     MOML(subi,1:3)=dip2.dip.mom(1:3);
%     R(1:2568,subi)=r;
moment(isnan(moment))=0;
noise(isnan(noise))=0;
pow=moment./noise;
pow(isnan(pow))=0;
hs=ft_read_headshape('hs_file');
figure;
scatter3pnt(hs.pnt*1000,5,'k');
hold on
scatter3pnt(cfg.grid.pos,25,pow);
view([-90 0])



