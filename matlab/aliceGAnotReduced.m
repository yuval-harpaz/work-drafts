function aliceGAnotReduced(file,loadOpt,sufix)
if ~exist('loadOpt','var')
    loadOpt='';
end
if isempty(loadOpt);
    loadOpt='avgNotReduced';
end
if ~exist('sufix','var')
    sufix='';
end
if isempty(sufix);
    sufix='NR';
end
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
    case 'alice'
        strE='';strM='';
        for subi=1:length(comps.C100)
            subStr=num2str(subi);
            subFold=sf{1,subi};
            cd (['/home/yuval/Data/alice/',subFold])
            load (loadOpt);
            avgEalice=avgE2;
            avgEalice.avg=zeros(size(avgE2.avg));
            avgMalice=avgM2;
            avgMalice.avg=zeros(size(avgM2.avg));
            for segi=[2 4 8 12 14 16] % 20 for WBW
                segStr=num2str(segi);
                eval(['avgEalice.avg=avgEalice.avg+avgE',segStr,'.avg']);
                eval(['avgMalice.avg=avgMalice.avg+avgM',segStr,'.avg']);
            end
            avgEalice.avg=avgEalice.avg./6;
            avgMalice.avg=avgMalice.avg./6;
            eval(['avgEalice',subStr,'=avgEalice;'])
            eval(['avgMalice',subStr,'=avgMalice;'])
            strE=[strE,',avgEalice',subStr];
            strM=[strM,',avgMalice',subStr];
        end
        cfg=[];
        cfg.keepindividual='yes';
        eval(['GavgEalice=ft_timelockgrandaverage(cfg',strE,');'])
        eval(['GavgMalice=ft_timelockgrandaverage(cfg',strM,');'])
        save (['/home/yuval/Copy/MEGdata/alice/ga/GavgMalice',sufix],'GavgMalice')
        save (['/home/yuval/Copy/MEGdata/alice/ga/GavgEalice',sufix],'GavgEalice')
        
    case '6101820'
        strE='';strM='';
        for segi=[6 10 18 20] % 20 for WBW
            for subi=1:length(comps.C100)
                subStr=num2str(subi);
                subFold=sf{1,subi};
                cd (['/home/yuval/Data/alice/',subFold])
                segStr=num2str(segi);
                if segi==20
                    load avgWbW
                    avgEalice=avgWbWeeg;
                    %                avgEalice.avg=zeros(size(avgE2.avg));
                    avgMalice=avgWbWmeg;
                    %avgMalice.avg=zeros(size(avgM2.avg));
                    
                    
                else
                    
                    load(loadOpt);
                    
                    eval(['avgEalice=avgE',segStr]);
                    eval(['avgMalice=avgM',segStr]);
                end
                
                %             avgEalice.avg=avgEalice.avg./6;
                %             avgMalice.avg=avgMalice.avg./6;
                
                eval(['avgEalice',subStr,'=avgEalice;'])
                eval(['avgMalice',subStr,'=avgMalice;'])
                strE=[strE,',avgEalice',subStr];
                strM=[strM,',avgMalice',subStr];
                
            end
            cfg=[];
            cfg.keepindividual='yes';
            eval(['GavgE',segStr,'=ft_timelockgrandaverage(cfg',strE,');'])
            eval(['GavgM',segStr,'=ft_timelockgrandaverage(cfg',strM,');'])
            save (['/home/yuval/Copy/MEGdata/alice/ga/GavgM',segStr,sufix],['GavgM',segStr])
            save (['/home/yuval/Copy/MEGdata/alice/ga/GavgE',segStr,sufix],['GavgE',segStr])
        end
    case '24812'
        strE='';strM='';
        for segi=[2 4 8 12] 
            for subi=1:length(comps.C100)
                subStr=num2str(subi);
                subFold=sf{1,subi};
                cd (['/home/yuval/Data/alice/',subFold])
                segStr=num2str(segi);
                load(loadOpt);
                eval(['avgEalice=avgE',segStr]);
                eval(['avgMalice=avgM',segStr]);
                eval(['avgEalice',subStr,'=avgEalice;'])
                eval(['avgMalice',subStr,'=avgMalice;'])
                strE=[strE,',avgEalice',subStr];
                strM=[strM,',avgMalice',subStr];
            end
            cfg=[];
            cfg.keepindividual='yes';
            eval(['GavgE',segStr,'=ft_timelockgrandaverage(cfg',strE,');'])
            eval(['GavgM',segStr,'=ft_timelockgrandaverage(cfg',strM,');'])
            save (['/home/yuval/Copy/MEGdata/alice/ga/GavgM',segStr,sufix],['GavgM',segStr])
            save (['/home/yuval/Copy/MEGdata/alice/ga/GavgE',segStr,sufix],['GavgE',segStr])
        end        
end
cd /home/yuval/Copy/MEGdata/alice/ga
