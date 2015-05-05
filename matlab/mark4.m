function mark4(toi,fPlot)
F=1:30;
%toi=[-0.8 0];
if ~existAndFull('toi')
    toi='last1';
end
if ~exist('fPlot','var')
    fPlot=false;
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
if ischar(toi)
    suf=toi;
else
    suf=num2str(toi(1));
end
%% compute phase
if exist(['res4_',suf,'.mat'],'file')
    load(['res4_',suf,'.mat']);
else
    for subi=1:22
        clear corr*
        clear miss*
        folder=['sub',num2str(subi)];
        cd (folder)
        load datafinal
        if ~ischar(toi)
            s0=nearest(datafinal.time{1},toi(2));
            sBL=nearest(datafinal.time{1},toi(1));
        end
        if subi==1;
            grad=datafinal.grad;
        else
            datafinal.grad=grad;
        end
        corri= find(datafinal.trialinfo(:,4)==2);
        missi= find(datafinal.trialinfo(:,4)==0);
        nTrl=min([length(corri),length(missi)]);
        corri=corri(round(1:length(corri)/nTrl:length(corri)));
        %corri=corri(1:nTrl);
        missi=missi(round(1:length(missi)/nTrl:length(missi)));
        %missi=missi(1:nTrl);
        if length(missi)~=length(corri)
            error('told you! wrong n')
        end
        if length(missi)>length(unique(missi)) || length(corri)>length(unique(corri))
            error ('duplicate indices!')
        end
        %for foii=1:length(F)
        for foi=F
            if ischar(toi)
                s0=nearest(datafinal.time{1},0);
                sBL=nearest(datafinal.time{1},-1/F(foi));
                if (s0-sBL)<(1/F(foi)*datafinal.fsample) && sBL>1
                    sBL=sBL-1;
                end
            end
            for trli=1:length(corri)
                [~,est] = dft05(datafinal.trial{corri(trli)}(:,sBL:s0),datafinal.fsample, foi);
                ang=angle(est); % this gives instanteneous phase. maybe unwarp not necessary
                corrPh(1:248,trli,foi)=2*pi-mod(angle(est(:,1)),2*pi);
                [~,est] = dft05(datafinal.trial{missi(trli)}(:,sBL:s0),datafinal.fsample, foi);
                ang=angle(est); % this gives instanteneous phase. maybe unwarp not necessary
                missPh(1:248,trli,foi)=2*pi-mod(angle(est(:,1)),2*pi);
            end
        end
        for foi=1:length(F)
            MissPh(1:248,subi,foi) = circ_mean(missPh(:,:,foi),[],2);
            MissR(1:248,subi,foi) = circ_r(missPh(:,:,foi), [],[], 2);
            CorrPh(1:248,subi,foi) = circ_mean(corrPh(:,:,foi),[],2);
            CorrR(1:248,subi,foi) = circ_r(corrPh(:,:,foi), [],[], 2);
        end
        disp(['done ',folder])
        cd ..
    end
    save (['res4_',suf,'.mat'],'F','toi','CorrR','CorrPh','MissR','MissPh')
end

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
