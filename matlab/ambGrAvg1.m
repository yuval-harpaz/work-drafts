function ambGrAvg1(subs,prefix,param)
if ~exist('param','var')
    param=[];
end
if isempty(param)
    param='pow';
end
if strcmp(param,'pow')
    suffix='p';
elseif strcmp(param,'nai')
     suffix='n';
elseif strcmp(param,'noise')
    suffix='N';
else
    error(['no suffix defined for ',param,'. is there such a field?'])
end
cd /home/yuval/Data/amb
%subs=1:25;
% load ~/ft_BIU/matlab/LCMV/template_grid_10mm
% pos=template_grid.pos;
load ~/ft_BIU/matlab/LCMV/M_10mm
strS='';strD='';
for subi=subs
    substr=num2str(subi);
    load ([substr,'/',prefix,'dom'])
    load ([substr,'/',prefix,'sub'])
    dom.transform=M;
    sub.transform=M;
    
    eval(['d',substr,'=dom;']);
    eval(['s',substr,'=sub;']);
    strS=[strS,',s',substr,' ']; %#ok<AGROW>
    strD=[strD,',d',substr,' ']; %#ok<AGROW>
    
    %                     DESIGN(1,subi)=subi;
    %                     DESIGN(2,subi)=1;
    %                     subi=subi+1;
    display(['loaded subject ',substr])
end

display('averaging')
cfg=[];
cfg.parameter          = param; % 'pow' 'nai' or 'coh'
cfg.keepindividual     = 'yes';
eval([prefix,'sub',suffix,'=ft_sourcegrandaverage(cfg,',strS(2:size(strS,2)),')']);
eval([prefix,'dom',suffix,'=ft_sourcegrandaverage(cfg,',strD(2:size(strD,2)),')']);
display(['saving ',prefix,'sub',suffix])
save ([prefix,'sub',suffix],[prefix,'sub',suffix]);
display(['saving ',prefix,'dom',suffix])
save ([prefix,'dom',suffix],[prefix,'dom',suffix]);

%     [cfg1,probplot,cfg2,statplot]=monteT(compt,condA,condB);
%     str=[condA,'_',condB,'_',compt];
%     save(str,'cfg1','probplot','cfg2','statplot')

end