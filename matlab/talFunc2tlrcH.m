function talFunc2tlrcH(subs,cond,SVL,pref)
% cond='rest';
% SVL='alpha,7-13Hz,eyesClosed-NULL,P,Zp.svl';
% creates a script in the home directory 'warped2tlrc' for moving the warped+orig to warped+tlrc
% run in a terminal ./warped2tlrc
! echo ''> ~/func2tlrc.txt
! chmod 777 ~/func2tlrc.txt
cd ('/media/Elements/MEG/tal')
for subi=1:length(subs)
    cd ('/media/Elements/MEG/tal')
    sub=subs{subi};
    display(['BEGGINING WITH ',sub]);
    cd ([sub,'/',sub,'/0.14d1']);
    conditions=textread('conditions','%s');
    restcell=find(strcmp(cond,conditions));
    for condi=1:length(restcell);
        path2file=conditions{restcell(condi)+1};
        %source= conditions{restcell(condi)+2};
        cd(path2file)
        funcName=SVL(1:(end-4));
        %if exist('warped+tlrc.BRIK','file')...
%                 && exist(['SAM/',SVL],'file')...
%                 && ~exist([funcName,'+tlrc.BRIK'],'file')
            PWD=pwd;
        %    copyfile(['SAM/',SVL],PWD)
            eval(['!~/abin/3dcopy ',SVL,' ',pref,num2str(condi)])
            eval(['!echo "cd "',PWD,' >> ~/func2tlrc.txt']); 
            eval(['!echo @auto_tlrc -apar warped+tlrc -input ',pref,num2str(condi),'+orig -dxyz 5 >> ~/func2tlrc.txt']);
        %end
    end
end
end