function talCleanH(subs,cond)
%
%% checking files in directories
% subs='quad01b' 'quad03'};
% cond='rest';
pat='/media/Elements/MEG/tal';
cd (pat)
diary(['log ',datestr(now)])
for subi=1:length(subs)
    cd (pat)
    sub=subs{subi};
    display(['BEGGINING WITH ',sub]);
    cd ([sub,'/',sub,'/0.14d1']);
    indiv=talIndivPathH(sub,cond,pat)
    conditions=textread('conditions','%s');
    restcell=find(strcmp(cond,conditions));
    for i=1:length(restcell);
        eval(['path2file=indiv.path',num2str(i)]);
        fileName= conditions{restcell(i)+2};
        cd(path2file)
        if ~exist(['./xc,lf_',fileName],'file') && ~exist(['./hb,lf_',fileName],'file') && ~exist(['./xc,hb,lf_',fileName],'file')
            p=pdf4D(fileName);
            cleanCoefs = createCleanFile(p, fileName,...
                'byLF',[] ,'Method','Adaptive',...
                'xClean',[4,5,6],...
                'chans2ignore',[],...
                'byFFT',0,...
                'HeartBeat',[],... % for automatic HB cleaning change 0 to []
                'maskTrigBits', [512]);
        else
            warning(['cleaned ',path2file,'/',fileName,' exists'])
        end
        cd ..
    end
    cd ../..
    
end
diary off
end

%%