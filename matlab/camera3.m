cd /home/yuval/Data/marik/camera
fileName1='1/c,rfhp0.1Hz';
hdr1=ft_read_header(fileName1);
hs1=ft_read_headshape('1/hs_file');
fileName2='2/c,rfhp0.1Hz';
hdr2=ft_read_header(fileName2);
load cameraData
cam=Measurement_head_coil_w_labels.Trajectories.Labeled.Data(1:4,1:3,:);
tCAM = (0:24530)/80;
t1meg=hdr1.orig.user_block_data{1,12}.pnt([12:15],:);
% transformation from camera to MEG space
figure;
plot3pnt(hs1.pnt,'b.')
hold on
plot3pnt(t1meg,'r.')
plot3pnt(hdr1.grad.chanpos(1:248,:),'ko');
plot3pnt(hdr2.grad.chanpos(1:248,:),'go');
legend('headshape','markers','MEG at time 1','MEG at time 2')
figure;
plot(tCAM,squeeze(cam(:,1,:)))
legend('Left cheeck','Right cheeck','Nose','Upper Lip')
title ('Camera space X coordinates for the four markers')
xlabel('time(sec)')