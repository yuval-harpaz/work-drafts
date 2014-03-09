cd /home/yuval/Data/epilepsy/b162b/1
% choose channels
cfg=[];
cfg.dataset='c,rfhp1.0Hz';
cfg.trl=round(678.17*[135,140,0]);
cfg.channel='MEG';
avg=ft_preprocessing(cfg);
avg=ft_timelockanalysis([],avg);

cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[0 0];
cfg.interactive='yes';
ft_topoplotER(cfg,avg);
%%
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
cfg.highlightsymbol='*';
cfg.highlightchannel = channels;
figure;ft_topoplotER(cfg,avg);
t=121;
cfg=[];
cfg.trl=round((t(1)-30)*678.17);
cfg.trl(1,2)=cfg.trl+round(678.17*15);
cfg.trl(2,:)=cfg.trl+round(678.17*15);
cfg.trl(3,:)=cfg.trl(2,:)+round(678.17*15);
cfg.trl(:,3)=round(678.17*[0,15,30]);
cfg.dataset='lf,hb_c,rfhp1.0Hz';
cfg.channel = channels;
cfg.hpfilter='yes';
cfg.hpfreq=1;
cfg.demean='yes';
raw=ft_preprocessing(cfg);
add=(-2e-12)*[1:length(raw.label)]';
data=raw.trial{1,1}-repmat(add,1,length(raw.trial{1,1}));
figure;plot(raw.time{1,1},data,'k')
data=raw.trial{1,2}-repmat(add,1,length(raw.trial{1,2}));
figure;plot(raw.time{1,2},data,'k')
data=raw.trial{1,3}-repmat(add,1,length(raw.trial{1,3}));
figure;plot(raw.time{1,3},data,'k')
%% 
cd /home/yuval/Data/epilepsy/b022/ictus
fn= 'hb_c,rfhp1.0Hz,ee';
hdr=ft_read_header(fn);
tracePlot_BIU(70,80,fn);
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

cfg=[];
cfg.layout='4D248.lay';
cfg.xlim=[0.09 0.09];
cfg.interactive='yes';
cfg.zlim=[-2e-12 2e-12];
figure;
ft_topoplotER(cfg,avg);

avg.avg=avg.avg(:,1);
avg.avg=zeros(size(avg.avg));
avg.time=avg.time(1);
channels = {'A2', 'A9', 'A15', 'A24', 'A43', 'A68', 'A97', 'A129', 'A157', 'A197'}
cfg=[];
cfg.layout='4D248.lay';
cfg.comment='no';
cfg.zlim=[-100 100];
cfg.highlight          = 'on';
cfg.highlightsymbol='*';
cfg.highlightchannel = channels;
figure;ft_topoplotER(cfg,avg);
t=63;
cfg=[];
cfg.trl=round((t(1)-30)*678.17);
cfg.trl(1,2)=cfg.trl+round(678.17*15);
cfg.trl(2,:)=cfg.trl+round(678.17*15);
cfg.trl(3,:)=cfg.trl(2,:)+round(678.17*15);
cfg.trl(:,3)=round(678.17*[0,15,30]);
cfg.dataset=fn;
cfg.channel = channels;
cfg.hpfilter='yes';
cfg.hpfreq=1;
cfg.demean='yes';
raw=ft_preprocessing(cfg);
add=(-2e-12)*[1:length(raw.label)]';
data=raw.trial{1,1}-repmat(add,1,length(raw.trial{1,1}));
figure;plot(raw.time{1,1},data,'k')
data=raw.trial{1,2}-repmat(add,1,length(raw.trial{1,2}));
figure;plot(raw.time{1,2},data,'k')
data=raw.trial{1,3}-repmat(add,1,length(raw.trial{1,3}));
figure;plot(raw.time{1,3},data,'k')