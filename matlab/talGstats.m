for prefi=1:3
    pref=prefs{prefi};
    for ppi=1:2
        pp=ppc{ppi};
        fileName1=[pref,num2str(ppi),'+tlrc'];
        newName=[pref,'_',pp,visit,'_DM_CM']; % Dys - Cont
        betweenGroups(subs1,subs2,fileName1,newName); % subs2-subs1;
        maskStat([newName,'+tlrc']);
    end
end