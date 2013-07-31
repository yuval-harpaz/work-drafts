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
    case 'frLR'
        for segi=[2:2:18,100,102] % 20 for WBW
            strE='';strM='';
            segStr=num2str(segi);
            for subi=1:length(comps.C100)
                subStr=num2str(subi);
                subFold=sf{1,subi};
                cd (['/home/yuval/Data/alice/',subFold])
                load fr
                eval(['frE',segStr,'LR',subStr,'=eegLR',segStr,';'])
                strE=[strE,',frE',segStr,'LR',subStr];
                eval(['frM',segStr,'LR',subStr,'=megLR',segStr,';'])
                strM=[strM,',frM',segStr,'LR',subStr];
            end
            cfg=[];
            cfg.keepindividual='yes';
            eval(['GavgFrE',segStr,'LR=ft_freqgrandaverage(cfg',strE,');'])
            eval(['GavgFrM',segStr,'LR=ft_freqgrandaverage(cfg',strM,');'])
            save(['/home/yuval/Copy/MEGdata/alice/ga/GavgFrE',segStr,'LR'],['GavgFrE',segStr,'LR']);
            save(['/home/yuval/Copy/MEGdata/alice/ga/GavgFrM',segStr,'LR'],['GavgFrM',segStr,'LR']);
        end
    case 'frLRalice'
        strE='';strM='';
        for subi=1:length(comps.C100)
            subStr=num2str(subi);
            subFold=sf{1,subi};
            cd (['/home/yuval/Data/alice/',subFold])
            load fr
            avgEaliceLR=eegLR2;
            avgEaliceLR.powspctrm=zeros(size(eegLR2.powspctrm));
            avgMaliceLR=megLR2;
            avgMaliceLR.powspctrm=zeros(size(megLR2.powspctrm));
            for segi=[2 4 8 12 14 16]
                segStr=num2str(segi);
                eval(['avgEaliceLR.powspctrm=avgEaliceLR.powspctrm+eegLR',segStr,'.powspctrm']);
                eval(['avgMaliceLR.powspctrm=avgMaliceLR.powspctrm+megLR',segStr,'.powspctrm']);
            end
            avgEaliceLR.powspctrm=avgEaliceLR.powspctrm./6;
            avgMaliceLR.powspctrm=avgMaliceLR.powspctrm./6;
            eval(['frEaliceLR',subStr,'=avgEaliceLR;'])
            eval(['frMaliceLR',subStr,'=avgMaliceLR;'])
            strE=[strE,',frEaliceLR',subStr];
            strM=[strM,',frMaliceLR',subStr];
        end
        cfg=[];
        cfg.keepindividual='yes';
        eval(['GavgFrEaliceLR=ft_freqgrandaverage(cfg',strE,');'])
        eval(['GavgFrMaliceLR=ft_freqgrandaverage(cfg',strM,');'])
        save /home/yuval/Copy/MEGdata/alice/ga/GavgFrMaliceLR GavgFrMaliceLR
        save /home/yuval/Copy/MEGdata/alice/ga/GavgFrEaliceLR GavgFrEaliceLR
        
    case 'frLRrest'
        strE='';strM='';
        for subi=1:length(comps.C100)
            subStr=num2str(subi);
            subFold=sf{1,subi};
            cd (['/home/yuval/Data/alice/',subFold])
            load fr
            avgErestLR=eegLR100;
            avgErestLR.powspctrm=(eegLR100.powspctrm+eegLR102.powspctrm)./2;
            avgMrestLR=megLR100;
            avgMrestLR.powspctrm=(megLR100.powspctrm+megLR102.powspctrm)./2;
            eval(['frErestLR',subStr,'=avgErestLR;'])
            eval(['frMrestLR',subStr,'=avgMrestLR;'])
            strE=[strE,',frErestLR',subStr];
            strM=[strM,',frMrestLR',subStr];
        end
        cfg=[];
        cfg.keepindividual='yes';
        eval(['GavgFrErestLR=ft_freqgrandaverage(cfg',strE,');'])
        eval(['GavgFrMrestLR=ft_freqgrandaverage(cfg',strM,');'])
        save /home/yuval/Copy/MEGdata/alice/ga/GavgFrMrestLR GavgFrMrestLR
        save /home/yuval/Copy/MEGdata/alice/ga/GavgFrErestLR GavgFrErestLR
    case 'fr'
        for segi=[2:2:20,100,102] % 20 for WBW
            strE='';strM='';
            if segi==20
                segStr='WBW';
                loadStr=segStr;
            else
                loadStr='';
            end
            segStr=num2str(segi);
            for subi=1:length(comps.C100)
                subStr=num2str(subi);
                subFold=sf{1,subi};
                cd (['/home/yuval/Data/alice/',subFold])
                load(['fr',loadStr])
                if segi==20
                    eval(['frE',segStr,'_',subStr,'=eegFr',loadStr,';'])
                    eval(['frM',segStr,'_',subStr,'=megFr',loadStr,';'])
                else
                    eval(['frE',segStr,'_',subStr,'=eegFr',segStr,';'])
                    eval(['frM',segStr,'_',subStr,'=megFr',segStr,';'])
                end
                strE=[strE,',frE',segStr,'_',subStr];
                strM=[strM,',frM',segStr,'_',subStr];
            end
            cfg=[];
            cfg.keepindividual='yes';
            eval(['GavgFrE',segStr,'=ft_freqgrandaverage(cfg',strE,');'])
            eval(['GavgFrM',segStr,'=ft_freqgrandaverage(cfg',strM,');'])
            save(['/home/yuval/Copy/MEGdata/alice/ga/GavgFrE',segStr],['GavgFrE',segStr]);
            save(['/home/yuval/Copy/MEGdata/alice/ga/GavgFrM',segStr],['GavgFrM',segStr]);
            
            
            %figure;
            %             cfg=[];
            %             cfg.xlim=[0.17 0.17];
            %             cfg.layout='WG32.lay';
            %ft_topoplotER(cfg,GavgE2_4LR);
            
        end
    case 'frRest'
        strE='';strM='';
        for subi=1:length(comps.C100)
            subStr=num2str(subi);
            subFold=sf{1,subi};
            cd (['/home/yuval/Data/alice/',subFold])
            load fr
            avgErest=eegFr100;
            avgErest.powspctrm=(eegFr100.powspctrm+eegFr102.powspctrm)./2;
            avgMrest=megFr100;
            avgMrest.powspctrm=(megFr100.powspctrm+megFr102.powspctrm)./2;
            eval(['frErest',subStr,'=avgErest;'])
            eval(['frMrest',subStr,'=avgMrest;'])
            strE=[strE,',frErest',subStr];
            strM=[strM,',frMrest',subStr];
        end
        cfg=[];
        cfg.keepindividual='yes';
        eval(['GavgFrErest=ft_freqgrandaverage(cfg',strE,');'])
        eval(['GavgFrMrest=ft_freqgrandaverage(cfg',strM,');'])
        save /home/yuval/Copy/MEGdata/alice/ga/GavgFrMrest GavgFrMrest
        save /home/yuval/Copy/MEGdata/alice/ga/GavgFrErest GavgFrErest
    case 'frAlice'
        strE='';strM='';
        for subi=1:length(comps.C100)
            subStr=num2str(subi);
            subFold=sf{1,subi};
            cd (['/home/yuval/Data/alice/',subFold])
            load fr
            avgEalice=eegFr2;
            avgEalice.powspctrm=zeros(size(eegFr2.powspctrm));
            avgMalice=megFr2;
            avgMalice.powspctrm=zeros(size(megFr2.powspctrm));
            for segi=[2 4 8 12 14 16]
                segStr=num2str(segi);
                eval(['avgEalice.powspctrm=avgEalice.powspctrm+eegFr',segStr,'.powspctrm']);
                eval(['avgMalice.powspctrm=avgMalice.powspctrm+megFr',segStr,'.powspctrm']);
            end
            avgEalice.powspctrm=avgEalice.powspctrm./6;
            avgMalice.powspctrm=avgMalice.powspctrm./6;
            eval(['frEalice',subStr,'=avgEalice;'])
            eval(['frMalice',subStr,'=avgMalice;'])
            strE=[strE,',frEalice',subStr];
            strM=[strM,',frMalice',subStr];
        end
        cfg=[];
        cfg.keepindividual='yes';
        eval(['GavgFrEalice=ft_freqgrandaverage(cfg',strE,');'])
        eval(['GavgFrMalice=ft_freqgrandaverage(cfg',strM,');'])
        save /home/yuval/Copy/MEGdata/alice/ga/GavgFrMalice GavgFrMalice
        save /home/yuval/Copy/MEGdata/alice/ga/GavgFrEalice GavgFrEalice
        
    case 'frLRwbw'
        segi=20; % 20 for WBW
        strE='';strM='';
        segStr=num2str(segi);
        for subi=1:length(comps.C100)
            subStr=num2str(subi);
            subFold=sf{1,subi};
            cd (['/home/yuval/Data/alice/',subFold])
            load frWBW
            eval(['frE',segStr,'LR',subStr,'=eegLRWBW;'])
            strE=[strE,',frE',segStr,'LR',subStr];
            eval(['frM',segStr,'LR',subStr,'=megLRWBW;'])
            strM=[strM,',frM',segStr,'LR',subStr];
        end
        cfg=[];
        cfg.keepindividual='yes';
        eval(['GavgFrE',segStr,'LR=ft_freqgrandaverage(cfg',strE,');'])
        eval(['GavgFrM',segStr,'LR=ft_freqgrandaverage(cfg',strM,');'])
        save(['/home/yuval/Copy/MEGdata/alice/ga/GavgFrE',segStr,'LR'],['GavgFrE',segStr,'LR']);
        save(['/home/yuval/Copy/MEGdata/alice/ga/GavgFrM',segStr,'LR'],['GavgFrM',segStr,'LR']);
        
    case 'coh'
        for segi=[2:2:20,100,102] % 20 for WBW
            strE='';strM='';
            if segi==20
                segStr='WBW';
                loadStr=segStr;
            else
                loadStr='';
            end
            segStr=num2str(segi);
            for subi=1:length(comps.C100)
                subStr=num2str(subi);
                subFold=sf{1,subi};
                cd (['/home/yuval/Data/alice/',subFold])
                load(['fr',loadStr])
                if segi==20
                    eval(['frE',segStr,'_',subStr,'=eegCoh',loadStr,';'])
                    eval(['frM',segStr,'_',subStr,'=megCoh',loadStr,';'])
                else
                    eval(['frE',segStr,'_',subStr,'=eegCoh',segStr,';'])
                    eval(['frM',segStr,'_',subStr,'=megCoh',segStr,';'])
                end
                strE=[strE,',frE',segStr,'_',subStr];
                strM=[strM,',frM',segStr,'_',subStr];
            end
            cfg=[];
            cfg.keepindividual='yes';
            eval(['GavgCohE',segStr,'=ft_freqgrandaverage(cfg',strE,');'])
            eval(['GavgCohM',segStr,'=ft_freqgrandaverage(cfg',strM,');'])
            save(['/home/yuval/Copy/MEGdata/alice/ga/GavgCohE',segStr],['GavgCohE',segStr]);
            save(['/home/yuval/Copy/MEGdata/alice/ga/GavgCohM',segStr],['GavgCohM',segStr]);
            
            
        end
    case 'cohRest'
        strE='';strM='';
        for subi=1:length(comps.C100)
            subStr=num2str(subi);
            subFold=sf{1,subi};
            cd (['/home/yuval/Data/alice/',subFold])
            load fr
            avgErest=eegCoh100;
            avgErest.powspctrm=(eegCoh100.powspctrm+eegCoh102.powspctrm)./2;
            avgMrest=megCoh100;
            avgMrest.powspctrm=(megCoh100.powspctrm+megCoh102.powspctrm)./2;
            eval(['cohErest',subStr,'=avgErest;'])
            eval(['cohMrest',subStr,'=avgMrest;'])
            strE=[strE,',cohErest',subStr];
            strM=[strM,',cohMrest',subStr];
        end
        cfg=[];
        cfg.keepindividual='yes';
        eval(['GavgCohErest=ft_freqgrandaverage(cfg',strE,');'])
        eval(['GavgCohMrest=ft_freqgrandaverage(cfg',strM,');'])
        save /home/yuval/Copy/MEGdata/alice/ga/GavgCohMrest GavgCohMrest
        save /home/yuval/Copy/MEGdata/alice/ga/GavgCohErest GavgCohErest
    case 'cohAlice'
        strE='';strM='';
        for subi=1:length(comps.C100)
            subStr=num2str(subi);
            subFold=sf{1,subi};
            cd (['/home/yuval/Data/alice/',subFold])
            load fr
            avgEalice=eegCoh2;
            avgEalice.powspctrm=zeros(size(eegCoh2.powspctrm));
            avgMalice=megCoh2;
            avgMalice.powspctrm=zeros(size(megCoh2.powspctrm));
            for segi=[2 4 8 12 14 16]
                segStr=num2str(segi);
                eval(['avgEalice.powspctrm=avgEalice.powspctrm+eegCoh',segStr,'.powspctrm']);
                eval(['avgMalice.powspctrm=avgMalice.powspctrm+megCoh',segStr,'.powspctrm']);
            end
            avgEalice.powspctrm=avgEalice.powspctrm./6;
            avgMalice.powspctrm=avgMalice.powspctrm./6;
            eval(['frEalice',subStr,'=avgEalice;'])
            eval(['frMalice',subStr,'=avgMalice;'])
            strE=[strE,',frEalice',subStr];
            strM=[strM,',frMalice',subStr];
        end
        cfg=[];
        cfg.keepindividual='yes';
        eval(['GavgCohEalice=ft_freqgrandaverage(cfg',strE,');'])
        eval(['GavgCohMalice=ft_freqgrandaverage(cfg',strM,');'])
        save /home/yuval/Copy/MEGdata/alice/ga/GavgCohMalice GavgCohMalice
        save /home/yuval/Copy/MEGdata/alice/ga/GavgCohEalice GavgCohEalice
        
    case 'alice'
        strE='';strM='';
        for subi=1:length(comps.C100)
            subStr=num2str(subi);
            subFold=sf{1,subi};
            cd (['/home/yuval/Data/alice/',subFold])
            load avgReduced
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
        save /home/yuval/Copy/MEGdata/alice/ga/GavgMalice GavgMalice
        save /home/yuval/Copy/MEGdata/alice/ga/GavgEalice GavgEalice
        
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
                    
                    load avgReduced
                    
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
            save (['/home/yuval/Copy/MEGdata/alice/ga/GavgM',segStr],['GavgM',segStr])
            save (['/home/yuval/Copy/MEGdata/alice/ga/GavgE',segStr],['GavgE',segStr])
        end
        
end
cd /home/yuval/Copy/MEGdata/alice/ga
