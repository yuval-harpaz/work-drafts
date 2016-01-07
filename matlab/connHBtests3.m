%% connectomeDB

cd /media/yuval/win_disk/Data/connectomeDB/MEG
load Subs
fn='c,rfDC';
for subi=[1,3:10]
    cd /media/yuval/win_disk/Data/connectomeDB/MEG
    cd(num2str(Subs(subi)))
    cd unprocessed/MEG/3-Restin/4D/
    [~,HBtimesE]=correctHB(fn,[],[],'E2');
    [~,HBtimes]=correctHB(fn);
    title(num2str(Subs(subi)))
    if length(HBtimes)==length(HBtimesE)
        means(subi)=mean(HBtimesE-HBtimes)*1000;
        SDs(subi)=std(HBtimesE-HBtimes)*1000;
        ranges(subi,1:2)=minmax((HBtimesE-HBtimes)*1000);
    else
        disp([num2str(subi),' no HB fit'])
    end
end
cd /media/yuval/win_disk/Data/connectomeDB/MEG
save E_Mstats means SDs ranges

% for subi=1:length(Subs)
%     cd /media/yuval/win_disk/Data/connectomeDB/MEG
%     cd(num2str(Subs(subi)))
%     cd unprocessed/MEG/3-Restin/4D/
%     load HBtimes
%     % load Rtopo
%     
%     comps=[];
%     for filei=1:2
%         if exist([pref{filei},'comp.mat'],'file')
%             load([pref{filei},'comp'])
%         else
%             cfg=[];
%             cfg.dataset=[pref{filei},fn];
%             cfg.bpfilter='yes';
%             cfg.bpfreq=[1 40];
%             cfg.demean='yes';
%             cfg.channel='MEG';
%             cfg.trl=[1,100000,1];
%             %         cfg.padding=0.5;
%             data=ft_preprocessing(cfg);
%             data=ft_resampledata([],data);
%             cfg=[];
%             cfg.channel={'MEG','-A2'};
%             cfg.channel={'MEG','-A2','-A246'};
%             comp=ft_componentanalysis(cfg,data);
%             save([pref{filei},'comp.mat'],'comp');
%         end
%         if ~exist('trl.mat','file')
%             trl=HBtimes'*data.fsample-206;
%             trl(:,2)=HBtimes'*data.fsample+206;
%             trl(:,3)=-206;
%             trl=round(trl(2:end-1,:));
%             save trl trl
%         else
%             load trl.mat
%         end
%         
%         %trials=zeros(246,207,size(trl,1)-2);
%         
%         for trli=2:(size(trl,1)-1)
%             try
%                 trials(1:length(comp.topolabel),1:413,trli-1)=abs(comp.trial{1}(:,trl(trli,1):trl(trli,2)));
%             end
%         end
%         rat=mean(squeeze(max(abs(trials(:,193:220,:)),[],2)./max(abs(trials(:,1:28,:)),[],2)),2);
%         if max(rat)>2
%             leftover(subi,filei)=find(rat>2,1);
%         else
%             leftover(subi,filei)=length(rat);
%         end
%     end
% end
% cd /media/yuval/win_disk/Data/connectomeDB/MEG
% %save leftover leftover pref
% 
% % test a subject
% subi=9;filei=1;
% 
% cd /media/yuval/win_disk/Data/connectomeDB/MEG
% cd(num2str(Subs(subi)))
% cd unprocessed/MEG/3-Restin/4D/
% load HBtimes
% load([pref{filei},'comp'])
% cfg=[];
% cfg.channel=comp.label(1:5);
% cfg.layout='4D248.lay';
% ft_databrowser(cfg,comp)
% 
% load trl.mat
% for trli=2:(size(trl,1)-1)
%     try
%         trials(1:length(comp.topolabel),1:413,trli-1)=abs(comp.trial{1}(:,trl(trli,1):trl(trli,2)));
%     end
% end
% rat=mean(squeeze(max(abs(trials(:,193:220,:)),[],2)./max(abs(trials(:,1:28,:)),[],2)),2);
% find(rat2>2) 
% 
% %% Sheraz
% cd /home/yuval/Copy/MEGdata/alpha/sheraz
% fileName='sub01_raw.fif';
% hdr=ft_read_header(fileName);
% trl=[1,hdr.nSamples,0];
% cfg=[];
% cfg.trl=trl;
% cfg.demean='yes';
% cfg.dataset=fileName;
% cfg.channel='MEGMAG';
% mag=ft_preprocessing(cfg);
% meanMAG=mean(mag.trial{1,1});
% cfg.channel='MEG';
% meg=ft_preprocessing(cfg);
% figOptions.label=meg.label;
% figOptions.layout='neuromag306mag.lay';
% clear mag
% [cleanMEG,tempMEG,periodMEG,mcgMEG,RtopoMEG]=correctHB(meg.trial{1,1},meg.fsample,0,meanMAG);
% 
% infile='rest-raw.fif';
% outfile='clean-raw.fif';
% raw=fiff_setup_read_raw(infile);
% 
% [data,times] = fiff_read_raw_segment(raw,raw.first_samp,raw.last_samp,1:248);
% 
% %% ctf
% cd /home/yuval/Data
% load /home/yuval/Data/ArtifactRemoval.ds/ECG308
% correctHB([],[],[],ECG);
% 
% %check HB topography
% cd /home/yuval/Data
% load('/home/yuval/Data/ArtifactRemoval.ds/hbCleanECG.mat', 'HBtimes')
% trl=round(HBtimes*1200)'-300;
% trl(:,2)=trl+900;
% trl(:,3)=-300;
% trl=trl(1:9,:);
% cfg = [];
% cfg.dataset = 'ArtifactRemoval.ds'; 
% cfg.channel='MEG';
% cfg.trl=trl;
% cfg = ft_definetrial(cfg);
% cfg.demean='yes';
% cfg.baselinewindow=[-0.25 -0.15];
% cfg.bpfilter='yes';
% cfg.bpfreq=[5 40];
% data = ft_preprocessing(cfg);
% avg=ft_timelockanalysis([],data);
% plot(avg.time,avg.avg)
% cfg=[];
% cfg.interactive='yes';
% cfg.xlim=[0 0];
% ft_topoplotER(cfg,avg);
% 
% load /home/yuval/Data/ArtifactRemoval.ds/ECG308
% cfg.matchMethod='topo';
% [~,HBtimes,templateHB,Period,MCG,Rtopo]=correctHB([],[],[],ECG,cfg);
