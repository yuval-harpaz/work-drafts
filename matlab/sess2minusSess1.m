function sess2minusSess1(subs1,subs2,tlrcFile,prefix)
% SET2-SET1 !
cd ~/Desktop/talResults
SET1='';
SET2='';
if ~exist('prefix','var')
    prefix='';
else
    prefix=[' -prefix ',prefix];
end
for subi=1:length(subs1)
    sub1=subs1{subi};sub2=subs2{subi};
    SET1=[SET1,sub1,'/',tlrcFile,' '];
    SET2=[SET2,sub2,'/',tlrcFile,' '];
end
eval(['!~/abin/3dttest',prefix,' -paired -set1 ',SET1,'-set2 ',SET2]);
%display(['!~/abin/3dttest -paired -set1 ',SET1,'-set2 ',SET2]);
end