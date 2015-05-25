
cd /home/yuval/Data/marik/som2/MNE
hs=ft_read_headshape('../1/hs_file')
fwd1=mne_read_forward_solution('pos1_raw-oct-6-fwd.fif');
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
lf=fwd1.sol.data;
%noise=sqrt(mean(lf.^2));
source=M'*lf;
%source=M'*lf./noise;
source=reshape(source,3,length(source)/3);
%source=source';
pow=sqrt(sum(source.^2));


figure;
scatter3(priBrain(:,1),priBrain(:,2),priBrain(:,3),20,pow,'filled')
