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
figure;plot(dataavg(:,3),'b')
hold on
plot(dataavg(:,5),'r')
title(['Main Comp Alpha, cond: ',conds(condi)]);
legend(conds([3,5]))
