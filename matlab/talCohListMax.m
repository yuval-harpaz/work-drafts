function table=talCohListMax(chan,freq)

cd /media/Elements/MEG/
load('talResults/Coh/cohLRv1post_D')
[~,chi]=ismember(chan,cohLRv1post_D.label);

group={'D','CQ','CV'};
conds={'cohLRv1pre_';'cohLRv1post_';'cohLRv2pre_';'cohLRv2post_'};
cd talResults/Coh


[D,CQ,CV]=getData(conds,group,chi,freq);
% 
% for gri=1:3
%     for condi=1:4
%         load([conds{condi},group{gri}])
%         eval(['grSize=size(',conds{condi},group{gri},'.powspctrm,1);']);
%         grSize=num2str(grSize);
%         eval([group{gri},'(1:',grSize,',',num2str(condi),')=mean(',conds{condi},group{gri},'.powspctrm(:,[',num2str(chi),'],',num2str(freq),'),2);']);
%     end
% end

table=[D;CQ;CV];
clear CQ CV D
conds={'cohLRv1pre_';'cohLRv2pre_'};
cd ../timeProdCoh
[D,CQ,CV]=getData(conds,group,chi,freq);
% for gri=1:3
%     for condi=1:2
%         load([conds{condi},group{gri}])
%         eval(['grSize=size(',conds{condi},group{gri},'.powspctrm,1);']);
%         grSize=num2str(grSize);
%         eval([group{gri},'(1:',grSize,',',num2str(condi),')=',conds{condi},group{gri},'.powspctrm(:,',num2str(chi),',',num2str(freq),');']);
%     end
% end

table(:,5:6)=[D;CQ;CV];
clear CQ CV D
cd ../oneBackCoh/W
[D,CQ,CV]=getData(conds,group,chi,freq);
% for gri=1:3
%     for condi=1:2
%         load([conds{condi},group{gri}])
%         eval(['grSize=size(',conds{condi},group{gri},'.powspctrm,1);']);
%         grSize=num2str(grSize);
%         eval([group{gri},'(1:',grSize,',',num2str(condi),')=',conds{condi},group{gri},'.powspctrm(:,',num2str(chi),',',num2str(freq),');']);
%     end
% end
table(1:size([D;CQ;CV],1),7:8)=[D;CQ;CV]; % a missing subject
clear CQ CV D

cd ../../oneBackCoh/NW
[D,CQ,CV]=getData(conds,group,chi,freq);
% for gri=1:3
%     for condi=1:2
%         load([conds{condi},group{gri}])
%         eval(['grSize=size(',conds{condi},group{gri},'.powspctrm,1);']);
%         grSize=num2str(grSize);
%         eval([group{gri},'(1:',grSize,',',num2str(condi),')=',conds{condi},group{gri},'.powspctrm(:,',num2str(chi),',',num2str(freq),');']);
%     end
% end
table(1:size([D;CQ;CV],1),9:10)=[D;CQ;CV];

if ~exist('org.apache.poi.ss.usermodel.WorkbookFactory', 'class')
    cd ~/Documents/MATLAB/20130227_xlwrite/20130227_xlwrite
    javaaddpath('poi_library/poi-3.8-20120326.jar');
    javaaddpath('poi_library/poi-ooxml-3.8-20120326.jar');
    javaaddpath('poi_library/poi-ooxml-schemas-3.8-20120326.jar');
    javaaddpath('poi_library/xmlbeans-2.3.0.jar');
    javaaddpath('poi_library/dom4j-1.6.1.jar');
end
Table={'subject';'quad01';'quad02';'quad03';'quad04';'quad08';'quad11';'quad29';'quad31';'quad39';'quad40';'quad41';'quad42';'quad05';'quad06';'quad07';'quad09';'quad10';'quad14';'quad15';'quad16';'quad18';'quad37';'quad38';'quad12';'quad20';'quad24';'quad25';'quad26';'quad27';'quad30';'quad32';'quad33';'quad34';'quad35';'quad36';};
Table(1,2:11)={'Rest_pre1coh','Rest_post1coh','Rest_pre2coh','Rest_post2coh','TP1coh','TP2coh','W1coh','W2coh','NW1c','NW2coh';};
cd ~/Desktop

for i=1:35
    for k=1:10
        Table{i+1,k+1}=num2str(table(i,k));
    end
end
xlwrite('cohMax59.xls',Table);


function [D,CQ,CV]=getData(conds,group,chi,freq)
for gri=1:3
    for condi=1:length(conds)
        load([conds{condi},group{gri}])
        eval(['grSize=size(',conds{condi},group{gri},'.powspctrm,1);']);
        grSize=num2str(grSize);
        eval([group{gri},'(1:',grSize,',',num2str(condi),')=max(',conds{condi},group{gri},'.powspctrm(:,[',num2str(chi),'],',num2str(freq),')''',');']);
    end
end

% %% 4Hz
% freq='4';
% load('/media/Elements/MEG/talResults/timeProdCoh/cohLRv1pre_D')
% %[~,A197i]=ismember(chan,cohLRv1post_D.label);
% [~,A158i]=ismember('A158',cohLRv1pre_D.label);
% group={'D','CQ','CV'};
% conds={'cohLRv1pre_';'cohLRv2pre_'};
% dirs={'/media/Elements/MEG/talResults/timeProdCoh','/media/Elements/MEG/talResults/oneBackCoh/W','/media/Elements/MEG/talResults/oneBackCoh/NW'};
% list=[];
% for diri=1:3
%     cd(dirs{diri})
%     for gri=1:3
%         for condi=1:2
%             load([conds{condi},group{gri}])
%             eval(['grSize=size(',conds{condi},group{gri},'.powspctrm,1);']);
%             grSize=num2str(grSize);
%             %        eval([group{gri},'_A197(1:',grSize,',',num2str(condi),')=',conds{condi},group{gri},'.powspctrm(:,A197i,10);']);
%             eval([group{gri},'_A158(1:',grSize,',',num2str(condi),')=',conds{condi},group{gri},'.powspctrm(:,A158i,',freq,');']);
%         end
%     end
%     listcol2=2*diri;listcol1=listcol2-1;
%     listrow=length(D_A158)+length(CQ_A158)+length(CV_A158);
%     list(1:listrow,listcol1:listcol2)=[D_A158;CQ_A158;CV_A158];
% end
