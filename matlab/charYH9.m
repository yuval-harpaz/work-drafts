
cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem
bands={'Delta','Theta','Alpha','Beta','Gamma'};
conds={'closed','open','charisma','room','dull','silent'};
for bandi=1:5
    band=bands{bandi};
    condA=conds{3};
    condB=conds{5};
    fn=[condA,'_',condB,'_',band,'_R'];
    if ~exist([fn,'_TT.mat'],'file')
        [~,w]=unix('rm perm/perm*');
        [~,w]=unix('rm perm/pos*');
        [~,w]=unix('rm perm/realT*');
        permuteBriks1([condA,'_',band,'_R+tlrc'],[condB,'_',band,'_R+tlrc'],'Char_',[],[],[0.001,0.0025,0.005,0.01]);
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

% permuteBriks1('closed_Theta_R+tlrc',0,'Char_');
% !mv perm/realTest+tlrc.BRIK ./closed_Theta_R_TT+tlrc.BRIK
% !mv perm/realTest+tlrc.HEAD ./closed_Theta_R_TT+tlrc.HEAD
% !mv perm/permResults* ./closed_Theta_R_TT.mat
%
% permuteBriks1('charisma_Beta_R+tlrc',0,'Char_');
% !mv perm/realTest+tlrc.BRIK ./closed_Beta_R_TT+tlrc.BRIK
% !mv perm/realTest+tlrc.HEAD ./closed_Beta_R_TT+tlrc.HEAD
% !mv perm/permResults* ./closed_Beta_R_TT.mat

