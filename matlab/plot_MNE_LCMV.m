stcL=mne_read_stc_file('lcmv-lh.stc');
lhpialFN='/usr/local/freesurfer/subjects/maor1/surf/lh.pial';
[vertsL, ~] =mne_read_surface(lhpialFN);
XL=vertsL(stcL.vertices,1);
YL=vertsL(stcL.vertices,2);
ZL=vertsL(stcL.vertices,3);
CL=stcL.data(:,183);
stcR=mne_read_stc_file('lcmv-lh.stc');
rhpialFN='/usr/local/freesurfer/subjects/maor1/surf/rh.pial';
[vertsR, ~] =mne_read_surface(rhpialFN);
XR=vertsR(stcR.vertices,1);
YR=vertsR(stcR.vertices,2);
ZR=vertsR(stcR.vertices,3);
CR=stcR.data(:,183);
scatter3(XL,YL,ZL,[],CL,'filled')
hold on
scatter3(XR,YR,ZR,[],CR,'filled')

time=stcL.tmin:stcL.tstep:((size(stcL.data,2)-1)*stcL.tstep+stcL.tmin);
LM1ind=1624;
figure;plot(time,stcL.data(LM1ind,:))

%C=zeros(1,length(verts));
%C(stc.vertices)=stc.data(:,183);
%patch('Faces',faces,'Vertices',verts,'CData',C)

%[verts, faces] = mne_reduce_surface(lhpialFN,8193,'lhs')
%lh_pial_s=mne_read_surface('lhs');

%surfs= mne_read_surfaces('pial','True','True','True','maor1',...
%    '/usr/local/freesurfer/subjects','True');
