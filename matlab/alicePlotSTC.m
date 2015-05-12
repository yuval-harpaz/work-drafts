function alicePlotSTC(subj,fileName,timeWin)
%fileName='fsaverage_wbw-meg-lh.stc';
%subj='ohad';
%timeWin=[0.075 0.125];
%sf={'idan','inbal','liron','maor','mark','odelia','ohad','yoni'};

    %Subj=['alice',upper(subj(1)),subj(2:end)];
    if strcmp(fileName(end-3:end),'.stc')
        fileName=fileName(1:end-7);
    elseif strcmp(fileName(end-1:end),'lh') || strcmp(fileName(end-1:end),'rh')
        fileName=fileName(1:end-3);
    end
    
    cd /usr/local/freesurfer/subjects/fsaverage/surf
    fsapialL=mne_read_surface('lh.pial');
    fsapialL=fsapialL(1:10242,:);
    fsapialR=mne_read_surface('rh.pial');
    fsapialR=fsapialR(1:10242,:);
    cd /home/yuval/Copy/MEGdata/alice
    cd (subj)
    cd MNE
    L=mne_read_stc_file([fileName,'-lh.stc']);
    R=mne_read_stc_file([fileName,'-rh.stc']);
    tmax=L.tmin+L.tstep*(size(L.data,2)-1);
    time=L.tmin:L.tstep:tmax;
    s1=nearest(time,timeWin(1));
    s2=nearest(time,timeWin(2));
    CL=mean(L.data(:,s1:s2),2);
    CR=mean(R.data(:,s1:s2),2);
    figure;
    scatter3(fsapialL(:,1),fsapialL(:,2),fsapialL(:,3),10,CL)
    hold on
    scatter3(fsapialR(:,1),fsapialR(:,2),fsapialR(:,3),10,CR)
    view([-90,0])
    
    %     mm=minmax([fsapialL',fsapialR']);
    %     mmm=mean(mm');
    lims=[-0.0994215431213379,-0.117807010650635,-0.0844370288848877;0.100578456878662,0.0821929893493652,0.115562971115112;]
    xlim(lims(:,1))
    ylim(lims(:,2))
    zlim(lims(:,3))
    axis vis3d
    rotate3d
end