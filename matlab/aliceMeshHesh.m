function aliceMeshHesh(subject,fig)
if ~exist('fig','var')
    fig=false;
end
subjectFS=['alice',upper(subject(1)),subject(2:end)];
cd (['/usr/local/freesurfer/subjects/',subjectFS,'/bem'])
bnd = ft_read_headshape([subjectFS,'-5-src.fif'], 'format', 'mne_source');
cd (['/home/yuval/Copy/MEGdata/alice/',subject])
hs=ft_read_headshape('hs_file')
bndPRI.pnt(:,1)=bnd.orig.pnt(:,2);
bndPRI.pnt(:,2)=-bnd.orig.pnt(:,1);
bndPRI.pnt(:,3)=bnd.orig.pnt(:,3);
if fig
    figure;ft_plot_mesh(bndPRI);
    hold on
    plot3pnt(hs.pnt,'g.');
end
% make SUMA surface
tri=ones(length(bnd.orig.tri),1);
tri(:,2)=3;
tri(:,3:5)=bnd.orig.tri-1; % 1st index in .ply is zero
cd MRI
disp('writing header')
!echo ply > FS.ply
!echo format ascii 1.0 >> FS.ply
!echo comment author: Yuval Harpaz >> FS.ply
!echo obj_info random information >> FS.ply
eval(['!echo element vertex ',num2str(length(bndPRI.pnt)),' >> FS.ply'])
!echo property float x >> FS.ply
!echo property float y >> FS.ply
!echo property float z >> FS.ply
eval(['!echo element face ',num2str(length(tri)),' >> FS.ply'])
!echo property uchar intensity >> FS.ply
!echo property list uchar int vertex_indices >> FS.ply
!echo end_header >> FS.ply
pnt=1000*bndPRI.pnt; % m to mm
pnt(:,1)=1000*bndPRI.pnt(:,2); % PRI to RAI
pnt(:,2)=-1000*bndPRI.pnt(:,1);

disp('writing pnt')
dlmwrite('FS.ply', pnt, '-append','delimiter', ' ','precision', 6); 
disp('writing tri')
dlmwrite('FS.ply', tri, '-append', 'delimiter', ' ','precision', 6); 
% if ~exist('bndPRI','file')
%     save bndPRI bndPRI
% end

!~/abin/afni -niml -dset ortho+orig &
!~/abin/suma -niml -i_ply FS.ply -sv ortho+orig -novolreg

% !mne_setup_source_space --subject $1 --spacing 5 --surface pial

