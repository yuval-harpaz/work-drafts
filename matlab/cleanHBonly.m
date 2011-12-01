function cleanHBonly(subs,cond)
%
%% checking files in directories
% subs='quad01b' 'quad03'};
% cond='rest';
cd ('/home/yuval/Desktop/tal')
diary(['log ',datestr(now)])
display('CLEANING HB');
for subi=1:length(subs)
    cd ('/home/yuval/Desktop/tal')
    sub=subs{subi};
    display(['BEGGINING WITH ',sub]);
    cd ([sub,'/',sub,'/0.14d1']);
    conditions=textread('conditions','%s');
    restcell=find(strcmp(cond,conditions));
    for i=1:length(restcell);
        path2file=conditions{restcell(i)+1};
        fileName= conditions{restcell(i)+2};
        %fileName=['xc,lf_',fileName];
        cd(path2file)
        if ~exist(['xc,hb,lf_',fileName],'file')
            if ~exist(['hb,xc,lf_',fileName],'file')
            p=pdf4D(['xc,lf_',fileName]);
            cleanCoefs = createCleanFile(p, ['xc,lf_',fileName],...
                'byLF',0 ,...
                'xClean',0,...
                'chans2ignore',[74,204],...
                'byFFT',0,...
                'HeartBeat',[])
         else
             warning([path2file,'/',fileName,' exists'])
         end
        cd ..
    end
    cd ../..
    
end
diary off
end

%%