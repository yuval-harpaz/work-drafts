%cd /home/yuval/Desktop/talResults
for subi=length(subs);
    sub=subs{subi,1};
    fileName=['/home/yuval/Desktop/talResults/s',sub,'_1bk.mat'];
    load(fileName);
    Wtrl=word.cfg.trl;
    Ntrl=nonword.cfg.trl;
    cd ('/home/yuval/Desktop/tal')
    display(['BEGGINING WITH ',sub]);
    cd ([sub,'/',sub,'/0.14d1']);
    conditions=textread('conditions','%s');
    oneBackCell=find(strcmp('oneBack',conditions));
    path2file=conditions{oneBackCell+1};
    source= conditions{oneBackCell+2};
    cd(path2file)
    p=pdf4D(source);
    hdr=get(p,'header');
    ends=hdr.epoch_data{1,1}.pts_in_epoch.
    resp=read_data_block(p,[1 ends],channel_index(p,'RESPONSE','name'));
    
%     cfg=[];
%     cfg.datafile=source;
%     cfg.trialfun='trialfun_beg';
%     %cfg.trialdef.eventtype  = 'RESPONSE'
%     %cfg.trialdef.eventvalue = '256';%number, string or list with numbers or strings
%     %cfg.trialdef.prestim    = 0.1
% %     cfg.trialdef.poststim   = 0.1
% %     cfg1=ft_definetrial(cfg);
%     cfg1.channel='X3';
%     %cfg1.hpfilter='yes';
%     %cfg1.hpfreq=110;
%     Aud=ft_preprocessing(cfg1);
%     
%     