% animalsCln
fi=12;
cd /home/yuval/Data/Amyg
fldr=num2str(fi);
cd(fldr)
fileName='c,rfhp0.1Hz';
p=pdf4D(fileName);
cleanCoefs = createCleanFile_fhb(p, fileName,'byLF',0,'byFFT',0,'HeartBeat',[]);
title(['sub ',fldr])
cd ..

