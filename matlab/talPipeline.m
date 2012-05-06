subs={'quad38'};
talSetPathH(subs)
cond='rest';
talCleanH(subs,cond)
% if necessary: cleanHBtalForced(subs,cond)
talPowerH(subs)
talOneBackH(subs)


talMarkers94H(subs)
% NUDGE
talSAM_H(subs,'alpha','eyesClosed',cond)

