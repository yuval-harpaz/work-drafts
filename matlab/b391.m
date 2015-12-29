cd /home/yuval/Data/epilepsy/b391
!./doEpi

%% select sources manuall
PRI=...
    [0   -5   2;... % R temporal inferior
     0   -5.5 4;... % R temporal main
     2.5 -5.5 2.5;...%R temporal anterior
     -3  -4   9;... % R Parietal 
     -2  -5   8;... % R Parietal small
     7.5 -3.5 5;... % R Frontal rightmost
     8.5 -1 5.5;... % R Frontal medial
     6   4  7.5;... % L Frontal
     5   4  3 ];    % Left Temporal
%ind=voxIndex(PRI,[-120 120 -90 90 -20 150]./10,0.5);
labels={'R temporal inferior'; 'R temporal main';'R temporal anterior';...
    'R Parietal';'R Parietal small';'R Frontal rightmost';'R Frontal medial';...
    'L Frontal';'Left Temporal'};

 %% get timecourses
ind=[31369;31338;37810;23683;26201;50905;53671;47550;44951;];
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
for ii=1:size(VS,1)
    j=size(VS,1);
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

%% find peaks and average
% plot(VS(:,1:203450)')
% 
% VS=VS-repmat(mean(VS,2),1,length(VS));
% corr(VS')
% VS(2,:)=-VS(2,:);
% VS(3,:)=-VS(3,:);
% VS(9,:)=-VS(9,:);

for vsi=1:size(VS,1)
    vs=VS(vsi,:);
    vs=vs-median(vs);
    [peak,peaki]=findPeaks(vs,3.5,round(2034.5/4));
    [peakneg,peaknegi]=findPeaks(-vs,3.5,round(2034.5/4));
    if length(peakneg)>length(peak)
        peak=peakneg;
        peaki=peaknegi;
        vsi
    end
    avg=zeros(size(VS,1),4070*2+1);
    count=0;
    for pi=1:length(peaki)
        s0=peaki(pi);
        if s0-4070>0 && s0+4070<=length(VS)
            avg=avg+VS(:,s0-4070:s0+4070);
            count=count+1;
        end
    end
    avg=avg./count;
    BL=mean(avg(:,1:2035),2);
    avg=avg-repmat(BL,1,length(avg));
    thr=1.5*max(max(abs(avg(:,1:2035)),[],2));
    for vsii=1:size(VS,1)
        [~,goodi]=find(abs(avg(vsii,1:4071))>thr,1);
        if isempty(goodi)
            samp(vsii)=0;
        else
            samp(vsii)=goodi;
        end
    end
    good=find(samp);
    samp=samp(good);
    [~,vsOrder]=sort(samp);
    vsOrder=good(vsOrder);
    figure;
    plot([-4070:4070],avg(vsOrder,:))
    hold on
    plot([-4070:4070],avg,'k')
    plot([-4070:4070],avg(vsOrder,:))
    legend(num2str(vsOrder'))
    title([num2str(vsi),'   ',num2str(vsOrder)]);
end


plot(VS(vsi,:))
hold on
plot(vs,'k')
plot(peaki,peak,'or')


%% burst starters

for vsi=1:size(VS,1)
    vs=VS(vsi,:);
    vs=vs-median(vs);
    [peak,peaki]=findPeaks(vs,3.5,round(2034.5/4));
    [peakneg,peaknegi]=findPeaks(-vs,3.5,round(2034.5/4));
    if length(peakneg)>length(peak)
        peak=peakneg;
        peaki=peaknegi;

    end
    disp([num2str(vsi),' ',num2str(length(peaki))])
    peaks{vsi,1}=peaki;
end
save peaks peaks

starters=zeros(9,1);
for vsi=1:9
    pik=peaks{vsi};
    total(vsi)=length(pik);
    for peaki=1:length(pik)
        noPrev=true;
        if pik(peaki)>1018
            for vsj=1:9
                prev=find((pik(peaki)-peaks{vsj})>0);
                if ~isempty(prev)
                    if peaks{vsj}(prev(end))<1018
                        noPrev=false;
                    end
                end
            end
        end
        starters(vsi)=starters(vsi)+noPrev;
    end
end

%% psth
cd /home/yuval/Data/epilepsy/b391
load peaks
load labels
times={};
for vsi=[2,4,5,6,7,8,9]
    pik=peaks{vsi};
    for vsj=[2,4,5,6,7,8,9] 
        times{vsi,1}{vsj}=[];
        count=0;
        for peaki=1:length(pik)
            if pik(peaki)>1018
                peri=find(abs(pik(peaki)-peaks{vsj})<2034);
                if ~isempty(peri)
                    times{vsi,1}{vsj}=[times{vsi,1}{vsj},peaks{vsj}(peri)-pik(peaki)];
                    count=count+1;
                end
            end
        end
    end   
end
%% bars
t1=2034.5*1.025;
edges=[-t1:2034.5/20:t1];
time=round((diff(edges)./2+edges(1:end-1))/2034.5*1000);
vsc=[2,4,5,6,7,8,9];
for vsi=2%[2,4,5,6,7,8,9]
    for vsj=vsc
        
        %          hist(times{vsi}{vsj},101);
        %          title(['timelock on ',num2str(vsi),', spikes on ',num2str(vsj)])
        binedData=histc(times{vsi}{vsj},edges);
        binedData(end-1)=binedData(end-1)+binedData(end);
        binedData(end)=[];
        figure;
        bar(time,binedData); xlim([-1000 1000])
        title(['timelock on ',num2str(vsi),', spikes on ',num2str(vsj)])
        pause
         
    end
end
%% color matrix
t1=2034.5*1.025;
edges=[-t1:2034.5/20:t1];
time=round((diff(edges)./2+edges(1:end-1))/2034.5*1000);
vsc=[2,4,5,6,7,8,9];
for vsi=2%1:7
    for vsj=1:7
        binedData=histc(times{vsc(vsi)}{vsc(vsj)},edges);
        binedData(end-1)=binedData(end-1)+binedData(end);
        binedData(end)=[];
        timeMat(vsj,1:21)=binedData(1:21);
%         bar(time,binedData); xlim([-1000 1000])
%         title(['timelock on ',num2str(vsi),', spikes on ',num2str(vsj)])
    end
    timeMatSc=timeMat./max(timeMat(:));
    fig=figure;
    imagesc(timeMatSc);
    imagesc(timeMatSc,[0 max(max(timeMatSc(:,1:end-1)))]);
    ax = gca;
    set(ax,'Xtick',1:21,'XTickLabel',time(1:21));
    set(ax,'Ytick',1:7,'YTickLabel',vsc);
    title(['timelock on ',num2str(vsc(vsi))])
    set(fig,'Position',[484   674   756   259])
end

for vsi=1:7
    for vsj=1:7
        sym=sum(histc(times{vsc(vsi)}{vsc(vsj)},[-51 51]));
        pre03=sum(histc(times{vsc(vsi)}{vsc(vsj)},round([-0.3 -0.025]*2034.5)));
        pre05=sum(histc(times{vsc(vsi)}{vsc(vsj)},round([-0.5 -0.025]*2034.5)));
        binedData(end-1)=binedData(end-1)+binedData(end);
        binedData(end)=[];
        timeMat(vsj,1:21)=binedData(1:21);
%         bar(time,binedData); xlim([-1000 1000])
%         title(['timelock on ',num2str(vsi),', spikes on ',num2str(vsj)])
    end
    timeMatSc=timeMat./max(timeMat(:));
    fig=figure;
    imagesc(timeMatSc,[0 max(max(timeMatSc(:,1:end-1)))]);
    ax = gca;
    set(ax,'Xtick',1:21,'XTickLabel',time(1:21));
    set(ax,'Ytick',1:7,'YTickLabel',vsc);
    title(['timelock on ',num2str(vsc(vsi))])
    set(fig,'Position',[484   674   756   259])
end

%% mask g2
for ii=1:3
    ist=num2str(ii);
    for jj=0:1
        jst=num2str(jj)
        fn=['Spikes1_',ist,'_',jst,'+orig'];
        [~,w]=afnix(['3dcalc -prefix ',fn(1:end-5),'M -a ',fn,' -b maskRS1+orig -exp "a*b"']);
    end
end

%% 
cd /home/yuval/Data/epilepsy/b391/3
[Grid]=fs2grid;
grid2t(Grid);
!mv pnt.txt SAM/
cd ../
!./doEpiFS



runi=3;
segi=0;
run=num2str(runi);
seg=num2str(segi);
[~,~,wts]=readWeights([run,'/SAM/pnt.txt.wts']);
cfg=[];
cfg.bpfilter='yes';
cfg.bpfreq=[20 70];
cfg.demean='yes';
cfg.channel='MEG';
cfg.dataset=[run,'/xc,hb,lf,',seg,'_c,rfhp0.1Hz,ee'];
data=ft_preprocessing(cfg);
VS=[];
VSmax=[];
for vsi=1:length(wts)
    vs=wts(vsi,:)*data.trial{1};
    [VS(vsi),VSmax(vsi)]=g2loop(vs,2034.5/4); % rep = 1824
    prog(vsi)
end
VS=VS./1824;
VSmax=VSmax./1824;
save g2FS_3_0 VS VSmax

figure;
% plot3pnt(hs.pnt*100,'.k')
% hold on
scatter3pnt(Grid.pos,15,VSmax)
figure;
plot3pnt(hs.pnt,'.k')
hold on
scatter3pnt(Grid.pos,15,VS)  

%% brain connectivity toolbox
cd /home/yuval/Data/epilepsy/b391
load peaks
load labels
times={};
for vsi=[2,4,5,6,7,8,9]
    pik=peaks{vsi};
    for vsj=[2,4,5,6,7,8,9] 
        times{vsi,1}{vsj}=[];
        count=0;
        for peaki=1:length(pik)
            if pik(peaki)>1018
                peri=find(abs(pik(peaki)-peaks{vsj})<2034);
                if ~isempty(peri)
                    times{vsi,1}{vsj}=[times{vsi,1}{vsj},peaks{vsj}(peri)-pik(peaki)];
                    count=count+1;
                end
            end
        end
    end   
end
t1=2034.5*1.025;
edges=[-t1:2034.5/20:t1];
time=round((diff(edges)./2+edges(1:end-1))/2034.5*1000);

graph=zeros(7);
grpi=0;
grpj=0;
for vsi=[2,4,5,6,7,8,9]
    grpi=grpi+1;
    for vsj=[2,4,5,6,7,8,9]
        grpj=grpj+1;
        if grpj==8
            grpj=1;
        end
        if vsi~=vsj
            
            %sym=sum(histc(times{vsc(vsi)}{vsc(vsj)},[-51 51]));
            %pre03=sum(histc(times{vsc(vsi)}{vsc(vsj)},round([-0.3 -0.025]*2034.5)));
            %pre05=sum(histc(times{vsc(vsi)}{vsc(vsj)},round([-0.5 -0.025]*2034.5)));
            binedData=histc(times{vsi}{vsj},edges);
            binedData(end-1)=binedData(end-1)+binedData(end);
            binedData(end)=[];
%             figure;
%             bar(time,binedData); xlim([-1000 1000])
%             title(['timelock on ',num2str(vsi),', spikes on ',num2str(vsj)])
            graph(grpi,grpj)=sum(binedData(16:20))./sum(binedData(1:5));
        end
    end
end


graph=zeros(7);
grpi=0;
grpj=0;
for vsi=[2,4,5,6,7,8,9]
    grpi=grpi+1;
    for vsj=[2,4,5,6,7,8,9]
        grpj=grpj+1;
        if grpj==8
            grpj=1;
        end
        if vsi~=vsj
            
            %sym=sum(histc(times{vsc(vsi)}{vsc(vsj)},[-51 51]));
            %pre03=sum(histc(times{vsc(vsi)}{vsc(vsj)},round([-0.3 -0.025]*2034.5)));
            %pre05=sum(histc(times{vsc(vsi)}{vsc(vsj)},round([-0.5 -0.025]*2034.5)));
            binedData=histc(times{vsi}{vsj},edges);
            binedData(end-1)=binedData(end-1)+binedData(end);
            binedData(end)=[];
%             figure;
%             bar(time,binedData); xlim([-1000 1000])
%             title(['timelock on ',num2str(vsi),', spikes on ',num2str(vsj)])
            graph(grpi,grpj)=sum(binedData(1:5));
        end
    end
end
[idBL,odBL,degBL] = strengths_dir(graph)

load('graphSum.mat')
[id,od,deg] = strengths_dir(graph)
id./ibBL
id./idBL
od./odBL