function marikSAMloopB023last5(subs,rm)
t=[40   53;40   65;40   60;5.5  13;40   48];
pat='/home/yuval/Data/epilepsy/b023/';
if ~exist('subs','var')
    subs=6:10;
end
if ~exist('rm','var')
    rm=false;
end
for runi=subs
    fold=num2str(runi);
    trun=t(runi-5,:);
    if trun(1)==40
        time=10;
    else
        time=5.5;
    end
    time(2)=trun(2);
    fn=['s',fold,'_c,rfhp1.0Hz,ee'];
    cd(pat)
    cd(fold)
    if ~exist(fn,'file')
        fn=['s',fold,'_c,rfDC,ee'];
    end
    if rm
        eval(['!rm ','*',fold,'+orig.*'])
        !rm *s+orig.*
        !rm *sw+orig.*
        !rm g2sw*_*
    end
    if ~exist(['adapt',fold,'+orig.BRIK'],'file')
        marikSAMloop(time,fold,fn,pat);
        eval(['!cp adapt',fold,'+orig.BRIK ../sw',fold,'+orig.BRIK'])
        eval(['!cp adapt',fold,'+orig.HEAD ../sw',fold,'+orig.HEAD']) 
    end
    if ~exist(['g2sw',fold,'+orig.BRIK'],'file')
        marikG2sw(time,fold,fn,pat);
        eval(['!cp g2sw',fold,'+orig.BRIK ../g2sw',fold,'+orig.BRIK'])
        eval(['!cp g2sw',fold,'+orig.HEAD ../g2sw',fold,'+orig.HEAD']) 
        disp(['done SAM SUB ',fold])
    end
    % averaging
    cd /home/yuval/Data/epilepsy/b023
    [V,info]=BrikLoad('maskRS+orig');
    info.BRICK_TYPES=3;
    clear V
    cond={'sw','adapt'};
    if rm
        eval(['!rm *',fold,'Avg*'])
    end
    if ~exist(['g2',cond{1},fold,'AvgPI+orig.BRIK'],'file')
        %ict=[10,23,15];
        g2_=BrikLoad([fold,'/g2',cond{1},fold,'+orig']);
        if ~(runi==9)
            g2_p=mean(g2_(:,:,:,1:(trun(1)-time(1))),4);
            OptTSOut.Prefix = ['g2',cond{1},fold,'AvgPI'];
            OptTSOut.Scale = 1;
            OptTSOut.verbose = 1;
            WriteBrik (g2_p, info,OptTSOut);
        end
        g2_i=mean(g2_(:,:,:,(trun(1)-time(1)+1):end),4);
        OptTSOut.Prefix = ['g2',cond{1},fold,'Avg'];
        WriteBrik (g2_i, info,OptTSOut);
        g2_=BrikLoad([fold,'/',cond{2},fold,'+orig']);
        if ~(runi==9)
            g2_p=mean(g2_(:,:,:,1:(trun(1)-time(1))),4);
            OptTSOut.Prefix = ['sw',fold,'AvgPI'];
            OptTSOut.Scale = 1;
            OptTSOut.verbose = 1;
            WriteBrik (g2_p, info,OptTSOut);
        end
        g2_i=mean(g2_(:,:,:,(trun(1)-time(1)+1):end),4);
        OptTSOut.Prefix = ['sw',fold,'Avg'];
        WriteBrik (g2_i, info,OptTSOut);
    end
end

