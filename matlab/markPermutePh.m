function markPermutePh(fileName)

if ~existAndFull('fileName')
    fileName='resDFT-0.5.mat';
end

if ~exist('./sub1','dir')
    try
        cd /media/yuval/My_Passport/Mark_threshold_visual_detection/MEG_data/
    catch
        try
            cd /home/yuval/Data/mark
        catch
            error('cd to mark directory')
        end
    end
end

%% compute phase
    load(fileName);

for foi=F
    for chani=1:248
        prC(chani) = circ_rtest(CorrPh(chani,:,foi));
    end
    for chani=1:248
        prM(chani) = circ_rtest(MissPh(chani,:,foi));
    end
    nSigC(foi)=sum(prC<0.05);
    nSigM(foi)=sum(prM<0.05);
end
figure;
disp('done')
plot(F,nSigC)
hold on
plot(F,nSigM,'r')
legend('correct','miss')
figure;
plot(F,squeeze(mean(mean(CorrR,1),2)))
hold on
plot(F,squeeze(mean(mean(MissR,1),2)),'r')
legend('correct','miss')

if fPlot
    fi=nearest(F,fPlot);
    
    for chani=1:248
        prC(chani) = circ_rtest(CorrPh(chani,:,fi));
    end
    for chani=1:248
        prM(chani) = circ_rtest(MissPh(chani,:,fi));
    end
    cfg=[];
    cfg.zlim=[0 max([max(mean(MissR(:,:,fi),2)) max(mean(CorrR(:,:,fi),2)) ])];
    cfg.highlight='labels';
    cfg.highlightchannel=find(prM<0.05);
    figure;topoplot248(mean(MissR(:,:,fi),2),cfg);title('Miss')
    colorbar
    cfg.highlightchannel=find(prC<0.05);
    figure;topoplot248(mean(CorrR(:,:,fi),2),cfg);title('Correct')
    colorbar
end
