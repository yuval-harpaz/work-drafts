%% Calculate data for different brain sections

load dataT

posteriorR = {'A51', 'A52', 'A77', 'A78', 'A79', 'A107', 'A108', 'A109', 'A110', 'A139', 'A140', 'A141', 'A142', 'A167', 'A168', 'A169', 'A170', 'A188', 'A189', 'A190', 'A191', 'A206', 'A207', 'A208', 'A225'};
anteriorR = {'A54', 'A55', 'A81', 'A82', 'A83', 'A112', 'A113', 'A114', 'A115', 'A144', 'A145', 'A146', 'A171', 'A172', 'A173', 'A174', 'A193', 'A209', 'A210', 'A211', 'A227', 'A244', 'A245', 'A246', 'A247'};

load LRpairs
[~,Li]=ismember(anteriorR,LRpairs(:,2));
anteriorL=LRpairs(Li,1);
[~,Li]=ismember(posteriorR,LRpairs(:,2));
posteriorL=LRpairs(Li,1);

cd Char_1
load Fr
cd ../
for subi=1:40
    for condi=1:6
        [~,chi]=ismember(anteriorR,Fr.label);
        antR(subi,condi)=mean(dataTmaxval(subi,condi,chi),3);
        [~,chi]=ismember(posteriorR,Fr.label);
        postR(subi,condi)=mean(dataTmaxval(subi,condi,chi),3);
        [~,chi]=ismember(anteriorL,Fr.label);
        antL(subi,condi)=mean(dataTmaxval(subi,condi,chi),3);
        [~,chi]=ismember(posteriorL,Fr.label);
        postL(subi,condi)=mean(dataTmaxval(subi,condi,chi),3);
    end
end
%save sectsT antL antR postL postR


%Topoplots
cfg=[];
cfg.highlight='labels';
cfg.highlightchannel=posterior;

%cfg.zlim=[0 0.1];
figure;topoplot248(squeeze(mean(dataAmaxval(:,1,:))),cfg);

cfg.highlightchannel=anterior;
figure;topoplot248(squeeze(mean(dataAmaxval(:,1,:))),cfg);


%Compare power of different regions of the brain over conditions
load sectsG

for section=1:4
    switch section
        case 1
            sect=antL;
            secttitle='antL';
        case 2
            sect=antR;
            secttitle='antR';
        case 3
            sect=postL;
            secttitle='postL';
        case 4
            sect=postR;
            secttitle='postR';
    end
    
[~,p]=ttest(sect(:,3),sect(:,5));
pChardull=p;

conds={'closed','open','charism','room','dull','silent'};
bars=squeeze(mean(sect,1));
err=std(sect)./sqrt(40);
figure, hold all;
bar(bars,'w');
errorbar(bars,err,'k','linestyle','none')
bar(bars,'w');
bar(3,bars(3),'b');
bar(5,bars(5),'r');
title({['mean gamma ',secttitle];'Significance of char vs. dull = ';pChardull})
set(gca,'XTick',1:6);
set(gca,'XTickLabel',conds);
end



%% TBR
load dataB
load dataT

TBR=dataTmaxval./dataBmaxval;

%Chart for overall TBR
TBRavg=squeeze(mean(TBR,3));
[~,p]=ttest(TBRavg(:,3),TBRavg(:,5));
pChardull=p;

conds={'closed','open','charism','room','dull','silent'};
bars=squeeze(mean(TBRavg(:,:),1));
err=std(TBRavg)./sqrt(40);
figure, hold all;
bar(bars,'w');
errorbar(bars,err,'k','linestyle','none')
bar(bars,'w');
bar(3,bars(3),'b');
bar(5,bars(5),'r');
title({'mean TBR';'Significance of char vs. dull = ';pChardull})
set(gca,'XTick',1:6);
set(gca,'XTickLabel',conds);
    
%Regional TBR

load sectsB
antLB=antL;
antRB=antR;
postLB=postL;
postRB=postR;
clear antL antR postL postR
load sectsT
antLT=antL;
antRT=antR;
postLT=postL;
postRT=postR;
clear antL antR postL postR

for section=1:4
    switch section
        case 1
            sectB=antLB;
            sectT=antLT;
        case 2
            sectB=antRB;
            sectT=antRT;
        case 3
            sectB=postLB;
            sectT=postLT;
        case 4
            sectB=postRB;
            sectT=postRT;
    end
    TBRsect(section,:,:)=sectT./sectB;
end
for section=1:4
    switch section
        case 1
            secttitle='antL';
        case 2
            secttitle='antR';
        case 3
            secttitle='postL';
        case 4
            secttitle='postR';
    end
    [~,p]=ttest(TBRsect(section,:,3),TBRsect(section,:,5));
    pChardull=p;
    
    conds={'closed','open','charism','room','dull','silent'};
    bars=squeeze(mean(squeeze(TBRsect(section,:,:)),1));
    err=std(TBRsect(section,:,:))./sqrt(40);
    figure, hold all;
    bar(bars,'w');
    errorbar(bars,err,'k','linestyle','none')
    bar(bars,'w');
    bar(3,bars(3),'b');
    bar(5,bars(5),'r');
    title({['mean TBR ',secttitle];'Significance of char vs. dull = ';pChardull})
    set(gca,'XTick',1:6);
    set(gca,'XTickLabel',conds);
end