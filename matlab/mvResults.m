function mvResults(subs,cond,pref)
% cond='rest';
% SVL='alpha,7-13Hz,eyesClosed-NULL,P,Zp.svl';


cd ('/home/yuval/Desktop/tal')
for subi=1:length(subs)
    cd ('/home/yuval/Desktop/tal')
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
%             if ~exist(['~/Desktop/talResults/',sub,'/',num2str(condi)],'dir')
%                 mkdir(['~/Desktop/talResults/',sub,'/',num2str(condi)]);
%             end
            eval(['!cp ',pref,num2str(condi),'+tlrc.BRIK ~/Desktop/talResults/',sub,'/'])
            eval(['!cp ',pref,num2str(condi),'+tlrc.HEAD ~/Desktop/talResults/',sub,'/'])
        end
    end
end
end