beg=-5;
dur=20
cd /home/yuval/Data/epilepsy/b162b/1
cfg=[];
cfg.dataset='c,rfhp1.0Hz';
cfg.trl=[1,2,0];
cfg.channel='MEG';
avg=ft_preprocessing(cfg);
avg=ft_timelockanalysis([],avg);
avg.avg=avg.avg(:,1);
avg.avg=zeros(size(avg.avg));
avg.time=avg.time(1);
channels = {'A133', 'A134', 'A135', 'A160', 'A161', 'A162', 'A163', 'A182', 'A183', 'A184'};
cfg=[];
cfg.layout='4D248.lay';
cfg.comment='no';
cfg.zlim=[-100 100];
cfg.highlight          = 'on';
cfg.highlightsymbol='o';
cfg.highlightchannel = channels;
cfg.style  = 'blank';
figure;ft_topoplotER(cfg,avg);
t=121;
cfg=[];
cfg.trl=round((t(1)+beg)*678.17);
cfg.trl(1,2)=cfg.trl+round(678.17*(beg+dur));
% cfg.trl(2,:)=cfg.trl+round(678.17*15);
% cfg.trl(3,:)=cfg.trl(2,:)+round(678.17*15);
cfg.trl(1,3)=round(678.17*beg);
cfg.dataset='lf,hb_c,rfhp1.0Hz';
cfg.channel = channels;
cfg.hpfilter='yes';
cfg.hpfreq=1;
cfg.demean='yes';
raw=ft_preprocessing(cfg);
add=(-2e-12)*[1:length(raw.label)]';
data=raw.trial{1,1}-repmat(add,1,length(raw.trial{1,1}));
figure('units','normalized','outerposition',[0 0 0.5 0.35]);plot(raw.time{1,1},data,'k')
ylim([0 25e-12])
% data=raw.trial{1,2}-repmat(add,1,length(raw.trial{1,2}));
% figure;plot(raw.time{1,2},data,'k')
% data=raw.trial{1,3}-repmat(add,1,length(raw.trial{1,3}));
% figure;plot(raw.time{1,3},data,'k')
%% 
cd /home/yuval/Data/epilepsy/b022/ictus
fn= 'hb_c,rfhp1.0Hz,ee';
hdr=ft_read_header(fn);

cfg=[];
cfg.dataset=fn;
cfg.trl=round(678.17*[64,65,0]);
cfg.channel='MEG';
cfg.hpfilter='yes';
cfg.hpfreq=1;
cfg.demean='yes';
cfg.blcwindow=[0,0.07];
avg=ft_preprocessing(cfg);
avg=ft_timelockanalysis([],avg);

avg.avg=avg.avg(:,1);
avg.avg=zeros(size(avg.avg));
avg.time=avg.time(1);
channels = {'A2', 'A9', 'A15', 'A24', 'A43', 'A68', 'A97', 'A129', 'A157', 'A197'}
cfg=[];
cfg.layout='4D248.lay';
cfg.comment='no';
cfg.zlim=[-100 100];
cfg.highlight          = 'on';
cfg.highlightsymbol='o';
cfg.highlightchannel = channels;
cfg.style  = 'blank';
figure;ft_topoplotER(cfg,avg);
t=63;
cfg=[];
cfg.trl=round((t(1)+beg)*678.17);
cfg.trl(1,2)=cfg.trl+round(678.17*(beg+dur));
% cfg.trl(2,:)=cfg.trl+round(678.17*15);
% cfg.trl(3,:)=cfg.trl(2,:)+round(678.17*15);
cfg.trl(1,3)=round(678.17*beg);
cfg.dataset=fn;
cfg.channel = channels;
cfg.hpfilter='yes';
cfg.hpfreq=1;
cfg.demean='yes';
raw=ft_preprocessing(cfg);
add=(-2e-12)*[1:length(raw.label)]';
data=raw.trial{1,1}-repmat(add,1,length(raw.trial{1,1}));
figure('units','normalized','outerposition',[0 0 0.5 0.35]);plot(raw.time{1,1},data,'k')
ylim([0 25e-12])
% data=raw.trial{1,2}-repmat(add,1,length(raw.trial{1,2}));
% figure;plot(raw.time{1,2},data,'k')
% data=raw.trial{1,3}-repmat(add,1,length(raw.trial{1,3}));
% figure;plot(raw.time{1,3},data,'k')
%%
cd /home/yuval/Data/epilepsy/b023/2
cfg=[];
cfg.dataset='c,rfhp1.0Hz';
cfg.trl=[1,2,0];
cfg.channel='MEG';
avg=ft_preprocessing(cfg);
avg=ft_timelockanalysis([],avg);
avg.avg=avg.avg(:,1);
avg.avg=zeros(size(avg.avg));
avg.time=avg.time(1);
channels = {'A79', 'A80', 'A81', 'A82', 'A83', 'A109', 'A110', 'A141', 'A168', 'A189'}
%channels = {'A133', 'A134', 'A135', 'A160', 'A161', 'A162', 'A163', 'A182', 'A183', 'A184'};
cfg=[];
cfg.layout='4D248.lay';
cfg.comment='no';
cfg.zlim=[-100 100];
cfg.highlight          = 'on';
cfg.highlightsymbol='o';
cfg.highlightchannel = channels;
cfg.style  = 'blank';
figure;ft_topoplotER(cfg,avg);
t=2124;
cfg=[];
cfg.trl=round((t(1)+beg)*678.17);
cfg.trl(1,2)=cfg.trl+round(678.17*(beg+dur));
% cfg.trl(2,:)=cfg.trl+round(678.17*15);
% cfg.trl(3,:)=cfg.trl(2,:)+round(678.17*15);
cfg.trl(1,3)=round(678.17*beg);
cfg.dataset='c,rfhp1.0Hz';
cfg.channel = channels;
cfg.hpfilter='yes';
cfg.hpfreq=1;
cfg.demean='yes';
raw=ft_preprocessing(cfg);
add=(-2e-12)*[1:length(raw.label)]';
data=raw.trial{1,1}-repmat(add,1,length(raw.trial{1,1}));
figure('units','normalized','outerposition',[0 0 0.5 0.35]);plot(raw.time{1,1},data,'k')
ylim([0 25e-12])
%% 
