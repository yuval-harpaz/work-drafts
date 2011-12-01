
trl=reindex(datacln.cfg.previous.trl,datacln.cfg.trl);
NoPain=trl(find(trl(:,4)==240 |trl(:,4)==222),1)./1017.25;
Pain=trl(find(trl(:,4)==230 |trl(:,4)==250),1)./1017.25;
Trig2mark('Pain',Pain','NoPain',NoPain');
fitMRI2hs('c,rfhp0.1Hz');
!~/abin/3dWarp -deoblique T.nii
hs2afni
% NOW NUDGE
!~/abin/3dSkullStrip -input warped+orig -prefix mask -mask_vol -skulls -o_ply ortho
!meshnorm -r0 ortho.ply > hull.shape
RUN='MOI703';DATA='c,rfhp0.1Hz';COV='Global';MARK='ERFemp';Active='Paina';
eval(['!SAMcov -r ',RUN,' -d ',DATA,' -m ',MARK,' -v']);
eval(['!SAMwts -r ',RUN,' -d ',DATA,' -m ',MARK,' -c ',Active,' -v']);
eval(['!SAMerf -r ',RUN,' -d ',DATA,' -m ',MARK,' -v']);

MARK='SPMemp';
eval(['!SAMcov -r ',RUN,' -d ',DATA,' -m ',MARK,' -v']);
eval(['!SAMwts -r ',RUN,' -d ',DATA,' -m ',MARK,' -c Sum -v']);
eval(['!SAMspm -r ',RUN,' -d ',DATA,' -m ',MARK,' -v']);
