%cd /home/yuval/Data/epilepsy/g2/avg
[V,info]=BrikLoad('/home/yuval/Data/epilepsy/g2/avg/common+orig');
clear V
cond={'seg','sw','all'};
cd /home/yuval/Data/epilepsy/meanAbs/avg
for foldi=1:3
    fold=num2str(foldi);
    for condi=1:length(cond)
        MA_=BrikLoad(['/home/yuval/Data/epilepsy/meanAbs/Movies/',cond{condi},fold,'+orig']);
        MA_p=mean(MA_(:,:,:,1:30),4);
        OptTSOut.Prefix = [cond{condi},fold,'AvgPI'];
        OptTSOut.Scale = 1;
        OptTSOut.verbose = 1;
        WriteBrik (MA_p, info,OptTSOut);
        MA_i=mean(MA_(:,:,:,31:end),4);
        OptTSOut.Prefix = [cond{condi},fold,'Avg'];
        WriteBrik (MA_i, info,OptTSOut);
    end
end