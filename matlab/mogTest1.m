cd /home/yuval/Data/alice/maor/mog
load triggers
load X
cc=imread('~/Dropbox/alice/MOG/MOGcc.bmp');
image(cc);
hold on
plot(400,400,'r.')

tr=200;
s0=triggers(find(triggers(:,2)==tr,1),1);
figure;
plot(X(1,s0-102:s0+3*1017));
xC=mean(X(1,s0+1000:s0+3000));
% x at the centre is 1.0266
plot(X(2,s0-102:s0+3*1017));
yC=mean(X(2,s0+1000:s0+3000));
% y at the centre is 0.7169
tr=202;
s0=triggers(find(triggers(:,2)==tr),1);
for i=1:length(s0)
    figure;
    plot(X(:,s0(i)-102:s0(i)+3*1017)');
    title('give start sample and end sample in command window')
    sStart = input('start ');
    sEnd = input('end ');
    xy202(i,1:2)=mean(X(:,s0(i)+sStart:s0(i)+sEnd)');
end
xy202=mean(xy202,1);


tr=176;
s0=triggers(find(triggers(:,2)==tr),1);
for i=1:length(s0)
    figure;
    plot(X(:,s0(i)-10:s0(i)+1017)');
    axis tight
    hold on
    plot(trig(:,s0(i)-10:s0(i)+1017)','y');
    title('give start sample and end sample in command window')
    sStart = input('start ');
    sEnd = input('end ');
    eval(['xy',num2str(tr),'(i,1:2)=mean(X(:,s0(i)+sStart:s0(i)+sEnd)''',');']);
end

eval(['xy',num2str(tr),'=mean(xy',num2str(tr),',1);']);








xC=mean(X(1,s0+1000:s0+3000));
% x at the centre is 1.0266, 410 in the image
plot(X(2,s0-102:s0+3*1017));
yC=mean(X(2,s0+1000:s0+3000));
% y at the centre is 0.7169, 376 in the image
image(cc);
hold on
plot(410,376,'ro')
% 178   176    174 trigger
% c      r     rr  location
% 410   493    574 pixel(x,376)
% 0.940 1.396  2.159 volt
% 
% data range -300 1800
% voltage range -5 +5 V
% x=210v+750, same for y
% 

ab=polyfit([0.94,1.94,2.16],[410,493,574],1);

ccc=imread('~/Dropbox/alice/MOG/MOGrr.bmp');
image(ccc);

a=ab(1);b=ab(2)
% pixel=volt*119+293;

%% draw gaze
cd /home/yuval/Data/alice/maor/mog
load triggers
load X
cc=imread('~/Dropbox/alice/MOG/MOGcc.bmp');

ETv=X(1,triggers(find(triggers(:,2)==20),1):triggers(find(triggers(:,2)==2),1));
ETpx=ETv*119+293;
ETvy=X(2,triggers(find(triggers(:,2)==20),1):triggers(find(triggers(:,2)==2),1));
ETpy=ETvy*119+293;

figure;
image(cc);
hold on
x=410;y=376;
for i=1:length(ETpx)
    pause(0.01)
    plot(x,y,'.k')
    if ETv(i)>0.5 && ETv(i)<1
        x=ETpx(i);
        y=ETpy(i);
        plot(x,y,'.r')
    end
end


figure1=figure('position',[1 1 400 800]);
subplot(2,1,2)
plot(ETv);
hold on
subplot(2,1,1)
image(cc);
hold on
x=410;y=376;
for i=2:5:length(ETpx)
    pause(0.01)
    subplot(2,1,1)
    plot(x,y,'.k')
    subplot(2,1,2)
    plot(i-1,ETv(i-1),'.b')
    if ETv(i)>0.5 && ETv(i)<1
        x=ETpx(i);
        y=ETpy(i);
        subplot(2,1,1)
        plot(x,y,'.r')
        subplot(2,1,2)
        plot(i,ETv(i),'.r')
        drawnow
    end
end
        
        
    
