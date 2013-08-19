function aliceImage(Gavg,xlim,prefix)
%xlim=[0.0885-0.03 0.0885+0.03];
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
!echo "cd /home/yuval/Copy/MEGdata/alice" > ~/alice2tlrc
for subi=1:8
    cd(['/home/yuval/Copy/MEGdata/alice/',sf{subi}])
    %load ('SAM/general,3-35Hz,alla.wts')
    cd SAM
    [~, ~, ActWgts]=readWeights('general,3-35Hz,alla.wts');
    cd ..
    load SAM/noiseNormCov
    samples=[nearest(Gavg.time,xlim(1)),nearest(Gavg.time,xlim(2))];
    if isfield(Gavg,'individual')
        data=squeeze(Gavg.individual(subi,:,samples(1):samples(2)));
        if size(data,2)==248 && size(data,1)~=248
            data=data'; % one time sample
        end
        vs=ActWgts*data;
        vs=abs(mean(vs./repmat(ns,1,size(vs,2)),2));
        vs(isnan(vs))=0;
        %make 3D image
        cd MRI
        
        cfg=[];
        cfg.step=5;
        cfg.boxSize=[-120 120 -90 90 -20 150];
        cfg.prefix=prefix;
        VS2Brik(cfg,vs);
        eval(['!echo "cd ',pwd,'" >> ~/alice2tlrc'])
        eval(['!echo "@auto_tlrc -apar ortho+tlrc -input ',prefix,'+orig -dxyz 5" >> ~/alice2tlrc'])
        eval(['!echo "mv ',prefix,'+tlrc.HEAD /home/yuval/Copy/MEGdata/alice/func/',prefix,'_',num2str(subi),'+tlrc.HEAD" >> ~/alice2tlrc']);
        eval(['!echo "mv ',prefix,'+tlrc.BRIK /home/yuval/Copy/MEGdata/alice/func/',prefix,'_',num2str(subi),'+tlrc.BRIK" >> ~/alice2tlrc']);
    end
end
!chmod 777 ~/alice2tlrc
