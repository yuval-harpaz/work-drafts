%function [GApowD,GApowM,GApowV]=talGApow
%powList
%chan='A158';
%freq=[4,10];

pat='/media/Elements/MEG/talResults'
cd(pat)

% % load squad01_pow94_1
% % 
cfg=[];
cfg.keepindividual='yes';
% % 

%[~,chi]=ismember(chan,pow.label);
load /media/Elements/MEG/tal/subs46
gr=groups(groups>0);

labels={'rest_pre','rest_post','tp','W','NW'};
condCode={'_pow94_1','_pow94_2','_pow112','_pow_W','_pow_NW'};
groupLabel={'D','CQ','CV'};
for condi=1:length(labels)
    for visiti=1:2
        for groupi=1:3
            eval(['subsG=subsV',num2str(visiti),'(find(gr==',num2str(groupi),'));']);
            grstr=groupLabel{groupi};
            clear pow*
            subStr='';
            for subi=1:length(subsG)
               try
                    load(['s',subsG{subi},condCode{condi}])
                    eval(['pow',num2str(subi),'=pow;'])
                    subStr=[subStr,'pow',num2str(subi),','];
                    %col(subi,1:length(freq))=pow.powspctrm(chi,freq);
                catch
                    display([subsV1{subi},' had an error. was there a s',subsG{subi},condCode{condi},' file?']);
               end
            end
            eval(['GApow=ft_freqgrandaverage(cfg,',subStr(1:end-1),');']);
            name=['pow_',labels{condi},'_v',num2str(visiti),'_',grstr];
            disp(name)
            eval([name,'=GApow;'])
            save(['pow/',name],name)
            
        end
    end
end
% cd pow
% d=dir;
% for i=3:32
%     name=d(i,1).name
%     load(name)
%     eval(['smp(i)=',name(1:end-4),'.powspctrm(1,1,1);'])
% end
% smp(3:end)