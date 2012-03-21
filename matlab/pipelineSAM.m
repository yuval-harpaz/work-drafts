cleanTal(subs,'rest');
powerTal(subs);
markers94(subs);
cd /home/yuval/Desktop/tal
subs=textread('subs4.txt','%s');
cond='rest';
pref='gamma';freq='25-45'; % pref='alpha';freq='7-13'; pref='theta';freq='3-7';
SAMTal(subs,pref,'eyesClosed',cond)
%% 
move2tlrc(subs,cond)
% in a terminal run ./warped2tlrc
SVL=[pref,',',freq,'Hz,eyesClosed-NULL,P,Zp.svl'];
func2tlrc(subs,cond,SVL,pref)
% in a terminal run ./func2tlrc.txt

%%

mvResults(subs,cond,pref);
subs4=importdata('subs4.txt');subs3=importdata('subs3.txt');
subs=subs3;subs(end+1:end+length(subs4))=subs4;
subs1=subs(1:2:end);subs2=subs(2:2:end);

fileName1=[pref,'1+tlrc'];fileName2=[pref,'2+tlrc'];
%% percent change
% devideSource(subs1,subs2,fileName1);
% devideSource(subs1,subs2,fileName2);
% devideSource2(subs,fileName1,fileName2);
% 
% % post / pre visit 1
% zeroTest(subs1,['PC_',fileName2(1:end-5),'_',fileName1],['PC',pref,'_post_pre_visit1']);
% % post / pre visit 2
% zeroTest(subs2,['PC_',fileName2(1:end-5),'_',fileName1],['PC',pref,'_post_pre_visit2']);    
% % pre2 / pre1
% zeroTest(subs1,['PC_',fileName1],['PC',pref,'_pre2_pre1']);
% % post2 / post1
% zeroTest(subs1,['PC_',fileName2],['PC',pref,'_post2_post1']);

%% reduction
% pref='gamma'; pref='alpha'; pref='theta';
%fileName1=[pref,'1+tlrc'];fileName2=[pref,'2+tlrc'];

% post - pre visit 1
withinTest(subs1,fileName1,fileName2,[pref,'_post_pre_visit1']);
masktlrc([pref,'_post_pre_visit1+tlrc']);
% post - pre visit 2
withinTest(subs2,fileName1,fileName2,[pref,'_post_pre_visit2']);
masktlrc([pref,'_post_pre_visit2+tlrc']);
% pre2 - pre1
sess2minusSess1(subs1,subs2,fileName1,[pref,'_pre2_pre1']);
masktlrc([pref,'_pre2_pre1+tlrc']);
% post2 - post1
sess2minusSess1(subs1,subs2,fileName2,[pref,'_post2_post1']);
masktlrc([pref,'_post2_post1+tlrc']);

%% group differences Dislexia - control
subs1=textread('groupC.txt','%s');
subs2=textread('groupD.txt','%s');
%cond='rest';
pref='theta';
%freq='3-7';
fileName1=[pref,'1+tlrc'];
newName=[pref,'_pre1_D_C'];
betweenGroups(subs1,subs2,fileName1,newName);
maskStat([newName,'+tlrc']);

%% coh on sources
% virtual sensors
tlrc=[ -40 -18 -8;40 -18 -8;... %   LR hippo, Wink 2006
    -49 17 17;49 17 17;... %        Broca
    -39 29 -6;39 29 -6;... %        IFG 47
    -48 -5 -21;48 -5 -21;... %      ITG
    -57 -12 -2;57 -12 -2;... %      STG
    -14 -20 12;14 -20 12;... %      thalamus
    -34 18 2;34 18 2;...    %       insula
    -30 -61 -36;30 -61 -36;... %    cerebellum
    -35 -25 60;35 -25 60]; %        Mu center
    
talSourceCoh(subs,tlrc);
% for every subject use vox=round(0.2*tlrc2orig(tlrc))/2; 
%% make a table for talSourceCoh results
subs=importdata('/home/yuval/Desktop/tal/subs3.txt')
cd /home/yuval/Desktop/talResults/CohSource
% load cohTemp
rownum=1;BroWer=[];
for subi =1:2:length(subs)
       for combi=1:18
           load(subs{subi});
            BroWer(rownum,1)=squeeze(squeeze(mean(coh1.cohspctrm(3,9,(8:13)),3)));
            BroWer(rownum,2)=squeeze(squeeze(mean(coh2.cohspctrm(3,9,(8:13)),3)));
            load(subs{(subi+1)});
            BroWer(rownum,3)=squeeze(squeeze(mean(coh1.cohspctrm(3,9,(8:13)),3)));
            BroWer(rownum,4)=squeeze(squeeze(mean(coh2.cohspctrm(3,9,(8:13)),3)));
            
       end
       display(num2str(rownum))
       rownum=rownum+1;
end

[H,P,CI,STATS] = ttest(BroWer(1,:),0)

%% new groups analysis
% 1=DM 2=CM 3=CV

% compare groups for 1 condition
load /home/yuval/Desktop/tal/subs36
gr=groups(groups>0);
prefs={'theta','alpha','gamma'};
ppc={'pre','post'};

subs1=subsV1(find(gr==2))% CM, control, motor learning
subs2=subsV1(find(gr==1))% DM
visit='1';
talGstats % subs2-subs1
talStats % post-pre

subs1=subsV2(find(gr==2))% CM, control, motor learning
subs2=subsV2(find(gr==1))% DM
visit='2';
talGstats % subs2-subs1
talStats % post-pre
!mv *post_pre* subs36

V1=subsV1(find(gr==2)); % CM
V2=subsV2(find(gr==2));
group='CM';
talVstats % visit 2 - visit 1

V1=subsV1(find(gr==1)); % DM
V2=subsV2(find(gr==1));
group='DM';
talVstats % visit 2 - visit 1
!mv *_2_1* subs36



            
            
            
       
