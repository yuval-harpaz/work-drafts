function [lToeInDN,lToeOut2DN,lToeOut3DN]=marikDenoiseLeg %#ok<STOUT>
% % t=0.05112;
% % cond=1;
% fold=num2str(cond);
% fn={'lToeIn','lToeOut2','lToeOut3'};
% fn=fn{cond};
fn={'lToeIn','lToeOut2','lToeOut3'};        


%% dipole fit

cd /home/yuval/Data/marik/4fingers
for cond=1:3
    load (fn{cond})
    eval(['raw=',fn{cond}])
    data=raw.avg;
    new_data=DATA_adaptive_pca_denoiser4(data,10,250,2);
    eval([fn{cond},'DN=new_data;'])
end