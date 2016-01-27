%% connectomeDB

cd /media/yuval/win_disk/Data/connectomeDB/MEG
load Subs
fn='c,rfDC';
subi=7;
cd(num2str(Subs(subi)))
cd unprocessed/MEG/3-Restin/4D/
cfg=[];
cfg.dataset=fn;
cfg.channel='MEG';
cfg.hpfilter='yes';
cfg.hpfreq=1;
cfg.hpfiltord=4;
cfg.demean='yes';
cfg.channel={'MEG','E2'};
cfg.trl=[1,20340,1];
data=ft_preprocessing(cfg);


M=mean(data.trial{1}(1:end-1,:));



[~,HBtimesE]=correctHB(fn,[],[],'E2');
[~,HBtimes]=correctHB(fn);
Ms=HBtimes*data.fsample;
Es=HBtimesE*data.fsample;
Ms=Ms(1:11); Es=Es(1:11); 

figure;plot(data.time{1},M)
hold on
plot(HBtimes(1:11),M(round(Ms)),'.r')
plot(HBtimesE(1:11),M(round(Ms)),'ok')

figure;plot(data.time{1},data.trial{1}(end,:))
hold on
plot(HBtimesE(1:11),data.trial{1}(end,round(Es)),'ok')

load('hbAvgAmp_comp.mat')
cfg=[];
cfg.channel=comp.label(1:5);
cfg.layout='4D248.lay';
ft_databrowser(cfg,comp)
load('hb5cat_comp.mat')
cfg=[];
cfg.channel=comp.label(1:5);
cfg.layout='4D248.lay';
ft_databrowser(cfg,comp)
%% check ica with / without ECG
cfg=[];
cfg.dataset='c,rfDC';
cfg.channel='MEG';
cfg.hpfilter='yes';
cfg.hpfreq=1;
cfg.hpfiltord=4;
cfg.demean='yes';
cfg.channel={'MEG','E2'};
cfg.trl=[1,ceil(2034.51*300),1];
data=ft_preprocessing(cfg);

data=ft_resampledata([],data);

comp=ft_componentanalysis([],data);
save compE comp
figure;plot(comp.trial{1}(1,1:20345))

figure;topoplot248(comp.topo(1:248,1))
cfg=[];
cfg.component=1;
dataE=ft_rejectcomponent(cfg,comp);
save dataE dataE
clear dataE

cfg=[]
cfg.channel='MEG';
comp=ft_componentanalysis(cfg,data);
save compM comp
clear data
%[p,pI]=findPeaks(comp.trial{1}(2,1:20345))
cfg=[];
cfg.component=[2,4];
dataM=ft_rejectcomponent(cfg,comp);
save dataM dataM
%clear dataM

cfg=[];
cfg.channel=comp.label(1:5);
cfg.layout='4D248.lay';
ft_databrowser(cfg,comp)


cfg=[];
cfg.dataset='hb5cat_c,rfDC';
cfg.channel='MEG';
cfg.hpfilter='yes';
cfg.hpfreq=1;
cfg.hpfiltord=4;
cfg.demean='yes';
cfg.channel={'MEG','E2'};
cfg.trl=[1,ceil(2034.51*300),1];
dataHB=ft_preprocessing(cfg);
dataHB=ft_resampledata([],dataHB);

figure;plot(data.time{1}(1:20345),data.trial{1}(248,1:20345),'k');
hold on;
plot(data.time{1}(1:20345),dataE.trial{1}(248,1:20345),'r')
plot(data.time{1}(1:20345),dataM.trial{1}(248,1:20345))
plot(data.time{1}(1:20345),dataHB.trial{1}(248,1:20345),'g')
legend({'unclean','ICA with ECG','ICA MEG only','Template removal'})
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
