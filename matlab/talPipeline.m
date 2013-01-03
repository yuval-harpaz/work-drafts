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
pat='/media/My Passport/MEG/tal';
talMove2tlrcH(subs,cond,pat)
pref='alpha';
talSAM_H(subs,pref,'eyesClosed',cond)
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

% in a terminal write: ./func2tlrc.txt
% view results
!/home/megadmin/abin/afni -dset warped+tlrc &

talMvResultsH(subs,cond,pref)

%% sensor level coherence
% load subs36;subs=subsV1;subs(30:58,1)=subsV2;
foi=1:50;
talCohH(subs,foi)

% L-R coherence, you need to have subs36.mat
%talGAcohLR_H([],'subs36')
talGAcohLR_DC([],'subs46');
%open talLRstats %run lines to view results.
open talLRstatsDC %run lines to view results.
open talCohLRstatsDC %permutation statistics


chan='A192';freq=10;
talStatTables(chan,freq,subsV1,groups)


%% anterior posterior coherence
% I used talAntPostChans to make lists of channels
load /media/Elements/MEG/tal/subs4
foi=1:50;
talCohH(subs,foi,[],'AntPost')
talGAcohAntPost_H
load /media/Elements/MEG/talResults/Coh/cohCv1post_DM
condA=V1post;
load /media/Elements/MEG/talResults/Coh/cohCv1post_CM
condB=V1post;
freq=10;
talCohAPstats(condA,condB,freq,0)

load /media/Elements/MEG/talResults/Coh/cohLv1pre_DM
condA=V1pre;
load /media/Elements/MEG/talResults/Coh/cohRv1pre_CM
condB=V1pre;
freq=10;
talCohAPstats(condA,condB,freq,1)

%% time production
talPowerTP(subs)
load /media/Elements/MEG/tal/subs46
talMarkers(subsV1,'timeProd');talMarkers(subsV2,'timeProd');
[cohLR,coh,freq,data]=talCohH(subsV1,[1:50],[],[],'timeProd');
[cohLR,coh,freq,data]=talCohH(subsV2,[1:50],[],[],'timeProd');
talGAcohLR_DC([],'subs46','timeProd');

%open talLRstats %run lines to view results.
open talLRstatsDC

%% one back
load('/media/My Passport/MEG/tal/subs46')
talMarkers(subsV1,'oneBack');
talMarkers(subsV2,'oneBack');
foi=1:50;
pat='/media/My Passport/MEG/tal';
[cohLR,coh,freq,data]=talCohLR(subsV1,foi,pat,'oneBack');
[cohLR,coh,freq,data]=talCohLR(subsV2,foi,pat,'oneBack'); % sub 3602 was bad
talGAcohLR_DC(pat,'subs46no36','oneBack','W');
talGAcohLR_DC(pat,'subs46no36','oneBack','NW');
% view results
open talLRstatsWNW

%% alpha SAM statistics
talGstats42 % group differences
talStats42 % post - pre
talVstats42 % visit2 - visit1