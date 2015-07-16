
load /usr/local/freesurfer/subjects/fsaverage_sym/surf/pairs lPair rPair
%lh.reg=mne_read_surface('lh.fsaverage_sym.sphere.reg');

sphere.lh=mne_read_surface('/usr/local/freesurfer/subjects/fsaverage_sym/surf/lh.sphere');
sphere.rh=mne_read_surface('/usr/local/freesurfer/subjects/fsaverage_sym/surf/rh.sphere');
sf={'idan','inbal','liron','maor','mark','odelia','ohad','yoni'};
for subi=1:8
    if ~exist(['/home/yuval/Copy/MEGdata/alice/',sf{subi},'/LRi.mat'],'file')
        subj=['alice',sf{subi}];
        subj(6)=upper(subj(6));
        subSphere.lh=mne_read_surface(['/usr/local/freesurfer/subjects/',subj,'/surf/lh.sphere']);
        subSphere.rh=mne_read_surface(['/usr/local/freesurfer/subjects/',subj,'/surf/rh.sphere']);
        clear li ri
        %[v,i]=min(sum(abs(sphere.rh-repmat(subSphere.rh(1,:),length(sphere.lh),1)),2));
        for srci=1:10242
            [~,ri(srci)]=min(sum(abs(subSphere.rh-repmat(sphere.rh(srci,:),length(subSphere.rh),1)),2));
            [~,li(srci)]=min(sum(abs(subSphere.lh-repmat(sphere.lh(lPair(srci),:),length(subSphere.lh),1)),2));
            prog(srci)
        end
        disp(' ');
        if length(unique(li))<10242
            disp([subj,' has ',num2str(10242-length(unique(li))),' repeting matches for LH'])
        end
        if length(unique(ri))<10242
            disp([subj,' has ',num2str(10242-length(unique(ri))),' repeting matches for RH'])
        end
        save (['/home/yuval/Copy/MEGdata/alice/',sf{subi},'/LRi.mat'],'li','ri')
    end
end
% lh.pial=mne_read_surface('/usr/local/freesurfer/subjects/aliceIdan/surf/lh.pial');
% rh.pial=mne_read_surface('/usr/local/freesurfer/subjects/aliceIdan/surf/rh.pial');
%
% pnti=2000;
% plot3pnt(lh.pial(li(pnti),:),'^r')
% hold on
% plot3pnt(rh.pial(ri(pnti),:),'^r')
% scatter3pnt([lh.pial;rh.pial],10,'k')

