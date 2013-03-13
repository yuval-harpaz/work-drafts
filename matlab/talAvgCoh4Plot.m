function talAvgCoh4Plot(freq,highlight)
cd /media/Elements/MEG/talResults
load LRpairs
LRcoh=zeros(1,246,50);
sessions={'pre','post'};
grps={'D','CQ','CV'};
folder='Coh';
count=0;
for vi=1:2
    for sessi=1:length(sessions)
        for grpi=1:3
            str=['cohLRv',num2str(vi),sessions{sessi},'_',grps{grpi}];
            load([folder,'/',str])
            eval(['LRcoh=LRcoh+mean(',str,'.powspctrm,1);'])
            count=count+1;
        end
    end
end

LRcoh=LRcoh./count;
eval(['LRrest=',str]);
for i=1:246
    chs(i)=~ismember(LRrest.label{i},LRpairs); %#ok<NODEF>
end
LRcoh(1,find(chs),:)=1;
LRrest.powspctrm=LRcoh;

LRcoh=zeros(1,246,50);
folder='oneBackCoh/W';
sessions={'pre'};
count=0;
for vi=1:2
    for sessi=1:length(sessions)
        for grpi=1:3
            str=['cohLRv',num2str(vi),sessions{sessi},'_',grps{grpi}];
            load([folder,'/',str])
            eval(['LRcoh=LRcoh+mean(',str,'.powspctrm,1);'])
            count=count+1;
        end
    end
end
LRcoh=LRcoh./count;
eval(['LRw=',str]);
LRcoh(1,find(chs),:)=1;
LRw.powspctrm=LRcoh;

LRcoh=zeros(1,246,50);
folder='oneBackCoh/NW';
sessions={'pre'};
count=0;
for vi=1:2
    for sessi=1:length(sessions)
        for grpi=1:3
            str=['cohLRv',num2str(vi),sessions{sessi},'_',grps{grpi}];
            load([folder,'/',str])
            eval(['LRcoh=LRcoh+mean(',str,'.powspctrm,1);'])
            count=count+1;
        end
    end
end
LRcoh=LRcoh./count;
eval(['LRnw=',str]);
LRcoh(1,find(chs),:)=1;
LRnw.powspctrm=LRcoh;

LRob=LRw;
LRob.powspctrm=(LRw.powspctrm+LRnw.powspctrm)./2;

LRcoh=zeros(1,246,50);
folder='timeProdCoh';
sessions={'pre'};
count=0;
for vi=1:2
    for sessi=1:length(sessions)
        for grpi=1:3
            str=['cohLRv',num2str(vi),sessions{sessi},'_',grps{grpi}];
            load([folder,'/',str])
            eval(['LRcoh=LRcoh+mean(',str,'.powspctrm,1);'])
            count=count+1;
        end
    end
end
LRcoh=LRcoh./count;
eval(['LRtp=',str]);
LRcoh(1,find(chs),:)=1;
LRtp.powspctrm=LRcoh;

LR=LRrest;
LR.powspctrm=(LRrest.powspctrm+LRtp.powspctrm+LRob.powspctrm)./3;

%fix bad chans for display (pairs of 204 and 74)
LR.powspctrm=LR.powspctrm(1,[1:68 70:132 134:246],:);
LR.label=LR.label([1:68 70:132 134:246]);
% [~,a203i]=ismember('A203',LRrest.label);
% [~,a205i]=ismember('A205',LRrest.label);
% [~,a106i]=ismember('A106',LRrest.label);
% [~,a75i]=ismember('A75',LRrest.label);
% LRrest.powspctrm(1,247,:)=(LRrest.powspctrm(1,a203i,:)+LRrest.powspctrm(1,a205i,:))./2;
% LRrest.label{247}='A204';
% LRrest.powspctrm(1,248,:)=(LRrest.powspctrm(1,a73i,:)+LRrest.powspctrm(1,a75i,:))./2;
% LRrest.label{248}='A74';

cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[freq freq];
cfg.zlim=[0 1];
cfg.comment='no';
if ~exist('highlight','var')
    cfg.marker='labels';
    cfg.interactive='yes';
else
    cfg.highlight          = 'labels';           
    cfg.highlightchannel   = highlight;
    cfg.highlightsymbol='o';
    cfg.highlightfontsize=12;
    cfg.marker='off';
end
ft_topoplotER(cfg,LR)
title([num2str(freq),'Hz'])


