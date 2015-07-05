load /home/yuval/Copy/MEGdata/alice/ga2015/GavgEqTrlsubs
sf={'idan','inbal','liron','maor','mark','odelia','ohad','yoni'};
t=[0.09 0.11];
cfg=[];
cfg.latency=t;
cfg.nonlinear='no';
cfg.symmetry='y';
cfg.method='pinv';
for subi=1:8
    cd ~/Data/alice/
    cd(sf{subi})
    %[~,badi]=ismember({'A64', 'A92', 'A93', 'A94', 'A118', 'A124', 'A125', 'A126', 'A127', 'A149', 'A150', 'A153', 'A154', 'A155', 'A175', 'A176', 'A177', 'A178', 'A179', 'A193', 'A194', 'A195', 'A212', 'A213', 'A227', 'A228', 'A229', 'A230', 'A246', 'A247', 'A248'},avgM20_1.label);
    %avgM20_1.avg(badi,:)=0;
    [~,lf,vol]=sphereGrid([],10,[],4);
    cfg.vol=vol;
    cfg.grid=lf;
    [dip2,r,mom]=dipolefitBIU(cfg,eval(['Mr',num2str(subi)]));
    mom1=mom(1,:);
    XX=sqrt(1./sum(mom.^2,2));
    XX(XX==Inf)=0;
    ori=mom.*repmat(XX,1,3); % normalize so mom length is 1
    eval(['data=Mr',num2str(subi)])
    cov_data=data.avg(1:248,nearest(data.time,0):nearest(data.time,0.5));
    all_cov=cov(cov_data');
    ratio=0.05;
    lambda = ratio * trace(all_cov)/size(all_cov,1);
    inv_cov = pinv(all_cov + lambda * eye(size(all_cov)));
    invCov=inv(all_cov+ lambda * eye(size(all_cov)));
    noise = svd(all_cov);
    noise = noise(end);
    % estimated noise floor is equal to or higher than lambda
    noise = max(noise, lambda);
    noise_cov = noise * eye(size(all_cov));
    weights=zeros(length(mom),248);
    noise=[];
    for voxi=1:length(mom)
        opt_vox_or  = ori(voxi,:);
        gain        = lf.leadfield{voxi} * opt_vox_or';
        trgain_invC = gain' * inv_cov;
        weights(voxi,1:248)  = trgain_invC / (trgain_invC * gain);
        Weights=gain'*invCov/(gain'*invCov*gain);
        %pow(voxi)=weights * all_cov * weights';
        noise(voxi)  = mean(abs(weights(voxi,:)));
        moment(voxi)=abs(mean(weights(voxi,:) * data.avg(1:248,nearest(data.time,t(1)):nearest(data.time,t(2)))));
%         SAMweights  = trgain_invC / (trgain_invC * gain);
%         % remember all output details for this dipole
%         dipout.pow(voxi)    = SAMweights * all_cov * SAMweights';
%         dipout.noise(voxi)  = SAMweights * noise_cov * SAMweights';
%         dipout.ori{voxi}    = opt_vox_or;
%         dipout.filter{voxi} = SAMweights;
%         dipout.mom{voxi} = SAMweights * data.avg(1:248,:);
        prog(voxi)
    end

%     POSL(subi)=dip2.grid_index(1);
%     MOML(subi,1:3)=dip2.dip.mom(1:3);
%     R(1:2568,subi)=r;
    pow(subi,1:2568)=moment./noise;
end
pow(pow==NaN)=0;
hs=ft_read_headshape('hs_file');
figure;
scatter3pnt(hs.pnt*1000,5,'k');
hold on
scatter3pnt(lf.pos,25,mean(pow,1));
view([-90 0])


