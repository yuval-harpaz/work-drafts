function fsLRpairs_subj_sym(subj)

subj='aliceIdan';
cd(['/usr/local/freesurfer/subjects/',subj,'/xhemi/surf'])
pial.lh=mne_read_surface('/usr/local/freesurfer/subjects/fsaverage_sym/surf/lh.pial');
pial.rh=mne_read_surface('/usr/local/freesurfer/subjects/fsaverage_sym/surf/rh.pial');

sphere.lh=mne_read_surface('/usr/local/freesurfer/subjects/fsaverage_sym/surf/lh.sphere.left_right');
sphere.rh=mne_read_surface('/usr/local/freesurfer/subjects/fsaverage_sym/surf/rh.sphere.left_right');
pial.lh=mne_read_surface('/usr/local/freesurfer/subjects/fsaverage_sym/surf/lh.pial');
pial.rh=mne_read_surface('/usr/local/freesurfer/subjects/fsaverage_sym/surf/rh.pial');

plot3pnt([pial.lh;pial.rh],'.k')
hold on
plot3pnt([pial.lh(1,:);pial.rh(1,:)],'^r')


for srci=1:10242
    [~,lPair(srci)]=min(sum(abs(sphere.lh-repmat(sphere.rh(srci,:),length(sphere.lh),1)),2));
    prog(srci)
end
plot3pnt(pial.lh(i,:),'^g')

scatter3pnt([pial.lh(lPair,:);pial.rh(1:10242,:)],10,[1:10242,1:10242])
rPair=1:10242;
save /usr/local/freesurfer/subjects/fsaverage_sym/surf/pairs lPair rPair
%lh.reg=mne_read_surface('lh.fsaverage_sym.sphere.reg');
% 
% 
% lh.pial=mne_read_surface('/usr/local/freesurfer/subjects/aliceIdan/surf/lh.pial');
% rh.pial=mne_read_surface('/usr/local/freesurfer/subjects/aliceIdan/surf/rh.pial');
% xhemilh.pial=mne_read_surface('/usr/local/freesurfer/subjects/aliceIdan/xhemi/surf/lh.pial');
% xhemirh.pial=mne_read_surface('/usr/local/freesurfer/subjects/aliceIdan/xhemi/surf/rh.pial');
