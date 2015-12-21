
cd /media/yuval/YuvalExtDrive/Data/Hilla_Rotem
bands={'Delta','Theta','Alpha','Beta','Gamma'};
conds={'closed','open','charisma','room','dull','silent'};
first=true;

[~,info]=BrikLoad('/media/yuval/YuvalExtDrive/Data/Hilla_Rotem/Char_1/YH/dull_Beta_R+tlrc');
% in=abs(v1(:,:,:))>0;
% ini=[];
% inj=[];
% ink=[];
% for ki=1:size(in,3)
%     [i,j,~]=find(in(:,:,ki));
%     ini=[ini;i];
%     inj=[inj;j];
%     ink=[ink;ones(length(i),1)*ki];
% end

OptTSOut.Scale = 1;
OptTSOut.verbose = 1;
OptTSOut.View = '+tlrc';


for bandi=1:5
    band=bands{bandi};
    for condi=1:6
        cond=conds{condi};
        %fn=[cond,'_',band,'_avg'];
        disp(' ')
        for subi=1:40
            sub=['Char_',num2str(subi)];
            cd(sub)
            cd YH
            v=BrikLoad([cond,'_',band,'+tlrc']);
            V=mean(v,4);
            OptTSOut.Prefix = [conds{condi},'_',bands{bandi},'_avg'];
            WriteBrik (V, info,OptTSOut);
            cd ../../
        end
        disp(['Done ',band,' ',cond])
    end
end



for bandi=1:5
    band=bands{bandi};
    condA=conds{3};
    condB=conds{5};
    fn=[condA,'_',condB,'_',band,'_avg'];
    if ~exist([fn,'_TT.mat'],'file')
        [~,w]=unix('rm perm/perm*');
        [~,w]=unix('rm perm/pos*');
        [~,w]=unix('rm perm/realT*');
        permuteBriks1([condA,'_',band,'_avg+tlrc'],[condB,'_',band,'_avg+tlrc'],'Char_',[],[],[0.001,0.0025,0.005,0.01]);
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


