load ~/work-drafts/matlab/pathBIU;path(pathBIU);
subs={'quad38'};
talSetPathH(subs)
cond='rest';
talCleanH(subs,cond)
% if necessary: cleanHBtalForced(subs,cond)
talPowerH(subs)
talOneBackH(subs)

cd /media/Elements/MEG/tal
talMarkers94H(subs)

%% NUDGE

cd quad38
load subpath; cd(subpath);
% cd into directrory and copy address

% in a terminal: 
% cd <paste address here>
% afni
%% 
talMove2tlrcH(subs,cond)

talSAM_H(subs,'alpha','eyesClosed',cond)

SVL='alpha,7-13Hz,eyesClosed-NULL,P,Zp.svl';
talFunc2tlrcH(subs,cond,SVL,pref)