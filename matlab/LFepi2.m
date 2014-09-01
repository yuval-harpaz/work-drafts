%% designed to show time frequency, rejected by Avi

cd /home/yuval/Data/epilepsy/b162b/1
fn='c,rfhp1.0Hz';
fn=['hb_',fn];
hdr=ft_read_header(fn);
t1=115;
t2=145;
tdif=t2-t1+1;
sRate=round(hdr.Fs);
cfg=[];
cfg.trl=[t1*sRate t2*sRate 0];
cfg.demean='yes';
cfg.dataset=fn;
cfg.channel='MEG';
data=ft_preprocessing(cfg);
%f=abs(fftBasic(data.trial{1,1},data.fsample));
%plot(mean(f))


chi=find(ismember(data.label,{'A132','A133','A134','A160','A161','A162'}));
fraw=zeros(248,339,tdif);
for i=1:(tdif-1)
    si=(i-1)*678:i*678;
    fraw(1:248,1:339,i)=abs(fftBasic(data.trial{1,1}(:,si+1),data.fsample));
end
cfg.dataset='cln100_c,rfhp1.0Hz';
data=ft_preprocessing(cfg);
f100=zeros(248,339,tdif);
for i=1:(tdif-1)
    si=(i-1)*678:i*678;
    f100(1:248,1:339,i)=abs(fftBasic(data.trial{1,1}(:,si+1),data.fsample));
end


% imgRaw=squeeze(mean(abs(fraw(chi,20:70,:))));figure;imagesc(imgRaw)
% img100=squeeze(mean(abs(f100(chi,20:70,:))));figure;imagesc(img100)
cfg.dataset='cln500_c,rfhp1.0Hz';
data=ft_preprocessing(cfg);
f500=zeros(248,339,tdif);
for i=1:(tdif-1)
    si=(i-1)*678:i*678;
    f500(1:248,1:339,i)=abs(fftBasic(data.trial{1,1}(:,si+1),data.fsample));
end
% f1=40;
% f2=70;
% imgRaw=squeeze(mean(abs(fraw(chi,f1:f2,:))));figure;imagesc(imgRaw)
% min50Hz = min(imgRaw(50,:));
% max50Hz = max(imgRaw(50,:));
% set(gca,'Clim',[min50Hz max50Hz])
% %img100=squeeze(mean(abs(f100(chi,f1:f2,:))));figure;imagesc(img100)
% img500=squeeze(mean(abs(f500(chi,f1:f2,:))));figure;imagesc(img500)
% set(gca,'Clim',[min50Hz max50Hz])

f1=20;
f2=70;

imgRaw=squeeze(mean(abs(fraw(chi,f1:f2,:))));figure;imagesc(imgRaw)
min50Hz = min(imgRaw(50-f1,:))*2;
max50Hz = max(imgRaw(50-f1,:))*2;
set(gca,'Clim',[min50Hz max50Hz])
%img100=squeeze(mean(abs(f100(chi,f1:f2,:))));figure;imagesc(img100)
img500=squeeze(mean(abs(f500(chi,f1:f2,:))));figure;imagesc(img500)
set(gca,'Clim',[min50Hz max50Hz])


figure;topoplot248(mean(f500(:,50,:),3))







cfg=[];
cfg.interpolation      = 'linear';
cfg.zlim=[0 5e-12];
figure;
topoplot248(f100(:,50),cfg,1);
title('N = 100')
figure;
topoplot248(f500(:,50),cfg,1);
title('N = 500')
figure;
topoplot248(f1000(:,50),cfg,1);
title('N = 1000')







cfg=[];
cfg.method='adaptive1';
cfg.Ncycles=4000;
cfg.jobs=4;
cln3=correctLF(fn,678.17,trig,cfg);
cfg=[];
cfg.method='adaptive1';
cfg.Ncycles=250;
cfg.jobs=4;
cln4=correctLF(fn,678.17,trig,cfg);

cfg=[];
cfg.method='adaptive1';
cfg.Ncycles=100;
cfg.jobs=4;
cln100=correctLF(fn,678.17,trig,cfg);
cfg=[];
cfg.method='adaptive1';
cfg.Ncycles=500;
cfg.jobs=4;
cln500=correctLF(fn,678.17,trig,cfg);
cfg=[];
cfg.method='adaptive1';
cfg.Ncycles=1000;
cfg.jobs=4;
cln1000=correctLF(fn,678.17,trig,cfg);


cfg=[];
cfg.method='adaptive';
cfg.Ncycles=500;
cfg.jobs=4;
cln3=correctLF(fn,678.17,trig,cfg);
cfg=[];
cfg.method='adaptive';
cfg.Ncycles=1000;
cfg.jobs=4;
cln4=correctLF(fn,678.17,trig,cfg);



f1=abs(fftBasic(cln1(:,t1*sRate:t2*sRate),data.fsample));
f2=abs(fftBasic(cln2(:,t1*sRate:t2*sRate),data.fsample));
bl(1:160)=mean(mean(f(:,151:180)));
figure;
plot(1:160,bl,'k--','linewidth',2)
set(gca,'fontname','times','fontsize',15)
hold on
plot(mean(f),'b','linewidth',2)
plot(mean(f1),'r','linewidth',2)
plot(mean(f2),'g','linewidth',2)
box off
xlim([1 160]);
ylim([0 2.2e-11])
% 
% figure;
% plot(f(114,:),'b')
% hold on
% plot(f1(132,:),'r') % sorted channels, A132
% plot(f2(132,:),'g')


cfg=[];
cfg.interpolation      = 'linear';
cfg.zlim=[0 5e-11];
figure;
topoplot248(f(:,50),cfg);
colorbar
cfg.zlim=[0 5e-12];
title('RAW 50Hz')
figure;
%topoplot248(f1(:,50),cfg,1)
topoplot248(f2(:,50),cfg,1)
colorbar
title('ADAPTIVE, N = 250')
figure;
%topoplot248(f1(:,50),cfg,1)
topoplot248(f1(:,50),cfg,1)
colorbar
title('ADAPTIVE, N = 4000')
figure;
cfg=[];
cfg.interpolation      = 'linear';
topoplot248(f(:,31),cfg);
title('RAW, 31Hz')



f3=abs(fftBasic(cln3(:,t1*sRate:t2*sRate),data.fsample));
f4=abs(fftBasic(cln4(:,t1*sRate:t2*sRate),data.fsample));

figure;
plot(1:160,bl,'k--','linewidth',2)
set(gca,'fontname','times','fontsize',15)
hold on
plot(mean(f),'b','linewidth',2)
plot(mean(f3),'r','linewidth',2)
plot(mean(f4),'g','linewidth',2)
box off
xlim([1 160]);
ylim([0 2.2e-11])

cfg=[];
cfg.interpolation      = 'linear';
cfg.zlim=[0 5e-12];
figure;
topoplot248(f3(:,50),cfg,1);
colorbar
cfg.zlim=[0 5e-12];
title('ADAPTIVE1, N = 4000')
figure;
%topoplot248(f1(:,50),cfg,1)
topoplot248(f4(:,50),cfg,1)
colorbar
title('ADAPTIVE1, N = 250')

f100=abs(fftBasic(cln100(:,t1*sRate:t2*sRate),data.fsample));
f500=abs(fftBasic(cln500(:,t1*sRate:t2*sRate),data.fsample));
f1000=abs(fftBasic(cln1000(:,t1*sRate:t2*sRate),data.fsample));
cfg=[];
cfg.interpolation      = 'linear';
cfg.zlim=[0 5e-12];
figure;
topoplot248(f100(:,50),cfg,1);
title('N = 100')
figure;
topoplot248(f500(:,50),cfg,1);
title('N = 500')
figure;
topoplot248(f1000(:,50),cfg,1);
title('N = 1000')
