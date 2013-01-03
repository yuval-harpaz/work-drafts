
load /media/Elements/MEG/tal/subs46
gr=groups(groups>0);
pref='alpha';
ppc={'pre','post'};
subs1=subsV1(find(gr==1)); % Dyslexia Quad
subs2=subsV1(find(gr==2)); % Control Quad
subs3=subsV1(find(gr==3)); % Control Verbal
subs4=subsV2(find(gr==1)); % Dyslexia Quad
subs5=subsV2(find(gr==2)); % Control Quad
subs6=subsV2(find(gr==3)); % Control Verbal

for ppi=1:2
    pp=ppc{ppi};
    fileName1=[pref,num2str(ppi),'+tlrc'];
    newName=[pref,'_D',pp,'_2_1']; % V2 - V1
    sess2minusSess1(subs1,subs4,fileName1,newName);
    maskStat([newName,'+tlrc']);
    
    newName=[pref,'_CQ',pp,'_2_1']; % V2 - V1
    sess2minusSess1(subs2,subs5,fileName1,newName);
    maskStat([newName,'+tlrc']);
    
    newName=[pref,'_CV',pp,'_2_1']; % V2 - V1
    sess2minusSess1(subs3,subs6,fileName1,newName);
    maskStat([newName,'+tlrc']);
end
