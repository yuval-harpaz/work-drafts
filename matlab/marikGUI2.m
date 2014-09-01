% cfg=[];
% cfg.dataset='lf,hb_c,rfhp1.0Hz';
% cfg.channel='MEG';
% cfg.trl=round(678.17*[91,145,91]);
% data=ft_preprocessing(cfg);
% 
% cfg=[];
% cfg.step=5;
% cfg.boxSize=[-120 120 -90 90 -20 150];
% cfg.prefix='wtsGlobal';
% cfg.TR=1;
% cfg.torig=0;
% VS2Brik(cfg,ActWgts);

%%
wts=ft_read_mri('wtsGlobal.nii');
g2data=zeros(size(wts.anatomy(:,:,:,1)));

for voxi=1:49
    for voxj=1:37
        for voxk=1:35
            if mean(squeeze(abs(wts.anatomy(voxi,voxj,voxk,:))))>0
                vs=squeeze(wts.anatomy(voxi,voxj,voxk,:))'*data.trial{1,1};
                norm=sqrt(mean(wts.anatomy(voxi,voxj,voxk,:)));
                g2data(voxi,voxj,voxk)=G2(vs)^w1.*(std(vs./norm))^w2;
            end
        end
    end
end
ft_write_mri('g2data.nii',g2data,'transform',wts.transform);