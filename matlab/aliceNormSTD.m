function aliceNormSTD(prefix)
for subi=1:8
    eval(['!~/abin/3dBrickStat -var ',prefix,'_',num2str(subi),'+tlrc > var.txt'])
    stdev=sqrt(importdata('var.txt'));
    eval(['!~/abin/3dcalc -prefix ',prefix,'N_',num2str(subi),' -a ',prefix,'_',num2str(subi),'+tlrc -exp ''','a/',num2str(stdev),''' '])
end