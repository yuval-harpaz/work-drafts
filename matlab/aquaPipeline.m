aquaClean
aquaRTtp
aquaPower
aquaMarkers94H
pref='alpha';
aquaSAM(pref,'eyesClosed',cond)
aquaLogPtoZ('rest_a');aquaLogPtoZ('rest_b');
% run 3dMVMaqua in a terminal

% masktlrc('3dANOVA_pre+tlrc','3dANOVA_msk')
masktlrc('3dANOVA_3gr+tlrc',[],'Msk')
% cerebellum, inferior occipital, parietal, mid occipital, fusiform,
% precuneus, MTG (near TPJ), somatosensory, insula
vox=[-17 -72 -18;3 -72 -3; 33 -62 62; 51 -77 7;-52 -32 -23; -17 -67 27;-62 -47 7;21 -27 57;42 6 3];
% interaction
aquaDataVox;
% cd /media/Elements/quadaqua/SAM
%  xlwrite('leftOccipital.xls',table);

aquaCoh
aquaGAcohLR
load /media/Elements/quadaqua/Coh/GA
stat=statPlot(cohLRv2_aqua,cohLRv2_quad,[10 10],[0 1],'ttest2')
stat=statPlot(cohLRv2_aqua,cohLRv2_verb,[10 10],[0 1],'ttest2')

