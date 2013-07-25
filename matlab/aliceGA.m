function aliceGA(file)

% 2 seg1.bmp
% 4 seg3.bmp	1
% 6 news.bmp	1
% 8 seg4.bmp	1
% 10 tamil.bmp	1
% 12 seg5.bmp	1
% 14 seg6.bmp	1
% 16 seg7.bmp	1
% 18 seg8.bmp	1 (loud)
% 20 break
% 50 words

cd /home/yuval/Copy/MEGdata/alice
load comps

switch file
    case 'LR'
        for segi=[2:2:20] % 20 for WBW
            strE='';strM='';
            segStr=num2str(segi);
            for subi=1:length(comps.C100)
                subStr=num2str(subi);
                subFold=sf{1,subi};
                cd (['/home/yuval/Data/alice/',subFold])
                load avgLR
                eval(['avgE',segStr,'LR',subStr,'=avgE',segStr,'LR;'])
                strE=[strE,',avgE',segStr,'LR',subStr];
                eval(['avgM',segStr,'LR',subStr,'=avgM',segStr,'LR;'])
                strM=[strM,',avgM',segStr,'LR',subStr];
            end
            cfg=[];
            cfg.keepindividual='yes';
            eval(['GavgE',segStr,'LR=ft_timelockgrandaverage(cfg',strE,');'])
            eval(['GavgM',segStr,'LR=ft_timelockgrandaverage(cfg',strM,');'])
            save(['/home/yuval/Copy/MEGdata/alice/ga/GavgE',segStr,'LR'],['GavgE',segStr,'LR']);
            save(['/home/yuval/Copy/MEGdata/alice/ga/GavgM',segStr,'LR'],['GavgM',segStr,'LR']);
            
            %figure;
            %             cfg=[];
            %             cfg.xlim=[0.17 0.17];
            %             cfg.layout='WG32.lay';
            %ft_topoplotER(cfg,GavgE2_4LR);
            
        end
    case 'LRalice'
        strE='';strM='';
        for subi=1:length(comps.C100)
            subStr=num2str(subi);
            subFold=sf{1,subi};
            cd (['/home/yuval/Data/alice/',subFold])
            load avgLR
            avgEaliceLR=avgE2LR;
            avgEaliceLR.avg=zeros(size(avgE2LR.avg));
            avgMaliceLR=avgM2LR;
            avgMaliceLR.avg=zeros(size(avgM2LR.avg));
            for segi=[2 4 8 12 14 16] % 20 for WBW
                segStr=num2str(segi);
                eval(['avgEaliceLR.avg=avgEaliceLR.avg+avgE',segStr,'LR.avg']);
                eval(['avgMaliceLR.avg=avgMaliceLR.avg+avgM',segStr,'LR.avg']);
            end
            avgEaliceLR.avg=avgEaliceLR.avg./6;
            avgMaliceLR.avg=avgMaliceLR.avg./6;
            eval(['avgEaliceLR',subStr,'=avgEaliceLR;'])
            eval(['avgMaliceLR',subStr,'=avgMaliceLR;'])
            strE=[strE,',avgEaliceLR',subStr];
            strM=[strM,',avgMaliceLR',subStr];
        end
        cfg=[];
        cfg.keepindividual='yes';
        eval(['GavgEaliceLR=ft_timelockgrandaverage(cfg',strE,');'])
        eval(['GavgMaliceLR=ft_timelockgrandaverage(cfg',strM,');'])
        save /home/yuval/Copy/MEGdata/alice/ga/GavgMaliceLR GavgMaliceLR
        save /home/yuval/Copy/MEGdata/alice/ga/GavgEaliceLR GavgEaliceLR
end
