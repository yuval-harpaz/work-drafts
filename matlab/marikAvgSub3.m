function marikAvgSub3
cd /home/yuval/Data/epilepsy/b023
[V,info]=BrikLoad('2/temp+orig');
clear V
cond={'sw'}
%ict=[10,23,15];
for foldi=2:4
    fold=num2str(foldi);
    for condi=1:length(cond)
        g2_=BrikLoad(['g2',cond{condi},fold,'+orig']);
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
% cd /home/yuval/Data/epilepsy/g2
% [V,info]=BrikLoad('~/Data/epilepsy/b022/ictus/g2_ictusAvg+orig');
% clear V
cond={'adapt'};
for foldi=2:4
    fold=num2str(foldi);
    for condi=1:length(cond)
        g2_=BrikLoad([cond{condi},fold,'+orig']);
        g2_p=mean(g2_(:,:,:,1:30),4);
        OptTSOut.Prefix = ['sw',fold,'AvgPI'];
        OptTSOut.Scale = 1;
        OptTSOut.verbose = 1;
        WriteBrik (g2_p, info,OptTSOut);
        g2_i=mean(g2_(:,:,:,31:end),4);
        OptTSOut.Prefix = ['sw',fold,'Avg'];
        WriteBrik (g2_i, info,OptTSOut);
    end
end
% cond={'seg','sw','all'};
% cd /home/yuval/Data/epilepsy/meanAbs/avg
% for foldi=1
%     fold=num2str(foldi);
%     for condi=1:3
%         g2_=BrikLoad(['/home/yuval/Data/epilepsy/meanAbs/Movies/b022_',cond{condi},fold,'+orig']);
%         g2_p=mean(g2_(:,:,:,1:30),4);
%         OptTSOut.Prefix = ['b022_',cond{condi},fold,'AvgPI'];
%         OptTSOut.Scale = 1;
%         OptTSOut.verbose = 1;
%         WriteBrik (g2_p, info,OptTSOut);
% %         g2_i=mean(g2_(:,:,:,31:end),4);
% %         OptTSOut.Prefix = ['b022_g2',cond{condi},fold,'Avg'];
% %         WriteBrik (g2_i, info,OptTSOut);
%     end
% end

