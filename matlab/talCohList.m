

load('talResults/Coh/cohLRv1post_D')
[~,A197i]=ismember('A197',cohLRv1post_D.label);
[~,A158i]=ismember('A158',cohLRv1post_D.label);
group={'D','CQ','CV'};
conds={'cohLRv1pre_';'cohLRv1post_';'cohLRv2pre_';'cohLRv2post_'};
cd talResults/Coh
for gri=1:3
    for condi=1:4
        load([conds{condi},group{gri}])
        eval(['grSize=size(',conds{condi},group{gri},'.powspctrm,1);']);
        grSize=num2str(grSize);
        eval([group{gri},'_A197(1:',grSize,',',num2str(condi),')=',conds{condi},group{gri},'.powspctrm(:,A197i,10);']);
        eval([group{gri},'_A158(1:',grSize,',',num2str(condi),')=',conds{condi},group{gri},'.powspctrm(:,A158i,10);']);
    end
end