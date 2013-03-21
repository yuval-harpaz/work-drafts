%% use SAMwts with fieldtrip
% make a text file with grid points
% here the grid points are 10mm spaced on template. the spacing is modified
% for each subject




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
% make new weights based on individually fit grid (pnt.txt)
% this works only after SAMcov (course7)
cd ..
!cp pnt.txt SAM/pnt.txt
!SAMwts -r oddball -d c,rfhp0.1Hz -m allTrials -c Alla -t pnt.txt -v


cd oddball/SAM;
wtsNoSuf='pnt.txt';
[SAMHeader, ActIndex, ActWgts]=readWeights([wtsNoSuf,'.wts']);
save([wtsNoSuf,'.mat'],'SAMHeader', 'ActIndex', 'ActWgts');
filter=wts2filter(ActWgts,grid.inside,size(grid.outside,1));
cd ../
load data
dataSt=data;
trli=find(data.trialinfo==128);
dataSt.trial=data.trial(1,trli);
dataSt.time=data.time(1,trli);
dataStAvg=ft_timelockanalysis([],dataSt);
timewin=[0.043657 0.075163];

% use weights from SAM (Dr. Robinson's) to make images with fieldtrip
sourceTest=OBbeamform(dataSt,timewin,'SAM',mri_realign,filter)
% make similar weights from raw data with fieldtrip version of SAM.
% multiply by averaged data, like SAMerf
sourceTest=OBbeamform(dataSt,timewin,'sam',mri_realign)
% compute weights on averaged data. Dr. Robinson won't approve.
sourceTest=OBbeamform(dataStAvg,timewin,'sam',mri_realign)
