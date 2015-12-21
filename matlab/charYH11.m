
cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem
bands={'Delta','Theta','Alpha','Beta','Gamma'};
conds={'closed','open','charisma','room','dull','silent'};
for bandi=[1,2,3,5]
    band=bands{bandi};
    for condi=[3,5]
        cond=conds{condi};
        fn=[cond,'_',band,'_Raud'];
        if exist([fn,'_TT.mat'],'file')
            [~,w]=unix(['mv ',fn,'* old/']);
        end
        [~,w]=unix('rm perm/perm*');
        [~,w]=unix('rm perm/pos*');
        [~,w]=unix('rm perm/realT*');
        permuteBriks1([fn,'+tlrc'],0,'Char_',[],[],[0.001,0.0025,0.005,0.01]);
        [~,w]=unix(['mv perm/realTest+tlrc.BRIK ./',fn,'_TT+tlrc.BRIK']);
        [~,w]=unix(['mv perm/realTest+tlrc.HEAD ./',fn,'_TT+tlrc.HEAD']);
        [~,w]=unix(['mv perm/permResults* ./',fn,'_TT.mat']);
        disp(' ')
        disp(['done ',fn])
        disp(' ')
        %         else
        %             disp(['skipping ',fn])
    end
end

for bandi=[2,3,5]
    band=bands{bandi};
    condA=conds{3};
    condB=conds{5};
    fn=[condA,'_',condB,'_',band,'_Raud'];
    %     if ~exist([fn,'_TT.mat'],'file')
    [~,w]=unix('rm perm/perm*');
    [~,w]=unix('rm perm/pos*');
    [~,w]=unix('rm perm/realT*');
    permuteBriks1([condA,'_',band,'_Raud+tlrc'],[condB,'_',band,'_Raud+tlrc'],'Char_',[],[],[0.001,0.0025,0.005,0.01]);
    [~,w]=unix(['mv perm/realTest+tlrc.BRIK ./',fn,'_TT+tlrc.BRIK']);
    [~,w]=unix(['mv perm/realTest+tlrc.HEAD ./',fn,'_TT+tlrc.HEAD']);
    [~,w]=unix(['mv perm/permResults* ./',fn,'_TT.mat']);
    disp(' ')
    disp(['done ',fn])
    disp(' ')
end



