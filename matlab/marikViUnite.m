function [data, cfg]=marikViUnite(varargin)
% This function creates datasets without reference channels, and with new labeling.
% Also, this function creates the united dataset (of combined grid of diff. head positions)
% Since this outputs will latter be used for source analysis, we also
% create here vol and leadfeild.

%% removing from the diff. datasets ref channels
cfg=[];
chanN=248;
for i=1:nargin
    
    eval(['data',num2str(i),'=varargin{1,i};']);
    clear label
    for chi=1:chanN
        eval(['label{chi,1}=[data',num2str(i),'.label{chi,1},''_',num2str(i),'''];']);
    end
    eval(['data',num2str(i),'.label=label;']);
    
    % VOL
    clear listing
    listing=dir(['./',num2str(i),'/headmodel_',num2str(i),'.mat']);
    if isempty(listing)
        cd (num2str(i));
        [vol,grid,mesh,M1]=headmodel_BIU([],[],5,[],'localspheres');        
        eval(['vol.label=data',num2str(i),'.label(1:chanN)']);
        vol.r=vol.r(1:chanN);
        vol.o=vol.o(1:chanN,:);       
        save (['headmodel_',num2str(i)'],'vol', 'mesh', 'grid', 'M1');
        cd ..
    else
        load(['./',num2str(i),'/headmodel_',num2str(i)]);
    end    
    eval(['data',num2str(i),'.vol=vol;']); 
    
    % GRAD
    eval(['grad=data',num2str(i),'.grad;']);
    eval(['grad.label=data',num2str(i),'.label;']);
    grad.chanori=grad.chanori(1:chanN,:);
    grad.chanpos=grad.chanpos(1:chanN,:);
    grad.chantype=grad.chantype(1:chanN,:);
    grad.chanunit=grad.chanunit(1:chanN,:);
    grad.coilori=grad.coilori(1:chanN,:);
    grad.coilpos=grad.coilpos(1:chanN,:);
    grad.tra=grad.tra(1:chanN,1:chanN); % grad.tra=eye(chanN); %*3 
    
    grad.label=label;
    eval(['data',num2str(i),'.grad=ft_convert_units(grad,''mm'');']);
%     data1.grad=grad;
    
    clear listing
    listing=dir(['./',num2str(i),'/leadfield_',num2str(i),'.mat']);
    
    if isempty(listing)
        
        cfg_lf = [];
        eval(['cfg_lf.grad = data',num2str(i),'.grad;']);
        eval(['cfg_lf.channel =data',num2str(i),'.label(1:chanN);']); %'MEG';
        cfg_lf.grid.pos=mesh.tess_ctx.vert;
        cfg_lf.grid.inside=1:length(cfg_lf.grid.pos);
        vol.label=cfg_lf.grad.label;
        cfg_lf.vol = vol;
        eval(['leadfield_',num2str(i),'= ft_prepare_leadfield(cfg_lf);']);
        
         cd (num2str(i));

         save (['leadfield_',num2str(i)],['leadfield_',num2str(i)]);
         
         cd ..
    else
        load(['./',num2str(i),'/leadfield_',num2str(i)]);
    end
    
    eval(['cfg.cfg',num2str(i),'.vol=vol;']);
    eval(['data',num2str(i),'=rmfield(data',num2str(i),',''vol'')']);
    eval(['cfg.cfg',num2str(i),'.grid=leadfield_',num2str(i),';']);
    
    close all
    
end


%%
% combinig  multiple datasets:
grad=data1.grad;
grad.tra=eye(chanN*nargin);  
vol=cfg.cfg1.vol;
clear label
for i=1:nargin
       
    eval(['grad.chanori((i-1)*chanN+1:i*chanN,:)=data',num2str(i),'.grad.chanori(1:chanN,:);']);
    eval(['grad.chanpos((i-1)*chanN+1:i*chanN,:)=data',num2str(i),'.grad.chanpos(1:chanN,:);']);
    eval(['grad.chantype((i-1)*chanN+1:i*chanN,:)=data',num2str(i),'.grad.chantype(1:chanN,:);']);
    eval(['grad.chanunit((i-1)*chanN+1:i*chanN,:)=data',num2str(i),'.grad.chanunit(1:chanN,:);']);
    eval(['grad.coilori((i-1)*chanN+1:i*chanN,:)=data',num2str(i),'.grad.coilori(1:chanN,:);']);
    eval(['grad.coilpos((i-1)*chanN+1:i*chanN,:)=data',num2str(i),'.grad.coilpos(1:chanN,:);']);
    
    for chi=1:chanN
        eval(['label{(i-1)*chanN+chi,1}=data',num2str(i),'.grad.label{chi,1};']);
    end
    grad.label=label;

    if i>1
        eval(['vol.r=[vol.r; cfg.cfg',num2str(i),'.vol.r(1:248,:)];']);
        eval(['vol.o=[vol.o; cfg.cfg',num2str(i),'.vol.o(1:248,:)];']);
    end
    
end
clear listing
listing=dir('./leadfieldU.mat');

if isempty(listing)

    cfg_lf = [];
    cfg_lf.grad = grad;
    cfg_lf.channel =grad.label;
    cfg_lf.grid.pos=mesh.tess_ctx.vert;
    cfg_lf.grid.inside=1:length(cfg_lf.grid.pos);
    vol.label=grad.label;
    cfg_lf.vol = vol;
    leadfieldU= ft_prepare_leadfield(cfg_lf);

     save ('leadfieldU','leadfieldU');

else
    load('./leadfieldU');
end

% DATA  
if isfield(varargin{1,1},'avg')
    avg=rmfield(varargin{1,1},'dof');
    avg=rmfield(avg,'cfg');
    avg.avg=[];
    avg.var=[];
    avg.grad=ft_convert_units(grad,'mm');
    avg.label=label;
    for loci=1:nargin
        avg.avg=[avg.avg; varargin{1,loci}.avg];
        avg.var=[avg.var; varargin{1,loci}.var];
    end
    data={};
    data.dataU=avg;
else
    Data=rmfield(varargin{1,1},'cfg');
    Data.grad=ft_convert_units(grad,'mm');
    Data.label=label;
    for loci=2:nargin
        for triali=1:length(Data.trial)
            Data.trial{triali}=[Data.trial{triali}; varargin{1,loci}.trial{triali}];
        end 
    end
    data={};
    data.dataU=Data;
end
        
vol.label=label;
cfg.cfgU.vol=vol;
% united.grad=grad;
cfg.cfgU.grid=leadfieldU; 

for i=1:nargin
    eval(['data.data',num2str(i),'=data',num2str(i)']);
end


% %%     
% % maybe to add her the option for a filter bp (till 40 Hz?)
% cfg=[];
% cfg.bpfilter='yes';
% cfg.bpfreq = [1 40];
% avg40_foot2=ft_preprocessing(cfg,avg_foot2);
% 
% % maybe also the option to calculate the cov
% cfg                  = [];
% cfg.covariance       = 'yes';
% cfg.removemean       = 'no';
% cfg.covariancewindow = [-0.1 0];
% cfg.channel=avg_foot2.label(249+248:744);
% cov_foot2_248c=ft_timelockanalysis(cfg, avg40_foot2);