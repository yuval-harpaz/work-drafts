function zeroTest(subs,tlrcFile,prefix)
% SET2-SET1 !
if ~exist('prefix','var')
    prefix='';
else
    prefix=[' -prefix ',prefix];
end
cd ~/Desktop/talResults
SET='';
for subi=1:length(subs)
    sub=subs{subi};
    SET=[SET,sub,'/',tlrcFile,' '];
end
eval(['!~/abin/3dttest',prefix,' -base1 0 -set2 ',SET]);
% display(['!~/abin/3dttest -paired -set1 ',SET1,'-set2 ',SET2]);
end