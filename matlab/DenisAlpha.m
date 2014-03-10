%% check shift and tilt
cd /home/yuval/Data/Denis/REST
load subs
str=['Rest=ft_freqgrandaverage(cfg']
for subi=1:length(subs)
    cd (num2str(subs(subi)))
    %load coilpos
    hdr=ft_read_header('clean-raw.fif');
    cfg=[];
    cfg.dataset='clean-raw.fif';
    cfg.channel=1:248;
    cfg.trl=round(10*hdr.Fs):round(hdr.Fs):round(69*hdr.Fs);
    cfg.trl=cfg.trl';
    cfg.trl(:,2)=cfg.trl+round(hdr.Fs);
    cfg.trl(:,3)=0;
    cfg.demean='yes';
    raw=ft_preprocessing(cfg);
    cfg=[];
    %cfg.trials=find(datacln.trialinfo==222);
    cfg.output       = 'pow';
%    cfg.channel      = {'MEG','-A204','-A74'};
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = 1:100;
    cfg.feedback='no';
    Fr = ft_freqanalysis(cfg, raw);
    eval(['Fr',num2str(subi),'=Fr;']);
    str=[str,',Fr',num2str(subi)];
    cd ..
end
cfg=[];
cfg.keepindividual='yes';
eval([str,');']);

for i=1:248
    Rest.label{i,1}=['A',num2str(i)];
end
save Rest Rest