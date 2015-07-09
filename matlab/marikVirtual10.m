nPNT=642;
cd /home/yuval/Data/marik/som2/1
hs=ft_read_headshape('hs_file');
hs=hs.pnt*1000;

inward=[10 20 30];

[pnt1,lf1,vol]=sphereGrid(nPNT,inward(1)); % inner
pnt_complex1=findPerpendicular(pnt1);
[pnt2,lf2]=sphereGrid(nPNT,inward(2)); % outer
pnt_complex2=findPerpendicular(pnt2);
[pnt3,lf3,vol]=sphereGrid(nPNT,inward(3)); % inner
pnt_complex3=findPerpendicular(pnt3);
pnt=[pnt1(:,:,1);pnt2(:,:,1);pnt3(:,:,1)];
ini=true(length(pnt),1);
ini(pnt(:,3)<vol.o(3))=false; % keep only top half sphere
ini(pnt(:,2)<min(hs(:,2)'+10))=false;
ini(pnt(:,2)>max(hs(:,2)'-10))=false;
ini=find(ini);
pnt=pnt(ini,:);

pnt_complex=pnt_complex1;
pnt_complex(nPNT+1:nPNT*2,:,:)=pnt_complex2;
pnt_complex(nPNT*2+1:nPNT*3,:,:)=pnt_complex3;
pnt_complex=pnt_complex(ini,:,:);
layer(1:nPNT,1)=1;layer(nPNT+1:nPNT*2)=2;layer(nPNT*2+1:nPNT*3)=3;
layer=layer(ini);
cd /home/yuval/Data/marik/som2/2
[~,lf4]=sphereGrid(nPNT,inward(1));
[~,lf5]=sphereGrid(nPNT,inward(2));
[~,lf6]=sphereGrid(nPNT,inward(3));
cd /home/yuval/Data/marik/som2/3
[~,lf7]=sphereGrid(nPNT,inward(1));
[~,lf8]=sphereGrid(nPNT,inward(2));
[~,lf9]=sphereGrid(nPNT,inward(3));
LF1=lf1; %head pos 1
LF1.leadfield(nPNT+1:nPNT*2)=lf2.leadfield;
LF1.leadfield(nPNT*2+1:nPNT*3)=lf3.leadfield;
LF1.leadfield=LF1.leadfield(ini);
LF1.pos(nPNT+1:nPNT*2,:)=lf2.pos;
LF1.pos(nPNT*2+1:nPNT*3,:)=lf3.pos;
LF1.pos=LF1.pos(ini,:);
LF1.inside(nPNT+1:nPNT*2)=lf2.inside;
LF1.inside(nPNT*2+1:nPNT*3)=lf2.inside;
LF1.inside=LF1.inside(ini);
LF2=lf4; %head pos 2
LF2.leadfield(nPNT+1:nPNT*2)=lf5.leadfield;
LF2.leadfield(nPNT*2+1:nPNT*3)=lf6.leadfield;
LF2.leadfield=LF2.leadfield(ini);
LF2.pos(nPNT+1:nPNT*2,:)=lf5.pos;
LF2.pos(nPNT*2+1:nPNT*3,:)=lf6.pos;
LF2.pos=LF2.pos(ini,:);
LF2.inside(nPNT+1:nPNT*2)=lf5.inside;
LF2.inside(nPNT*2+1:nPNT*3)=lf6.inside;
LF2.inside=LF2.inside(ini);
LF3=lf7; %pos3 
LF3.leadfield(nPNT+1:nPNT*2)=lf8.leadfield;
LF3.leadfield(nPNT*2+1:nPNT*3)=lf9.leadfield;
LF3.leadfield=LF3.leadfield(ini);
LF3.pos(nPNT+1:nPNT*2,:)=lf8.pos;
LF3.pos(nPNT*2+1:nPNT*3,:)=lf9.pos;
LF3.pos=LF3.pos(ini,:);
LF3.inside(nPNT+1:nPNT*2)=lf8.inside;
LF3.inside(nPNT*2+1:nPNT*3)=lf9.inside;
LF3.inside=LF3.inside(ini);

close all
figure
plot3pnt(hs,'.')
hold on
plot3pnt(pnt,'.k')

cd /home/yuval/Data/marik/som2
load avgFilt
[data, cfg]=marikViUnite(avg1_handR,avg2_handR,avg3_handR);
%LF.label=data.dataU.label

gain=[];
for pnti=1:length(pnt)
    dip=(pnt_complex(pnti,:,2)-pnt_complex(pnti,:,1))*LF1.leadfield{pnti}';
    dip=[dip,(pnt_complex(pnti,:,2)-pnt_complex(pnti,:,1))*LF2.leadfield{pnti}'];
    dip=[dip,(pnt_complex(pnti,:,2)-pnt_complex(pnti,:,1))*LF3.leadfield{pnti}'];
    gain(1:744,pnti)=dip;
    dip=(pnt_complex(pnti,:,3)-pnt_complex(pnti,:,1))*LF1.leadfield{pnti}';
    dip=[dip,(pnt_complex(pnti,:,3)-pnt_complex(pnti,:,1))*LF2.leadfield{pnti}'];
    dip=[dip,(pnt_complex(pnti,:,3)-pnt_complex(pnti,:,1))*LF3.leadfield{pnti}'];
    gain(1:744,length(pnt)+pnti)=dip;
end

%% 
samp=138; % 158 185
M=data.dataU.avg(:,samp);

%[mostActive,neighbours]=clusterSensors(data.dataU,data.dataU.time(samp),'97%',50,1);
%cfg.channel = {'A46', 'A128'}
load mostActive
coordAct=mean(data.dataU.grad.chanpos(mostActive,:));
load neighb
neighbours=neighb;

% 
[srci]=chooseNearSrc(data.dataU,pnt,coordAct,50);
% disp([num2str(sum(neighbours)),' channels and ',num2str(sum(srci)),' sources'])
% 
src1=find(layer==1.*srci);
src2=find(layer==2.*srci);
src3=find(layer==3.*srci);
Pow=zeros(length(srci)*2,1);
tic
for permi=1:10000
    Ran=[];
    for layeri=1:3
        eval(['lenLayer=length(src',num2str(layeri),');'])
        [~,ran]=sort(rand(1,lenLayer));
        eval(['selected=src',num2str(layeri),'(ran(1:5));'])
        Ran=[Ran;selected];
    end
    srcPerm=false(size(srci));
    srcPerm(Ran)=true;
    Gain=gain(:,[srcPerm;srcPerm]);
    source=Gain\M;
    recon=Gain*source;
    R=corr(recon,M).^2;
    pow=zeros(size(Pow));
    pow([srcPerm;srcPerm])=source*R;
    Pow=Pow+pow;
end
toc
Pow1=sqrt(Pow(1:920).^2+Pow(921:1840).^2);
figure;
scatter3pnt(pnt,25,Pow1)
[~,maxPNT]=max(Pow1);
hold on
scatter3(pnt(maxPNT,1),pnt(maxPNT,2),pnt(maxPNT,3),30,0)

%% whole head permutations

Pow=zeros(length(srci)*2,1);
tic
for permi=1:100000
    Ran=[];
    for layeri=1:3
        src=find(layer==layeri);
        lenLayer=sum(layer==layeri);
        [~,ran]=sort(rand(1,lenLayer));
        selected=src(ran(1:5));
        Ran=[Ran;selected];
    end
    srcPerm=false(size(srci));
    srcPerm(Ran)=true;
    Gain=gain(:,[srcPerm;srcPerm]);
    source=Gain\M;
    recon=Gain*source;
    R=corr(recon,M).^2;
    pow=zeros(size(Pow));
    pow([srcPerm;srcPerm])=source*R;
    Pow=Pow+pow;
    prog(permi)
end
toc
Pow1=sqrt(Pow(1:920).^2+Pow(921:1840).^2);
figure;
scatter3pnt(pnt,25,Pow1)
[~,maxPNT]=max(Pow1);
hold on
scatter3(pnt(maxPNT,1),pnt(maxPNT,2),pnt(maxPNT,3),30,0)

[~,sortPNT]=sort(Pow1,'descend');
sortPNT(1:5)


%% no layers

Pow=zeros(length(srci)*2,1);
tic
for permi=1:100000
    Ran=[];
    
    [~,ran]=sort(rand(1,length(srci)));
    selected=ran(1:5);
    Ran=[Ran;selected];
    
    srcPerm=false(size(srci));
    srcPerm(Ran)=true;
    Gain=gain(:,[srcPerm;srcPerm]);
    source=Gain\M;
    recon=Gain*source;
    R=corr(recon,M).^2;
    pow=zeros(size(Pow));
    pow([srcPerm;srcPerm])=source*R;
    Pow=Pow+pow;
    prog(permi)
end
toc
Pow1=sqrt(Pow(1:920).^2+Pow(921:1840).^2);
figure;
scatter3pnt(pnt,25,Pow1)
[~,maxPNT]=max(Pow1);
hold on
scatter3(pnt(maxPNT,1),pnt(maxPNT,2),pnt(maxPNT,3),30,0)

[~,sortPNT]=sort(Pow1,'descend');
sortPNT(1:5)

%% LR flip

load LRpairs
Mfliped=M;
for i=1:248
    [~,chi]=ismember(data.data1.label{i}(1:end-2),LRpairs(:,1));
    if chi>0
        chPairi=find(ismember(data.data1.label,[LRpairs{chi,2},'_1']));
        Mfliped(chPairi)=M(i);
        Mfliped(chPairi+248)=M(i+248);
        Mfliped(chPairi+248*2)=M(i+248*2);
    end
    [~,chi]=ismember(data.data1.label{i}(1:end-2),LRpairs(:,2));
    if chi>0
        chPairi=find(ismember(data.data1.label,[LRpairs{chi,1},'_1']));
        Mfliped(chPairi)=M(i);
        Mfliped(chPairi+248)=M(i+248);
        Mfliped(chPairi+248*2)=M(i+248*2);
    end 
end
Msum=M-Mfliped;

Pow=zeros(length(layer)*2,1);
tic
for permi=1:100000
    Ran=[];
    
    [~,ran]=sort(rand(1,length(layer)));
    selected=ran(1:5);
    Ran=[Ran;selected];
    
    srcPerm=false(size(layer));
    srcPerm(Ran)=true;
    Gain=gain(:,[srcPerm;srcPerm]);
    source=Gain\Mfliped;
    recon=Gain*source;
    R=corr(recon,Mfliped).^2;
    pow=zeros(size(Pow));
    pow([srcPerm;srcPerm])=source*R;
    Pow=Pow+pow;
    prog(permi)
end
toc
Pow1=sqrt(Pow(1:920).^2+Pow(921:1840).^2);
figure;
scatter3pnt(pnt,25,Pow1)
[~,maxPNT]=max(Pow1);
hold on
scatter3(pnt(maxPNT,1),pnt(maxPNT,2),pnt(maxPNT,3),30,0)

[~,sortPNT]=sort(Pow1,'descend');
sortPNT(1:5)




