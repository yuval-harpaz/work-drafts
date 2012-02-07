function indiv=indivPathTal(sub,cond) %#ok<STOUT>
%sub=subs{subi};

cond='rest';
cd ('/home/yuval/Desktop/tal')
cd ([sub,'/',sub,'/0.14d1']);
conditions=textread('conditions','%s');
condcell=find(strcmp(cond,conditions));
for i=1:length(condcell);
    source='';
    path2file=conditions{condcell(i)+1};
    RUN=conditions{condcell(i)+1}(end);
    %fileName=['xc,lf_',fileName];
    cd(path2file)
    fileName= conditions{condcell(i)+2};
    if exist(['xc,hb,lf_',fileName],'file')
        source=['xc,hb,lf_',fileName];
    elseif exist(['hb,xc,lf_',fileName],'file')
        source=['hb,xc,lf_',fileName];
    elseif exist(['xc,lf_',fileName],'file')
        source=['xc,lf_',fileName];
    else
        warning(['did not find clean file for ',sub])
    end
    
    eval(['indiv.path',num2str(i),'=''',path2file,''';'])
    eval(['indiv.source',num2str(i),'=''',source,''';'])
end