for prefi=1:3
    pref=prefs{prefi};
    % post - pre
    fileName1=[pref,'1+tlrc'];
    fileName2=[pref,'2+tlrc'];
    newName=[pref,'_CM_post_pre',visit];
    withinTest(subs1,fileName1,fileName2,newName);
    masktlrc([newName,'+tlrc']);
    newName=[pref,'_DM_post_pre',visit];
    withinTest(subs2,fileName1,fileName2,newName);
    masktlrc([newName,'+tlrc']);
end