
cd /home/yuval/Data/marik/som2/MNE
hs=ft_read_headshape('../1/hs_file')
fwd1=mne_read_forward_solution('fixed1-fwd.fif');
lh=fwd1.src(1).rr(fwd1.src(1).vertno,:);
rh=fwd1.src(2).rr(fwd1.src(2).vertno,:);

priBrain=[lh;rh];
priBrain=priBrain(:,[2,1,3]);
priBrain(:,2)=-priBrain(:,2);
plot3pnt(priBrain,'.')
hold on
plot3pnt(hs.pnt,'ok')

load ../avgFilt

M=avg1_handR.avg(:,138);
for chi=1:248
    Msorted(chi)=M(find(ismember(avg1_handR.label,['A',num2str(chi)])));
end
lf=fwd1.sol.data;
%noise=sqrt(mean(lf.^2));
source=Msorted*lf;
%source=M'*lf./noise;

pow=abs(source);


figure;
scatter3(priBrain(:,1),priBrain(:,2),priBrain(:,3),20,pow,'filled')
% vert=fwd1.src(1).vertno;
% save vert vert
% save M1 M
save /home/yuval/Data/marik/som2/MNE/pow1.mat pow

cd ..
[data, cfg]=marikViUnite(avg1_handR,avg2_handR,avg3_handR);
[mostActive,neighbours]=clusterSensors(data.data1,0.1,'97%',50,1);
[srci]=chooseNearSrc(data.data1,priBrain*1000,mostActive,50);
disp([num2str(sum(neighbours)),' channels and ',num2str(sum(srci)),' sources'])
source=gain(neighbours,srci)\M(neighbours);
Nsrc=sum(srci);
pow=sqrt(source(1:Nsrc).^2+source(Nsrc+1:end).^2);
Pow=zeros(size(pnt,1),1);
Pow(srci)=pow;
%M=[M;avg2_handR.avg(:,138)];