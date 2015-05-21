
cd /home/yuval/Data/marik/som2/1
hs=ft_read_headshape('hs_file')
[pnt2,lf2]=sphereGrid(162); % outer
pnt_complex2=findPerpendicular(pnt2);
[pnt1,lf1,vol1]=sphereGrid(162,3); % inner
pnt_complex1=findPerpendicular(pnt1);
pnt=[pnt1(:,:,1);pnt2(:,:,1)];
upi=find(pnt(:,3)>=vol1.o(3)); % keep only top half sphere
pnt=pnt(upi,:);
pnt_complex=pnt_complex1;
pnt_complex(163:162*2,:,:)=pnt_complex2;
pnt_complex=pnt_complex(upi,:,:);
cd /home/yuval/Data/marik/som2/2
[~,lf4]=sphereGrid(162);
[~,lf3]=sphereGrid(162,3);
cd /home/yuval/Data/marik/som2/3
[~,lf6]=sphereGrid(162);
[~,lf5]=sphereGrid(162,3);
LF1=lf1; %head pos 1
LF1.leadfield(163:324)=lf2.leadfield;
LF1.leadfield=LF1.leadfield(upi);
LF1.pos(163:324,:)=lf2.pos;
LF1.pos=LF1.pos(upi,:);
LF1.inside(163:324)=lf2.inside;
LF1.inside=LF1.inside(upi);
LF2=lf3; %head pos 2
LF2.leadfield(163:324)=lf4.leadfield;
LF2.leadfield=LF2.leadfield(upi);
LF2.pos(163:324,:)=lf4.pos;
LF2.pos=LF2.pos(upi,:);
LF2.inside(163:324)=lf4.inside;
LF2.inside=LF2.inside(upi);
LF3=lf5; %pos3 
LF3.leadfield(163:324)=lf6.leadfield;
LF3.leadfield=LF3.leadfield(upi);
LF3.pos(163:324,:)=lf6.pos;
LF3.pos=LF3.pos(upi,:);
LF3.inside(163:324)=lf6.inside;
LF3.inside=LF3.inside(upi);

close all
figure
plot3pnt(hs.pnt,'.')
hold on
plot3pnt(pnt/100,'.k')

cd /home/yuval/Data/marik/som2
load avgFilt
[data, cfg]=marikViUnite(avg1_handR,avg2_handR,avg3_handR);
%LF.label=data.dataU.label

gain=[];
for pnti=1:178
    dip=(pnt_complex(pnti,:,2)-pnt_complex(pnti,:,1))*LF1.leadfield{pnti}';
    dip=[dip,(pnt_complex(pnti,:,2)-pnt_complex(pnti,:,1))*LF2.leadfield{pnti}'];
    dip=[dip,(pnt_complex(pnti,:,2)-pnt_complex(pnti,:,1))*LF3.leadfield{pnti}'];
    gain(1:744,pnti)=dip;
    dip=(pnt_complex(pnti,:,3)-pnt_complex(pnti,:,1))*LF1.leadfield{pnti}';
    dip=[dip,(pnt_complex(pnti,:,3)-pnt_complex(pnti,:,1))*LF2.leadfield{pnti}'];
    dip=[dip,(pnt_complex(pnti,:,3)-pnt_complex(pnti,:,1))*LF3.leadfield{pnti}'];
    gain(1:744,178+pnti)=dip;
end

%% marik's method
samp=138; % 158 185
M=data.dataU.avg(:,samp);
source=gain\M;

pow=sqrt(source(1:178).^2+source(179:end).^2);

figure;
scatter3(pnt(:,1),pnt(:,2),pnt(:,3),25,pow,'filled')
view([-90,0])
xlim([-11 15])
ylim([-11 11])
zlim([-5 15])
axis vis3d
hold on
plot3pnt(hs.pnt*100,'.k')
cm=colormap;
colorbar
colormap(cm(1:end-7,:))
rotate3d

[~,maxi]=max(pow);
sourceMax=[source(maxi),source(178+maxi)];
map1=gain(1:248,maxi).*sourceMax(1)+gain(1:248,maxi+178).*sourceMax(2);
figure;topoplot248(map1);colorbar
figure;topoplot248(M(1:248))



%% my method
samp=138; % 158 185
M=data.dataU.avg(:,samp);
source=M'*gain;


pow=sqrt(source(1:178).^2+source(179:end).^2);

figure;
scatter3(pnt(:,1),pnt(:,2),pnt(:,3),25,pow,'filled')
view([-90,0])
xlim([-11 15])
ylim([-11 11])
zlim([-5 15])
axis vis3d
hold on
plot3pnt(hs.pnt*100,'.k')
cm=colormap;
colorbar
colormap(cm(1:end-7,:))
rotate3d

[~,maxi]=max(pow);
sourceMax=[source(maxi),source(178+maxi)];
map1=gain(1:248,maxi).*sourceMax(1)+gain(1:248,maxi+178).*sourceMax(2);
figure;topoplot248(map1);colorbar
figure;topoplot248(M(1:248))

%% foot

dataF=marikViUnite(avg1_footL,avg2_footL,avg3_footL);
samp=145; %180; % 145

M=dataF.dataU.avg(:,samp);
source=M'*gain;


pow=sqrt(source(1:178).^2+source(179:end).^2);

figure;
scatter3(pnt(:,1),pnt(:,2),pnt(:,3),25,pow,'filled')
view([-90,0])
xlim([-11 15])
ylim([-11 11])
zlim([-5 15])
axis vis3d
hold on
plot3pnt(hs.pnt*100,'.k')
cm=colormap;
colorbar
colormap(cm(1:end-7,:))
rotate3d

[~,maxi]=max(pow);
sourceMax=[source(maxi),source(178+maxi)];
map1=gain(1:248,maxi).*sourceMax(1)+gain(1:248,maxi+178).*sourceMax(2);
figure;topoplot248(map1);colorbar
figure;topoplot248(M(1:248))

%% handR + footL
M=data.dataU.avg(:,138)+2.5*dataF.dataU.avg(:,145);
source=M'*gain;


pow=sqrt(source(1:178).^2+source(179:end).^2);

figure;
scatter3(pnt(:,1),pnt(:,2),pnt(:,3),25,pow,'filled')
view([-90,0])
xlim([-11 15])
ylim([-11 11])
zlim([-5 15])
axis vis3d
hold on
plot3pnt(hs.pnt*100,'.k')
cm=colormap;
colorbar
colormap(cm(1:end-7,:))
rotate3d

[~,maxi]=max(pow);
sourceMax=[source(maxi),source(178+maxi)];
map1=gain(1:248,maxi).*sourceMax(1)+gain(1:248,maxi+178).*sourceMax(2);
figure;topoplot248(map1);colorbar
figure;topoplot248(M(1:248))