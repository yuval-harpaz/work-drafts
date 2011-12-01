function findTrigs(conds,condTrigs)
currentPath=pwd;
% if exist('../conditions','file')
%     !rm ../conditions
% end
files={'c,rfhp0.1Hz','c1,rfhp0.1Hz','c2,rfhp0.1Hz','c3,rfhp0.1Hz','c4,rfhp0.1Hz','c5,rfhp0.1Hz','c6,rfhp0.1Hz'};
for runi=1:10
    if exist(num2str(runi),'dir')
        cd(num2str(runi));
        
        for filei=1:7
            if exist(files{filei},'file')
                trig=readTrig_BIU(files{filei});
                trig=clearTrig(trig);
                trigs=unique(trig);
                for condi=1:3
                    if max(trigs==condTrigs(condi))>0
                        eval(['!echo "',conds{condi},' ',pwd,' ',files{filei},'" >> ../../conditions']);
%                         cd ..
%                         writeCondFiles(conds{condi},files{filei});
%                         cd ([subpath,'/',num2str(runi)]);
                    end
                end
            end
        end
        close all
        cd ..
    end
end
cd(currentPath);
end