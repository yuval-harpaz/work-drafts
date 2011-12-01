function cpWarpedTal(subs,cond)
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
    warped1=[conditions{restcell(1)+1},'/warped+orig*'];
    
    for i=2:length(restcell);
        path2file=[conditions{restcell(i)+1},'/'];
        warpedB=[conditions{restcell(i)+1},'/warped+orig.BRIK'];
        warpedH=[conditions{restcell(i)+1},'/warped+orig.HEAD'];
        warpedBcopy=[conditions{restcell(i)+1},'/Cwarped+orig.BRIK'];
        warpedHcopy=[conditions{restcell(i)+1},'/Cwarped+orig.HEAD'];
        if ~exist(warpedBcopy,'file')
        eval(['!cp ',warpedB,' ',warpedBcopy]);
        eval(['!cp ',warpedH,' ',warpedHcopy]);
        end
        eval(['!cp ',warped1,' ',path2file]);
% 
%         warped
%         path2file=conditions{restcell(i)+1};
        %fileName= conditions{restcell(i)+2};
        %fileName=['xc,lf_',fileName];
        
%         cd(path2file)
%         
%         if ~exist(['xc,hb,lf_',fileName],'file')
%             p=pdf4D(fileName);
%             cleanCoefs = createCleanFile(p, fileName,...
%                 'byLF',256 ,'Method','Adaptive',...
%                 'xClean',[4,5,6],...
%                 'chans2ignore',[74,204],...
%                 'byFFT',0,...
%                 'HeartBeat',[],... % for automatic HB cleaning change 0 to []
%                 'maskTrigBits', 512);
%          else
%              warning([path2file,'/',fileName,' exists'])
%          end
        cd ..
    end
    cd ../..
    
end
diary off
end

%%