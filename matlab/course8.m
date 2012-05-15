cd oddball

% first we want a headmodel
% put debug points here: in headmodel_BIU at lines 119 (D.inv{1}...) and
% 131 (eval([tinpoints...). in ft_prepare_localspheres_mm in line 195(end)
% now run
[vol,grid,mesh,M1]=headmodel_BIU([],[],[],[],'localspheres');
save headmodel vol grid mesh M1
load ~/ft_BIU/matlab/files/sMRI.mat
mri_realign=sMRI;
mri_realign.transform=inv(M1)*sMRI.transform;
grid2t(grid);

load trl
trigTime=(trl(:,1)-trl(:,3))./1017.25;
Trig2mark(...
    'All',trigTime',...
    'Standard',trigTime(find(trl(:,4)==128),1)',...
    'Oddball',trigTime(find(trl(:,4)==64),1)',...
    'Novel',trigTime(find(trl(:,4)==32),1)');

toi=[0.043657 0.075163];

cd ..
createPARAM('allTrials','ERF','All',toi,'All',[(toi(1)-toi(2)) 0],[1 40],[-0.1 0.5],[],[],'MultiSphere');
!SAMcov -r oddball -d c,rfhp0.1Hz -m allTrials -v
!SAMwts -r oddball -d c,rfhp0.1Hz -m allTrials -c Alla -v
!SAMerf -r oddball -d c,rfhp0.1Hz -m allTrials -v -z 3
% view results
cd oddball
!cp SAM/*.svl ./
!~/abin/afni -dset warped+orig &

% make new weights based on individually fit grid (pnt.txt)
!cp pnt.txt SAM/pnt.txt
!SAMwts -r oddball -d c,rfhp0.1Hz -m allTrials -c Alla -t pnt.txt -v

cd oddball/SAM;
wtsNoSuf='pnt.txt';
[SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts');
filter=wts2filter(ActWgts,grid.inside,size(grid.outside,1));




%% messy below, don't look
 % this was calculated in course6 (auditory data)

cd oddball;
wtsNoSuf='SAM/allTrials,1-40Hz,Alla';
[SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts'); %sa
vox=[1.5,-5.5,5.5];
% lets visualize the weights used for source loc to this voxel
plotWeights(wtsNoSuf,vox)

% now we want a virtual sensor created for this voxel to be created for 2
% conditions
[voxi,allInd]=voxIndex(vox,100.*[...
    SAMHeader.XStart SAMHeader.XEnd ...
    SAMHeader.YStart SAMHeader.YEnd ...
    SAMHeader.ZStart SAMHeader.ZEnd],...
    100.*SAMHeader.StepSize,1);
wts=ActWgts(voxi,:);
vsSt=ActWgts(voxi,:)*standard.avg;

[vol,grid,mesh,M1]=headmodel_BIU([],[],[],[],'localspheres');
load ~/ft_BIU/matlab/files/sMRI.mat
mri_realign=sMRI;
mri_realign.transform=inv(M1)*sMRI.transform;

