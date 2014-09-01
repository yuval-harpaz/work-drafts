

cd /home/yuval/Data/epilepsy/b162b/1
fn='c,rfhp1.0Hz';
hdr=ft_read_header(fn);
t1=139;
t2=145;
tdif=t2-t1+1;
sRate=round(hdr.Fs);
cfg=[];
cfg.trl=[t1*sRate t2*sRate 0];
cfg.demean='yes';
cfg.dataset=['hb_',fn];
cfg.channel='MEG';
data=ft_preprocessing(cfg);
fraw=abs(fftBasic(data.trial{1,1},data.fsample));
%plot(mean(f))

cfg.dataset='cln500A1_c,rfhp1.0Hz';
data=ft_preprocessing(cfg);
f500A1=abs(fftBasic(data.trial{1,1},data.fsample));
cfg.dataset='cln500_c,rfhp1.0Hz';
data=ft_preprocessing(cfg);
f500=abs(fftBasic(data.trial{1,1},data.fsample));

cfg=[];
cfg.interpolation      = 'linear';
cfg.zlim=[0 3];
cfg.comment='no';
figure;
topoplot248(10^11*fraw(:,31),cfg);
set(gca,'Fontsize',20,'FontName','times')
set(gcf,'color','w')
title('31Hz, Raw')

figure;
topoplot248(10^11*fraw(:,50),cfg);
set(gca,'Fontsize',20,'FontName','times')
set(gcf,'color','w')
title('50Hz, Raw')

cfg.zlim=[0 1];
figure;
topoplot248(10^11*f500(:,50),cfg);
set(gca,'Fontsize',20,'FontName','times')
set(gcf,'color','w')
title('50Hz, ADAPTIVE')

figure;
topoplot248(10^11*f500A1(:,50),cfg);
set(gca,'Fontsize',20,'FontName','times')
set(gcf,'color','w')
title('50Hz, ADAPTIVE1')

figure;
topoplot248(10^11*f500A1(:,50),cfg);
set(gca,'Fontsize',20,'FontName','times')
set(gcf,'color','w')
colorbar
title('COPY COLORBAR ONLY')

cor=corr(10^11*f500(:,50),10^11*fraw(:,31))
cor1=corr(10^11*f500A1(:,50),10^11*fraw(:,31))


chi=find(ismember(data.label,{'A132','A133','A134','A160','A161','A162'}));

figure;plot(mean(10^11*f500(chi,50)));
cfg=[];
cfg.trl=[t1*sRate t2*sRate 0];
cfg.demean='yes';
cfg.dataset=['hb_',fn];
cfg.channel='MEG';
cfg.dftfilter='yes';
cfg.dftfreq=50;
data=ft_preprocessing(cfg);
fdft=abs(fftBasic(data.trial{1,1},data.fsample));


fig2=figure('position',[300,300,600,800]);
subplot(2,1,1)
set(gca,'fontname','times','fontsize',20)
plot(mean(fdft(chi,:)),'r','linewidth',2);
box off
hold on
plot(mean(f500(chi,:)),'g','linewidth',2);
plot(mean(fraw(chi,:)),'b','linewidth',2);
xlim([10 80])
ylabel('PSD (T^2/Hz)')
xlabel('Hz')
title('Selected channels')
lg1=legend('DFT','Adaptive','Raw');
set(lg1,'box','off')

subplot(2,1,2)
set(gca,'fontname','times','fontsize',20)
plot(mean(fdft(:,:)),'r','linewidth',2);
box off
hold on
plot(mean(f500(:,:)),'g','linewidth',2);
plot(mean(fraw(:,:)),'b','linewidth',2);
xlim([10 80])
xlabel('Hz')
ylabel('PSD (T^2/Hz)')
title('All channels')
cd /home/yuval/Desktop/poster
exportfig(fig2,'figEpi2.png','color','rgb','Format','png','Resolution',300)
% 
% 
% 
% 
% 
% 
% cfg=[];
% cfg.method='adaptive1';
% cfg.Ncycles=4000;
% cfg.jobs=4;
% cln3=correctLF(fn,678.17,trig,cfg);
% cfg=[];
% cfg.method='adaptive1';
% cfg.Ncycles=250;
% cfg.jobs=4;
% cln4=correctLF(fn,678.17,trig,cfg);
% 
% cfg=[];
% cfg.method='adaptive1';
% cfg.Ncycles=100;
% cfg.jobs=4;
% cln100=correctLF(fn,678.17,trig,cfg);
% cfg=[];
% cfg.method='adaptive1';
% cfg.Ncycles=500;
% cfg.jobs=4;
% cln500=correctLF(fn,678.17,trig,cfg);
% cfg=[];
% cfg.method='adaptive1';
% cfg.Ncycles=1000;
% cfg.jobs=4;
% cln1000=correctLF(fn,678.17,trig,cfg);
% 
% 
% cfg=[];
% cfg.method='adaptive';
% cfg.Ncycles=500;
% cfg.jobs=4;
% cln3=correctLF(fn,678.17,trig,cfg);
% cfg=[];
% cfg.method='adaptive';
% cfg.Ncycles=1000;
% cfg.jobs=4;
% cln4=correctLF(fn,678.17,trig,cfg);
% 
% 
% 
% f1=abs(fftBasic(cln1(:,t1*sRate:t2*sRate),data.fsample));
% f2=abs(fftBasic(cln2(:,t1*sRate:t2*sRate),data.fsample));
% bl(1:160)=mean(mean(f(:,151:180)));
% figure;
% plot(1:160,bl,'k--','linewidth',2)
% set(gca,'fontname','times','fontsize',15)
% hold on
% plot(mean(f),'b','linewidth',2)
% plot(mean(f1),'r','linewidth',2)
% plot(mean(f2),'g','linewidth',2)
% box off
% xlim([1 160]);
% ylim([0 2.2e-11])
% % 
% % figure;
% % plot(f(114,:),'b')
% % hold on
% % plot(f1(132,:),'r') % sorted channels, A132
% % plot(f2(132,:),'g')
% 
% 
% cfg=[];
% cfg.interpolation      = 'linear';
% cfg.zlim=[0 5e-11];
% figure;
% topoplot248(f(:,50),cfg);
% colorbar
% cfg.zlim=[0 5e-12];
% title('RAW 50Hz')
% figure;
% %topoplot248(f1(:,50),cfg,1)
% topoplot248(f2(:,50),cfg,1)
% colorbar
% title('ADAPTIVE, N = 250')
% figure;
% %topoplot248(f1(:,50),cfg,1)
% topoplot248(f1(:,50),cfg,1)
% colorbar
% title('ADAPTIVE, N = 4000')
% figure;
% cfg=[];
% cfg.interpolation      = 'linear';
% topoplot248(f(:,31),cfg);
% title('RAW, 31Hz')
% 
% 
% 
% f3=abs(fftBasic(cln3(:,t1*sRate:t2*sRate),data.fsample));
% f4=abs(fftBasic(cln4(:,t1*sRate:t2*sRate),data.fsample));
% 
% figure;
% plot(1:160,bl,'k--','linewidth',2)
% set(gca,'fontname','times','fontsize',15)
% hold on
% plot(mean(f),'b','linewidth',2)
% plot(mean(f3),'r','linewidth',2)
% plot(mean(f4),'g','linewidth',2)
% box off
% xlim([1 160]);
% ylim([0 2.2e-11])
% 
% cfg=[];
% cfg.interpolation      = 'linear';
% cfg.zlim=[0 5e-12];
% figure;
% topoplot248(f3(:,50),cfg,1);
% colorbar
% cfg.zlim=[0 5e-12];
% title('ADAPTIVE1, N = 4000')
% figure;
% %topoplot248(f1(:,50),cfg,1)
% topoplot248(f4(:,50),cfg,1)
% colorbar
% title('ADAPTIVE1, N = 250')
% 
% f100=abs(fftBasic(cln100(:,t1*sRate:t2*sRate),data.fsample));
% f500=abs(fftBasic(cln500(:,t1*sRate:t2*sRate),data.fsample));
% f1000=abs(fftBasic(cln1000(:,t1*sRate:t2*sRate),data.fsample));
% cfg=[];
% cfg.interpolation      = 'linear';
% cfg.zlim=[0 5e-12];
% figure;
% topoplot248(f100(:,50),cfg,1);
% title('N = 100')
% figure;
% topoplot248(f500(:,50),cfg,1);
% title('N = 500')
% figure;
% topoplot248(f1000(:,50),cfg,1);
% title('N = 1000')
