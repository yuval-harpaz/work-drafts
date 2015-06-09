nPNT=642;
cd /home/yuval/Data/marik/som2/1
hs=ft_read_headshape('hs_file');
hs=hs.pnt*1000;

inward=[10 20 30];

[pnt1,lf1,vol]=sphereGrid(nPNT,inward(1),true); 

%% find paired pnt

left=find(pnt1(:,2)>vol.o(2));
right=find(pnt1(:,2)<vol.o(2));
center=find(pnt1(:,2)==vol.o(2));


pnt_complex1=findPerpendicular(pnt1);
[pnt2,lf2]=sphereGrid(nPNT,inward(2),true); 
pnt_complex2=findPerpendicular(pnt2);
[pnt3,lf3,vol]=sphereGrid(nPNT,inward(3),true); 
pnt_complex3=findPerpendicular(pnt3);
pnt=[pnt1(:,:,1);pnt2(:,:,1);pnt3(:,:,1)];
left=[left;left+length(pnt1);left+length(pnt1)*2];
right=[right;right+length(pnt1);right+length(pnt1)*2];

ini=true(length(pnt),1);
l=~ini;
r=~ini;
l(left)=true;
r(right)=true;
ini(pnt(:,3)<vol.o(3))=false; % keep only top half sphere
l(~ini)=false;
r(~ini)=false;
left=find(l(ini));
right=find(r(ini));

ini=find(ini);
pnt=pnt(ini,:);

pnt_complex=pnt_complex1;
pnt_complex(nPNT+1:nPNT*2,:,:)=pnt_complex2;
pnt_complex(nPNT*2+1:nPNT*3,:,:)=pnt_complex3;
pnt_complex=pnt_complex(ini,:,:);

cd /home/yuval/Data/marik/som2/2
[~,lf4]=sphereGrid(nPNT,inward(1),true);
[~,lf5]=sphereGrid(nPNT,inward(2),true);
[~,lf6]=sphereGrid(nPNT,inward(3),true);
cd /home/yuval/Data/marik/som2/3
[~,lf7]=sphereGrid(nPNT,inward(1),true);
[~,lf8]=sphereGrid(nPNT,inward(2),true);
[~,lf9]=sphereGrid(nPNT,inward(3),true);
LF1=lf1; %head pos 1
LF1.leadfield(nPNT+1:nPNT*2)=lf2.leadfield;
LF1.leadfield(nPNT*2+1:nPNT*3)=lf3.leadfield;
LF1.leadfield=LF1.leadfield(ini);
LF1.pos(nPNT+1:nPNT*2,:)=lf2.pos;
LF1.pos(nPNT*2+1:nPNT*3,:)=lf3.pos;
LF1.pos=LF1.pos(ini,:);
LF1.inside(nPNT+1:nPNT*2)=lf2.inside;
LF1.inside(nPNT*2+1:nPNT*3)=lf2.inside;
LF1.inside=LF1.inside(ini);
LF2=lf4; %head pos 2
LF2.leadfield(nPNT+1:nPNT*2)=lf5.leadfield;
LF2.leadfield(nPNT*2+1:nPNT*3)=lf6.leadfield;
LF2.leadfield=LF2.leadfield(ini);
LF2.pos(nPNT+1:nPNT*2,:)=lf5.pos;
LF2.pos(nPNT*2+1:nPNT*3,:)=lf6.pos;
LF2.pos=LF2.pos(ini,:);
LF2.inside(nPNT+1:nPNT*2)=lf5.inside;
LF2.inside(nPNT*2+1:nPNT*3)=lf6.inside;
LF2.inside=LF2.inside(ini);
LF3=lf7; %pos3 
LF3.leadfield(nPNT+1:nPNT*2)=lf8.leadfield;
LF3.leadfield(nPNT*2+1:nPNT*3)=lf9.leadfield;
LF3.leadfield=LF3.leadfield(ini);
LF3.pos(nPNT+1:nPNT*2,:)=lf8.pos;
LF3.pos(nPNT*2+1:nPNT*3,:)=lf9.pos;
LF3.pos=LF3.pos(ini,:);
LF3.inside(nPNT+1:nPNT*2)=lf8.inside;
LF3.inside(nPNT*2+1:nPNT*3)=lf9.inside;
LF3.inside=LF3.inside(ini);

close all
figure
plot3pnt(hs,'.')
hold on
plot3pnt(pnt,'.k')

cd /home/yuval/Data/marik/som2
load avgFilt
[data, cfg]=marikViUnite(avg1_handR,avg2_handR,avg3_handR);
%LF.label=data.dataU.label

gain=[];
for pnti=1:length(pnt)
    dip=(pnt_complex(pnti,:,2)-pnt_complex(pnti,:,1))*LF1.leadfield{pnti}';
    dip=[dip,(pnt_complex(pnti,:,2)-pnt_complex(pnti,:,1))*LF2.leadfield{pnti}'];
    dip=[dip,(pnt_complex(pnti,:,2)-pnt_complex(pnti,:,1))*LF3.leadfield{pnti}'];
    gain(1:744,pnti)=dip;
    dip=(pnt_complex(pnti,:,3)-pnt_complex(pnti,:,1))*LF1.leadfield{pnti}';
    dip=[dip,(pnt_complex(pnti,:,3)-pnt_complex(pnti,:,1))*LF2.leadfield{pnti}'];
    dip=[dip,(pnt_complex(pnti,:,3)-pnt_complex(pnti,:,1))*LF3.leadfield{pnti}'];
    gain(1:744,length(pnt)+pnti)=dip;
end

%% 
samp=138; % 158 185
M=data.dataU.avg(:,samp);

pow=[];
for si=1:length(left)
    lefti=left(si);
    righti=right(si);
%     figure;
%     subplot(2,2,1)
%     topoplot248(gain(1:248,lefti));
%     subplot(2,2,3)
%     topoplot248(gain(1:248,lefti+length(pnt)))
%     subplot(2,2,2)
%     topoplot248(gain(1:248,righti))
%     subplot(2,2,4)
%     topoplot248(gain(1:248,righti+length(pnt)))
%     pause
%     close
    tmp=gain(:,[lefti,righti])\M;
    %tmp=M'*gain(:,[lefti,righti]);
    srcLa(si)=tmp(1); srcRa(si)=tmp(2);
    tmp=gain(:,[lefti+length(pnt),righti+length(pnt)])\M;
    %tmp=M'*gain(:,[lefti+length(pnt),righti+length(pnt)]);
    srcLb(si)=tmp(1); srcRb(si)=tmp(2);
    
end
srcA=srcLa+srcRa;
srcB=srcLb-srcRb; % here it is minus because of dipole projected field issue, plot to see

[~,maxi]=max(abs(srcA)+abs(srcB));
fieldL=srcLa(maxi).*gain(1:248,left(maxi))+srcLb(maxi).*gain(1:248,left(maxi)+length(pnt));
fieldR=srcRa(maxi).*gain(1:248,right(maxi))+srcRb(maxi).*gain(1:248,right(maxi)+length(pnt));
figure;topoplot248(fieldR)
figure;topoplot248(fieldR+fieldL)
figure;topoplot248(fieldL)
figure;topoplot248(M(1:248))


src=abs(srcA)+abs(srcB);
pow=zeros(length(pnt),1);
pow(left)=src;
pow(right)=src;

figure;
scatter3(pnt(:,1),pnt(:,2),pnt(:,3),25,pow,'filled')
view([-90,90])
xlim([-110 150])
ylim([-110 110])
zlim([-50 150])
axis vis3d
hold on
plot3pnt(hs,'.k')
cm=colormap;
colorbar
colormap(cm(1:end-7,:))
rotate3d