function cleanTal(subs,cond)
%
%% checking files in directories
% subs='quad01b' 'quad03'};
% cond='rest';
cd ('/home/yuval/Desktop/tal')
diary(['log ',datestr(now)])
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
        cd(path2file)
        if ~exist(['xc,lf_',fileName],'file') && ~exist(['hb,lf_',fileName],'file') && ~exist(['xc,hb,lf_',fileName],'file')
            p=pdf4D(fileName);
            cleanCoefs = createCleanFile(p, fileName,...
                'byLF',256 ,'Method','Adaptive',...
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