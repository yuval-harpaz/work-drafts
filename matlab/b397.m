cd /media/yuval/win_disk/Data/epilepsy2/b397/2
cfg=[];
cfg.dataset='c,rfhp1.0Hz';
cfg.trl=[1,1017.25*4,0];
cfg.channel='MEG';
cfg.lpfilter='yes';
cfg.lpfreq=70;
MEG=ft_preprocessing(cfg);

for ei=1:32
    labels{ei,1}=['E',num2str(ei)];
end

cfg=[];
cfg.dataset='c,rfhp1.0Hz';
cfg.trl=[1,1017.25*4,0];
cfg.channel = labels;
% cfg.lpfilter='yes';
% cfg.lpfreq=70;
% cfg.demean='yes';
EEG=ft_preprocessing(cfg);

load rsEEG
rsEEG=rsEEG(:,1:1017.25*4);
EEG.trial{1}(:,:)=rsEEG;
EEG.trial{1}(13,:)=[];
EEG.trial{1}(19,:)=[];
%EEG.label = {'Fp1'; 'Fpz'; 'Fp2'; 'F7'; 'F3'; 'Fz'; 'F4'; 'F8'; 'FC5'; 'FC1'; 'FC2'; 'FC6'; 'M1'; 'T7'; 'C3'; 'Cz'; 'C4'; 'T8'; 'M2'; 'CP5'; 'CP1'; 'CP2'; 'CP6'; 'P7'; 'P3'; 'Pz'; 'P4'; 'P8'; 'POz'; 'O1'; 'Oz'; 'O2'};
EEG.label = {'Fp1'; 'Fpz'; 'Fp2'; 'F7'; 'F3'; 'Fz'; 'F4'; 'F8'; 'FC5'; 'FC1'; 'FC2'; 'FC6'; 'T7'; 'C3'; 'Cz'; 'C4'; 'T8'; 'CP5'; 'CP1'; 'CP2'; 'CP6'; 'P7'; 'P3'; 'Pz'; 'P4'; 'P8'; 'POz'; 'O1'; 'Oz'; 'O2'};
EEG=ft_timelockanalysis([],EEG)
cd ../
cfg=[];
cfg.layout='WG32.lay';
cfg.interactive='yes';
cfg.xlim=[2.95 2.95];
cfg.zlim=[-0.1 0.1];
ft_topoplotER(cfg,EEG);

%%




% 
% figure;plot(MEG.trial{1}(14,:))
% spike1=3402;
% t1=MEG.time{1}(spike1);
% 
% cfg=[];
% cfg.layout='4D248.lay';
% cfg.interactive='yes';
% cfg.xlim=[t1 t1];
% cfg.zlim=[-3e-12 3e-12];
% figure;ft_topoplotER(cfg,ft_timelockanalysis([],MEG));
% 
% M=MEG.trial{1}(:,spike1);
% M(chi)=0;
% cfg=[];
% cfg.zlim=[-3e-12 3e-12];
% cfg.interpolate='linear';
% cfg.style = 'straight';
% figure;topoplot248(M,cfg)
% 
% load rsEEG
% E=rsEEG(:,spike1)
% 
% cd ../
% topoplot32(E)
% 
% 
% 
% for ei=1:32
%     labels{ei,1}=['E',num2str(ei)];
% end
% cfg=[];
% cfg.dataset='c,rfhp1.0Hz';
% cfg.trl=[1,1017.25*4,0];
% cfg.channel = labels;
% cfg.lpfilter='yes';
% cfg.lpfreq=70;
% cfg.demean='yes';
% EEG=ft_preprocessing(cfg);
% EEG.trial{1}(13,:)=[];
% EEG.trial{1}(19,:)=[];
% %EEG.label = {'Fp1'; 'Fpz'; 'Fp2'; 'F7'; 'F3'; 'Fz'; 'F4'; 'F8'; 'FC5'; 'FC1'; 'FC2'; 'FC6'; 'M1'; 'T7'; 'C3'; 'Cz'; 'C4'; 'T8'; 'M2'; 'CP5'; 'CP1'; 'CP2'; 'CP6'; 'P7'; 'P3'; 'Pz'; 'P4'; 'P8'; 'POz'; 'O1'; 'Oz'; 'O2'};
% EEG.label = {'Fp1'; 'Fpz'; 'Fp2'; 'F7'; 'F3'; 'Fz'; 'F4'; 'F8'; 'FC5'; 'FC1'; 'FC2'; 'FC6'; 'T7'; 'C3'; 'Cz'; 'C4'; 'T8'; 'CP5'; 'CP1'; 'CP2'; 'CP6'; 'P7'; 'P3'; 'Pz'; 'P4'; 'P8'; 'POz'; 'O1'; 'Oz'; 'O2'};
% cd ../
% spike1=3402;
% t1=EEG.time{1}(spike1);
% cfg=[];
% cfg.layout='WG32.lay';
% cfg.interactive='yes';
% cfg.xlim=[3.06 3.06];
% cfg.zlim=[-0.0005 0.0005];
% ft_topoplotER(cfg,ft_timelockanalysis([],EEG));
% 
% 
% 
% %% rescale EEG
% cd /media/yuval/win_disk/Data/epilepsy2/b397/2
% for ei=1:32
%     labels{ei,1}=['E',num2str(ei)];
% end
% cfg=[];
% cfg.dataset='c,rfhp1.0Hz';
% cfg.trl=[1,1017.25*4,0];
% cfg.channel = labels;
% % cfg.lpfilter='yes';
% % cfg.lpfreq=70;
% % cfg.demean='yes';
% EEG=ft_preprocessing(cfg);
% EEG.trial
% load rsEEG
% rsEEG=rsEEG(:,1:1017.25*4);
% %r=corr(rsEEG',EEG.trial{1}','rows','pairwise');
% 
% 
% 
% plot(EEG.trial{1}(1,:));hold on;plot(rsEEG(1,1:length(EEG.time{1}))./70,'r')