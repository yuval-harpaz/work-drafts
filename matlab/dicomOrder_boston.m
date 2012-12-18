ind=nan(285,1);
cd /autofs/space/shimshon_002/users/eiran/Yuval/sagit/cond1
for tri=1:285
    if exist(['sc',num2str(tri),'sl2.dcm'],'file') && exist(['sc',num2str(tri),'sl35.dcm'],'file')
        ind(tri)=1;
        info=dicominfo(['sc',num2str(tri),'sl1.dcm']);
        ind(tri,2)=info.SeriesNumber;
        ind(tri,3)=round(info.Private_0021_105e/10000);
    end
end
cd /autofs/space/shimshon_002/users/eiran/Yuval/sagit/cond0
for tri=1:285
    if exist(['sc',num2str(tri),'sl2.dcm'],'file') && exist(['sc',num2str(tri),'sl35.dcm'],'file')
        ind(tri)=0;
        info=dicominfo(['sc',num2str(tri),'sl1.dcm']);
        ind(tri,2)=info.SeriesNumber;
        ind(tri,3)=round(info.Private_0021_105e/10000);
    end
end

%%
cd /autofs/space/shimshon_002/users/eiran/Yuval/sagit
load dicomInd.mat
% dcmunpack -src VG_OE -targ vgoe -run 5 bold nii f.nii -run 6 bold nii f.nii -run 7 bold nii f.nii
runs=unique(ind(:,2))';
for runi=[6 7];%runs
    runind=ind(ind(:,2)==runi,:);
    d=diff(ind(:,1));
    trlim=find(abs(d));
    TRs=length(trlim)+1;
    trlim(2:TRs)=trlim;trlim(1)=0;
    trlim=trlim+1;
    veci=0;
    vec=[];
    for linei=1:TRs
        veci=veci+1;
        vec(veci)=ind(trlim(linei),3);
        veci=veci+1;
        vec(veci)=20;
        veci=veci+1;
        vec(veci)=ind(trlim(linei),1)+1;
        veci=veci+1;
        vec(veci)=1;
    end
    fileID=fopen(['VG.par',num2str(runi)],'w')
    fprintf(fileID,'%d\t%d\t%d\t%d\n',vec)
    fclose(fileID)
end
cd ..
!cp VG_OE/VG.par5 vgoe/bold/005/VG.par
!cp VG_OE/VG.par6 vgoe/bold/006/VG.par
!cp VG_OE/VG.par7 vgoe/bold/007/VG.par