%% Correlative channels between subjects

load dataA dataAord
condlength=[240 240 302 302 282 302];
conds={'closed','open','charisma','room','dull','silent'};

% R=[];
% R=corr(squeeze(dataAord(:,3,1,:,1))','rows','pairwise');
% r=[];
% for subi=1:size(R,1)
%     ii=1:size(R,1);
%     ii(subi)=[];
%     r(subi,:)=squeeze(mean(R(ii,subi,:)));
% end

%Make plot based on correlations between subjects in most powerful channels
%and frequencies
for subi=1:40
    for condi=1:6
        for freq=1:size(dataAord,3)
            for time=1:302
                [maxval,maxi]=max(dataAord(subi,condi,freq,time,:));
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
        data=data-m;
    end
    data=data(1:condlength(condi),:);
    RR=corr(data);
    [V,D]=eig(RR);
    PC1=V(:,end)'*data';
    dataavg=mean(data')';
    orient=corr(dataavg,PC1');
    if orient<0
        PC1=-PC1;
    end
    figure;plot(PC1)
    hold on
    title(['Main Comp Alpha, cond: ',conds(condi)]);
    
    %Create smoothed, time-adjusted plot
    for tscale=1:floor((condlength(condi)-9)/5+1)
        tstart=1+5*(tscale-1);
        movAvgmax(tscale)=sum(PC1(tstart:(tstart+9)))/10;
    end
    timescale=[1:length(movAvgmax)].*2.5;
    figure;
    plot(timescale,movAvgmax)
    title(['smoothed main comp alpha, cond: ',conds(condi)]);
    
    clear data RR V PC1 movAvgmax
end



%% Correlative channels within brain regions

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
[~,chi]=ismember(anteriorR,Fr.label);
antR=dataAord(:,:,:,:,chi);
[~,chi]=ismember(posteriorR,Fr.label);
postR=dataAord(:,:,:,:,chi);
[~,chi]=ismember(anteriorL,Fr.label);
antL=dataAord(:,:,:,:,chi);
[~,chi]=ismember(posteriorL,Fr.label);
postL=dataAord(:,:,:,:,chi);
clear Fr

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
    