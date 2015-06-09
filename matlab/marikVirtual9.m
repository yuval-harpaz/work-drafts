nPNT=642;
cd /home/yuval/Data/marik/som2/1
hs=ft_read_headshape('hs_file');
hs=hs.pnt*1000;

inward=[10 20 30];

[pnt1,lf1,vol]=sphereGrid(nPNT,inward(1)); % inner
pnt_complex1=findPerpendicular(pnt1);
[pnt2,lf2]=sphereGrid(nPNT,inward(2)); % outer
pnt_complex2=findPerpendicular(pnt2);
[pnt3,lf3,vol]=sphereGrid(nPNT,inward(3)); % inner
pnt_complex3=findPerpendicular(pnt3);
pnt=[pnt1(:,:,1);pnt2(:,:,1);pnt3(:,:,1)];
ini=true(length(pnt),1);
ini(pnt(:,3)<vol.o(3))=false; % keep only top half sphere
ini(pnt(:,2)<min(hs(:,2)'+10))=false;
ini(pnt(:,2)>max(hs(:,2)'-10))=false;
ini=find(ini);
pnt=pnt(ini,:);

pnt_complex=pnt_complex1;
pnt_complex(nPNT+1:nPNT*2,:,:)=pnt_complex2;
pnt_complex(nPNT*2+1:nPNT*3,:,:)=pnt_complex3;
pnt_complex=pnt_complex(ini,:,:);

cd /home/yuval/Data/marik/som2/2
[~,lf4]=sphereGrid(nPNT,inward(1));
[~,lf5]=sphereGrid(nPNT,inward(2));
[~,lf6]=sphereGrid(nPNT,inward(3));
cd /home/yuval/Data/marik/som2/3
[~,lf7]=sphereGrid(nPNT,inward(1));
[~,lf8]=sphereGrid(nPNT,inward(2));
[~,lf9]=sphereGrid(nPNT,inward(3));
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

%[mostActive,neighbours]=clusterSensors(data.dataU,data.dataU.time(samp),'97%',50,1);
%cfg.channel = {'A46', 'A128'}
load mostActive
coordAct=mean(data.dataU.grad.chanpos(mostActive,:));
load neighb
neighbours=neighb;
% cfg=[];
% cfg.zlim=[-max(abs(M)) max(abs(M))];
% cfg.highlight='labels';
% cfg.highlightchannel=find(neighbours(1:248));
% figure;topoplot248(M(1:248),cfg);title('set1')
% cfg.highlightchannel=find(neighbours(249:248*2));
% figure;topoplot248(M(249:248*2),cfg);title('set2')
% cfg.highlightchannel=find(neighbours(248*2+1:248*3));
% figure;topoplot248(M(248*2+1:248*3),cfg);title('set3')
% 
[srci]=chooseNearSrc(data.dataU,pnt,coordAct,50);
% disp([num2str(sum(neighbours)),' channels and ',num2str(sum(srci)),' sources'])
% 
% source=gain(neighbours,[srci;srci])\M(neighbours);
% Nsrc=sum(srci);
% pow=sqrt(source(1:Nsrc).^2+source(Nsrc+1:end).^2);
% Pow=zeros(size(pnt,1),1);
% Pow(srci)=pow;
% figure;
% scatter3(pnt(:,1),pnt(:,2),pnt(:,3),25,Pow,'filled')
% view([-900,0])
% xlim([-110 150])
% ylim([-110 110])
% zlim([-50 150])
% axis vis3d
% % hold on
% % plot3pnt(hs,'.k')
% cm=colormap;
% colorbar
% colormap(cm(1:end-7,:))
% rotate3d
% 
% [~,maxPNT]=max(Pow);
% 
% recon=gain(:,[srci;srci])*source; % reconstructed field
% 
% cfg=[];
% cfg.zlim=[-max(abs(recon)) max(abs(recon))];
% cfg.highlight='labels';
% cfg.highlightchannel=find(neighbours(1:248));
% figure;topoplot248(recon(1:248),cfg);title('set1')
% cfg.highlightchannel=find(neighbours(249:248*2));
% figure;topoplot248(recon(249:248*2),cfg);title('set2')
% cfg.highlightchannel=find(neighbours(248*2+1:248*3));
% figure;topoplot248(recon(248*2+1:248*3),cfg);title('set3')
% ind1=ini(find(maxPow))-nPNT; % where in the original nPNT*3 points the outer dipole is
% Ind1=find(ini==ind1); % where in pnt the outer dipole is
% ind2=ini(find(maxPow));
% Ind2=find(ini==ind2); % where in pnt the middle dipole is, equals maxPNT
% ind3=ini(find(maxPow))+nPNT;
% Ind3=find(ini==ind3); % where in pnt the inner dipole is
% src1i=find(find(srci)==Ind1);
% src2i=find(find(srci)==Ind2);
% src3i=find(find(srci)==Ind3);
% 
% maxPow=zeros(size(pnt,1),1);
% maxPow([Ind1,Ind2,Ind3])=[0.5,1,0.5];
% 
% figure;
% scatter3(pnt(:,1),pnt(:,2),pnt(:,3),25,maxPow,'filled')
% view([-900,0])
% xlim([-110 150])
% ylim([-110 110])
% zlim([-50 150])
% axis vis3d
% cm=colormap;
% colorbar
% colormap(cm(1:end-7,:))
% rotate3d

% recon2=gain(:,Ind2)*source(src2i)+gain(:,Ind2+length(Pow))*source(src2i+sum(srci));
% topoplot248(recon2(1:248))
% recon2=gain(:,Ind2)+gain(:,Ind2+length(Pow)); % equals mapMax
% recon1=gain(:,ind1)*source(;
% recon1=gain(:,[ind1,ind1+length(Pow)])*source(;

%% zero non-neighbours
% M0=M;
% M0(~neighbours)=0;
% source=gain(:,[srci;srci])\M0;
% Nsrc=sum(srci);
% pow=sqrt(source(1:Nsrc).^2+source(Nsrc+1:end).^2);
% Pow=zeros(size(pnt,1),1);
% Pow(srci)=pow;
% figure;
% scatter3(pnt(:,1),pnt(:,2),pnt(:,3),25,Pow,'filled')
% [~,maxPNT]=max(Pow);
% hold on
% scatter3(pnt(maxPNT,1),pnt(maxPNT,2),pnt(maxPNT,3),30,0)
% view([-900,0])
% xlim([-110 150])
% ylim([-110 110])
% zlim([-50 150])
% axis vis3d
% % plot3pnt(hs,'.k')
% cm=colormap;
% colorbar
% colormap(cm(1:end-7,:))
% rotate3d
% 
% recon=gain(:,[srci;srci])*source; % reconstructed field
% 
% cfg=[];
% cfg.zlim=[-max(abs(recon)) max(abs(recon))];
% cfg.highlight='labels';
% cfg.highlightchannel=find(neighbours(1:248));
% figure;topoplot248(recon(1:248),cfg);title('set1')
% cfg.highlightchannel=find(neighbours(249:248*2));
% figure;topoplot248(recon(249:248*2),cfg);title('set2')
% cfg.highlightchannel=find(neighbours(248*2+1:248*3));
% figure;topoplot248(recon(248*2+1:248*3),cfg);title('set3')
% 
% 
% [~,PowSort]=sort(Pow,'descend');
% cfg=[];
% cfg.zlim=[-5e-11 5e-11];
% for powi=1:5
%     ind=ini(PowSort(powi));
%     Ind=find(ini==ind);
%     srcii=find(find(srci)==Ind);
%     reconi=gain(:,Ind)*source(srcii)+gain(:,Ind+length(Pow))*source(srcii+sum(srci));
%     figure;
%     topoplot248(reconi(1:248),cfg);
% end
% figure;
% topoplot248(recon(1:248),cfg);

%% one pnt at a time
M0=M;
M0(~neighbours)=0;
Gain=gain(:,[srci;srci]);
pow=[];
source=[];
for si=1:sum(srci)
    source([si,si+sum(srci)])=Gain(:,[si;si+sum(srci)])\M0;
end
source=source';
pow=sqrt(source(1:sum(srci)).^2+source(sum(srci)+1:end).^2);
Pow=zeros(size(pnt,1),1);
Pow(srci)=pow;
figure;
scatter3(pnt(:,1),pnt(:,2),pnt(:,3),25,Pow,'filled')
[~,maxPNT]=max(Pow);
hold on
scatter3(pnt(maxPNT,1),pnt(maxPNT,2),pnt(maxPNT,3),30,0)
view([-900,0])
xlim([-110 150])
ylim([-110 110])
zlim([-50 150])
axis vis3d
% plot3pnt(hs,'.k')
cm=colormap;
colorbar
colormap(cm(1:end-7,:))
rotate3d
  
% [~,PowSort]=sort(pow,'descend');
% cfg=[];
% cfg.zlim=[-5e-14 5e-14];
R=[];
gof=[];
for powi=1:length(pow)
    Ind=Pow(powi);
    reconi=Gain(:,[powi;powi+length(pow)])*source([powi,powi+length(pow)]);
%     figure;
%     topoplot248(reconi(1:248),cfg);
    R(powi)=corr(reconi,M0).^2;
    [~,g]=fit(reconi*10^14,M0*10^14,'poly1');
    gof(powi)=g.sse;
end

Pow=zeros(size(pnt,1),1);
Pow(srci)=R;
GOF=zeros(size(pnt,1),1);
GOF(srci)=max(gof)-gof;
[~,maxPNT]=max(Pow);
[~,maxG]=max(GOF);

figure;
scatter3(pnt(maxPNT,1),pnt(maxPNT,2),pnt(maxG,3),35,0)
hold on
scatter3(pnt(:,1),pnt(:,2),pnt(:,3),25,GOF,'filled')
view([-900,0])
xlim([-110 150])
ylim([-110 110])
zlim([-50 150])
axis vis3d
% plot3pnt(hs,'.k')
cm=colormap;
colorbar
colormap(cm(1:end-7,:))
rotate3d

figure;
topoplot248(recon(1:248),cfg);
