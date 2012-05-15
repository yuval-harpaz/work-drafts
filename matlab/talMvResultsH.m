function talMvResultsH(subs,cond,pref)
% cond='rest';
% SVL='alpha,7-13Hz,eyesClosed-NULL,P,Zp.svl';


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
        %funcName=SVL(1:(end-4));
        if exist([pref,num2str(condi),'+tlrc.BRIK'],'file')
%             if ~exist(['~/media/Elements/MEG/talResults/',sub,'/',num2str(condi)],'dir')
%                 mkdir(['~/media/Elements/MEG/talResults/',sub,'/',num2str(condi)]);
%             end
            if ~exist(['/media/Elements/MEG/talResults/',sub],'dir')
                mkdir (['/media/Elements/MEG/talResults/',sub]);
            end
            eval(['!cp ',pref,num2str(condi),'+tlrc.BRIK /media/Elements/MEG/talResults/',sub,'/'])
            eval(['!cp ',pref,num2str(condi),'+tlrc.HEAD /media/Elements/MEG/talResults/',sub,'/'])
        end
    end
end
end
