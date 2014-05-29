function table=talCohList2(chanL,chanR,freq)

cd /media/Elements/MEG/
load('talResults/Coh/cohLRv1post_D')
[~,chi]=ismember(chanL,cohLRv1post_D.label);

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

table(:,5:6,1:length(chanL))=[D;CQ;CV];
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
table(1:size([D;CQ;CV],1),7:8,1:length(chanL))=[D;CQ;CV]; % a missing subject
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
table(1:size([D;CQ;CV],1),9:10,1:length(chanL))=[D;CQ;CV];

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
for chani=1:59
    for i=1:35
        for k=1:10
            Table{i+1,k+1}=num2str(table(i,k,chani));
        end
    end
    xlwrite('coh.xls',Table,[chanL{chani},'_',chanR{chani}]);
end
    
    
function [D,CQ,CV]=getData(conds,group,chi,freq)
for gri=1:3
    for condi=1:length(conds)
        load([conds{condi},group{gri}])
        eval(['grSize=size(',conds{condi},group{gri},'.powspctrm,1);']);
        grSize=num2str(grSize);
        eval([group{gri},'(1:',grSize,',',num2str(condi),',1:length(chi))=',conds{condi},group{gri},'.powspctrm(:,[',num2str(chi),'],',num2str(freq),');']);
    end
end