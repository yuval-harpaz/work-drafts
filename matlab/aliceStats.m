function [p,stats]=aliceStats(ci)
% ci=1 for N100, 2 for N170, 3 for M100, 4 for M170
cd /home/yuval/Copy/MEGdata/alice
load comps

% legend('1','2','4','6','7','8','3 news','5 tamil','9 loud')
for subi=1:length(comps.C100)
    subFold=sf{1,subi};
    cd (['/home/yuval/Data/alice/',subFold])
    load files/tablesWH
    X(subi,1)=table(5,ci);
    X(subi,2)=(table(4,ci)+table(6,ci))/2;
end
[~,p,~,stats] = ttest2(X(:,1),X(:,2))   

