function setPathsTal(subs)
%
currPWD=pwd;
%% checking files in directories
% sub='quad01b';

% diary(['log ',datestr(now)])
for subi=1:length(subs)
    cd ('/home/yuval/Desktop/tal')
    sub=subs{subi};
    display(['BEGGINING WITH ',sub]);
    if ~exist([sub,'/',sub,'/0.14d1'])
        %mkdir ([sub,'/',sub])
        copyfile(sub,['new/',sub])
        copyfile(['new/',sub],[sub,'/',sub])
    end
    cd ([sub,'/',sub,'/0.14d1']);
    %% looking for the session name, saving path in subject directory
    !rm Exp*
    ! ls > ls.txt
    txt=textread('ls.txt','%s');
    pathsi=0;
    for lsi=1:length(txt)
        if ~isempty(findstr('@',txt{lsi}))
            pathsi=pathsi+1;
            subpathi=['/home/yuval/Desktop/tal/',sub,'/',sub,'/0.14d1/',txt{lsi}];
            subpath(pathsi,1:length(subpathi))=subpathi;
        end
    end
    save(['/home/yuval/Desktop/tal/',sub,'/subpath'],'subpath')
    %% listing the runs and scanning triggers in data files
    for pathi=1:size(subpath,1)
        cd(subpath(pathi,:))
        runs=[];
        runcount=0;
        for i=1:9
            if exist(num2str(i),'dir')
                runcount=runcount+1;
                runs(runcount)=i;
            end
        end
        runs
        trigs=[];
        clear runcount;
        conds={'rest','oneBack','timeProd'};
        condTrigs=[92,202,112];
        % must be inside session
        findTrigs(conds,condTrigs);
        %         for i=1:length(runs)
        %             eval(['!echo ',num2str(runs(i)),' >> conditions'])
        %         end
        cd ..
    end
    cd ../..
    subpath='';
    
end
cd(currPWD);
% diary off
end

%%