function indiv=talIndivPathH(sub,cond,pat) %#ok<STOUT>
PWD=pwd;
%sub=subs{subi};
if ~exist('pat','var')
    pat=[];
end
if isempty(pat)
    pat='/media/Elements/MEG/tal';
end
if ~exist('cond','var')
    cond='';
end
if isempty(cond)
    cond='rest';
end
cd (pat)
cd ([sub,'/',sub,'/0.14d1']);
conditions=textread('conditions','%s');
condcell=find(strcmp(cond,conditions));
for i=1:length(condcell);
    source='';
    path2file=conditions{condcell(i)+1};
    stri=findstr(path2file,'/tal/');
    talFolder=path2file(1:stri);
    if strcmp(talFolder,{'/home/yuval/Desktop/'})
        path2file(1:19)='/media/Elements/MEG';
    end
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
    elseif exist(['hb,lf_',fileName],'file')
        source=['hb,lf_',fileName];
    else
        warning(['did not find clean file for ',sub])
    end
    
    eval(['indiv.path',num2str(i),'=''',path2file,''';'])
    eval(['indiv.source',num2str(i),'=''',source,''';'])
    
end
cd(PWD);