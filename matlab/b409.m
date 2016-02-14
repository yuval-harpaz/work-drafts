cd /home/yuval/Data/epilepsy/b409/session2/2

cfg=[];
cfg.dataset='hb,lf_c,rfhp1.0Hz';
cfg.demean='yes';
cfg.bpfilter='yes';
cfg.bpfreq=[5 70];
cfg.trl=[270000,283563,270000];
cfg.channel='MEG';
data=ft_preprocessing(cfg);

cfg=[];
cfg.method='pca';
comp=ft_componentanalysis(cfg,data);

cfg=[];
cfg.layout='4D248.lay';
cfg.channel=comp.label(1:5);
cfg.blocksize=5;
ft_databrowser(cfg,comp)

ma=mean(abs(data.trial{1}));
[peaks,Ipeaks]=findPeaks(ma,2,10);
figure;plot(ma);hold on;plot(Ipeaks,peaks,'or')

count=0;
for trli=1:length(peaks)
    pI=Ipeaks(trli);
    first=false;
    if trli==1
        first=true;
    elseif pI-Ipeaks(trli-1)>100
        first=true;
    end
    if first
        count=count+1;
        i1(count)=pI;
    end
end
figure;plot(ma);hold on;plot(i1,ma(i1),'or')
i1(5:6)=[];
i1(end-2:end)=[];

avg=zeros(248,3000);
for trli=1:length(i1)
    avg=avg+data.trial{1}(:,i1(trli)-2500:i1(trli)+499);
end


avg=correctBL(avg,[1 1000]);
avg=avg(:,2200:2800);
figure;plot(avg')

figure;topoplot248(avg(:,300))
c=caxis;caxis([-max(abs(c)) max(abs(c))])
figure;topoplot248(avg(:,293))
caxis([-max(abs(c)) max(abs(c))])
figure;topoplot248(avg(:,343))
caxis([-max(abs(c)) max(abs(c))])
load LRpairs
Rl={'A83', 'A84', 'A112', 'A113', 'A114', 'A115', 'A116', 'A144', 'A145', 'A146', 'A147', 'A148', 'A149', 'A171', 'A172', 'A173', 'A174', 'A175', 'A176', 'A193', 'A194', 'A195', 'A209', 'A210', 'A211', 'A227', 'A228', 'A244', 'A245', 'A246', 'A247', 'A248'};
[~,pi]=ismember(Rl,LRpairs(:,2));
Ll=LRpairs(pi);
[~,Ri]=ismember(Rl,data.label);
[~,Li]=ismember(Ll,data.label);
figure;
plot(-mean(avg(Li,:)),'b')
hold on
plot(mean(avg(Ri,:)),'r')
plot(mean(abs(avg)),'k')

rimda(avg(:,300));


%% Rimda 4D
cd /home/yuval/Data/epilepsy/b409/session2/2
load avg
load pnt
load gain
rimda(avg(:,300));
rimda(avg(:,250:350));

