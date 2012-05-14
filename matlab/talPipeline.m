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

%% hilbert envelope correlations
coords=[ -40 -18 -8;40 -18 -8;... %   LR hippo, Wink 2006
-49 17 17;49 17 17;... %        Broca
-39 29 -6;39 29 -6;... %        IFG 47
-48 -5 -21;48 -5 -21;... %      ITG
-57 -12 -2;57 -12 -2;... %      STG
-14 -20 12;14 -20 12;... %      thalamus
-34 18 2;34 18 2;...    %       insula
-30 -61 -36;30 -61 -36;... %    cerebellum
-35 -25 60;35 -25 60]; % central
% subs={'quad01'};
load /home/yuval/Desktop/tal/subs36
subs=subsV1';subs(30:(29*2))=subsV2;
coordType = 'tlrc'; % 'orig' (in pri) or 'tlrc' (in lpi);
label={'Lhip';'Rhip';'Lbr';'Rbr';'L47';'R47';'Litg';'Ritg';'Lstg';'Rstg';'Ltha';'Rtha';'Lins';'Rins';'Lcereb';'Rcereb';'Lmu';'Rmu'};
freq='alpha';
talHilb2(subs,coords,coordType,label,'alpha',[74,204],pat);