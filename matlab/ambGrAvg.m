function ambGrAvg(subs,ur)
if ~exist('ur','var')
    ur='';
end
cd /home/yuval/Data/amb
%subs=1:25;
% load ~/ft_BIU/matlab/LCMV/template_grid_10mm
% pos=template_grid.pos;
load ~/ft_BIU/matlab/LCMV/M_10mm
strS='';strD='';
for subi=subs
    substr=num2str(subi);
    load ([substr,'/dom',ur])
    load ([substr,'/sub',ur])
    dom.transform=M;
    sub.transform=M;
    
    eval(['d',substr,'=dom;']);
    eval(['s',substr,'=sub;']);
    strS=[strS,',s',substr,' ']; %#ok<AGROW>
    strD=[strD,',d',substr,' ']; %#ok<AGROW>
    
    %                     DESIGN(1,subi)=subi;
    %                     DESIGN(2,subi)=1;
    %                     subi=subi+1;
end


cfg=[];
cfg.parameter          = 'pow'; % 'pow' 'nai' or 'coh'
cfg.keepindividual     = 'yes';
eval(['subG=sourcegrandaverage(cfg,',strS(2:size(strS,2)),')']);
eval(['domG=sourcegrandaverage(cfg,',strD(2:size(strD,2)),')']);
save (['grndAvg',ur],'subG','domG')
%eval(['save s',num2str(con),'p',compt,' s',num2str(con),'p']);
% cfg.parameter='nai';
% eval(['s',num2str(con),'n=sourcegrandaverage(cfg,',str(2:size(str,2)),')']);
% eval(['save s',num2str(con),'n',compt,' s',num2str(con),'n']);
% clear *_* *n *p
end