for prefi=1:3
    pref=prefs{prefi};
    for ppi=1:2
        pp=ppc{ppi};
        fileName1=[pref,num2str(ppi),'+tlrc'];
        newName=[pref,'_',group,pp,'_2_1']; % V2 - V1
        sess2minusSess1(V1,V2,fileName1,newName);
        maskStat([newName,'+tlrc']);
    end
end