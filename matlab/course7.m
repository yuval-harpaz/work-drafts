!cp /home/meg/SAM_BIU/docs/SuDi0811.rtw oddball.rtw

load oddball_data


% choose time of interest
cfg=[];
cfg.interactive='yes';
cfg.layout='4D248.lay';
figure;
ft_multiplotER(cfg,standard);

toi=[0.216239 0.301471];
close all

% for SAM we have to create a text file with the timing of the trials by
% condition,
% and we want a list of all the trials pulled together.
trl=data.cfg.trl;
trigTime=(trl(:,1)-trl(:,3))./1017.25;
Trig2mark(...
    'All',trigTime',...
    'Standard',trigTime(find(trl(:,4)==128),1)',...
    'Oddball',trigTime(find(trl(:,4)==64),1)',...
    'Novel',trigTime(find(trl(:,4)==32),1)');

fitMRI2hs('c,rfhp0.1Hz') 
hs2afni
% see that the headshape fits the MRI with AFNI
% if you have to nudge this is the time.

% for Nolte model proceed to these steps
!~/abin/3dSkullStrip -input warped+orig -prefix mask -mask_vol -skulls -o_ply ortho
!meshnorm ortho_brainhull.ply > hull.shape

%% param file
cd ..
createPARAM('allTrials','ERF','All',toi,'All',[(toi(1)-toi(2)) 0],[1 40],[-0.1 0.5],[],[],'MultiSphere');


% to run SAM you have to be one folder above the data
!SAMcov -r  oddball -d c,rfhp0.1Hz -m allTrials -v
!SAMwts -r  oddball -d c,rfhp0.1Hz -m allTrials -c Alla -v
!SAMerf -r  oddball -d c,rfhp0.1Hz -m allTrials -v
!cp oddball/SAM/*svl oddball/
% now see the image in afni




