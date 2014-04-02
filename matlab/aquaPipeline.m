aquaClean
aquaRTtp
aquaPower
aquaMarkers94H
pref='alpha';
aquaSAM(pref,'eyesClosed',cond)
aquaLogPtoZ('rest_a');aquaLogPtoZ('rest_b');
% run 3dMVMaqua in a terminal
masktlrc('3dANOVA_pre+tlrc','3dANOVA_msk')
% interaction
table=aquaDataVox([-22.5 -67.5 12.5]);
cd /media/Elements/quadaqua/SAM
 xlwrite('leftOccipital.xls',table);
table=aquaDataVox([23 48 22]);
cd /media/Elements/quadaqua/SAM
xlwrite('rightPreFrontal.xls',table); 
table=aquaDataVox([-32 23 57]);
cd /media/Elements/quadaqua/SAM
xlwrite('leftMidFrontal.xls',table);
% group
table=aquaDataVox([7 42 48]);
cd /media/Elements/quadaqua/SAM
xlwrite('leftTonsil.xls',table);
% visit
table=aquaDataVox([53 -67 17]);
cd /media/Elements/quadaqua/SAM
xlwrite('rightMidTempGyrus.xls',table);
table=aquaDataVox([-37 8 47]);
cd /media/Elements/quadaqua/SAM
xlwrite('leftMidFrontalVISIT.xls',table);



