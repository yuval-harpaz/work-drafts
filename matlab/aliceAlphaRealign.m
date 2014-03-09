%% realign alice

cd /home/yuval/Copy/MEGdata/alpha
load temp
load alice/subs
cd ~/Copy/MEGdata/alice
for subi=1:length(subs)
    cd(subs{subi})
    load fr.mat megFr100
    cfg=[];
    cfg.trl=megFr100.cfg.previous.trl;
    cfg.channel='MEG';
    cfg.demean='yes';
    cfg.feedback='no';
    LSclean=ls('*lf*');
    cfg.dataset=LSclean(1:end-1);
    data=ft_preprocessing(cfg);
    
    cfg=[];
    cfg.template{1,1}=temp.hdr.grad;
    hs=ft_read_headshape('hs_file');
    [o,r]=fitsphere(hs.pnt);
    cfg.inwardshift=0.025;
    cfg.vol.r=r;cfg.vol.o=o;
    data_ra=ft_megrealign(cfg,data);
    
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
    eval(['Fr',num2str(subi),'=Fr;'])
    cd ..
end
save Fr_ra Fr*
!mv Fr_ra.mat /home/yuval/Copy/MEGdata/alice/alphaRA/alice.mat

cd /media
%% check shift and tilt
exp={'alice','AviMa','Hyp','tal','Tuv'};
cd /home/yuval/Copy/MEGdata/alpha
subCount=0;
for expi=1:5
    cd(exp{expi})
    load headPos;
    for subi=1:length(o)
        eval(['sub=sub',num2str(subi),';']);
        L=sub.hdr.grad.chanpos(37,:); % A233
        R=sub.hdr.grad.chanpos(235,:); % A244
        p=R(1)-L(1); % how much left is posterior to right
        l=L(2)-(L(2)-R(2))/2; % how much left is more to the left
        i=L(3)-R(3); % how much left is below right (head leans to right)
        subCount=subCount+1;
        A233pli(subCount,1:3)=[p,l,i];
        
    end
    cd ..
end
[a,b]=ttest(A233pli(:,1));
[a,b]=ttest(A233pli(:,2));
mean(A233pli);
save A233pli A233pli




cd /home/yuval/Copy/MEGdata/alpha
load temp
cd ~/Copy/MEGdata/alice/idan
load fr.mat megFr100
cfg=[];
cfg.trl=megFr100.cfg.previous.trl;
cfg.channel='MEG';
cfg.demean='yes';
cfg.feedback='no';
LSclean=ls('*lf*');
cfg.dataset=LSclean(1:end-1);
data=ft_preprocessing(cfg);

cfg=[];
cfg.template{1,1}=temp.hdr.grad;
hs=ft_read_headshape('hs_file');
[o,r]=fitsphere(hs.pnt);
cfg.inwardshift=0.025;
cfg.vol.r=r;cfg.vol.o=o;
data_ra=ft_megrealign(cfg,data);

cfg=[];
%cfg.trials=find(datacln.trialinfo==222);
cfg.output       = 'pow';
cfg.channel      = {'MEG','-A204','-A74'};
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = 1:100;
cfg.feedback='no';
Fr = ft_freqanalysis(cfg, data_ra);

cfg=[];
cfg.trials=i;
cfg.layout='4D248.lay';
cfg.xlim=[9 9];
figure;
ft_topoplotER(cfg,Fr)


%% how I got the template
cd /home/yuval/Copy/MEGdata/alpha/AviMa
load headPos;
for subi=1:length(o)
    eval(['sub=sub',num2str(subi),';']);
    L=sub.hdr.grad.chanpos(37,:); % A233
    R=sub.hdr.grad.chanpos(235,:); % A244
    p(subi)=R(1)-L(1); % how much left is posterior to right
    l(subi)=L(2)-(L(2)-R(2))/2; % how much left is more to the left
    i(subi)=L(3)-R(3); % how much left is below right (head leans to right)
end
[v,ind]=min(abs(p)+abs(i));
eval(['ID=sub',num2str(ind),'.ID;']);
disp([ID,' had only ',num2str(v*1000),'mm tilt'])
cd ../alice
load headPos;
for subi=1:length(o)
    eval(['sub=sub',num2str(subi),';']);
    L=sub.hdr.grad.chanpos(37,:); % A233
    R=sub.hdr.grad.chanpos(235,:); % A244
    p(subi)=R(1)-L(1); % how much left is posterior to right
    l(subi)=L(2)-(L(2)-R(2))/2; % how much left is more to the left
    i(subi)=L(3)-R(3); % how much left is below right (head leans to right)
end
[v,ind]=min(abs(p)+abs(i));
eval(['ID=sub',num2str(ind),'.ID;']);
disp([ID,' had only ',num2str(v*1000),'mm tilt'])
cd ../Hyp
load headPos;
for subi=1:length(o)
    eval(['sub=sub',num2str(subi),';']);
    L=sub.hdr.grad.chanpos(37,:); % A233
    R=sub.hdr.grad.chanpos(235,:); % A244
    p(subi)=R(1)-L(1); % how much left is posterior to right
    l(subi)=L(2)-(L(2)-R(2))/2; % how much left is more to the left
    i(subi)=L(3)-R(3); % how much left is below right (head leans to right)
end
[v,ind]=min(abs(p)+abs(i));
eval(['ID=sub',num2str(ind),'.ID;']);
disp([ID,' had only ',num2str(v*1000),'mm tilt'])

temp.hdr.grad.chanpos(:,2)=sub.hdr.grad.chanpos(:,2)-l(subi);
fitsphere(temp.hdr.grad.chanpos(1:248,:))
temp.hdr.grad.chanpos(:,2)=sub.hdr.grad.chanpos(:,2)+0.001;
save temp temp


for subi=1:length(o)
    sub=num2str(subi);
    eval(['fid(',sub,',1:5,1:3)=sub',sub,'.hs.fid.pnt'])
end
for subi=1:length(o)
    eval(['sub=sub',num2str(subi)]);
    
    plot3pnt(sub.hs.pnt,'.')
    hold on
    plot3pnt(sub.hdr.grad.chanpos(1:248,:),'yo')
end
%%
% exp={'alice','AviMa','Hyp','tal','Tuv'};
% 
% cd /home/yuval/Copy/MEGdata/alice/SEATED/idan
% hdr=ft_read_header('c,rfhp0.1Hz')
% % here I make template with chans A229 A248 and A220 at z=0, A1 and A220 at
% % y=0, and A1 at x=0. 
% y229=pdist([hdr.grad.chanpos(121,:);hdr.grad.chanpos(225,:)],'euclidean')/2;
% dist229_1=pdist([hdr.grad.chanpos(121,:);hdr.grad.chanpos(186,:)],'euclidean');
% dist220_1=pdist([hdr.grad.chanpos(31,:);hdr.grad.chanpos(186,:)],'euclidean');
% dist229_220=pdist([hdr.grad.chanpos(121,:);hdr.grad.chanpos(31,:)],'euclidean');
% 
% syms x1 x4 z3
% solutions=solve(x1^2+y229^2+z3^2-dist229_1^2,x4^2+z3^2-dist220_1^2,(x1-x4)^2+y229^2-dist229_220^2);
% X1=eval(solutions.x1(1));
% Z3=eval(solutions.z3(1));
% X4=eval(solutions.x4(1));
% 
% isequal(pdist([X4,0,0;0,0,Z3],'euclidean'),dist220_1);
% isequal(pdist([X4,0,0;X1,y229,0],'euclidean'),dist229_220); % OK really
% isequal(pdist([X1,y229,0;0,0,Z3],'euclidean'),dist229_1);
% anchor.label={'A229','A248','A1','A220'};
% anchor.pos=[X1,y229,0;X1,-y229,0;0,0,Z3;X4,0,0];
cd /home/yuval/Copy/MEGdata/alice
load anchor
cd /home/yuval/Copy/MEGdata/alice/SEATED/idan
hdr=ft_read_header('c,rfhp0.1Hz');
grad=hdr.grad;
pts=grad.chanpos([121,225,186,31],:);
M1=makeTrans(pts,anchor.pos);
test=transPnt(pts,M1)
%test=transPnt(pts,inv(M1))

plot3pnt(anchor.pos,'ro')
hold on
plot3pnt(test,'go')
plot3pnt(test(1,:),'k*')

% ind=[121;225;186;31];
% grad.label{ind}
% pos=grad.chanpos(ind,:);
% cfg=[];
% cfg.fiducial=pos;
% [sensor] = ft_sensorrealign(cfg);
cfg=[];
cfg.method='fiducial';
cfg.fiducial={'NAS','LPA','RPA'};
cfg.target.pnt(1,1:3) = grad.chanpos(find(ismember(grad.label,'A121')),:);  
cfg.target.pnt(2,:) = grad.chanpos(find(ismember(grad.label,'A158')),:);  
cfg.target.pnt(3,:) = grad.chanpos(find(ismember(grad.label,'A171')),:);
grad.fid=cfg.target.pnt;
cfg.grad=grad;
cfg.target.label    = {'NAS','LPA','RPA'};
cfg.target.unit='m';
[sensor] = ft_sensorrealign(cfg);   
cd /home/yuval/Copy/MEGdata
cd alice
cd idan
load fr.mat megFr100
cfg=[];
cfg.trl=megFr100.cfg.previous.trl;
cfg.channel='MEG';
cfg.demean='yes';
cfg.feedback='no';
LSclean=ls('*lf*');
cfg.dataset=LSclean(1:end-1);
data=ft_preprocessing(cfg);
cfg=[];
%cfg.trials=find(datacln.trialinfo==222);
cfg.output       = 'pow';
%    cfg.channel      = 'MEG';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foi          = 1:100;
cfg.feedback='no';
Fr = ft_freqanalysis(cfg, data);

cfg=[];
cfg.trials=i;
cfg.layout='4D248.lay';
cfg.xlim=[10 10];
figure;
ft_topoplotER(cfg,Fr)


cfg=[];
cfg.template={dom.grad};
hs=ft_read_headshape([subjn,'/DOM/hs_file']);
[o,r]=fitsphere(hs.pnt);
load([subjn,'/DOM/dom.mat']);
cfg.inwardshift=0.025;
cfg.vol.r=r;cfg.vol.o=o;
cfg.trials=1;
dom_ra=ft_megrealign(cfg,dom);









cd /home/yuval/Copy/MEGdata/alpha/tal
load Open
%label=Open.label;
Open.powspctrm=zeros(size(Open.powspctrm(1,:,:)));
OpenNeg=rmfield(Open,'cfg');
ClosedNeg=Open;
N=0;
Nneg=0;
NO=0;
NOneg=0;
NC=0;
NCneg=0;
for expi=1:5
    op=false;
    cl=false;
    cd /home/yuval/Copy/MEGdata/alpha
    cd (exp{expi})
    load headPos
    N=N+size(o,1);
    if exist('Open.mat','file')
        op=true;
        NO= NO+size(o,1);
        load Open
        [~,chani]=ismember(OpenNeg.label,Open.label);
        chani=chani(chani>0);
    end
    if exist('Closed.mat','file')
        cl=true;
        NC= NC+size(o,1);
        load Closed
        [~,chani]=ismember(ClosedNeg.label,Closed.label);
        chani=chani(chani>0);
    end
    neg=find(o(:,2)<=0.001);
    if ~isempty(neg)
        disp(length(neg))
        for negi=1:length(neg)
            if op
                eval(['OpenNeg.powspctrm(',num2str(NOneg+negi),',:,:)=Open.powspctrm(',num2str(neg(negi)),',chani,:)']);
            end
            if cl
                eval(['ClosedNeg.powspctrm(',num2str(NCneg+negi),',:,:)=Closed.powspctrm(',num2str(neg(negi)),',chani,:)']);
            end
        end
        Nneg=Nneg+length(neg);
        if op
            NOneg=NOneg+length(neg);
        end
        if cl
            NCneg=NCneg+length(neg);
        end
    end
end
cd /home/yuval/Copy/MEGdata/alpha
save leftHeadPosition ClosedNeg OpenNeg