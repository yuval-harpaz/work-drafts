function [critF,sigF,Freal]=permuteMat_anova1(varA,varB,varC,pVal)
% This script is for one way repeated measures ANOVA with 3 conditions.
% every row is a subject, columns for channels



%% make a list of random shuffling of the conditions
n=size(varA,1);
M=randint(1500,30,[1 6]);
M(sum(M,2)==n,:)=[];
%M(find(sum(M')==n),:)=[];
M=M(1:1000,:);
shuffle=[1,2,3;1,3,2;2,1,3;2,3,1;3,1,2;3,2,1]; 

% random assignment of conditions:
Nperm=length(M);
fprintf(['performing ',num2str(Nperm),' permutations: '])
%vars={varA,varB};
for permi=1:Nperm
    for sampi=1:size(varA,2)
        
        dataA=varA(:,sampi);
        Subs=logical((M(permi,:)==3)+(M(permi,:)==4));
        dataA(Subs)=varB(Subs,sampi);
        Subs=logical((M(permi,:)==5)+(M(permi,:)==6));
        dataA(Subs)=varC(Subs,sampi);
        
        
        dataB=varB(:,sampi);
        Subs=logical((M(permi,:)==3)+(M(permi,:)==5));
        dataB(Subs)=varA(Subs,sampi);
        Subs=logical((M(permi,:)==2)+(M(permi,:)==4));
        dataB(Subs)=varC(Subs,sampi);
        
        dataC=varC(:,sampi);
        Subs=logical((M(permi,:)==4)+(M(permi,:)==6));
        dataC(Subs)=varA(Subs,sampi);
        Subs=logical((M(permi,:)==2)+(M(permi,:)==5));
        dataC(Subs)=varB(Subs,sampi);
        
        data=[dataA,dataB,dataC];
        [p, table] = anova_rm(data, 'off');
        Fstat(permi,sampi)=table{2,5}; %takes F value from each permutation
    end
    progNum(permi);
end

F=sort(Fstat,'descend')
critF=F(pVal*(size(F,1)),:);

% real data:
Freal=[];
for sample=1:length(varA);
    for sub=1:size(varA,1);
        newMat(sub,:)=[varA(sub,sample) varB(sub,sample) varC(sub,sample)];
    end
    [p, table] = anova_rm(newMat, 'off');
    Freal(1,sample)=table{2,5};
%     Pval(1,sample)=table{2,6};
end


sigF=find(Freal>critF);
% or (more conservative):
sigFmax=find(Freal>max(critF))