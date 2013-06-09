cd /home/yuval/Data/camera
fileName1='1/c,rfhp0.1Hz';
fileName2='2/c,rfhp0.1Hz';
hdr1=ft_read_header(fileName1);
hdr2=ft_read_header(fileName2);
hs1=ft_read_headshape('1/hs_file');
hs2=ft_read_headshape('2/hs_file');
load cameraData
cam=Measurement_head_coil_w_labels.Trajectories.Labeled.Data(:,1:3,:);
tCAM = (0:24530)/80;
figure;
plot(tCAM,squeeze(cam(:,1,:)))
legend(Measurement_head_coil_w_labels.Trajectories.Labeled.Labels)

% chan order in camera: L chick, R chick, Nose, Upper lip, bottom lip
% chan raw in user_data_block 11 = Nasion, 12 = L chick, 13 = Rchick, 14 =
% Nose, 15 = upper lip.
% coord order of camera is RPI ( and in mm )
t1=mean(cam(1:4,:,1:1000),3); % R chick, Nose, upper lip
t1fix = [t1(:,2) t1(:,1) t1(:,3)]/1000;
t1meg=hdr1.orig.user_block_data{1,12}.pnt([12:15],:);
M1 = spm_eeg_inv_rigidreg(t1meg',t1fix')

P1hy=t1fix';
P1hy(4,:)=1;
alignedP1hy = M1 * P1hy;


 camera.pnt=t1fix;
 test=ft_transform_geometry(inv(M1), camera)
% 
% 
% estimateRigidTransform(t1meg,t1fix)

plot3pnt(hs1.pnt,'b.')
hold on
plot3pnt(t1meg,'k.')

%plot3(alignedP1hy(1,:),alignedP1hy(2,:),alignedP1hy(3,:),'.r')
plot3pnt(alignedP1hy(1:4,1:4)','ro')




% X1 = inv(t1fix)*t1meg;
% t1fixFix=t1fix*X1;
% t2=mean(cam(2:4,:,16800:17800),3);
% t2fix = [t2(:,2) t2(:,1) t2(:,3)]/1000;
% t2fixFix=t2fix*X1;
% figure;
% plot3pnt(hdr1.grad.chanpos,'g.')
% hold on
% plot3pnt(hs1.pnt,'b.')
% plot3pnt(t1fixFix,'k.')
% plot3pnt(t2fixFix,'r.')
% 
% 
% 
% X = inv(t1fixFix'*t1fixFix)*t1fixFix'*t2fix;
% 
% [M1] = spm_eeg_inv_rigidreg(t1fix, t1meg)
% % look in the end of ft_transform_geometry
% old=t1fix;
% old(:,4) = 1;
% t1fixFix = old * inv(M1)';
% t1fixFix = t1fixFix(:,1:3);
% old=t2fix;
% old(:,4) = 1;
% t2fixFix = old * M1';
% t2fixFix = t2fixFix(:,1:3);
% plot3pnt(hs1.pnt,'.')
% hold on
% plot3pnt(t1fixFix,'.k')
% 
% 
% 
% 
% grad.chanpos=(hdr1.grad.chanpos*X);
% figure;
% plot3pnt(hdr1.grad.chanpos,'g.')
% hold on
% plot3pnt(hdr2.grad.chanpos,'b.')
% plot3pnt(grad.chanpos,'r.')
% 
% 
% 
% 
% 
% 
% t2=mean(cam(2:4,:,16800:17800),3);
% % arrange it as PRI
% t1fix = [t1(:,2) t1(:,1) t1(:,3)]/1000;
% t2fix = [t2(:,2) t2(:,1) t2(:,3)]/1000;
% 
% 
% % t1*X= t2 (this is the equation)
% 
% X = inv(t1fix'*t1fix)*t1fix'*t2fix;
% grad.chanpos=(hdr1.grad.chanpos*X);
% figure;
% plot3pnt(hdr1.grad.chanpos,'g.')
% hold on
% plot3pnt(hdr2.grad.chanpos,'b.')
% plot3pnt(grad.chanpos,'r.')
% 
% 
% figure;
% plot3pnt(t1,'g.');
% hold on
% plot3pnt(t2,'b.');
% plot3pnt(t1*X, 'r.')
% 
% figure;
% plot3pnt(hs1.pnt,'.')
% hold on
% plot3pnt(hdr1.orig.user_block_data{1,12}.pnt(1:5,:),'g.')
% plot3pnt(hdr1.orig.user_block_data{1,12}.pnt(6:10,:),'b.')
% plot3pnt(hdr1.orig.user_block_data{1,12}.pnt(11:15,:),'r.')
% 
% 
% t1*X
% 
% 
% p=pdf4D(fileName1);
% cleanCoefs = createCleanFile(p, fileName1,...
%     'byLF',256 ,'Method','Adaptive',...
%     'xClean',[4,5,6],...
%     'byFFT',0,...
%     'HeartBeat',[]);
% 
% p=pdf4D(fileName2);
% cleanCoefs = createCleanFile(p, fileName2,...
%     'byLF',256 ,'Method','Adaptive',...
%     'xClean',[4,5,6],...
%     'byFFT',0,...
%     'HeartBeat',[]);
% 
% 
% cd /home/yuval/Data/camera
% trig=readTrig_BIU(fileName)
% 
% cfg=[];
% cfg.dataset=fileName;
% cfg.trialdef.eventtype='TRIGGER';
% cfg.trialdef.prestim=0.1;
% cfg.trialdef.poststim=0.3;
% cfg.trialdef.offset=-0.1;
% cfg.trialfun='BIUtrialfun';
% cfg.trialdef.eventvalue= [104,102]; %left index finger
% cfg1=ft_definetrial(cfg);
% cfg1.demean='yes';
% cfg1.baselinewindow=[-0.1 0];
% cfg1.bpfilter='yes';
% cfg1.bpfreq=[3 30];
% cfg1.channel='MEG';
% cfg1.feedback='no';
% somsens=ft_preprocessing(cfg1);
% cfg=[];
% cfg.method='summary';
% cfg.channel='MEG';
% cfg.alim=1e-12;
% somsensCln=ft_rejectvisual(cfg, somsens);