subs={'quad37'};
setPathsTal(subs)
cond='rest';
cleanTal(subs,cond)
% if necessary: cleanHBtalForced(subs,cond)
powerTal(subs)
oneBack(subs)


markers94(subs)
% NUDGE
SAMTal(subs,'alpha','eyesClosed',cond)

