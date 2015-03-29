
for subi=1:22
    cd /media/yuval/My_Passport/Mark_threshold_visual_detection/MEG_data/
    folder=['sub',num2str(subi)];
    cd (folder)
    % markerFile=textread('MarkerFile.mrk','%s','delimiter','\n');
    % mLine=find(ismember(markerFile,'missed'));
    % cLine=find(ismember(markerFile,'correct'));
    % nTrl=str2num(markerFile{mLine+2});
    % trl=[];
    % for trli=1:nTrl
    %     trl(trli,1)=str2double(markerFile{mLine+3+trli}(5:end));
    % end
    % TRL=round(trl*678.17)-544
    load datafinal
    corri= find(datafinal.trialinfo(:,4)==2);
    missi= find(datafinal.trialinfo(:,4)==0);
    [~,F]=fftBasic(datafinal.trial{1}(1,1:s0),678.17);
    foi=[8:12];
    foii=[find(F>foi(1),1)-1:find(F<foi(end),1,'last')+1];
    s0=nearest(datafinal.time{1},0);
    for trli=1:length(corri)
        f=fftBasic(datafinal.trial{corri(trli)}(:,1:s0),678.17);
        f=f(:,foii);
        [maxPSD,maxi]=max(abs(f(:,:)),[],2);
        corrF(1:248,trli)=F(maxi+foii(1)-1);
        corrPSD(1:248,trli)=maxPSD;
        for chani=1:248
            corrPh(chani,trli)=mod(phase(f(chani,maxi(chani))),2*pi);
        end
    end
    for trli=1:length(missi)
        f=fftBasic(datafinal.trial{missi(trli)}(:,1:s0),678.17);
        f=f(:,foii);
        [maxPSD,maxi]=max(abs(f(:,:)),[],2);
        missF(1:248,trli)=F(maxi+foii(1)-1);
        missPSD(1:248,trli)=maxPSD;
        for chani=1:248
            missPh(chani,trli)=mod(phase(f(chani,maxi(chani))),2*pi);
        end
    end
    nTrl=min([length(corri),length(missi)]);
    MissPh(1:248,subi) = circ_mean(missPh(:,1:nTrl),[],2);
    MissR(1:248,subi) = circ_r(missPh(:,1:nTrl), [],[], 2);
    MissF(1:248,subi)=mean(missF(:,1:nTrl),2);
    MissPSD(1:248,subi)=mean(missPSD(:,1:nTrl),2);
    CorrPh(1:248,subi) = circ_mean(corrPh(:,1:nTrl),[],2);
    CorrR(1:248,subi) = circ_r(corrPh(:,1:nTrl), [],[], 2);
    CorrF(1:248,subi)=mean(corrF(:,1:nTrl),2);
    CorrPSD(1:248,subi)=mean(corrPSD(:,1:nTrl),2);
    disp(['done ',folder])
end
cd ..
save YH1 Miss* Corr*




cfg=[];
cfg.highlight='on';
cfg.highlightchannel=find(ttest(MissPSD',CorrPSD'));
cfg.zlim=[0 max([mean(MissPSD,2);mean(CorrPSD,2)])];
figure;topoplot248(mean(MissPSD,2),cfg)
title('Miss');
figure;topoplot248(mean(CorrPSD,2),cfg)
title('Correct');

cfg.highlightchannel=find(ttest(MissF',CorrF'));
cfg.zlim=[min([mean(MissF,2);mean(CorrF,2)]) max([mean(MissF,2);mean(CorrF,2)])];
figure;topoplot248(mean(MissF,2),cfg)
title('Miss');
figure;topoplot248(mean(CorrF,2),cfg)
title('Correct');

cfg.highlightchannel=find(ttest(MissR',CorrR'));
cfg.zlim=[0 max([mean(MissR,2);mean(CorrR,2)])];
figure;topoplot248(mean(MissR,2),cfg)
title('Miss');
figure;topoplot248(mean(CorrR,2),cfg)
title('Correct');

for chani=1:248
    p(chani) = circ_wwtest(CorrPh(chani,:),MissPh(chani,:));
end
cfg.highlightchannel=find(p<0.05);
cfg.zlim=[0 max([mean(MissPSD,2);mean(CorrPSD,2)])];
figure;topoplot248(mean(MissPSD,2),cfg)
title('Miss');
figure;topoplot248(mean(CorrPSD,2),cfg)
title('Correct');


figure; % A145
subplot(2,2,1)
circ_plot(MissPh(135,:)','pretty','bo',true,'linewidth',2,'color','r'),

subplot(2,2,3)
circ_plot(MissPh(135,:)','hist',[],20,true,true,'linewidth',2,'color','r')

subplot(2,2,2)
circ_plot(CorrPh(135,:)','pretty','bo',true,'linewidth',2,'color','r'),

subplot(2,2,4)
circ_plot(CorrPh(135,:)','hist',[],20,true,true,'linewidth',2,'color','r')

figure; % A65
subplot(2,2,1)
circ_plot(MissPh(13,:)','pretty','bo',true,'linewidth',2,'color','r'),

subplot(2,2,3)
circ_plot(MissPh(13,:)','hist',[],20,true,true,'linewidth',2,'color','r')

subplot(2,2,2)
circ_plot(CorrPh(13,:)','pretty','bo',true,'linewidth',2,'color','r'),

subplot(2,2,4)
circ_plot(CorrPh(13,:)','hist',[],20,true,true,'linewidth',2,'color','r')


for chani=1:248
    p(chani) = circ_cmtest(CorrPh(chani,:),MissPh(chani,:));
end
cfg.highlightchannel=find(p<0.05);
cfg.zlim=[0 max([mean(MissPSD,2);mean(CorrPSD,2)])];
figure;topoplot248(mean(MissPSD,2),cfg)
title('Miss');
figure;topoplot248(mean(CorrPSD,2),cfg)
title('Correct');


