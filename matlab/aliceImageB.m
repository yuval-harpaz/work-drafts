function aliceImageB(Gavg,xlim,prefix,wts)
% makes movies
if ~exist('wts','var')
    wts='';
end
if isempty(wts)
    wts='general,3-35Hz,alla.wts';
end
%xlim=[0.0885-0.03 0.0885+0.03];
sf={'idan'  'inbal'  'liron'  'maor'  'odelia'	'ohad'  'yoni' 'mark'};
!echo "cd /home/yuval/Copy/MEGdata/alice" > ~/alice2tlrc
for subi=1:8
    cd(['/home/yuval/Copy/MEGdata/alice/',sf{subi}])
    %load ('SAM/general,3-35Hz,alla.wts')
    cd SAM
    [~, ~, ActWgts]=readWeights(wts);
    cd ..
    load SAM/noiseNormCov
    samples=[nearest(Gavg.time,xlim(1)),nearest(Gavg.time,xlim(2))];
    if isfield(Gavg,'individual')
        data=squeeze(Gavg.individual(subi,:,samples(1):samples(2)));
        if size(data,2)==248 && size(data,1)~=248
            data=data'; % one time sample
        end
        vs=ActWgts*data;
        vs=abs(vs./repmat(ns,1,size(vs,2)));
        vs(isnan(vs))=0;
        %make 4D image
        cd MRI
        cfg=[];
        cfg.step=5;
        cfg.boxSize=[-120 120 -90 90 -20 150];
        cfg.prefix=prefix;
        if size(vs,2)>1
            cfg.TR=1000*(Gavg.time(2)-Gavg.time(1));
            cfg.torig=1000*Gavg.time(samples(1));
        end
        VS2Brik(cfg,vs);
        eval(['!@auto_tlrc -apar ortho+tlrc -input ',prefix,'+orig -dxyz 5']);
        eval(['!mv ',prefix,'+tlrc.HEAD /home/yuval/Copy/MEGdata/alice/func/B/',prefix,'_',num2str(subi),'+tlrc.HEAD']);
        eval(['!mv ',prefix,'+tlrc.BRIK /home/yuval/Copy/MEGdata/alice/func/B/',prefix,'_',num2str(subi),'+tlrc.BRIK']);
    end
end
