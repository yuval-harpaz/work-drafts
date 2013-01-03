load /media/Elements/MEG/tal/subs46
gr=groups(groups>0);
pref='alpha';
ppc={'pre','post'};
% subs1=subsV1(find(gr==1)); % Dyslexia Quad
% subs2=subsV1(find(gr==2)); % Control Quad
% subs3=subsV1(find(gr==3)); % Control Verbal

% pref=prefs{prefi};
% post - pre
for visiti=1:2
    visit=num2str(visiti);
    eval(['subs1=subsV',visit,'(find(gr==1));']); % Dyslexia Quad
    eval(['subs2=subsV',visit,'(find(gr==2));']); % Control Quad
    eval(['subs3=subsV',visit,'(find(gr==3));']); % Control Verbal
    fileName1=[pref,'1+tlrc'];
    fileName2=[pref,'2+tlrc'];
    newName=[pref,'_D_post_pre',visit];
    withinTest42(subs1,fileName1,fileName2,newName);
    masktlrc([newName,'+tlrc']);
    newName=[pref,'_CQ_post_pre',visit];
    withinTest42(subs2,fileName1,fileName2,newName);
    masktlrc([newName,'+tlrc']);
    newName=[pref,'_CV_post_pre',visit];
    withinTest42(subs3,fileName1,fileName2,newName);
    masktlrc([newName,'+tlrc']);
end
