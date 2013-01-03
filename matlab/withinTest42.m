function withinTest42(subs,tlrcFile1,tlrcFile2,prefix)
% SET2-SET1 !
cd /media/Elements/MEG/talResults
SET1='';
SET2='';
if ~exist('prefix','var')
    prefix='';
else
    prefix=[' -prefix ',prefix];
end
for subi=1:length(subs)
    sub=subs{subi};
    SET1=[SET1,sub,'/',tlrcFile1,' '];
    SET2=[SET2,sub,'/',tlrcFile2,' '];
end
eval(['!~/abin/3dttest',prefix,' -paired -set1 ',SET1,'-set2 ',SET2]);
%display(['!~/abin/3dttest -paired -set1 ',SET1,'-set2 ',SET2]);
end