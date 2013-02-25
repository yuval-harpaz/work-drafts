function ambGrAvgUR(subs)
cd /home/yuval/Data/amb
cons={'Dom','Sub'};
strS='';strD='';
for subi=subs
    substr=num2str(subi);
    for condi=1:2
        cond=conds(condi)
        load ([substr,'/',cond,'UR'])
        for triali=1:length(UR.trial)
            
        eval([cond,substr,'=ur;']);
    end
    strS=[strS,',Sub',substr,' ']; %#ok<AGROW>
    strD=[strD,',Dom',substr,' ']; %#ok<AGROW>
end


cfg=[];
cfg.parameter          = 'pow'; % 'pow' 'nai' or 'coh'
cfg.keepindividual     = 'yes';
eval(['subG=sourcegrandaverage(cfg,',strS(2:size(strS,2)),')']);
eval(['domG=sourcegrandaverage(cfg,',strD(2:size(strD,2)),')']);
save grndAvg subG domG
%eval(['save s',num2str(con),'p',compt,' s',num2str(con),'p']);
% cfg.parameter='nai';
% eval(['s',num2str(con),'n=sourcegrandaverage(cfg,',str(2:size(str,2)),')']);
% eval(['save s',num2str(con),'n',compt,' s',num2str(con),'n']);
% clear *_* *n *p

%    save DESIGN DESIGN % the design is only used for between group statistics



    [cfg1,probplot,cfg2,statplot]=monteT(compt,condA,condB);
    str=[condA,'_',condB,'_',compt];
    save(str,'cfg1','probplot','cfg2','statplot')

end