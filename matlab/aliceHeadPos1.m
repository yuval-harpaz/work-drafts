%% AviMa
cd /home/yuval/Copy/MEGdata/alpha
load temp
cd /home/yuval/Copy/MEGdata/alpha/AviMa
load subs
load Open
cd /media/YuvalExtDrive/alpha/AviMa
subNum=[1,2,4:11];
for subi=1:length(subs)
    
    cd /media/YuvalExtDrive/alpha/AviMa
    cd(subs{subi})
%     if exist('1','dir')
%         cd 1
%     else
%         cd 2
%     end
%     fileName = Open.cfg.previous{1,subNum(subi)}.previous.datafile;
%     trl=Open.cfg.previous{1,subNum(subi)}.previous.trl(Open.cfg.previous{1,subNum(subi)}.trials,:);
%     cfg=[];
%     cfg.trl=trl;
%     cfg.channel='MEG';
%     cfg.demean='yes';
%     cfg.feedback='no';
%     cfg.dataset=fileName;
%     data=ft_preprocessing(cfg);
    load close
    cfg=[];
    cfg.template{1,1}=temp.hdr.grad;
    hs=ft_read_headshape('hs_file');
    [o,r]=fitsphere(hs.pnt);
    cfg.inwardshift=0.025;
    cfg.vol.r=r;cfg.vol.o=o;
    data_ra=ft_megrealign(cfg,meg);
    
    cfg=[];
    %cfg.trials=find(datacln.trialinfo==222);
    cfg.output       = 'pow';
    cfg.channel      = {'MEG','-A204','-A74'};
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = 1:100;
    cfg.feedback='no';
    Fr = ft_freqanalysis(cfg, data_ra);
    save realign data data_ra Fr
    eval(['Fr',num2str(subi+8),'=Fr;'])
    
    
    
end
close all
clear Fr
save /home/yuval/Copy/MEGdata/alice/alphaRA/AviMa.mat Fr*
clear Fr*

%% Hyp
cd /home/yuval/Copy/MEGdata/alpha/Hyp
load subs
load Closed 

for subi=1:length(subs)
    cd /media/YuvalExtDrive/alpha/Hyp
    cd(subs{subi})
%     if subi==5
%         fileName='xc,hb,lf_c,rfhp0.1Hz';
%     else
%         fileName = Closed.cfg.previous{1,subNum(subi)}.previous.datafile;
%     end
%     trl=Closed.cfg.previous{1,subNum(subi)}.previous.trl(Closed.cfg.previous{1,subNum(subi)}.trials,:);
%     cfg=[];
%     cfg.trl=trl;
%     cfg.channel='MEG';
%     cfg.demean='yes';
%     cfg.feedback='no';
%     cfg.dataset=fileName;
%     data=ft_preprocessing(cfg);
    load close
    cfg=[];
    cfg.template{1,1}=temp.hdr.grad;
    hs=ft_read_headshape('hs_file');
    [o,r]=fitsphere(hs.pnt);
    cfg.inwardshift=0.025;
    cfg.vol.r=r;cfg.vol.o=o;
    data_ra=ft_megrealign(cfg,meg);
    
    cfg=[];
    %cfg.trials=find(datacln.trialinfo==222);
    cfg.output       = 'pow';
    cfg.channel      = {'MEG','-A204','-A74'};
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = 1:100;
    cfg.feedback='no';
    Fr = ft_freqanalysis(cfg, data_ra);
    save realign data_ra Fr
    eval(['Fr',num2str(subi+18),'=Fr;'])
end
close all
clear Fr
save /home/yuval/Copy/MEGdata/alice/alphaRA/Hyp.mat Fr*
clear Fr*
%% Tal
cd /home/yuval/Copy/MEGdata/alpha/tal
load subs
strCl='cfg';
strOp='cfg';
for subi=1:length(subs)
    sub=subs{subi};
    cd /media/YuvalExtDrive/MEG/tal
    cd ([sub,'/',sub,'/0.14d1']);
    conditions=textread('conditions','%s');
    restcell=find(strcmp('rest',conditions),1);
    resti=1;
    path2file=conditions{restcell(resti)+1};
    source= conditions{restcell(resti)+2};
    cd(path2file(end-16:end))
    fileName = source;
    if exist(['xc,hb,lf_',source],'file')
        clnsource=['xc,hb,lf_',source];
    elseif exist(['hb,xc,lf_',source],'file')
        clnsource=['hb,xc,lf_',source];
    elseif exist(['xc,lf_',source],'file')
        clnsource=['xc,lf_',source];
    else
        error('no cleaned source file found')
    end
    trig=readTrig_BIU(clnsource);
    trig=clearTrig(trig);
    close
    if ~max(find(unique(trig)))>0
        error('no rest trig')
    end
    for trval=[92 94];
        time0=find(trig==trval);
        epoched=time0+1017:1017:time0+60*1017.25;
        cfg=[];
        cfg.dataset=clnsource;
        cfg.trl=epoched';
        cfg.trl(:,2)=cfg.trl+1017;
        cfg.trl(:,3)=0;
        cfg.trialfun='trialfun_beg';
        cfg.channel={'MEG'}
        cfg.blc='yes';
        cfg.feedback='no';
        meg=ft_preprocessing(cfg);
        cfg=[];
        cfg.method='var';
        cfg.criterion='sd';
        cfg.critval=3;
        good=badTrials(cfg,meg,0);
        cfg=[];
        cfg.template{1,1}=temp.hdr.grad;
        hs=ft_read_headshape('hs_file');
        [o,r]=fitsphere(hs.pnt);
        cfg.inwardshift=0.025;
        cfg.vol.r=r;cfg.vol.o=o;
        cfg.trials=good;
        data_ra=ft_megrealign(cfg,meg);
        cfg=[];
        %cfg.trials=good;
        cfg.output       = 'pow';
        cfg.method       = 'mtmfft';
        cfg.taper        = 'hanning';
        cfg.foi          = [3 6 9 10 11 12 15 20 25 30 40 50 60 70 80 90 100];
        cfg.feedback='no';
        %cfg.keeptrials='yes';
        megFr = ft_freqanalysis(cfg, data_ra);
        [~,maxch]=max(mean(megFr.powspctrm(:,:),1));
        maxchans{(trval-90)/2,subi}=megFr.label(maxch);
        cnd='Op';
        if trval==94
           cnd='Cl';
        end
        newVname=[cnd,'_',num2str(subi)];
        eval([newVname,'=megFr']);
        
        eval(['str',cnd,'=[str',cnd,',',''',''',',newVname];']);
        
    end
end

clear Fr*
for i=1:25;str=num2str(i);eval(['Fr',num2str(i+18),'=Op_',str]);end
save talOp Fr*
clear Fr*
for i=1:25;str=num2str(i);eval(['Fr',num2str(i+13),'=Cl_',str]);end
save talCl Fr*
%% Tuv
cd /home/yuval/Copy/MEGdata/alpha/Tuv
load subs
for subi=1:length(subs)
    sub=subs{subi};
    cd /media/YuvalExtDrive/alpha/Tuv
    cd(subs{subi}(end-1:end))
    load close
    cfg=[];
    cfg.template{1,1}=temp.hdr.grad;
    try
        hs=ft_read_headshape('hs_file');
    catch
        hs=ft_read_headshape('2/hs_file');
    end
    [o,r]=fitsphere(hs.pnt);
    cfg.inwardshift=0.025;
    cfg.vol.r=r;cfg.vol.o=o;
    %cfg.trials=good;
    data_ra=ft_megrealign(cfg,meg);
    cfg=[];
    %cfg.trials=good;
    cfg.output       = 'pow';
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = [3 6 9 10 11 12 15 20 25 30 40 50 60 70 80 90 100];
    cfg.feedback='no';
    %cfg.keeptrials='yes';
    Fr = ft_freqanalysis(cfg, data_ra);
    save realign data_ra Fr
    eval(['Fr',num2str(subi+38),'=Fr;'])
    
end
cd /home/yuval/Copy/MEGdata/alice/alphaRA
clear Fr;save TuvCl Fr*
cd /home/yuval/Copy/MEGdata/alpha/Tuv
load subs
for subi=1:length(subs)
    sub=subs{subi};
    cd /media/YuvalExtDrive/alpha/Tuv
    cd(subs{subi}(end-1:end))
    load open
    cfg=[];
    cfg.template{1,1}=temp.hdr.grad;
    try
        hs=ft_read_headshape('hs_file');
    catch
        hs=ft_read_headshape('2/hs_file');
    end
    [o,r]=fitsphere(hs.pnt);
    cfg.inwardshift=0.025;
    cfg.vol.r=r;cfg.vol.o=o;
    %cfg.trials=good;
    data_ra=ft_megrealign(cfg,meg);
    close all
    cfg=[];
    %cfg.trials=good;
    cfg.output       = 'pow';
    cfg.method       = 'mtmfft';
    cfg.taper        = 'hanning';
    cfg.foi          = [3 6 9 10 11 12 15 20 25 30 40 50 60 70 80 90 100];
    cfg.feedback='no';
    %cfg.keeptrials='yes';
    Fr = ft_freqanalysis(cfg, data_ra);
    save realign data_ra Fr
    eval(['Fr',num2str(subi+43),'=Fr;'])
    
end
cd /home/yuval/Copy/MEGdata/alice/alphaRA
clear Fr;save TuvOp Fr*

%     
%     cd /media/YuvalExtDrive/alpha/Tuv
%     
%     cd(subs{subi}(end-1:end))
%     fileName = 'c,rfhp0.1Hz';
%     try
%     hdr=ft_read_header(['1/',fileName]);
%     hs=ft_read_headshape(['1/','hs_file']);
%     catch
%         hdr=ft_read_header(fileName);
%         hs=ft_read_headshape('hs_file');
%     end
%     eval(['sub',num2str(subi),'.hdr=hdr;']);
%     eval(['sub',num2str(subi),'.hs=hs;']);
%     eval(['sub',num2str(subi),'.ID=subs{subi};']);
%     o(subi,1:3)=fitsphere(hdr.grad.chanpos(1:248,:));
%     
% end
cd /home/yuval/Copy/MEGdata/alpha/Tuv
clear subs subi
save headPos sub* o
clear
%% GA
cd /home/yuval/Copy/MEGdata/alice/alphaRA
load aliceOp
load AviMaOp
load talOp
load TuvOp
str='Open=ft_freqgrandaverage(cfg';
for subi=1:58
    str=[str,',Fr',num2str(subi)];
end
str=[str,');'];
cfg.keepindividual='yes';
cfg.foilim=[9 11];
eval(str);
save Open Open
clear Fr*

load HypCl
load talCl
load TuvCl
str='Closed=ft_freqgrandaverage(cfg';
for subi=1:53
    str=[str,',Fr',num2str(subi)];
end
str=[str,');'];
cfg.keepindividual='yes';
cfg.foilim=[9 11];
eval(str);
save Closed Closed


% cd /home/yuval/Copy/MEGdata/alpha/Tuv
% load subs
% for subi=1:length(subs)
%     sub=subs{subi};
%     cd /media/YuvalExtDrive/MEG/tal
%     cd ([sub,'/',sub,'/0.14d1']);
%     conditions=textread('conditions','%s');
%     restcell=find(strcmp('rest',conditions),1);
%     resti=1;
%     path2file=conditions{restcell(resti)+1};
%     source= conditions{restcell(resti)+2};
%     cd(path2file(end-16:end))
%     fileName = source;
%     hdr=ft_read_header(fileName);
%     hs=ft_read_headshape('hs_file');
%     eval(['sub',num2str(subi),'.hdr=hdr;']);
%     eval(['sub',num2str(subi),'.hs=hs;']);
%     eval(['sub',num2str(subi),'.ID=subs{subi};']);
%     o(subi,1:3)=fitsphere(hdr.grad.chanpos(1:248,:));
%     
%     
% end
% cd /home/yuval/Copy/MEGdata/alpha/tal
% clear subs subi
% save headPos sub* o
% clear
% %% alice
% cd /home/yuval/Copy/MEGdata/alpha/alice
% load subs
% 
% cd /home/yuval/Copy/MEGdata/alice
% for subi=1:length(subs)
%     
%     cd(subs{subi})
%     
%     try
%     hdr=ft_read_header('c,rfhp0.1Hz');
%     catch
%         hdr=ft_read_header('c,rfDC');
%     end
%     hs=ft_read_headshape('hs_file');
%     eval(['sub',num2str(subi),'.hdr=hdr;']);
%     eval(['sub',num2str(subi),'.hs=hs;']);
%     eval(['sub',num2str(subi),'.ID=subs{subi};']);
%     o(subi,1:3)=fitsphere(hdr.grad.chanpos(1:248,:));
%     cd ..
% end
% cd /home/yuval/Copy/MEGdata/alpha/alice
% clear subs subi
% save headPos sub* o
% clear
% 
% %% 
% 
%         
% 

% cd /home/yuval/Copy/MEGdata/alpha/AviMa
% load subs
% cfg=[];
% cfg.xlim=[10 10];
% cfg.layout='4D248.lay';
% 
% for subi=1:length(subs)
%     cd /media/YuvalExtDrive/alpha/AviMa
%     cd(subs{subi})
%     load open
%     figure;ft_topoplotER(cfg,megFr)
%     title(subs{subi});
% end