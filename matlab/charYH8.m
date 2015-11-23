
cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem
bands={'Delta','Theta','Alpha','Beta','Gamma'};
conds={'closed','open','charisma','room','dull','silent'};
for bandi=1:5
    band=bands{bandi};
    for condi=1:6
        cond=conds{condi};
        fn=[cond,'_',band,'_R'];
        if ~exist([fn,'_TT.mat'],'file')
            [~,w]=unix('rm perm/perm*');
            [~,w]=unix('rm perm/pos*');
            [~,w]=unix('rm perm/realT*');
            permuteBriks1([fn,'+tlrc'],0,'Char_');
            [~,w]=unix(['mv perm/realTest+tlrc.BRIK ./',fn,'_TT+tlrc.BRIK']);
            [~,w]=unix(['mv perm/realTest+tlrc.HEAD ./',fn,'_TT+tlrc.HEAD']);
            [~,w]=unix(['mv perm/permResults* ./',fn,'_TT.mat']);
            disp(' ')
            disp(['done ',fn])
            disp(' ')
        else
            disp(['skipping ',fn])
        end
    end
end

% permuteBriks1('closed_Theta_R+tlrc',0,'Char_');
% !mv perm/realTest+tlrc.BRIK ./closed_Theta_R_TT+tlrc.BRIK
% !mv perm/realTest+tlrc.HEAD ./closed_Theta_R_TT+tlrc.HEAD
% !mv perm/permResults* ./closed_Theta_R_TT.mat
% 
% permuteBriks1('charisma_Beta_R+tlrc',0,'Char_');
% !mv perm/realTest+tlrc.BRIK ./closed_Beta_R_TT+tlrc.BRIK
% !mv perm/realTest+tlrc.HEAD ./closed_Beta_R_TT+tlrc.HEAD
% !mv perm/permResults* ./closed_Beta_R_TT.mat

