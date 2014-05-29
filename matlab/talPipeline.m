

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
% pref='alpha';
pref='gamma';
talSAM_H(subs,pref,'eyesClosed',cond)
%pat='/media/My Passport/MEG/tal';
pat='/media/Elements/MEG/tal';
% talMove2tlrcH(subs,cond,pat)
%SVL='alpha,7-13Hz,eyesClosed-NULL,P,Zp.svl';

SVL='gamma,25-45Hz,eyesClosed-NULL,P,Zp.svl';
talFunc2tlrcH(subs,cond,SVL,pref)
talMvResultsH(subs,cond,pref)
talGstats42('gamma');

pref='theta';
subs={'quad38','quad39','quad40','quad41','quad42','quad3802','quad3902','quad4002','quad4102','quad4202'};
talSAM_H(subs,pref,'eyesClosed',cond)
SVL='theta,3-7Hz,eyesClosed-NULL,P,Zp.svl';
talFunc2tlrcH(subs,cond,SVL,pref)
display('run ~/func2tlrc.txt')
talMvResultsH(subs,cond,pref)
talGstats42('theta');
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
open talCohList %prepare list of channel info for rest

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
open talLRcohFigs
talPower1bk(subsV1);
%% alpha SAM statistics
talGstats42 % group differences
talStats42 % post - pre
talVstats42 % visit2 - visit1

%% voxel values
pat='/media/Elements/MEG/tal';
load([pat,'/subs46'])
gr=groups(groups>0);
subs1=subsV1(find(gr<4)); % all
coordinates=[27, -37, 55;9, -37, -15;57, 27,2;37, -78,9];
alphaV1Pre=talCorBehav1(subs1,coordinates,'alpha1',pat);
alphaV1Post=talCorBehav1(subs1,coordinates,'alpha2',pat);
subs2=subsV2(find(gr<4)); % all
alphaV2Pre=talCorBehav1(subs2,coordinates,'alpha1',pat);
alphaV2Post=talCorBehav1(subs2,coordinates,'alpha2',pat);

%% 10.02.13
open talCohList

open talPowList
chan='A171';
freq=4;
[list,labels]=talPowList1(chan,freq);
freq=10;
[list,labels]=talPowList1(chan,freq);

%% 03.03.13
% mean coh and pow
talAvgCoh4Plot(4)
figure;talAvgCoh4Plot(4,{'A157','A172'})
figure;talAvgCoh4Plot(10,{'A157','A172'})

%%
chans4Hz= {'A155', 'A156', 'A157', 'A158', 'A178', 'A179', 'A212'};
chans10Hz=  {'A129', 'A130', 'A131', 'A156', 'A157', 'A158', 'A159', 'A180', 'A181', 'A197', 'A198'};
pat='/media/Elements/MEG/tal';
% load([pat,'/subs46'])
chan='A198';freq=10;
table=talCohList1(chan,freq);
table10=talCohList1(chans10Hz,10);
table4=talCohList1(chans4Hz,4);
figure;talAvgCoh4Plot(10,chans10Hz);

[list,labels]=talPowList1(chan,freq);

%% LRcoh WNW source level
[cohLR,coh,freq,data]=talWNW(subsV1,foi,pat,'oneBack');
[cohLR,coh,freq,data]=talWNW({'quad01'},4); % FIXME - write LR BRIK files

%% 21.05.13
talGApow
talpowFigs
talPowNorm
talPowGAplot(file,freq)
%% 29.10.13
cd /media/Elements/MEG/talResults/Coh
load LRchans
%load LRpairs
chans=Lchannel;
chans(60:118)=Rchannel;
freq=10;

talStatPlot('cohLRv1pre_D','cohLRv1pre_C',[freq freq],[0 1],'ttest2',chans',1);
talStatPlot('cohLRv2pre_D','cohLRv2pre_C',[freq freq],[0 1],'ttest2',chans',1);


talStatPlot('cohLRv2pre_D','cohLRv2post_D',[freq freq],[0 1],'paired-ttest',chans',1);
talStatPlot('cohLRv2pre_D','cohLRv1pre_C',[freq freq],[0 1],'ttest2',chans',1);


talStatPlot('cohLRv1pre_D','cohLRv1pre_CQ',[freq freq],[0 1],'ttest2',chans',1);
talStatPlot('cohLRv2pre_D','cohLRv2pre_CQ',[freq freq],[0 1],'ttest2',chans',1);
talStatPlot('cohLRv2pre_D','cohLRv2post_D',[freq freq],[0 1],'paired-ttest',chans',1);
talStatPlot('cohLRv2pre_D','cohLRv1pre_CQ',[freq freq],[0 1],'ttest2',chans',1);
% repeated measures ANOVA
talStatPlot_rm('cohLRv1pre_D','cohLRv1pre_CQ','cohLRv2pre_D','cohLRv2pre_CQ',[freq freq],[0 1],chans',1,0.05);
talStatPlot_rm('cohLRv1pre_D','cohLRv1pre_CQ','cohLRv2pre_D','cohLRv2pre_CQ',[freq freq],[0 1],chans',1,0.01);
talStatPlot_rm('cohLRv1pre_D','cohLRv1pre_CQ','cohLRv2pre_D','cohLRv2pre_CQ',[freq freq],[0 1],chans',1,0.005);

pat='/media/Elements/MEG/tal';
chan='A133';freq=10;
table=talCohList1(chan,freq);

talStatPlotFds('cohLRv1pre_D','cohLRv1pre_CQ','cohLRv2pre_D','cohLRv2pre_CQ',[freq freq],[0 1],chans',1,0.01);

%% back to z from p
talLogPtoZ('alpha1')
cd /media/Elements/MEG/talResults
!3dttest -prefix alphaz_pre2_D_CQ -set1 quad0502/alpha1z+tlrc quad0602/alpha1z+tlrc quad0702/alpha1z+tlrc quad0902/alpha1z+tlrc quad1002/alpha1z+tlrc quad1402/alpha1z+tlrc quad1502/alpha1z+tlrc quad1602/alpha1z+tlrc quad1802/alpha1z+tlrc quad3802/alpha1z+tlrc -set2 quad01b/alpha1z+tlrc quad0202/alpha1z+tlrc quad0302/alpha1z+tlrc quad0402/alpha1z+tlrc quad0802/alpha1z+tlrc quad1102/alpha1z+tlrc quad2902/alpha1z+tlrc quad3102/alpha1z+tlrc quad3902/alpha1z+tlrc quad4002/alpha1z+tlrc quad4102/alpha1z+tlrc quad4202/alpha1z+tlrc
!3dttest -prefix alphaz_pre1_D_CQ -set1 quad05/alpha1z+tlrc quad06/alpha1z+tlrc quad07/alpha1z+tlrc quad09/alpha1z+tlrc quad10/alpha1z+tlrc quad14/alpha1z+tlrc quad15/alpha1z+tlrc quad16/alpha1z+tlrc quad18/alpha1z+tlrc quad38/alpha1z+tlrc -set2 quad01/alpha1z+tlrc quad02/alpha1z+tlrc quad03/alpha1z+tlrc quad04/alpha1z+tlrc quad08/alpha1z+tlrc quad11/alpha1z+tlrc quad29/alpha1z+tlrc quad31/alpha1z+tlrc quad39/alpha1z+tlrc quad40/alpha1z+tlrc quad41/alpha1z+tlrc quad42/alpha1z+tlrc
% copied them to /media/Elements/MEG/talResults/subs42
cd subs42
masktlrc('alphaz_pre2_D_CQ+tlrc')
masktlrc('alphaz_pre1_D_CQ+tlrc')


!3dttest -prefix alphaz_Dpre_2_1 -paired -set1 quad01/alpha1+tlrc quad02/alpha1+tlrc quad03/alpha1+tlrc quad04/alpha1+tlrc quad08/alpha1+tlrc quad11/alpha1+tlrc quad29/alpha1+tlrc quad31/alpha1+tlrc quad39/alpha1+tlrc quad40/alpha1+tlrc quad41/alpha1+tlrc quad42/alpha1+tlrc -set2 quad01b/alpha1+tlrc quad0202/alpha1+tlrc quad0302/alpha1+tlrc quad0402/alpha1+tlrc quad0802/alpha1+tlrc quad1102/alpha1+tlrc quad2902/alpha1+tlrc quad3102/alpha1+tlrc quad3902/alpha1+tlrc quad4002/alpha1+tlrc quad4102/alpha1+tlrc quad4202/alpha1+tlrc
!3dttest -prefix alphaz_CQpre_2_1 -paired -set1 quad05/alpha1+tlrc quad06/alpha1+tlrc quad07/alpha1+tlrc quad09/alpha1+tlrc quad10/alpha1+tlrc quad14/alpha1+tlrc quad15/alpha1+tlrc quad16/alpha1+tlrc quad18/alpha1+tlrc quad38/alpha1+tlrc -set2 quad0502/alpha1+tlrc quad0602/alpha1+tlrc quad0702/alpha1+tlrc quad0902/alpha1+tlrc quad1002/alpha1+tlrc quad1402/alpha1+tlrc quad1502/alpha1+tlrc quad1602/alpha1+tlrc quad1802/alpha1+tlrc quad3802/alpha1+tlrc
!mv alphaz*_2_1* subs42/
cd subs42
masktlrc('alphaz_Dpre_2_1+tlrc')
masktlrc('alphaz_CQpre_2_1+tlrc')

%3dttest -prefix alpha_Dpre_2_1 -paired -set1 quad01/alpha1+tlrc quad02/alpha1+tlrc quad03/alpha1+tlrc quad04/alpha1+tlrc quad08/alpha1+tlrc quad11/alpha1+tlrc quad29/alpha1+tlrc quad31/alpha1+tlrc quad39/alpha1+tlrc quad40/alpha1+tlrc quad41/alpha1+tlrc quad42/alpha1+tlrc -set2 quad01b/alpha1+tlrc quad0202/alpha1+tlrc quad0302/alpha1+tlrc quad0402/alpha1+tlrc quad0802/alpha1+tlrc quad1102/alpha1+tlrc quad2902/alpha1+tlrc quad3102/alpha1+tlrc quad3902/alpha1+tlrc quad4002/alpha1+tlrc quad4102/alpha1+tlrc quad4202/alpha1+tlrc\n[yuval@meg2: Tue Jan  1 11:35:22 2013] ===================================\n[yuval@meg2: Tue Jan  1 11:35:22 2013] 3dcalc -a /home/yuval/SAM_BIU/docs/MASK+tlrc -b tempStat+tlrc -expr 'a*b' -prefix masked~

[Dys,Cont]=talDataVox;

[Dys,Cont]=talDataVox([-27 8 57]); %left middle frontal gyrus
[Dys,Cont]=talDataVox([23 53 17]); %right superior frontal gyrus
[Dys,Cont]=talDataVox([13 18 42]); %right cigulate gyrus / right SMA

%% 25.05.14
cd /media/Elements/MEG/talResults/Coh
load LRchans
%load LRpairs
chans=Lchannel;
chans(60:118)=Rchannel;
freq=10;
cd /media/Elements/MEG/talResults/timeProdCoh
talStatPlot_rm('cohLRv1pre_D','cohLRv1pre_CQ','cohLRv2pre_D','cohLRv2pre_CQ',[freq freq],[0 1],chans',1,0.05);
cd /media/Elements/MEG/talResults/oneBackCoh/NW
talStatPlot_rm('cohLRv1pre_D','cohLRv1pre_CQ','cohLRv2pre_D','cohLRv2pre_CQ',[freq freq],[0 1],chans',1,0.05);
cd /media/Elements/MEG/talResults/oneBackCoh/W
talStatPlot_rm('cohLRv1pre_D','cohLRv1pre_CQ','cohLRv2pre_D','cohLRv2pre_CQ',[freq freq],[0 1],chans',1,0.05);

% cd /media/Elements/MEG/talResults/oneBackCoh/
% [P,figure1]=talStatPlotWNW_rm('W/cohLRv1pre_D','W/cohLRv1pre_CQ','W/cohLRv2pre_D','W/cohLRv2pre_CQ','NW/cohLRv1pre_D','NW/cohLRv1pre_CQ','NW/cohLRv2pre_D','NW/cohLRv2pre_CQ',[freq freq],[0 1],chans',1,0.05);

talCohList2(Lchannel,Rchannel,10);
talCohList1(Lchannel,10);
talCohListMax(Lchannel,10);
load('/media/Elements/MEG/tal/subs46')
talSAM_TP(subsV1,'alpha')
chans5={'A234','A215','A233','A231','A230'};
talCohList1(chans5,10);

%%

subsV1={'quad01';'quad02';'quad03';'quad04';'quad08';'quad11';'quad29';'quad31';'quad39';'quad40';'quad41';'quad42';'quad05';'quad06';'quad07';'quad09';'quad10';'quad14';'quad15';'quad16';'quad18';'quad37';'quad38';'quad12';'quad20';'quad24';'quad25';'quad26';'quad27';'quad30';'quad32';'quad33';'quad34';'quad35';'quad36';};
subsV2={'quad01b';'quad0202';'quad0302';'quad0402';'quad0802';'quad1102';'quad2902';'quad3102';'quad3902';'quad4002';'quad4102';'quad4202';'quad0502';'quad0602';'quad0702';'quad0902';'quad1002';'quad1402';'quad1502';'quad1602';'quad1802';'quad3702';'quad3802';'quad1202';'quad2002';'quad2402';'quad2502';'quad2602';'quad2702';'quad3002';'quad3202';'quad3302';'quad3402';'quad3502';'quad3602';};
talSAM_TP(subsV1,'alpha')
talSAM_TP(subsV2,'alpha')




% %pat='/media/My Passport/MEG/tal';
% pat='/media/Elements/MEG/tal';
% % talMove2tlrcH(subs,cond,pat)
% %SVL='alpha,7-13Hz,eyesClosed-NULL,P,Zp.svl';
% 
% SVL='gamma,25-45Hz,eyesClosed-NULL,P,Zp.svl';
% talFunc2tlrcH(subs,cond,SVL,pref)
% talMvResultsH(subs,cond,pref)
% talGstats42('gamma');
% 
% pref='theta';
% subs={'quad38','quad39','quad40','quad41','quad42','quad3802','quad3902','quad4002','quad4102','quad4202'};
% talSAM_H(subs,pref,'eyesClosed',cond)
% SVL='theta,3-7Hz,eyesClosed-NULL,P,Zp.svl';
% talFunc2tlrcH(subs,cond,SVL,pref)
% display('run ~/func2tlrc.txt')
% talMvResultsH(subs,cond,pref)
% talGstats42('theta');