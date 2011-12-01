%% creating epochs
% sub='MOI703';
source='xc,lf_c,rfhp0.1Hz';
% pat='/home/yuval/Desktop/moran';
% cd([pat,'/',sub])
trig=readTrig_BIU(source);
trig=clearTrig(trig);
trval=102;
time0=find(trig==trval);
epoched=time0+1017:1017:time0+240*1017.25;
cfg.dataset=source;
cfg.trialdef.poststim=2;
cfg.trialfun='trialfun_beg';
cfg1=[];
cfg1=ft_definetrial(cfg);
cfg1.trl(1:size(epoched,2),1)=epoched';
cfg1.trl(1:size(epoched,2),2)=epoched'+1017;
cfg1.trl(1:size(epoched,2),3)=0;
cfg1.channel={'MEG','-A74','-A204'}
%% reading high frequencies to find muscle artifact
cfg1.hpfilter='yes';cfg1.hpfreq=20;
data=ft_preprocessing(cfg1);
cfg2=[];
cfg2.method='summary'; %trial
cfg2.channel='MEG';
cfg2.alim=1e-12;
datacln=ft_rejectvisual(cfg2, data);
%% reading 4 to 80Hz for freq analysis
cfg1=rmfield(cfg1,{'hpfilter','hpfreq'});
cfg1.bpfilter='yes';cfg1.bpfreq=[1 83];
cfg1.trl=datacln.cfg.trl;
data=ft_preprocessing(cfg1);
save data data
cfg3            = [];
cfg3.output     = 'pow';
cfg3.method     = 'mtmfft';
cfg3.foilim     = [8 12];
cfg3.tapsmofrq  = 1;
cfg3.keeptrials = 'no';
%cfg.channel    = {'MEG' '-A204' '-A74'};
alpha=ft_freqanalysis(cfg3,data);
cfg4.interactive='yes';
ft_topoplotER(cfg4,alpha);
save alpha alpha

%% source localization
epoched=epoched/1017.25;
% eval(['cond',num2str(trval),'=epoched;']);
% 
% save trials cond*
Trig2mark('rest1',cond52,'press1',cond200,'press2',cond204,'press3',cond208,'press4',cond212,'rest2',cond54)
Trig2mark('rest1',epoched)
fitMRI2hs(source);
!~/abin/3dWarp -deoblique T.nii
hs2afni
% NOW NUDGE
!~/abin/3dSkullStrip -input warped+orig -prefix mask -mask_vol -skulls -o_ply ortho
!meshnorm ortho.ply > hull.shape
cd ..
MARK='alpha';Active='rest1';
createPARAM(MARK,'SPM',Active,[0 1],'',[],[7.5 13.5],[0 1],'Z-Test');
eval(['!SAMcov -r ',sub,' -d ',source,' -m ',MARK,' -v']);
eval(['!SAMwts -r ',sub,' -d ',source,' -m ',MARK,' -c ',Active,'a -v']);
eval(['!SAMspm -r ',sub,' -d ',source,' -m ',MARK,' -v']);
cd([sub,'/SAM']);system('cp rest*.svl ../');cd ../..

MARK='rest2_11';Active='rest2';
createPARAM(MARK,'SPM',Active,[0 1],'',[],[10.5 14.5],[0 1],'Z-Test');
eval(['!SAMcov -r ',sub,' -d ',source,' -m ',MARK,' -v']);
eval(['!SAMwts -r ',sub,' -d ',source,' -m ',MARK,' -c ',Active,'a -v']);
eval(['!SAMspm -r ',sub,' -d ',source,' -m ',MARK,' -v']);
cd([sub,'/SAM']);system('cp rest2*.svl ../');cd ../..

MARK='pressDiffp';Active='press1';Control='rest1';
createPARAM(MARK,'SPM',Active,[0 1],Control,[0 1],[10.5 14.5],[0 1],'Pseudo-Z');
eval(['!SAMcov -r ',sub,' -d ',source,' -m ',MARK,' -v']);
eval(['!SAMwts -r ',sub,' -d ',source,' -m ',MARK,' -c Sum -v']);
eval(['!SAMspm -r ',sub,' -d ',source,' -m ',MARK,' -v']);
cd([sub,'/SAM']);system('cp press*.svl ../');cd ../..


%~/Desktop/BP/15$ 3dcalc -a press1_11+orig -b rest1_11+orig -expr '100 *(a-b)/b ' -prefix percent_chng

% MARK='ERFemp';Active='Paina';
% eval(['!SAMcov -r ',sub,' -d ',source,' -m ',MARK,' -v']);
% eval(['!SAMwts -r ',sub,' -d ',source,' -m ',MARK,' -c ',Active,' -v']);
% eval(['!SAMerf -r ',sub,' -d ',source,' -m ',MARK,' -v']);
% 
% MARK='SPMemp';
% eval(['!SAMcov -r ',sub,' -d ',source,' -m ',MARK,' -v']);
% eval(['!SAMwts -r ',sub,' -d ',source,' -m ',MARK,' -c Sum -v']);
% eval(['!SAMspm -r ',sub,' -d ',source,' -m ',MARK,' -v']);
