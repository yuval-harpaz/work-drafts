function talCohAPstats(condA,condB,freq,paired)
str='';
dataA=squeeze(condA.cohspctrm(:,:,freq,:));
dataB=squeeze(condB.cohspctrm(:,:,freq,:));
for chani=1:size(dataA,1)
    for chanj=1:size(dataA,1)
        dA=squeeze(dataA(chani,chanj,:));
        dB=squeeze(dataB(chani,chanj,:));
        try
            if paired
                [h,p,~,stat]=ttest(dA,dB);
            else
                [h,p,~,stat]=ttest2(dA,dB);
            end
            if h
                str=[str,' ',num2str(chani),'x',num2str(chanj)];
            else
                p
            end
        end
    end
end
figure;
subplot(1,2,1)
imagesc(squeeze(mean(dataA,3)))
title(str)
subplot(1,2,2)
imagesc(squeeze(mean(dataB,3)))
end