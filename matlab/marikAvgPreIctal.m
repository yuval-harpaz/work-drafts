function marikAvgPreIctal
cd /home/yuval/Data/epilepsy/b162b
[V,info]=BrikLoad('1/old/91g2+orig');
clear V
cond={'seg','sw','_'}
for foldi=1:3
    fold=num2str(foldi);
    cd (fold)
    for condi=2%:3
        g2_=BrikLoad(['/home/yuval/Data/epilepsy/g2/movies/g2',cond{condi},fold,'+orig']);
        g2_=mean(g2_(:,:,:,1:30),4);
        OptTSOut.Prefix = ['g2',cond{condi},fold,'AvgPI'];
        OptTSOut.Scale = 1;
        OptTSOut.verbose = 1;
        WriteBrik (g2_, info,OptTSOut);
        copyfile(['g2',cond{condi},fold,'AvgPI+orig.BRIK'],'/home/yuval/Data/epilepsy/g2/avg/')
        copyfile(['g2',cond{condi},fold,'AvgPI+orig.HEAD'],'/home/yuval/Data/epilepsy/g2/avg/')
    end
    cd ..
end