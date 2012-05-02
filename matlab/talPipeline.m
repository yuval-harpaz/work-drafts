subs={'quad38'};
talSetPathH(subs)
cond='rest';
talCleanH(subs,cond)
% if necessary: cleanHBtalForced(subs,cond)
talPowerH(subs)
talOneBackH(subs)


markers94(subs)
% NUDGE
SAMTal(subs,'alpha','eyesClosed',cond)

