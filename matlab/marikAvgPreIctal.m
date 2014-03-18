function marikAvgPreIctal
cd /home/yuval/Data/epilepsy/g2/avg
[V,info]=BrikLoad('common+orig');
clear V
cond={'seg','sw','_'}
for foldi=1:3
    fold=num2str(foldi);
    for condi=1:3
        g2_=BrikLoad(['/home/yuval/Data/epilepsy/g2/movies/g2',cond{condi},fold,'+orig']);
        g2_p=mean(g2_(:,:,:,1:30),4);
        OptTSOut.Prefix = ['g2',cond{condi},fold,'AvgPI'];
        OptTSOut.Scale = 1;
        OptTSOut.verbose = 1;
        WriteBrik (g2_p, info,OptTSOut);
        g2_i=mean(g2_(:,:,:,31:end),4);
        OptTSOut.Prefix = ['g2',cond{condi},fold,'Avg'];
        WriteBrik (g2_i, info,OptTSOut);
    end
end
% [V,info]=BrikLoad('old/b022_g2_Avg+orig');
% clear V
% fold='1';
% for condi=1:3
%     g2_=BrikLoad(['/home/yuval/Data/epilepsy/g2/movies/b022_g2',cond{condi},fold,'+orig']);
%     g2_p=mean(g2_(:,:,:,1:30),4);
%     OptTSOut.Prefix = ['g2',cond{condi},fold,'AvgPI'];
%     OptTSOut.Scale = 1;
%     OptTSOut.verbose = 1;
%     WriteBrik (g2_p, info,OptTSOut);
%     g2_i=mean(g2_(:,:,:,31:end),4);
%     OptTSOut.Prefix = ['g2',cond{condi},fold,'Avg'];
%     WriteBrik (g2_i, info,OptTSOut);
% end
cd /home/yuval/Data/epilepsy/g2
[V,info]=BrikLoad('~/Data/epilepsy/b022/ictus/g2_ictusAvg+orig');
clear V
cond={'seg','sw','_'};
for foldi=1
    fold=num2str(foldi);
    for condi=1:3
        g2_=BrikLoad(['/home/yuval/Data/epilepsy/g2/movies/b022_g2',cond{condi},fold,'+orig']);
        g2_p=mean(g2_(:,:,:,1:30),4);
        OptTSOut.Prefix = ['b022_g2',cond{condi},fold,'AvgPI'];
        OptTSOut.Scale = 1;
        OptTSOut.verbose = 1;
        WriteBrik (g2_p, info,OptTSOut);
        g2_i=mean(g2_(:,:,:,31:end),4);
        OptTSOut.Prefix = ['b022_g2',cond{condi},fold,'Avg'];
        WriteBrik (g2_i, info,OptTSOut);
    end
end
cond={'seg','sw','all'};
cd /home/yuval/Data/epilepsy/meanAbs/avg
for foldi=1
    fold=num2str(foldi);
    for condi=1:3
        g2_=BrikLoad(['/home/yuval/Data/epilepsy/meanAbs/Movies/b022_',cond{condi},fold,'+orig']);
        g2_p=mean(g2_(:,:,:,1:30),4);
        OptTSOut.Prefix = ['b022_',cond{condi},fold,'AvgPI'];
        OptTSOut.Scale = 1;
        OptTSOut.verbose = 1;
        WriteBrik (g2_p, info,OptTSOut);
%         g2_i=mean(g2_(:,:,:,31:end),4);
%         OptTSOut.Prefix = ['b022_g2',cond{condi},fold,'Avg'];
%         WriteBrik (g2_i, info,OptTSOut);
    end
end

