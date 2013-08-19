function aliceNoiseEstimate(sf)
% sf is names of subject folders {'liron','idan','yoni'}
for subi=1:8
    cd(['/home/yuval/Copy/MEGdata/alice/',sf{subi},'/SAM'])
    [~, ~, ActWgts]=readWeights('general,3-35Hz,alla.wts');
    ns=sqrt(sum(ActWgts.*ActWgts,2));
    save noiseNorm2 ns
    cd ('general,3-35Hz')
    !readcovBIU.py Noise.cov > noiseCov.txt
    nc=importdata('noiseCov.txt');
    ncov=reshape(nc,248,248);
    % test=ncov-ncov';
    cd ..
    ns=zeros(length(ActWgts),1);
    vsi=find(ActWgts(:,1));
    for vsii=vsi'
        ns(vsii)=ActWgts(vsii,:)*ncov*ActWgts(vsii,:)';
    end
    save noiseNormCov ns
end