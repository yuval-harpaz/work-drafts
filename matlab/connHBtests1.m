%% raw data
cd /media/yuval/MEG_B1/Noa_nasty_HB/
fn='c1,rfhp0.1Hz';
pref={'hbAvgAmp_','hbLabels_','hb5cat_'};
cfg=[];
cfg.ampLinThr=0;
correctHB('c1,rfhp0.1Hz',[],[],[],cfg);
!mv hb_c1,rfhp0.1Hz hbAvgAmp_c1,rfhp0.1Hz
correctHB('c1,rfhp0.1Hz');
!mv hb_c1,rfhp0.1Hz hb5cat_c1,rfhp0.1Hz
[~,HBtimes,~,~,~,Rtopo]=correctHB('c1,rfhp0.1Hz');
save HBtimes HBtimes
save Rtopo Rtopo

% load HBtimes
% load Rtopo
comps=[];
for filei=[1,3]
    if exist([pref{filei},'comp.mat'],'file')
        load([pref{filei},'comp'])
    else
        cfg=[];
        cfg.dataset=[pref{filei},fn];
        cfg.bpfilter='yes';
        cfg.bpfreq=[1 40];
        cfg.demean='yes';
        cfg.channel='MEG';
        cfg.padding=0.5;
        data=ft_preprocessing(cfg);
        data=ft_resampledata([],data);
        cfg=[];
        cfg.channel={'MEG','-A74','-A204'};
        comp=ft_componentanalysis(cfg,data);
        save([pref{filei},'comp.mat'],'comp');
    end
    if ~exist('trl.mat','file')
        trl=HBtimes'*data.fsample-103;
        trl(:,2)=HBtimes'*data.fsample+103;
        trl(:,3)=-103;
        trl=round(trl(2:end-1,:));
        save trl trl
    else
        load trl.mat
    end
    %trials=zeros(246,207,size(trl,1)-2);
    for trli=2:(size(trl,1)-1)
        trials(1:246,1:207,trli)=abs(comp.trial{1}(:,trl(trli,1):trl(trli,2)));
    end
    compHB=median(trials,3);
    %     avg=zeros(246,207);
    %     for trli=2:(size(trl,1)-1)
    %         avg=avg+abs(comp.trial{1}(:,trl(trli,1):trl(trli,2)));
    %     end
    % figure;plot(-103:103,avg(1:20,:))
    % figure;plot(-103:103,avg')
    compHB=correctBL(compHB,[1 90]);
    compHB=compHB./repmat(max(compHB(:,1:90)')',1,207);
    
    cmpi=find(sum(compHB(:,98:116)>3,2));
    
    figure;plot(compHB(cmpi,:)')
    hold on
    plot(compHB','k')
    plot(compHB(cmpi,:)')
    plot(1:207,3,'.k')
    title(pref{filei})
    legend(num2str(cmpi))
    
%     comps(filei,1)=;
%     save([pref{filei},'comp'],'comp')
end
% comps(2)=[];
% save comps comps

findBadChans('c1,rfhp0.1Hz');
findBadChans('hbAvgAmp_c1,rfhp0.1Hz');
%%
cd /media/yuval/MEG_B1/Noa_nasty_HB/sub6
%fn='c1,rfhp0.1Hz';
pref={'hbAvgAmp_','hbLabels_','hb5cat_'};
%load HBtimes
%load Rtopo
load trl

for filei=1:3
    load([pref{filei},'comp'])
    trials=[];
    for trli=2:450 % (size(trl,1)-1) no good cleaning after HB 510
        trials(1:246,1:207,trli)=abs(comp.trial{1}(:,trl(trli,1):trl(trli,2)));
    end
    compHB=mean(trials,3);
    compHB=correctBL(compHB,[1 90]);
    compHB=compHB./repmat(max(compHB(:,1:90)')',1,207);
    %     figure;plot(compHB')
    %     hold on
    %     plot(1:207,3,'.k')
    %     title(pref{filei})
    comps(filei,1)=find(sum(compHB(:,98:116)>3,2),1)
    %save([pref{filei},'comp'],'comp')
end

cfg=[];
cfg.channel=comp.label(1:5);
cfg.layout='4D248.lay';
ft_databrowser(cfg,comp)

%% components with visible peaks

cd /media/yuval/MEG_B1/Noa_nasty_HB/sub23
%fn='c1,rfhp0.1Hz';
pref={'hbAvgAmp_','hb5cat_'};
%load HBtimes
%load Rtopo

load trl
for filei=1:2
    load([pref{filei},'comp'])
    %comp.trial{1}=correctBL(comp.trial{1},[1 1000]);
    trials=[];
    for trli=2:450 % (size(trl,1)-1) no good cleaning after HB 510
        trials(1:246,1:207,trli-1)=abs(comp.trial{1}(:,trl(trli,1):trl(trli,2)));
    end
    
    rat=mean(squeeze(max(abs(trials(:,91:120,:)),[],2)./max(abs(trials(:,1:20,:)),[],2)),2);
    %rat=mean(squeeze(mean(abs(trials(:,91:120,:)),2)./mean(abs(trials(:,1:20,:)),2)),2);
    %figure;plot(rat,'.')
    leftover(filei,1)=find(rat>2,1);
end
disp(leftover)


cfg=[];
cfg.channel=comp.label(1:5);
cfg.layout='4D248.lay';
ft_databrowser(cfg,comp)