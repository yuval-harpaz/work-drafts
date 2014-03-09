%% AviMa
cd /home/yuval/Copy/MEGdata/alpha/AviMa
load subs
cd /media/YuvalExtDrive/alpha/AviMa
for subi=1:length(subs)
    try
        cd /media/YuvalExtDrive/alpha/AviMa
        cd(subs{subi})
        if exist('1','dir')
            cd 1
        else
            cd 2
        end
        
        fileName = 'c,rfhp0.1Hz';
        hdr=ft_read_header(fileName);
        hs=ft_read_headshape('hs_file');
        eval(['sub',num2str(subi),'.hdr=hdr;']);
        eval(['sub',num2str(subi),'.hs=hs;']);
        eval(['sub',num2str(subi),'.ID=subs{subi};']);
        o(subi,1:3)=fitsphere(hdr.grad.chanpos(1:248,:));
        

    end
end
cd /home/yuval/Copy/MEGdata/alpha/AviMa
clear subs subi
save headPos sub* o
clear
%% Hyp
cd /home/yuval/Copy/MEGdata/alpha/Hyp
load subs


for subi=1:length(subs)
    cd /media/YuvalExtDrive/alpha/Hyp
    cd(subs{subi})
    fileName = 'c,rfhp0.1Hz';
    hdr=ft_read_header(fileName);
    hs=ft_read_headshape('hs_file');
    eval(['sub',num2str(subi),'.hdr=hdr;']);
    eval(['sub',num2str(subi),'.hs=hs;']);
    eval(['sub',num2str(subi),'.ID=subs{subi};']);
    o(subi,1:3)=fitsphere(hdr.grad.chanpos(1:248,:));
    
end
cd /home/yuval/Copy/MEGdata/alpha/Hyp
clear subs subi
save headPos sub* o
clear
%% Tal FIXME - Tal and Tuv mixed up!
cd /home/yuval/Copy/MEGdata/alpha/tal
load subs
for subi=1:length(subs)
    cd /media/YuvalExtDrive/alpha/Tuv
    
    cd(subs{subi}(end-1:end))
    fileName = 'c,rfhp0.1Hz';
    try
    hdr=ft_read_header(['1/',fileName]);
    hs=ft_read_headshape(['1/','hs_file']);
    catch
        hdr=ft_read_header(fileName);
        hs=ft_read_headshape('hs_file');
    end
    eval(['sub',num2str(subi),'.hdr=hdr;']);
    eval(['sub',num2str(subi),'.hs=hs;']);
    eval(['sub',num2str(subi),'.ID=subs{subi};']);
    o(subi,1:3)=fitsphere(hdr.grad.chanpos(1:248,:));
    
end
cd /home/yuval/Copy/MEGdata/alpha/Tuv
clear subs subi
save headPos sub* o
clear
%% Tuv
cd /home/yuval/Copy/MEGdata/alpha/Tuv
load subs
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
    hdr=ft_read_header(fileName);
    hs=ft_read_headshape('hs_file');
    eval(['sub',num2str(subi),'.hdr=hdr;']);
    eval(['sub',num2str(subi),'.hs=hs;']);
    eval(['sub',num2str(subi),'.ID=subs{subi};']);
    o(subi,1:3)=fitsphere(hdr.grad.chanpos(1:248,:));
    
    
end
cd /home/yuval/Copy/MEGdata/alpha/tal
clear subs subi
save headPos sub* o
clear
%% alice
cd /home/yuval/Copy/MEGdata/alpha/alice
load subs

cd /home/yuval/Copy/MEGdata/alice
for subi=1:length(subs)
    
    cd(subs{subi})
    
    try
    hdr=ft_read_header('c,rfhp0.1Hz');
    catch
        hdr=ft_read_header('c,rfDC');
    end
    hs=ft_read_headshape('hs_file');
    eval(['sub',num2str(subi),'.hdr=hdr;']);
    eval(['sub',num2str(subi),'.hs=hs;']);
    eval(['sub',num2str(subi),'.ID=subs{subi};']);
    o(subi,1:3)=fitsphere(hdr.grad.chanpos(1:248,:));
    cd ..
end
cd /home/yuval/Copy/MEGdata/alpha/alice
clear subs subi
save headPos sub* o
clear

%% 

        


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