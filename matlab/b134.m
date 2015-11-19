% b134b
cd /home/yuval/Data/epilepsy/b134b/2kHz
p=pdf4D('lf,rs_c,rfhp0.1Hz');
sRate=double(get(p,'dr'));
chi = channel_index(p, 'meg', 'name');
data = read_data_block(p,[1 sRate*60*10],chi);
load time
BL1=nearest(time,14);
BL2=nearest(time,18);


time=time(1:length(data));

B=zeros(1,length(data));
for chii=1:248
    ch=data(chii,:);
    ch=ch-mean(ch(BL1:BL2));
    ch=ch.^2;
    B=B+ch;
end
B=B./248;
B=sqrt(B);
B=B./mean(B(BL1:BL2));
figure;plot(time,B);
Bs=smooth(B,2034);
hold on
plot(time,Bs,'r')
fBL=abs(fftBasic(data(:,BL1:BL2),sRate));

Bs1=Bs;
samp1=1;
ff=zeros(248,length(fBL));
count=0;

while samp1<(length(Bs)-2035)
    samp0=find(Bs1>1.5,1);
    samp1=samp0+2035;
    ff=ff+abs(fftBasic(data(:,samp0:samp1),sRate));
    count=count+1;
    
    Bs1(1:samp1)=0;
    prog(count);
end
 ff=ff./count;   
figure;plot(mean(ff(:,1:100))./mean(fBL(:,1:100)))
figure;topoplot248(ff(:,9),[],1)
title alpha
figure;topoplot248(mean(ff(:,11:21),2),[],1)
%%

cd /home/yuval/Data/epilepsy/b134b/2kHz
p=pdf4D(source);
cleanCoefs = createCleanFile(p, source,...
    'stepCorrect',1,...
    'byLF',0 ,...
    'xClean',0,...
    'byFFT',0,...
    'HeartBeat',0)
p=pdf4D('rs_c,rfhp0.1Hz');
cleanCoefs = createCleanFile(p, 'rs_c,rfhp0.1Hz',...
    'stepCorrect',0,...
    'byLF',256 ,...
    'xClean',0,...
    'byFFT',0,...
    'HeartBeat',0)


p=pdf4D('lf,rs_c,rfhp0.1Hz');
sRate=double(get(p,'dr'));
hdr = get(p, 'header');
nSamp=hdr.epoch_data{1,1}.pts_in_epoch;
chi = channel_index(p, 'meg', 'name');
data = read_data_block(p,[1 nSamp],chi);
load LRpairs
L=zeros(1,length(data));
R=L;
for sidei=1:115
    ch=data(str2num(LRpairs{sidei,1}(2:end)),:);
    ch=ch-mean(ch(3600000:end));
    ch=ch.^2;
    L=L+ch;
end
L=L/115;
for sidei=1:115
    ch=data(str2num(LRpairs{sidei,2}(2:end)),:);
    ch=ch-mean(ch(3600000:end));
    ch=ch.^2;
    R=R+ch;
end
R=R/115
R=sqrt(R);
L=sqrt(L);
save LR L R
