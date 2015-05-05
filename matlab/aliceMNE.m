cd /home/yuval/Copy/MEGdata/alice/MNE

trig=readTrig_BIU;
plot(trig)
trig=bitand(uint16(trig),2048);
rewriteTrig(source,trig,'tf')
system('python aliceTF.py')
