cd /media/yuval/win_disk/Data/epilepsy2/b397
cfg=[];
cfg.dataset='2/c,rfhp1.0Hz';
cfg.trl=[1,1017.25*8,0];
cfg.channel='MEG';
cfg.lpfilter='yes';
cfg.lpfreq=70;
cfg.demean='yes';
MEG=ft_preprocessing(cfg);
MEG=ft_timelockanalysis([],MEG);
cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
cfg.xlim=[3.93 3.93];
cfg.zlim=[-2.5e-12 2.5e-12];
figure;ft_topoplotER(cfg,MEG);




for ei=1:32
    labels{ei,1}=['E',num2str(ei)];
end

cfg=[];
cfg.dataset='2/c,rfhp1.0Hz';
cfg.trl=[1,1017.25*8,0];
cfg.channel = labels;
% cfg.lpfilter='yes';
% cfg.lpfreq=70;
% cfg.demean='yes';
EEG=ft_preprocessing(cfg);

load 2/rsEEG
rsEEG=rsEEG(:,1:1017.25*8);
EEG.trial{1}(:,:)=rsEEG;
EEG.trial{1}(13,:)=[];
EEG.trial{1}(19,:)=[];
%EEG.label = {'Fp1'; 'Fpz'; 'Fp2'; 'F7'; 'F3'; 'Fz'; 'F4'; 'F8'; 'FC5'; 'FC1'; 'FC2'; 'FC6'; 'M1'; 'T7'; 'C3'; 'Cz'; 'C4'; 'T8'; 'M2'; 'CP5'; 'CP1'; 'CP2'; 'CP6'; 'P7'; 'P3'; 'Pz'; 'P4'; 'P8'; 'POz'; 'O1'; 'Oz'; 'O2'};
EEG.label = {'Fp1'; 'Fpz'; 'Fp2'; 'F7'; 'F3'; 'Fz'; 'F4'; 'F8'; 'FC5'; 'FC1'; 'FC2'; 'FC6'; 'T7'; 'C3'; 'Cz'; 'C4'; 'T8'; 'CP5'; 'CP1'; 'CP2'; 'CP6'; 'P7'; 'P3'; 'Pz'; 'P4'; 'P8'; 'POz'; 'O1'; 'Oz'; 'O2'};
EEG=ft_timelockanalysis([],EEG)

cfg=[];
cfg.layout='WG32.lay';
cfg.interactive='yes';
cfg.xlim=[3.926 3.926];
cfg.zlim=[-0.15 0.15];
figure;ft_topoplotER(cfg,EEG);

%%
[g2sum,g2max]=g2loop(EEG.avg,1017,0);

topoplot30(g2sum);
topoplot30(g2max);
[g2sum,g2max]=g2loop(rsEEG,10172,0);
topoplot32(g2sum);
topoplot32(g2max);

%% talk2
cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
cfg.xlim=[3.09 3.09];
cfg.zlim=[-2e-12 2e-12];
cfg.comment='no';
figure;ft_topoplotER(cfg,MEG);

%% 
