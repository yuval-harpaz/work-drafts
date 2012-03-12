function [source,intsource,grid,mesh]=makeMask(volType)
cd /home/yuval/Data/amb/9/1


fileName='rw_c,rfhp1.0Hz,lp';


[vol,grid,mesh,M1,single]=headmodel_BIU('rw_c,rfhp1.0Hz,lp',[],[],volType);
%        save ([mask,volType],'vol', 'grid', 'mesh', 'M1', 'single')
%% calculating covariance for all the trials

load cov
hdr=read_4d_hdr_BIU(fileName);
grad=bti2grad_BIU(hdr);
grad=ft_convert_units(grad,'mm');
cov.grad=grad;
cfg8        = [];
cfg8.method = 'lcmv'; % 'mne'
cfg8.grid= grid;
cfg8.vol    = vol;
cfg8.lambda = 0.05;
cfg8.keepfilter='yes';
cfg.rawtrial='yes';
%cfg8.fixedori='robert'; % 'stephen' doesn't work; default is spinning.
source= ft_sourceanalysis(cfg8, cov);


%% reconstructing source trace

load MRIcr;

cfg10 = [];
cfg10.parameter = 'all';

intsource = ft_sourceinterpolate(cfg10, source,MRIcr);

end

