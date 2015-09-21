function charTables
%% setup java for xlwrite
if ~exist('org.apache.poi.ss.usermodel.WorkbookFactory', 'class')
    cd ~/Documents/MATLAB/20130227_xlwrite/20130227_xlwrite
    javaaddpath('poi_library/poi-3.8-20120326.jar');
    javaaddpath('poi_library/poi-ooxml-3.8-20120326.jar');
    javaaddpath('poi_library/poi-ooxml-schemas-3.8-20120326.jar');
    javaaddpath('poi_library/xmlbeans-2.3.0.jar');
    javaaddpath('poi_library/dom4j-1.6.1.jar');
end
%% Correlative channels between subjects
cd('/media/yuval/My Passport/Hila&Rotem')
%load dataA dataAord
%%
trigVal=[202 204 220 230 240 250;202 204 240 230 220 250];
conds={'closed','open','charisma','room','dull','silent'};


thetaFreq=4:7;
alphaFreq=8:12;
betaFreq=13:24;
gammaFreq=25:40;
for bandi=1:4
    load Sub40
    switch bandi
        case 1
            bandFreq=thetaFreq;
            Four='FrLow.mat';
            sheet='theta';
        case 2
            bandFreq=alphaFreq;
            Four='Fr.mat';
            sheet='alpha';

        case 3
            bandFreq=betaFreq;
            Four='FrBeta.mat';
            sheet='beta';

        case 4
            bandFreq=gammaFreq;
            Four='FrGamma.mat';
            sheet='gamma';

    end
    
    dataBand=zeros(40,6,length(bandFreq),302,248);
    for freqi=1:length(bandFreq)
        
        for subi=1:length(Sub)
            cd(Sub{subi,1})
            load(Four)
            freq=find(round(Fr.freq)==bandFreq(freqi));
            cond=TRL(:,4);
            clear TRL
            if subi==1
                Good=zeros(40,1674);
                Good(subi,good)=1;
                Cond=cond';
            else
                Cond(subi,:)=cond;
                Good(subi,good)=1;
            end
            for chan=1:248
                datai(:,chan)=Fr.powspctrm(:,chan,freq).*Good(subi,:)';
            end
            for condi=1:6
                i0=find(Cond(subi,:)==trigVal(Sub{subi,2},condi),1);
                i1=find(Cond(subi,:)==trigVal(Sub{subi,2},condi),1,'last');
                dataBand(subi,condi,freqi,1:length(i0:i1),:)=datai(i0:i1,:);
            end
            clear datai
            cd ../
            disp([Sub{subi,1},' complete']);
        end
        disp(['Frequency ',num2str(freq),' processed']);
    end
    dataBand(dataBand==0)=NaN;
    %%
    condlength=[240 240 302 302 282 302];
    conds={'closed','open','charisma','room','dull','silent'};
    for subi=1:40
        for condi=1:6
            for freq=1:size(dataBand,3)
                for time=1:302
                    [maxval,maxi]=max(dataBand(subi,condi,freq,time,:));
                    datamaxchan(subi,condi,freq,time)=maxval;
                end
            end
        end
        disp(['First max calculated for sub ',num2str(subi)])
    end
    for subi=1:40
        for condi=1:6
            for time=1:302
                [maxval,maxi]=max(datamaxchan(subi,condi,:,time));
                datamax(subi,condi,time)=maxval;
            end
        end
        disp(['Second max calculated for sub ',num2str(subi)])
    end
    for condi=1:6
        data=squeeze(datamax(:,condi,:))';
        thr=nanmedian(data(:))*40;
        data(data>thr)=nan;
        for coli=1:40
            m=nanmean(data(1:condlength(condi),coli));
            data(isnan(data(:,coli)),coli)=m;
            %data=data-m;
        end
        data=data(1:condlength(condi),:);
        means(1:40,condi)=mean(data);
    end
    means(37,:)=[];
    labels={'closed','open','char','room','dull','silent'};
    %[~,p]=ttest(means(:,3),means(:,5))
    %plot(mean(means'))
    bars=mean(means,1);
    err=std(means)./sqrt(size(means,1));
    figure, hold all;
    bar(bars,'w');
    errorbar(bars,err,'k','linestyle','none')
    bar(bars,'w');
    bar(3,bars(3),'b');
    bar(5,bars(5),'r');
    title(['mean ',sheet])
    set(gca,'XTick',1:6);
    set(gca,'XTickLabel',labels);
    cd('/media/yuval/My Passport/Hila&Rotem')
    Sub(37,:)=[];
    table={};
    table{1,1}='subjects\condition';
    for coli=1:6
        table{1,coli+1}=labels{coli};
        for rowi=1:39
            if coli==1
                table{rowi+1,1}=Sub{rowi,1};
            end
            table{rowi+1,coli+1}=means(rowi,coli)*10e24;
        end
    end
    xlwrite([sheet,'Means'],table);
    %% Correlations
    load audioChar
    load audioDull
    data=squeeze(datamax(:,3,:))';
    data(:,37)=[];
    thr=nanmedian(data(:))*40;
    data(data>thr)=nan;
    data=data(1:condlength(condi),:);
    timeCourseChar=nanmean(data,2)*10e24;
    timeCourseChar(:,2)=audioChar;
    
    data=squeeze(datamax(:,5,:))';
    data(:,37)=[];
    thr=nanmedian(data(:))*40;
    data(data>thr)=nan;
    data=data(1:condlength(5),:);
    timeCourseDull=nanmean(data,2)*10e24;
    timeCourseDull(:,2)=audioDull;
    [r,p]=corr(timeCourseChar);
    figure;
    plot(timeCourseChar)
    title({[sheet,' Char'],['r = ',num2str(r(2)),', p = ',num2str(p(2))]})
    [r,p]=corr(timeCourseDull);
    figure;
    plot(timeCourseDull)
    title({[sheet,' Dull'],['r = ',num2str(r(2)),', p = ',num2str(p(2))]})
    table={};
    %table{1,1}='subjects\condition';
    table{1,1}='brainChar';
    table{1,2}='audioChar';
    table{1,3}='brainDull';
    table{1,4}='audioDull';
    for rowi=1:302
        table{rowi+1,1}=timeCourseChar(rowi,1);
        table{rowi+1,2}=timeCourseChar(rowi,2);
        if rowi<283
            table{rowi+1,3}=timeCourseDull(rowi,1);
            table{rowi+1,4}=timeCourseDull(rowi,2);
        end
    end
    
    xlwrite([sheet,'Timecourse'],table);
end