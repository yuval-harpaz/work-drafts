%% check correlation within SAD card
load ~/work-drafts/matlab/channelmap_BIU.mat
cd /home/yuval/Data/emptyRoom
fn='c,rfhp0.1Hz';


cfg=[];
cfg.dataset=fn;
cfg.demean='yes';
cfg.bpfilter='yes';
cfg.bpfreq=[1 40];
cfg.channel='MEG';
cfg.trl=[1,101725,0];
data=ft_preprocessing(cfg);
sRate=data.fsample;
rr=corr(data.trial{1}');
rr(logical(eye(length(rr))))=nan;
rpr=nanmean(rr);
mean(rpr)
ttest(rpr)
ismeg=[];
for chi=2:289
    if strcmp(channelmap_BIU{chi,1}(1),'A')
        ismeg(chi-1,1)=true;
    else
        ismeg(chi-1,1)=false;
    end
end
for SADi=1:18
    SADch=cell2mat(channelmap_BIU(2:289,2))==SADi;
    SADch=SADch & ismeg;
    [~,megch]=ismember(channelmap_BIU(1+find(SADch),1),data.label);
    rrS=corr(data.trial{1}(megch,:)');
    Nch=sum(SADch);
    rrS(logical(eye(Nch)))=nan;
    table(SADi,1)=Nch;
    table(SADi,2)=mean(nanmean(rrS));
    table(SADi,3)=min(nanmin(rrS));
end
mean(table)
% mean corr per SAD card is 0.3814