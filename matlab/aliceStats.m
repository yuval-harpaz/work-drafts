function [p,stats,X]=aliceStats(ci,method,tableName,cond,test)
% ci=ER component index; 1 for N100, 2 for N170, 3 for M100, 4 for M170
cd /home/yuval/Copy/MEGdata/alice
load comps
X=zeros(length(comps.C100),2);
if ~exist('tableName','var')
    tableName='tableWH';
end
if ~exist('cond','var')
    cond='tamil';
end
switch cond
    case 'tamil'
        seg0=4;
        seg1=5;
        seg2=6;
    case 'news'
        seg0=2;
        seg1=3;
        seg2=4;
    case 'loud'
        seg0=8;
        seg1=9;
        seg2=7;
    case 'WBW'
        seg0=1;
        seg1=10;
        seg2=2;
end
% legend('1','2','4','6','7','8','3 news','5 tamil','9 loud')
for subi=1:length(comps.C100)
    subFold=sf{1,subi};
    cd (['/home/yuval/Data/alice/',subFold])
    load (['files/',tableName]);
    if ~exist('method','var')
        X(subi,1)=table(seg1,ci);
        X(subi,2)=(table(seg0,ci)+table(seg2,ci))/2;
    elseif isempty(method)
        X(subi,1)=table(seg1,ci);
        X(subi,2)=(table(seg0,ci)+table(seg2,ci))/2;
    else
        switch method
            case 'z'
                m=mean(table(:,ci)); %#ok<NODEF>
                sd=std(table(:,ci));
                X(subi,1)=(table(seg1,ci)-m)/sd;;
                X(subi,2)=((table(seg0,ci)+table(seg2,ci))/2-m)/sd;
        end
    end
end
if strcmp('tamil',cond)
    X=X(1:7,:);
end
if ~exist('test','var')
    test='t';
end
switch test
    case 't'
        [~,p,~,stats] = ttest2(X(:,1),X(:,2));
    case 'U'
        [p,~,stats]=ranksum(X(:,1),X(:,2));
end

