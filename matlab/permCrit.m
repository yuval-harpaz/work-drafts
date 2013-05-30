function Crit=permCrit(fileName);
if ~exist('fileName','var')
    fileName='Tval';
end
% after running ./permute.sh in /home/yuval/Data/perm
tlist=importdata(fileName);
tNeg=sort(tlist.data(:,1));
tPos=sort(tlist.data(:,2),'descend');
Crit=(tPos(25)-tNeg(25))/2;

