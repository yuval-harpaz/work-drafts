function ambMergeSources(prefix,param)

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
load([prefix,'dom',suffix])
dom=eval([prefix,'dom',suffix]);
load([prefix,'sub',suffix])
sub=eval([prefix,'sub',suffix]);
eval(['domsub=',prefix,'dom',suffix]);
for subi=1:length(domsub.trial)
    eval(['domsub.trial(1,subi).',param,'=(dom.trial(1,subi).',param,'+sub.trial(1,subi).',param,')./2;']);
end
eval([prefix,'domsub',suffix,'=domsub']);

save([prefix,'domsub',suffix],[prefix,'domsub',suffix]);
display(['saved ',prefix,'domsub',suffix,'.mat']);
end


