%% using mne -trans.fif to later align the points
load /home/yuval/Data/marik/mark/1/trans
transInv=inv(trans); % mri to headshape
transMM=transInv; % m to mm
transMM(:,4)=transInv(:,4).*1000; 
%% read output of mne_setup_source_space --space 5
lh=importdata('/usr/local/freesurfer/subjects/Mark/bem/Mark-5-lh.pnt');
rh=importdata('/usr/local/freesurfer/subjects/Mark/bem/Mark-5-rh.pnt');
hs=ft_read_headshape('/home/yuval/Data/marik/mark/1/hs_file');
rhPRI=rh.data(:,2);
rhPRI(:,2)=rh.data(:,1);
rhPRI(:,3)=rh.data(:,3);
lhPRI=lh.data(:,2);
lhPRI(:,2)=lh.data(:,1);
lhPRI(:,3)=lh.data(:,3);
rhFix=transPnt(rhPRI,transMM);
lhFix=transPnt(lhPRI,transMM);
figure; 
plot3pnt(lhPRI,'.')
hold on
plot3pnt(lhFix,'r.')
plot3pnt(hs.pnt*1000,'.y')
plot3pnt(rhPRI,'.')
hold on
plot3pnt(rhFix,'r.')
title('RED = NEW POSITION')
lh=lhFix;
rh=rhFix;
save ctx lh rh


