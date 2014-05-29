kurFigSensitivity
kurFigBreakdown


cd /home/yuval/Data/kurtosis/b024
cfg1=[];
cfg1.dataset='hb_c,rfhp1.0Hz,ee';
cfg1.trl=[1 67817 0];
cfg1.channel='MEG';
cfg1.bpfilter='yes';
cfg1.bpfreq=[20 70];
data=ft_preprocessing(cfg1);
cd SAM
[SAMHeader, ActIndex, ActWgts]=readWeights('Spikes,16-80Hz,Global.wts');

xyz=[0.5 3.5 10];
[indL,~]=voxIndex(xyz,100.*[...
    SAMHeader.XStart SAMHeader.XEnd ...
    SAMHeader.YStart SAMHeader.YEnd ...
    SAMHeader.ZStart SAMHeader.ZEnd],...
    100.*SAMHeader.StepSize,1);

xyz=[-2.5 -3 9];%[1.5 -2 10];
[indR,~]=voxIndex(xyz,100.*[...
    SAMHeader.XStart SAMHeader.XEnd ...
    SAMHeader.YStart SAMHeader.YEnd ...
    SAMHeader.ZStart SAMHeader.ZEnd],...
    100.*SAMHeader.StepSize,1);

vsR=ActWgts(uint16(indR),:)*data.trial{1,1};
vsL=ActWgts(uint16(indL),:)*data.trial{1,1};
timeline=data.time{1,1};
timeBeg=0:0.25:99.5;
timeEnd=timeBeg+0.5;
for wini=1:length(timeBeg)
    time(wini)=(timeBeg(wini)+timeEnd(wini))/2;
    sBeg=nearest(timeline,timeBeg(wini));
    sEnd=nearest(timeline,timeEnd(wini));
    g2far(wini)=G2(vsL(sBeg:sEnd));
    g2lesion(wini)=G2(vsR(sBeg:sEnd));
end

sum(g2far(g2far>0))
sum(g2lesion(g2lesion>0))
max(g2far)
max(g2lesion)

timeBeg=0:5:90;
timeEnd=timeBeg+10;
for wini=1:length(timeBeg)
    time10(wini)=(timeBeg(wini)+timeEnd(wini))/2;
    sBeg=nearest(timeline,timeBeg(wini));
    sEnd=nearest(timeline,timeEnd(wini));
    g2far10(wini)=G2(vsL(sBeg:sEnd));
    g2lesion10(wini)=G2(vsR(sBeg:sEnd));
end

sum(g2far10(g2far10>0))
sum(g2lesion10(g2lesion10>0))
max(g2far10)
max(g2lesion10)

figure;
plot(time,g2far,'r');
hold on;
plot(time,g2lesion,'k');
plot(time10,g2far10,'m');
plot(time10,g2lesion10,'b');

legend(...
    'distant, 0.5s, max(g2))=34, sum(g2)=264',...
    'lesion,  0.5s, max(g2))=10, sum(g2)=351',...
    'distant,  10s, max(g2))=55, sum(g2)= 161',...
    'lesion,   10s, max(g2))= 8, sum(g2)= 61')
figure;plot(timeline,vsL,'r')
hold on
plot(timeline,vsR,'k')

timeBeg=0:0.125:9.875;
timeEnd=timeBeg+0.25;
for wini=1:length(timeBeg)
    time025(wini)=(timeBeg(wini)+timeEnd(wini))/2;
    sBeg=nearest(timeline,timeBeg(wini));
    sEnd=nearest(timeline,timeEnd(wini));
    g2far025(wini)=G2(vsL(sBeg:sEnd));
    g2lesion025(wini)=G2(vsR(sBeg:sEnd));
end
neg=find(g2lesion025<0);

figure;
plot(timeline(1:6782),vsR(1:6782)*10^8-5,'k')
hold on
plot(time025,g2lesion025,'b.')
plot(time025(neg),g2lesion025(neg),'c.')
h=fill([2,2.25,2.25,2],[-5 -5 -4 -4],[0.5 0.5 0.5])
set(h,'EdgeColor','None');
plot([2,2.125],[-4,5.177],'color',[0.5 0.5 0.5])
plot([2.25,2.125],[-4,5.177],'color',[0.5 0.5 0.5])
xlabel('time (s)')
ylabel('g2')
legend('virtual sensor','positive g2','negative g2','sliding window')
%% b028
cd /home/yuval/Data/kurtosis/b028
cfg1=[];
cfg1.dataset='c,rfhp1.0Hz,ee';
cfg1.trl=[1 67817 0];
cfg1.channel='MEG';
cfg1.bpfilter='yes';
cfg1.bpfreq=[20 70];
data=ft_preprocessing(cfg1);
cd SAM
[SAMHeader, ActIndex, ActWgts]=readWeights('Global,20-70Hz,Global,ECD.wts');

xyz=[8.5 1.5 5];
[indF,~]=voxIndex(xyz,100.*[...
    SAMHeader.XStart SAMHeader.XEnd ...
    SAMHeader.YStart SAMHeader.YEnd ...
    SAMHeader.ZStart SAMHeader.ZEnd],...
    100.*SAMHeader.StepSize,1);

xyz=[-1.5 5 8];%[1.5 -2 10];
[indP,~]=voxIndex(xyz,100.*[...
    SAMHeader.XStart SAMHeader.XEnd ...
    SAMHeader.YStart SAMHeader.YEnd ...
    SAMHeader.ZStart SAMHeader.ZEnd],...
    100.*SAMHeader.StepSize,1);

vsF=ActWgts(uint16(indF),:)*data.trial{1,1};
vsP=ActWgts(uint16(indP),:)*data.trial{1,1};
timeline=data.time{1,1};
timeBeg=0:0.25:99.5;
timeEnd=timeBeg+0.5;
for wini=1:length(timeBeg)
    time(wini)=(timeBeg(wini)+timeEnd(wini))/2;
    sBeg=nearest(timeline,timeBeg(wini));
    sEnd=nearest(timeline,timeEnd(wini));
    g2far(wini)=G2(vsP(sBeg:sEnd));
    g2lesion(wini)=G2(vsF(sBeg:sEnd));
end

sum(g2far(g2far>0))
sum(g2lesion(g2lesion>0))
max(g2far)
max(g2lesion)

timeBeg=0:5:90;
timeEnd=timeBeg+10;
for wini=1:length(timeBeg)
    time10(wini)=(timeBeg(wini)+timeEnd(wini))/2;
    sBeg=nearest(timeline,timeBeg(wini));
    sEnd=nearest(timeline,timeEnd(wini));
    g2far10(wini)=G2(vsP(sBeg:sEnd));
    g2lesion10(wini)=G2(vsF(sBeg:sEnd));
end

sum(g2far10(g2far10>0))
sum(g2lesion10(g2lesion10>0))
max(g2far10)
max(g2lesion10)

figure;
plot(time,g2far,'r');
hold on;
plot(time,g2lesion,'k');
plot(time10,g2far10,'m');
plot(time10,g2lesion10,'b');

legend(...
    'distant, 0.5s, max(g2))=14, sum(g2)= 571',...
    'lesion,  0.5s, max(g2))=10, sum(g2)= 692',...
    'distant,  10s, max(g2))=48, sum(g2)= 354',...
    'lesion,   10s, max(g2))= 7, sum(g2)=  88')
figure;plot(timeline,vsP,'r')
hold on
plot(timeline,vsF,'k')