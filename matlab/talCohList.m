
%% first draw of data
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

%% 10 feb 2013
% 10Hz
load('talResults/timeProdCoh/cohLRv1pre_D')
%[~,A197i]=ismember('A197',cohLRv1post_D.label);
[~,A158i]=ismember('A158',cohLRv1pre_D.label);
group={'D','CQ','CV'};
conds={'cohLRv1pre_';'cohLRv2pre_'};
cd talResults/timeProdCoh
for gri=1:3
    for condi=1:2
        load([conds{condi},group{gri}])
        eval(['grSize=size(',conds{condi},group{gri},'.powspctrm,1);']);
        grSize=num2str(grSize);
%        eval([group{gri},'_A197(1:',grSize,',',num2str(condi),')=',conds{condi},group{gri},'.powspctrm(:,A197i,10);']);
        eval([group{gri},'_A158(1:',grSize,',',num2str(condi),')=',conds{condi},group{gri},'.powspctrm(:,A158i,10);']);
    end
end

cd ../..

load('talResults/oneBackCoh/W/cohLRv1pre_D')
%[~,A197i]=ismember('A197',cohLRv1post_D.label);
[~,A158i]=ismember('A158',cohLRv1pre_D.label);
group={'D','CQ','CV'};
conds={'cohLRv1pre_';'cohLRv2pre_'};
cd talResults/oneBackCoh/W
for gri=1:3
    for condi=1:2
        load([conds{condi},group{gri}])
        eval(['grSize=size(',conds{condi},group{gri},'.powspctrm,1);']);
        grSize=num2str(grSize);
%        eval([group{gri},'_A197(1:',grSize,',',num2str(condi),')=',conds{condi},group{gri},'.powspctrm(:,A197i,10);']);
        eval([group{gri},'_A158(1:',grSize,',',num2str(condi),')=',conds{condi},group{gri},'.powspctrm(:,A158i,10);']);
    end
end


cd ../..

cd talResults/oneBackCoh/NW
for gri=1:3
    for condi=1:2
        load([conds{condi},group{gri}])
        eval(['grSize=size(',conds{condi},group{gri},'.powspctrm,1);']);
        grSize=num2str(grSize);
%        eval([group{gri},'_A197(1:',grSize,',',num2str(condi),')=',conds{condi},group{gri},'.powspctrm(:,A197i,10);']);
        eval([group{gri},'_A158(1:',grSize,',',num2str(condi),')=',conds{condi},group{gri},'.powspctrm(:,A158i,10);']);
    end
end

%% 4Hz
freq='4';
load('/media/Elements/MEG/talResults/timeProdCoh/cohLRv1pre_D')
%[~,A197i]=ismember('A197',cohLRv1post_D.label);
[~,A158i]=ismember('A158',cohLRv1pre_D.label);
group={'D','CQ','CV'};
conds={'cohLRv1pre_';'cohLRv2pre_'};
dirs={'/media/Elements/MEG/talResults/timeProdCoh','/media/Elements/MEG/talResults/oneBackCoh/W','/media/Elements/MEG/talResults/oneBackCoh/NW'};
list=[];
for diri=1:3
    cd(dirs{diri})
    for gri=1:3
        for condi=1:2
            load([conds{condi},group{gri}])
            eval(['grSize=size(',conds{condi},group{gri},'.powspctrm,1);']);
            grSize=num2str(grSize);
            %        eval([group{gri},'_A197(1:',grSize,',',num2str(condi),')=',conds{condi},group{gri},'.powspctrm(:,A197i,10);']);
            eval([group{gri},'_A158(1:',grSize,',',num2str(condi),')=',conds{condi},group{gri},'.powspctrm(:,A158i,',freq,');']);
        end
    end
    listcol2=2*diri;listcol1=listcol2-1;
    listrow=length(D_A158)+length(CQ_A158)+length(CV_A158);
    list(1:listrow,listcol1:listcol2)=[D_A158;CQ_A158;CV_A158];
end
