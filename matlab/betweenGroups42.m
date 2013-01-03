function betweenGroups42(subs1,subs2,tlrcFile,prefix)
% SET2-SET1 !
cd /media/Elements/MEG/talResults
SET1='';
SET2='';
if ~exist('prefix','var')
    prefix='';
else
    prefix=[' -prefix ',prefix];
end
for sub1i=1:length(subs1)
    sub1=subs1{sub1i};
    SET1=[SET1,sub1,'/',tlrcFile,' '];
end
for sub2i=1:length(subs2)
    sub2=subs2{sub2i};
    SET2=[SET2,sub2,'/',tlrcFile,' '];
end
eval(['!~/abin/3dttest',prefix,' -set1 ',SET1,'-set2 ',SET2]);
%display(['!~/abin/3dttest -paired -set1 ',SET1,'-set2 ',SET2]);
end