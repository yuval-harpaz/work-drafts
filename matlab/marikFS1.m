%% using mne -trans.fif to later align the points
load /home/yuval/Data/marik/mark/1/trans
transInv=inv(trans); % mri to headshape
transMM=transInv; % m to mm
transMM(:,4)=transInv(:,4).*1000; 
%% read output of mne_setup_source_space --space 5
lh=importdata('/usr/local/freesurfer/subjects/Mark/bem/Mark-5-lh.pnt');
rh=importdata('/usr/local/freesurfer/subjects/Mark/bem/Mark-5-rh.pnt');
hs=ft_read_headshape('/home/yuval/Data/marik/mark/1/hs_file');
% rhPRI=rh.data(:,2);
% rhPRI(:,2)=-rh.data(:,1);
% rhPRI(:,3)=rh.data(:,3);
% lhPRI=lh.data(:,2);
% lhPRI(:,2)=-lh.data(:,1);
% lhPRI(:,3)=lh.data(:,3);
% rhFix=transPnt(rhPRI,transMM);
% lhFix=transPnt(lhPRI,transMM);
rhFix=transPnt(rh.data,transMM);
lhFix=transPnt(lh.data,transMM);

rhPRI=rhFix(:,2);
rhPRI(:,2)=-rhFix(:,1);
rhPRI(:,3)=rhFix(:,3);
lhPRI=lhFix(:,2);
lhPRI(:,2)=-lhFix(:,1);
lhPRI(:,3)=lhFix(:,3);

figure; 
plot3pnt(lhFix,'.')
hold on
%plot3pnt(rhFix,'.')
plot3pnt(hs.pnt*1000,'.y')
title('LH')


figure; 
plot3pnt(lhPRI,'b.')
hold on
plot3pnt(rhPRI,'c.')
plot3pnt(hs.pnt*1000,'.y')
legend ('LH','RH','scalp')
title('NEW')

% figure
% plot3pnt(lhFix,'r.')
% hold on
% plot3pnt(rhFix,'m.')
% plot3pnt(hs.pnt*1000,'.y')
% legend ('LH','RH','scalp')
% title('OLD')
lh=lhPRI;
rh=rhPRI;
save ctx lh rh
%% dip
lh=importdata('/usr/local/freesurfer/subjects/Mark/bem/Mark-5-lh.dip');
rh=importdata('/usr/local/freesurfer/subjects/Mark/bem/Mark-5-rh.dip');

hs=ft_read_headshape('/home/yuval/Data/marik/mark/1/hs_file');
% rhPRI=rh.data(:,2);
% rhPRI(:,2)=-rh.data(:,1);
% rhPRI(:,3)=rh.data(:,3);
% lhPRI=lh.data(:,2);
% lhPRI(:,2)=-lh.data(:,1);
% lhPRI(:,3)=lh.data(:,3);
% rhFix=transPnt(rhPRI,transMM);
% lhFix=transPnt(lhPRI,transMM);
rhFix=transPnt(rh.data(:,3:5),transMM);
lhFix=transPnt(lh.data(:,3:5),transMM);

rhPRI=rhFix(:,2);
rhPRI(:,2)=-rhFix(:,1);
rhPRI(:,3)=rhFix(:,3);
lhPRI=lhFix(:,2);
lhPRI(:,2)=-lhFix(:,1);
lhPRI(:,3)=lhFix(:,3);


figure; 
plot3pnt(lhPRI,'b.')
hold on
plot3pnt(rhPRI,'c.')
plot3pnt(hs.pnt*1000,'.y')
legend ('LH','RH','scalp')
title('NEW')

lhpnt=lhPRI;
rhpnt=rhPRI;


% ori
rhFix=transPnt(rh.data(:,7:9),transMM);
lhFix=transPnt(lh.data(:,7:9),transMM);

rhPRI=rhFix(:,2);
rhPRI(:,2)=-rhFix(:,1);
rhPRI(:,3)=rhFix(:,3);
lhPRI=lhFix(:,2);
lhPRI(:,2)=-lhFix(:,1);
lhPRI(:,3)=lhFix(:,3);
lhori=lhPRI;
rhori=rhPRI;
save ctxdip lhpnt rhpnt lhori rhori