
cd /home/yuval/Data/marik/som2/1
hs=ft_read_headshape('hs_file');
hs=hs.pnt*1000;
[pnt2,lf2]=sphereGrid(162); % outer
pnt_complex2=findPerpendicular(pnt2);
[pnt1,lf1,vol]=sphereGrid(162,3); % inner
pnt_complex1=findPerpendicular(pnt1);
pnt=[pnt1(:,:,1);pnt2(:,:,1)];
ini=true(length(pnt),1);
ini(pnt(:,3)<vol1.o(3))=false; % keep only top half sphere
ini(pnt(:,2)<min(hs(:,2)'+10))=false;
ini(pnt(:,2)>max(hs(:,2)'-10))=false;
ini=find(ini);
pnt=pnt(ini,:);

pnt_complex=pnt_complex1;
pnt_complex(163:162*2,:,:)=pnt_complex2;
pnt_complex=pnt_complex(ini,:,:);

cd /home/yuval/Data/marik/som2/2
[~,lf4]=sphereGrid(162);
[~,lf3]=sphereGrid(162,3);
cd /home/yuval/Data/marik/som2/3
[~,lf6]=sphereGrid(162);
[~,lf5]=sphereGrid(162,3);
LF1=lf1; %head pos 1
LF1.leadfield(163:324)=lf2.leadfield;
LF1.leadfield=LF1.leadfield(ini);
LF1.pos(163:324,:)=lf2.pos;
LF1.pos=LF1.pos(ini,:);
LF1.inside(163:324)=lf2.inside;
LF1.inside=LF1.inside(ini);
LF2=lf3; %head pos 2
LF2.leadfield(163:324)=lf4.leadfield;
LF2.leadfield=LF2.leadfield(ini);
LF2.pos(163:324,:)=lf4.pos;
LF2.pos=LF2.pos(ini,:);
LF2.inside(163:324)=lf4.inside;
LF2.inside=LF2.inside(ini);
LF3=lf5; %pos3 
LF3.leadfield(163:324)=lf6.leadfield;
LF3.leadfield=LF3.leadfield(ini);
LF3.pos(163:324,:)=lf6.pos;
LF3.pos=LF3.pos(ini,:);
LF3.inside(163:324)=lf6.inside;
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

cfg=[];
cfg.zlim=[-max(abs(M)) max(abs(M))];
cfg.highlight='labels';

[mostActive,neighbours]=clusterSensors(data.dataU,0.1,'97%',50,1);
cfg.highlightchannel=find(mostActive(1:248));
figure;topoplot248(M(1:248),cfg);title('set1')
cfg.highlightchannel=find(mostActive(249:248*2));
figure;topoplot248(M(249:248*2),cfg);title('set2')
cfg.highlightchannel=find(mostActive(248*2+1:248*3));
figure;topoplot248(M(248*2+1:248*3),cfg);title('set3')

cfg.highlightchannel=find(neighbours(1:248));
figure;topoplot248(M(1:248),cfg);title('set1')
cfg.highlightchannel=find(neighbours(249:248*2));
figure;topoplot248(M(249:248*2),cfg);title('set2')
cfg.highlightchannel=find(neighbours(248*2+1:248*3));
figure;topoplot248(M(248*2+1:248*3),cfg);title('set3')

[srci]=chooseNearSrc(data.dataU,pnt,mostActive,40);

disp([num2str(sum(neighbours)),' channels and ',num2str(sum(srci)),' sources'])

% figure;plot3pnt(data.dataU.grad.chanpos,'ok')
% hold on
% plot3pnt(data.dataU.grad.chanpos(find(mostActive),:),'or')
% plot3pnt(pnt,'.c')
% plot3pnt(pnt(srci,:),'b.')


source=gain(neighbours,[srci;srci])\M(neighbours);
Nsrc=sum(srci);
pow=sqrt(source(1:Nsrc).^2+source(Nsrc+1:end).^2);
Pow=zeros(size(pnt,1),1);
Pow(srci)=pow;
figure;
scatter3(pnt(:,1),pnt(:,2),pnt(:,3),25,Pow,'filled')
view([-900,0])
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

% reconstructed=gain*source;
% figure;topoplot248(reconstructed(1:248))



