function aliceGAwbw2

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
segi=20; % 20 for WBW
strE='';strM='';
segStr=num2str(segi);
for subi=1:length(comps.C100)
    subStr=num2str(subi);
    subFold=sf{1,subi};
    cd (['/home/yuval/Data/alice/',subFold])
    load avgWbW2
    if subi==4
        load avgWbW2fixedArtifact
    end
    eval(['avgE',segStr,'_',subStr,'=avgWbWeeg;'])
    strE=[strE,',avgE',segStr,'_',subStr];
    eval(['avgM',segStr,'_',subStr,'=avgWbWmeg;'])
    strM=[strM,',avgM',segStr,'_',subStr];
end
cfg=[];
cfg.keepindividual='yes';
eval(['GavgE',segStr,'=ft_timelockgrandaverage(cfg',strE,');'])
eval(['GavgM',segStr,'=ft_timelockgrandaverage(cfg',strM,');'])
cd /home/yuval/Copy/MEGdata/alice/ga
save(['/home/yuval/Copy/MEGdata/alice/ga/GavgE',segStr,'_2'],['GavgE',segStr]);
save(['/home/yuval/Copy/MEGdata/alice/ga/GavgM',segStr,'_2'],['GavgM',segStr]);

