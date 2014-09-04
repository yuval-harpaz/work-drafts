function LFepi4



reps=[100 200 300 400 500 1000 1500 2000 3000 4000];
try
    matlabpool;
end

% if ~exist('permN','var')
%     permN=500;
% end
% if isempty(permN)
%     permN=500;
% end

cd /home/yuval/Data/epilepsy/b162b/1
fn='hb_c,rfhp1.0Hz';
hdr=ft_read_header(fn);
t1=139;
t2=145;
% selected={'A132','A133','A134','A160','A161','A162'};
sRate=hdr.Fs;
cfg=[];
cfg.demean='yes';
cfg.dataset=fn;
cfg.channel='MEG';
data=ft_preprocessing(cfg);
time=data.time{1,1};
cfg.channel='TRIGGER';
trig=ft_preprocessing(cfg);
trig=trig.trial{1,1};
data=data.trial{1,1};
%fraw=abs(fftBasic(data.trial{1,1},data.fsample));

s1=round(sRate*t1);
s2=round(sRate*t2);

%%


cd /home/yuval/Dropbox/MEG/LF/data
f=abs(fftBasic(data(:,s1:s2),sRate));
field31=f(:,31);
field50=f(:,50);
% fS=abs(fftBasic(S(s1:s2),sRate));
% fS50=fS(31);
% 
% fSW=abs(fftBasic(SW(:,s1:s2),sRate));
% fSW50=fSW(:,31);
%plot(fS,'c');hold on;plot(fSW,'k')%;plot(F3,'b')
cfg=[];
cfg.Lfreq=50;
cfg.jobs=4;
cfg.method='adaptive1';
cfgp=[];
cfgp.interpolate='linear';
cfgp.zlim=[0 6e-12];
for repi=1:length(reps)
    disp(num2str(repi))
    cfg.Ncycle=reps(repi);
    cl=correctLF(data,sRate,trig,cfg);
    close;
    fcl=abs(fftBasic(cl(:,s1:s2),sRate));
    figure;topoplot248(fcl(:,50),cfgp);
    title(num2str(reps(repi)))
    fieldCl(repi,1:248)=fcl(:,50); 
    
end
save fields field* reps 
% ratioSW=(fSW50-fS50)/fS50; % the ratio between dirty and original signals
% snr={'0.25','0.5','1','2','4','8','16','32'};
% 
% 
% 









% 
% cd /home/yuval/Data/epilepsy/b162b/1
% fn='c,rfhp1.0Hz';
% hdr=ft_read_header(fn);
% t1=139;
% t2=145;
% tdif=t2-t1+1;
% sRate=round(hdr.Fs);
% cfg=[];
% cfg.trl=[t1*sRate t2*sRate 0];
% cfg.demean='yes';
% cfg.dataset=['hb_',fn];
% cfg.channel='MEG';
% data=ft_preprocessing(cfg);
% fraw=abs(fftBasic(data.trial{1,1},data.fsample));
% %plot(mean(f))
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% cfg.dataset='cln500A1_c,rfhp1.0Hz';
% data=ft_preprocessing(cfg);
% f500A1=abs(fftBasic(data.trial{1,1},data.fsample));
% cfg.dataset='cln500_c,rfhp1.0Hz';
% data=ft_preprocessing(cfg);
% f500=abs(fftBasic(data.trial{1,1},data.fsample));
% 
% cfg=[];
% cfg.interpolation      = 'linear';
% cfg.zlim=[0 3];
% cfg.comment='no';
% figure;
% topoplot248(10^11*fraw(:,31),cfg);
% set(gca,'Fontsize',20,'FontName','times')
% set(gcf,'color','w')
% title('31Hz, Raw')
% 
% figure;
% topoplot248(10^11*fraw(:,50),cfg);
% set(gca,'Fontsize',20,'FontName','times')
% set(gcf,'color','w')
% title('50Hz, Raw')
% 
% cfg.zlim=[0 1];
% figure;
% topoplot248(10^11*f500(:,50),cfg);
% set(gca,'Fontsize',20,'FontName','times')
% set(gcf,'color','w')
% title('50Hz, ADAPTIVE')
% 
% figure;
% topoplot248(10^11*f500A1(:,50),cfg);
% set(gca,'Fontsize',20,'FontName','times')
% set(gcf,'color','w')
% title('50Hz, ADAPTIVE1')
% 
% figure;
% topoplot248(10^11*f500A1(:,50),cfg);
% set(gca,'Fontsize',20,'FontName','times')
% set(gcf,'color','w')
% colorbar
% title('COPY COLORBAR ONLY')
% 
% cor=corr(10^11*f500(:,50),10^11*fraw(:,31))
% cor1=corr(10^11*f500A1(:,50),10^11*fraw(:,31))
% 
% 
% chi=find(ismember(data.label,{'A132','A133','A134','A160','A161','A162'}));
% 
% figure;plot(mean(10^11*f500(chi,50)));
% cfg=[];
% cfg.trl=[t1*sRate t2*sRate 0];
% cfg.demean='yes';
% cfg.dataset=['hb_',fn];
% cfg.channel='MEG';
% cfg.dftfilter='yes';
% cfg.dftfreq=50;
% data=ft_preprocessing(cfg);
% fdft=abs(fftBasic(data.trial{1,1},data.fsample));
% 
% 
% fig2=figure('position',[300,300,600,800]);
% subplot(2,1,1)
% set(gca,'fontname','times','fontsize',20)
% plot(mean(fdft(chi,:)),'r','linewidth',2);
% box off
% hold on
% plot(mean(f500(chi,:)),'g','linewidth',2);
% plot(mean(fraw(chi,:)),'b','linewidth',2);
% xlim([10 80])
% ylabel('PSD (T^2/Hz)')
% xlabel('Hz')
% title('Selected channels')
% lg1=legend('DFT','Adaptive','Raw');
% set(lg1,'box','off')
% 
% subplot(2,1,2)
% set(gca,'fontname','times','fontsize',20)
% plot(mean(fdft(:,:)),'r','linewidth',2);
% box off
% hold on
% plot(mean(f500(:,:)),'g','linewidth',2);
% plot(mean(fraw(:,:)),'b','linewidth',2);
% xlim([10 80])
% xlabel('Hz')
% ylabel('PSD (T^2/Hz)')
% title('All channels')
% %cd /home/yuval/Desktop/poster
% %exportfig(fig2,'figEpi2.png','color','rgb','Format','png','Resolution',300)
