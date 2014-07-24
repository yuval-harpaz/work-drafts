

marikSAM([920 952],'2','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b_318');

marikSAM_g2([920 952],'2','c,rfhp1.0Hz','/home/yuval/Data/epilepsy/b_318');
cd /home/yuval/Data/epilepsy/b_318
[V,info]=BrikLoad('maskRS+orig');
clear V
cond={'all2','g2_2'};
%ict=[10,23,15];

for condi=1:length(cond)
    color=BrikLoad([cond{condi},'+orig']);
    colorp=mean(color(:,:,:,1:15),4);
    OptTSOut.Prefix = [cond{condi},'AvgPI'];
    OptTSOut.Scale = 1;
    OptTSOut.verbose = 1;
    WriteBrik (colorp, info,OptTSOut);
    colori=mean(color(:,:,:,16:end),4);
    OptTSOut.Prefix = [cond{condi},'Avg'];
    WriteBrik (colori, info,OptTSOut);
end
