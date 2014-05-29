function talSAM_TP(subs,PARAM)
cond='timeProd';
% PARAM='alpha';Active='eyesClosed';
cd ('/media/Elements/MEG/tal')
for subi=1:length(subs)
    cd ('/media/Elements/MEG/tal')
    sub=subs{subi};
    display(['BEGGINING WITH ',sub]);
    cd ([sub,'/',sub,'/0.14d1']);
    conditions=textread('conditions','%s');
    restcell=find(strcmp(cond,conditions));
    i=1;
    source='';
    path2file=conditions{restcell(i)+1};
    RUN=conditions{restcell(i)+1}(end);
    %fileName=['xc,lf_',fileName];
    cd(path2file(end-16:end))
    if ~exist([path2file(end),'.rtw'],'file')
        PWD=pwd;
        path2RTW=findDiRTW(PWD,'Su');
        copyfile(path2RTW,['./',path2file(end),'.rtw'])
    end
    if exist([cond,'MarkerFile.mrk'],'file')
        copyfile([cond,'MarkerFile.mrk'],'MarkerFile.mrk');
    else
        warning(['no ',cond,'MarkerFile.mrk'])
    end
    fileName= conditions{restcell(i)+2};
    if exist(['xc,hb,lf_',fileName],'file')
        source=['xc,hb,lf_',fileName];
    elseif exist(['hb,xc,lf_',fileName],'file')
        source=['hb,xc,lf_',fileName];
    elseif exist(['xc,lf_',fileName],'file')
        source=['xc,lf_',fileName];
    else
        warning('did not find clean file')
    end
    cd ..
    if ~exist([PARAM,'TP.param'],'file')
        copyfile(['/media/Elements/MEG/tal/',PARAM,'TP.param'],'./')
    end
    if ~exist([RUN,'/SAM/',PARAM,'TP,SAMspm-Segments'],'file');
        eval(['!SAMcov64 -r ',RUN,' -d ',source,' -m ',PARAM,'TP -v']);
        eval(['!SAMwts64 -r ',RUN,' -d ',source,' -m ',PARAM,'TP -c timeProd32a -v']);
        eval(['!SAMspm64 -r ',RUN,' -d ',source,' -m ',PARAM,'TP -v']);
        cd([RUN,'/SAM']);system(['cp *timeProd*.svl ../']);cd ../..
    end
    
end
end