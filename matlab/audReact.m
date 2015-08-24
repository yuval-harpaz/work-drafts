function [ca,pca,ac,p] = audReact(band,charBool,quart)

%input

%band = one-character string representing the frequency band that the
%function will calculate for. Can be A, B, G, L, or T (alpha, beta, gamma,
%low, and theta respectively).

%charBool = boolean value representing whether the output data will be
%calculated from the charisma data set or the dull. true=charisma, false=dull

%quart = two-character string value representing the quarter of the brain
%the function will use (la, lp, ra, rp are left anterior, left posterior, etc.).
%If the parameter is left empty, the default is the entire brain.

%output

%ca = correlation between the average brain activity over subjects and the
%audio patterning of the video the subjects were watching

%ac = average correlation between the brain activity of each subject and
%the video they were watching

%p = p-value (significance) of the correlations between subjects' brain
%activity and the audio patterning of the video

band=upper(band);
disp('Loading original data file...')
eval(['load data',band,' data',band,'ord'])
eval(['dataord=data',band,'ord;'])
condlength=[240 240 302 302 282 302];

switch band
    case 'A'
        bandname='Alpha';
    case 'B'
        bandname='Beta';
    case 'G'
        bandname='Gamma';
    case 'L'
        bandname='Low';
    case 'T'
        bandname='Theta';
end

%magnify data for specific region (optional)
if nargin==3
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
    switch quart
        case 'ra'
            [~,chi]=ismember(anteriorR,Fr.label);
            dataord=dataord(:,:,:,:,chi);
            secttitle='Right Anterior';
        case 'rp'
            [~,chi]=ismember(posteriorR,Fr.label);
            dataord=dataord(:,:,:,:,chi);
            secttitle='Right Posterior';
        case 'la'
            [~,chi]=ismember(anteriorL,Fr.label);
            dataord=dataord(:,:,:,:,chi);
            secttitle='Left Anterior';
        case 'lp'
            [~,chi]=ismember(posteriorL,Fr.label);
            dataord=dataord(:,:,:,:,chi);
            secttitle='Left Posterior';
    end
    clear Fr
else
    secttitle='Whole Brain';
end

%create datasets using maximum values across channels and frequencies
for subi=1:40
    for condi=1:6
        for freq=1:size(dataord,3)
            for time=1:302
                [maxval,maxi]=max(dataord(subi,condi,freq,time,:));
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
for condi=2:6;
    data=squeeze(datamax(:,condi,:))';
    BL(1:40,condi-1)=nanmedian(data(1:20,:));
end
BL=mean(BL');
datafix=nan(302,40,6);
dataavg=nan(302,6);
for condi=1:6
    data=squeeze(datamax(:,condi,:))';
    data=data(1:condlength(condi),:);
    data=(data-repmat(BL,size(data,1),1))./repmat(BL,size(data,1),1);
    datafix(1:length(data),:,condi)=data;
    dataavg(1:length(data),condi)=nanmedian(data')';
    clear data
end
for subi=1:40
    for condi=1:6
        datafix(datafix(:,subi,condi)>(1000*abs(nanmedian(datafix(:,subi,condi)))),subi,condi)=nan;
    end
end


% %PC version
% if charBool
%     condi=3;
% else
%     condi=5;
% end
% data=squeeze(datafix(:,:,condi));
% thr=nanmedian(data(:))*40;
% data(data>thr)=nan;
% for coli=1:40
%     m=nanmean(data(1:condlength(condi),coli));
%     data(isnan(data(:,coli)),coli)=m;
%     data=data-m;
% end
% data=data(1:condlength(condi),:);
% RR=corr(data(:,[1:36,38:40]));
% [V,D]=eig(RR);
% PC1=V(:,end)'*data(:,[1:36,38:40])';
% datamean=mean(data(:,[1:36,38:40])')';
% orient=corr(datamean,PC1');
% if orient<0
%     PC1=-PC1;
% end


%calculate correlations with audio
disp('Loading audio data...')
if charBool
    %charisma
    load audioChar
    timescale=[1:length(dataavg(:,3))]/2;
    figure;
    plot(timescale,dataavg(:,3),'b')
    hold on
%     plot(timescale,PC1*.1,'g')
    plot(timescale,audioChar,'r')
    title({[bandname,' Activity vs. Charisma Audio'];secttitle})
    legend(bandname,'Audio')
    [ca,pca]=corr(dataavg(:,3),audioChar');
    figure;plot(audioChar,dataavg(:,3),'o');
    xlabel('Audio')
    ylabel('Brain')
    line=[0:0.1:1]*ca;
    line=line-mean(line)+mean(dataavg(:,3));
    hold on
    plot([0:0.1:1],line,'k')
    ylim([-0.4 1])
    title({[bandname,' Activity vs. Charisma Audio'];secttitle;['p = ',num2str(pca)]})
    for subi=[1:36,38:40]
        subcorr(subi)=corr(datafix(:,subi,3),audioChar','rows','pairwise');
    end
else
    %dull
    dulldata=dataavg(1:282,5);
    load audioDull
    timescale=[1:length(dulldata)]/2;
    figure;
    plot(timescale,dulldata,'b')
    hold on
    plot(timescale,audioDull,'r')
    title({[bandname,' Activity vs. Dull Audio'];secttitle})
    legend(bandname,'Audio')
    [ca,pca]=corr(dulldata,audioDull');
    figure;plot(audioDull,dataavg(1:282,5),'o');
    xlabel('Audio')
    ylabel('Brain')
    line=[0:0.1:1]*ca;
    line=line-mean(line)+mean(dataavg(1:282,5));
    hold on
    plot([0:0.1:1],line,'k')
    ylim([-0.4 1])
    title({[bandname,' Activity vs. Dull Audio'];secttitle;['p = ',num2str(pca)]})
    for subi=[1:36,38:40]
        subcorr(subi)=corr(datafix(1:282,subi,5),audioDull','rows','pairwise');
    end
end
ac=mean(subcorr);
[~,p]=ttest(subcorr);
end