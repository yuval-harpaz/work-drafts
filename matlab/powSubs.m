cd /home/yuval/Desktop/talEEG
load allQ
%load pow

%load /home/yuval/Desktop/talEEG/matNames
cfg2            = [];
cfg2.output     = 'pow';
cfg2.method     = 'mtmfft';
cfg2.foilim     = [1 55];
cfg2.tapsmofrq  = 1;
cfg2.keeptrials = 'no';
for subi=[5 10 33 36 37 40 50 53 54]
    if subi==5
        subI=['0',num2str(subi)];
    else
        subI=num2str(subi);
    end
    for BLi=1:2
        load dataTemp
        trlCount=0;
        for SEGi=1:6
            matName=['Q',subI,'_1_BL',num2str(BLi),'_SEG',num2str(SEGi),'ref'];
            if exist(matName,'var')
                eval(['seg=',matName,';']);
                for trli=1:16
                    seg1stSmp=(trli-1)*2048+1;
                    segLstSmp=trli*2048;
                    if length(seg)>seg1stSmp
                        trlCount=trlCount+1;
                        data.trial{1,trlCount}=seg(:,seg1stSmp:segLstSmp);
                    end
                end
            end
        end
        
        pow=ft_freqanalysis(cfg2,data);
        if subi==5
            eval(['avgPowBL',num2str(BLi),'=pow;']);
        else
            eval(['spc=avgPowBL',num2str(BLi),'.powspctrm;'])
            spc=spc+pow.powspctrm;
            eval(['avgPowBL',num2str(BLi),'.powspctrm=spc;'])
        end
        %save(['Q',subI,'BL',num2str(BLi),'pow'],'pow')
        
    end
end
avgPowBL1.powspctrm=avgPowBL1.powspctrm./9;
avgPowBL2.powspctrm=avgPowBL2.powspctrm./9;

avgPowBL1.powspctrm=avgPowBL1.powspctrm(:,1:182);
avgPowBL1.freq=avgPowBL1.freq(:,1:182);
avgPowBL2.powspctrm=avgPowBL2.powspctrm(:,1:182);
avgPowBL2.freq=avgPowBL2.freq(:,1:182);
avgDiff=avgPowBL2;
avgDiff.powspctrm=avgPowBL2.powspctrm-avgPowBL1.powspctrm;
save avgPowBL avgPowBL1 avgPowBL2 avgDiff

cfg.layout='egi65.lay';
cfg.interactive='yes';
cfg.xlim=[7 13];
cfg.zlim=[-1 1];
figure;
ft_topoplotER(cfg,avgDiff)
title('BASELINE 1 - BASELINE 2')
cfg.zlim=[0 2.5]
figure;
ft_topoplotER(cfg,avgPowBL1)
title('BASELINE 1')
figure;
ft_topoplotER(cfg,avgPowBL2)
title('BASELINE 2')



