%https://surfer.nmr.mgh.harvard.edu/fswiki/CoordinateSystems

% mri_info --vox2ras /usr/local/freesurfer/subjects/aliceIdan/mri/brain.mgz
Norig=[-1.00000    0.00000    0.00000  128.00000;0.00000 0.00000 1.00000 -128.00000;0.00000 -1.00000 0.00000  128.00000;0.00000 0.00000 0.00000 1.00000];
% mri_info --vox2ras-tkr /usr/local/freesurfer/subjects/aliceIdan/mri/brain.mgz
Torig=[-1.00000    0.00000    0.00000  128.00000;0.00000 0.00000 1.00000 -128.00000;0.00000 -1.00000 0.00000  128.00000;0.00000 0.00000 0.00000 1.00000];
% /usr/local/freesurfer/subjects/aliceIdan/mri/transforms/talairach.xfm
TalXFM=[1.076955 0.036432 0.052603 -1.595352;-0.102803 1.024217 -0.152002 -20.094635;-0.043021 0.125422 1.182905 -53.583435];% 

MNI305RAS = TalXFM*Norig*inv(Torig)*[tkrR tkrA tkrS 1]'

