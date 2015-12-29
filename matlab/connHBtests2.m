%% connectomeDB

cd /media/yuval/win_disk/Data/connectomeDB/MEG
load Subs
fn='c,rfDC';
pref={'hbAvgAmp_','hb5cat_'};
for subi=1:length(Subs)
    close all
    cd /media/yuval/win_disk/Data/connectomeDB/MEG
    cd(num2str(Subs(subi)))
    cd unprocessed/MEG/3-Restin/4D/
    if ~exist('./hbAvgAmp_c,rfDC','file')
        cfg=[];
        cfg.badChan=[246];
        cfg.ampLinThr=0;
        cfg.dataFiltFreq=0.1;
        correctHB(fn,[],[],[],cfg);
        unix(['mv hb_',fn,' hbAvgAmp_c,rfDC']);
        saveas(2,'avgHB.png')
        close all
    end
    if ~exist('./hb5cat_c,rfDC','file')
        correctHB(fn);
        unix(['mv hb_',fn,' hb5cat_c,rfDC']);
        close all
    end
    if ~exist('Rtopo.mat','file')
        [~,HBtimes,~,~,~,Rtopo]=correctHB(fn);
        save HBtimes HBtimes
        save Rtopo Rtopo
    end
end


for subi=1:length(Subs)
    cd /media/yuval/win_disk/Data/connectomeDB/MEG
    cd(num2str(Subs(subi)))
    cd unprocessed/MEG/3-Restin/4D/
    load HBtimes
    % load Rtopo
    
    comps=[];
    for filei=1:2
        if exist([pref{filei},'comp.mat'],'file')
            load([pref{filei},'comp'])
        else
            cfg=[];
            cfg.dataset=[pref{filei},fn];
            cfg.bpfilter='yes';
            cfg.bpfreq=[1 40];
            cfg.demean='yes';
            cfg.channel='MEG';
            %         cfg.padding=0.5;
            data=ft_preprocessing(cfg);
            data=ft_resampledata([],data);
            cfg=[];
            cfg.channel={'MEG','-A2'};
            cfg.channel={'MEG','-A2','-A246'};
            comp=ft_componentanalysis(cfg,data);
            save([pref{filei},'comp.mat'],'comp');
        end
        if ~exist('trl.mat','file')
            trl=HBtimes'*data.fsample-206;
            trl(:,2)=HBtimes'*data.fsample+206;
            trl(:,3)=-206;
            trl=round(trl(2:end-1,:));
            save trl trl
        else
            load trl.mat
        end
        
        %trials=zeros(246,207,size(trl,1)-2);
        for trli=2:(size(trl,1)-1)
            trials(1:length(comp.topolabel),1:413,trli-1)=abs(comp.trial{1}(:,trl(trli,1):trl(trli,2)));
        end
        rat=mean(squeeze(max(abs(trials(:,193:220,:)),[],2)./max(abs(trials(:,1:28,:)),[],2)),2);
        if max(rat)>2
            leftover(subi,filei)=find(rat>2,1);
        else
            leftover(subi,filei)=length(rat);
        end
    end
end
cd /media/yuval/win_disk/Data/connectomeDB/MEG
save leftover leftover pref

% test a subject
subi=10;filei=1;

cd /media/yuval/win_disk/Data/connectomeDB/MEG
cd(num2str(Subs(subi)))
cd unprocessed/MEG/3-Restin/4D/
load HBtimes
load([pref{filei},'comp'])
cfg=[];
cfg.channel=comp.label(1:5);
cfg.layout='4D248.lay';
ft_databrowser(cfg,comp)

load trl.mat