cd /home/yuval/Desktop/tal
subs=textread('subs3.txt','%s');
cond='rest';
pref='gamma';
SAMTal(subs,'gamma','eyesClosed',cond)
%% 
SVL='gamma,25-45Hz,eyesClosed-NULL,P,Zp.svl';
func2tlrc(subs,cond,SVL,pref)
%% now run ./func2tlrc.txt

%%

mvResults(subs,cond,pref);
subs1=subs(1:2:end);subs2=subs(2:2:end);
fileName1=[pref,'1+tlrc'];fileName2=[pref,'2+tlrc'];
%% percent change
devideSource(subs1,subs2,fileName1);
devideSource(subs1,subs2,fileName2);
devideSource2(subs,fileName1,fileName2);

% post / pre visit 1
zeroTest(subs1,['PC_',fileName2(1:end-5),'_',fileName1],['PC',pref,'_post_pre_visit1']);
% post / pre visit 2
zeroTest(subs2,['PC_',fileName2(1:end-5),'_',fileName1],['PC',pref,'_post_pre_visit2']);    
% pre2 / pre1
zeroTest(subs1,['PC_',fileName1],['PC',pref,'_pre2_pre1']);
% post2 / post1
zeroTest(subs1,['PC_',fileName2],['PC',pref,'_post2_post1']);

%% reduction
% post - pre visit 1
withinTest(subs1,fileName1,fileName2,[pref,'_post_pre_visit1']);
% post - pre visit 2
withinTest(subs2,fileName1,fileName2,[pref,'_post_pre_visit2']);
% pre2 - pre1
sess2minusSess1(subs1,subs2,fileName1,[pref,'_pre2_pre1']);
% post2 - post1
sess2minusSess1(subs1,subs2,fileName2,[pref,'_post2_post1']);

%%