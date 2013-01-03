
load /media/Elements/MEG/tal/subs46
gr=groups(groups>0);
pref='alpha';
ppc={'pre','post'};

% subs1=subsV1(find(gr==1)); % Dyslexia Quad
% subs2=subsV1(find(gr==2)); % Control Quad
% subs3=subsV1(find(gr==3)); % Control Verbal
for visiti=1:2
    visit=num2str(visiti);
    eval(['subs1=subsV',visit,'(find(gr==1));']); % Dyslexia Quad
    eval(['subs2=subsV',visit,'(find(gr==2));']); % Control Quad
    eval(['subs3=subsV',visit,'(find(gr==3));']); % Control Verbal
    for ppi=1:2
        pp=ppc{ppi};
        fileName1=[pref,num2str(ppi),'+tlrc'];
        
        newName=[pref,'_',pp,visit,'_D_CQ']; % Dys - Cont
        betweenGroups42(subs2,subs1,fileName1,newName); % subs2-subs1;
        maskStat([newName,'+tlrc']);
        
        newName=[pref,'_',pp,visit,'_D_CV']; % Dys - Cont
        betweenGroups42(subs3,subs1,fileName1,newName); % subs2-subs1;
        maskStat([newName,'+tlrc']);
        
        newName=[pref,'_',pp,visit,'_CQ_CV']; % Dys - Cont
        betweenGroups42(subs3,subs2,fileName1,newName); % subs2-subs1;
        maskStat([newName,'+tlrc']);
    end
end
