cd /home/yuval/Data/epilepsy/b391
!./doEpi

%% select sources manuall
PRI=...
    [0   -5   2;... % R temporal inferior
     0   -5.5 4;... % R temporal main
     2.5 -5.5 2.5;...%R temporal anterior
     -3  -4   9;... % R Parietal 
     -2  -5   8;... % R Parietal small
     5   -1  12;... % R Parietal medial
     7.5 -3.5 5;... % R Frontal rightmost
     8.5 -1 5.5;... % R Frontal medial
     6   4  7.5;... % L Frontal
     5   4  3 ];    % Left Temporal
%ind=voxIndex(PRI,[-120 120 -90 90 -20 150]./10,0.5);

 %% get timecourses
ind=[31369;31338;37810;23683;26201;44619;50905;53671;47550;44951;];
cfg=[];
cfg.bpfilter='yes';
cfg.bpfreq=[20 70];
cfg.demean='yes';
cfg.channel='MEG';
VS=[];
count=1;
for runi=1:3
    for segi=0:1
        run=num2str(runi);
        seg=num2str(segi);
        [~,~,wts]=readWeights([run,'/SAM/Spikes1,20-70Hz,Global',seg,'.wts']);
        wts=wts(ind,:);
        cfg.dataset=[run,'/xc,hb,lf,',seg,'_c,rfhp0.1Hz,ee'];
        data=ft_preprocessing(cfg);
        VS=[VS,wts*data.trial{1}];
        ends(count)=length(VS);
        disp(['DONE ',num2str(count)])
        count=count+1;
    end
end
save VS VS ends      


%% xcorr
cd /home/yuval/Data/epilepsy/b391
load VS

imagesc(corr(VS'))
for ii=1:10
    j=10;
    while j>=ii
        [r,lags]=xcorr(VS(ii,:),VS(j,:),2035);
        plot(lags,r)
        title(num2str([ii,j]))
        pause
        j=j-1;
    end
end
%% g2
fac=4;
[~,~,~,g2TC]=g2loop(VS,2034.5/fac);
imagesc(corr(g2TC'))

for ii=2:10
    j=10;
    while j>=ii
        for segi=1:length(ends)
            t1=floor(ends(segi)/2034.5*fac);
            if segi==1
                t0=1;
                [r,lags]=xcorr(g2TC(ii,t0:t1),g2TC(j,t0:t1),100*fac);
            else
                t0=ends(segi-1)+1;
                t0=ceil(t0./2045.5*fac);
                r(segi,:)=xcorr(g2TC(ii,t0:t1),g2TC(j,t0:t1),100*fac);
            end
        end
        r=mean(r);
        plot(lags,r)
        title(num2str([ii,j]))
        pause
        j=j-1;
    end
end



%% check partial correlations or something with 
% b391clustering.py

%%
plot(VS(:,1:203450)')
VS=VS-repmat(mean(VS,2),1,length(VS));
for vsi=1:10
    vs=VS(vsi,:);
    vs=vs-median(vs);
    [peak,peaki]=findPeaks(vs,3.5,round(2034.5/4));
    [peakneg,peaknegi]=findPeaks(vs,3.5,round(2034.5/4));
    if length(peakneg)>length(peak)
        peak=peakneg;
        peaki=peaknegi;
    end
    avg=zeros(10,4070*2+1);
    count=0;
    for pi=1:length(peaki)
        s0=peaki(pi);
        if s0-4070>0 && s0+4070<=length(VS)
            avg=avg+VS(:,s0-4070:s0+4070);
            count=count+1;
        end
    end
    avg=avg./count;
    figure;
    plot([-4070:4070],avg)
    title(num2str(vsi));
end
plot(VS(vsi,:))
hold on
plot(vs,'k')
plot(peaki,peak,'or')



