cd /home/yuval/Data/OMEGA
DIR=dir('MNI*');
for subi=5:length(DIR)
    close all
    cd /home/yuval/Data/OMEGA
    sub=DIR(subi).name;
    cd(sub)
    if ~exist('hb2.fig','file')
        correctHB;
        saveas(1,'hb1.fig')
        saveas(2,'hb2.fig')
    end
    disp(['XXXXX ',num2str(subi),' XXXXX'])
    
end