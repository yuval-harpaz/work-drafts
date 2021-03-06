function mark2(foi,toi)
% foi is a vector of desired frequencies
if ~exist('method','var')
    method='mostSig';
end
if ~exist('foi','var')
    foi=[];
end
if isempty(foi)
    foi=[8:12];
end
if ~exist('toi','var')
    toi=[];
end
if isempty(toi)
    toi=[-0.8 0];
end
if ~exist('sub1','dir')
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
for subi=1:22
    clear corr* miss*
    folder=['sub',num2str(subi)];
    cd (folder)
    load datafinal
    if subi==1;
        grad=datafinal.grad;
    else
        datafinal.grad=grad;
    end
    corri= find(datafinal.trialinfo(:,4)==2);
    missi= find(datafinal.trialinfo(:,4)==0);
    s0=nearest(datafinal.time{1},toi(2));
    sBL=nearest(datafinal.time{1},toi(1));
    [~,F]=fftBasic(datafinal.trial{1}(1,sBL:s0),678.17);
    if length(foi)==1
        foii=nearest(F,foi);
        if foii==0
            foii=1;
        end
    else
        foii=[find(F>foi(1),1)-1:find(F<foi(end),1,'last')+1];
        foii=foii(foii>0);
    end
    for trli=1:length(corri)
        f=fftBasic(datafinal.trial{corri(trli)}(:,sBL:s0),678.17);
        f=f(:,foii);
        [maxPSD,maxi]=max(abs(f(:,:)),[],2);
        corrF(1:248,trli)=F(maxi+foii(1)-1);
        corrPSD(1:248,trli)=maxPSD;
        for chani=1:248
            corrPh(chani,trli)=mod(phase(f(chani,maxi(chani))),2*pi);
        end
    end
    for trli=1:length(missi)
        f=fftBasic(datafinal.trial{missi(trli)}(:,sBL:s0),678.17);
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
    % averaging
%     cfg=[];
%     cfg.trials=corri(1:nTrl);
%     corr=ft_timelockanalysis(cfg,datafinal);
%     cfg.trials=missi(1:nTrl);
%     miss=ft_timelockanalysis(cfg,datafinal);
    disp(['done ',folder])
    cd ..
end

%% plot PSD topography + sig channels
[~,p]=ttest(MissPSD',CorrPSD');
cfg=[];
cfg.highlight='labels';
cfg.highlightchannel=find(p<0.05);
cfg.zlim=[0 max([mean(MissPSD,2);mean(CorrPSD,2)])];
%figure;topoplot248((mean(MissPSD,2)+mean(CorrPSD,2))./2,cfg);
figure;topoplot248(mean(MissPSD,2),cfg);title('Miss')
figure;topoplot248(mean(CorrPSD,2),cfg);title('Correct')


%% phase + circular colormap
% flip up down doesn't work:
%
% cmap=[0,0,0.562500000000000;0,0,0.625000000000000;0,0,0.687500000000000;0,0,0.750000000000000;0,0,0.812500000000000;0,0,0.875000000000000;0,0,0.937500000000000;0,0,1;0,0.0625000000000000,1;0,0.125000000000000,1;0,0.187500000000000,1;0,0.250000000000000,1;0,0.312500000000000,1;0,0.375000000000000,1;0,0.437500000000000,1;0,0.500000000000000,1;0,0.562500000000000,1;0,0.625000000000000,1;0,0.687500000000000,1;0,0.750000000000000,1;0,0.812500000000000,1;0,0.875000000000000,1;0,0.937500000000000,1;0,1,1;0.0625000000000000,1,0.937500000000000;0.125000000000000,1,0.875000000000000;0.187500000000000,1,0.812500000000000;0.250000000000000,1,0.750000000000000;0.312500000000000,1,0.687500000000000;0.375000000000000,1,0.625000000000000;0.437500000000000,1,0.562500000000000;0.500000000000000,1,0.500000000000000;0.562500000000000,1,0.437500000000000;0.625000000000000,1,0.375000000000000;0.687500000000000,1,0.312500000000000;0.750000000000000,1,0.250000000000000;0.812500000000000,1,0.187500000000000;0.875000000000000,1,0.125000000000000;0.937500000000000,1,0.0625000000000000;1,1,0;1,0.937500000000000,0;1,0.875000000000000,0;1,0.812500000000000,0;1,0.750000000000000,0;1,0.687500000000000,0;1,0.625000000000000,0;1,0.562500000000000,0;1,0.500000000000000,0;1,0.437500000000000,0;1,0.375000000000000,0;1,0.312500000000000,0;1,0.250000000000000,0;1,0.187500000000000,0;1,0.125000000000000,0;1,0.0625000000000000,0;1,0,0;0.937500000000000,0,0;0.875000000000000,0,0;0.812500000000000,0,0;0.750000000000000,0,0;0.687500000000000,0,0;0.625000000000000,0,0;0.562500000000000,0,0;0.500000000000000,0,0;];
% cmapC=[cmap;flipud(cmap)];
%cmapC(65,:)=[];

% this worked
% C=[58 181 75;247 148 29;238 28 37;46 49 146;58 181 75]./255;
% cmapC=[];
% for ci=1:4
%     for sci=1:10
%         dif=sci/10-0.1;
%         cmapC(10*ci-10+sci,1:3)=C(ci,:).*(1-dif)+C(ci+1,:).*dif;
%     end
% end
% cmapC(end+1,:)=cmapC(1,:);
C=[58 181 75;216 223 32;254 242 0;247 148 29;241 89 42;239 62 54;238 28 37;146 39 143;102 46 147;46 49 146;0 114 187;0 170 185]./255;
C(end+1,:)=C(1,:);
cmapC=[];
for ci=1:(size(C,1)-1)
    for sci=1:10
        dif=sci/10-0.1;
        cmapC(10*ci-10+sci,1:3)=C(ci,:).*(1-dif)+C(ci+1,:).*dif;
    end
end
cmapC(end+1,:)=cmapC(1,:);

% nonparametric test 
MeanMissPh=circ_mean(missPh,[],2);
MeanCorrPh=circ_mean(corrPh,[],2);
for chani=1:248
    p(chani) = circ_cmtest(CorrPh(chani,:),MissPh(chani,:));
end
cfg=[];
cfg.colormap=cmapC;
cfg.interpolate='nearest';
cfg.style='straight';
cfg.highlight='labels';
cfg.highlightchannel=find(p<0.05);
figure;topoplot248(MeanMissPh,cfg);title('Miss')
colorbar
figure;topoplot248(MeanCorrPh,cfg);title('Correct')
colorbar

[~,pr]=ttest(CorrR',MissR');
cfg=[];
cfg.zlim=[0 max([max(mean(MissR,2)) max(mean(CorrR,2)) ])];
cfg.highlight='labels';
cfg.highlightchannel=find(pr<0.05);
figure;topoplot248(mean(MissR,2),cfg);title('Miss')
colorbar
figure;topoplot248(mean(CorrR,2),cfg);title('Correct')
colorbar

% cfg=[];
% cfg.zlim=[0.9 1];
% cfg.interpolation='linear';
% figure;topoplot248(1-p,cfg);
% 
% %% plot angle of selected channels
% conds={'Miss','Correct'};
% switch method
%     case 'allSig' % all sig channels
%         Pi=find(p<0.05);
%         if isempty(Pi)
%             display('no sig results!')
%         else
%             for chi=Pi
%                 plotChan(MissPh(chi,:)',CorrPh(chi,:)',datafinal.label{chi})
%             end
%         end
%     case 'mostSig' % most sig channel and peak PSD channel
%         [P,Pi]=min(p);
%         if P>0.05
%             display('no sig results!')
%         else
%             plotChan(MissPh(Pi,:)',CorrPh(Pi,:)',[datafinal.label{Pi},' most sig, p = ',num2str(P)],conds);
%             [~,Pi]=max((mean(MissPSD,2)+mean(CorrPSD,2)));
%             plotChan(MissPh(Pi,:)',CorrPh(Pi,:)',[datafinal.label{Pi},' peak PSD, p = ',num2str(p(Pi))],conds);
%         end
% end
% disp(' ')
% function plotChan(MissPh,CorrPh,chanName,conds)
% figure('name',chanName); % A145
% subplot(2,1,1)
% circ_plotYH(MissPh,'pretty','bo',conds{1},true,'linewidth',2,'color','r');
% %title(chanName)
% subplot(2,1,2)
% circ_plotYH(CorrPh,'pretty','bo',conds{2},true,'linewidth',2,'color','r');

% 
% subplot(2,2,4)
% circ_plot(CorrPh(135,:)','hist',[],20,true,true,'linewidth',2,'color','r')
% title('Miss');
% figure;topoplot248(mean(CorrPSD,2),cfg)
% title('Correct');

% plot PSD

% cfg.highlightchannel=find(ttest(MissPSD',CorrPSD'));
% cfg.zlim=[0 max([mean(MissPSD,2);mean(CorrPSD,2)])];
% figure;topoplot248(mean(MissPSD,2),cfg)
% title('Miss');
% figure;topoplot248(mean(CorrPSD,2),cfg)
% title('Correct');

% plot which were max frequencies
% cfg.highlightchannel=find(ttest(MissF',CorrF'));
% cfg.zlim=[min([mean(MissF,2);mean(CorrF,2)]) max([mean(MissF,2);mean(CorrF,2)])];
% figure;topoplot248(mean(MissF,2),cfg)
% title('Miss');
% figure;topoplot248(mean(CorrF,2),cfg)
% title('Correct');
% [~,p]=ttest(MissR',CorrR');
% cfg.highlightchannel=find(ttest(MissR',CorrR'));
% cfg.zlim=[0 max([mean(MissR,2);mean(CorrR,2)])];
% figure;topoplot248(mean(MissR,2),cfg)
% title('Miss');
% figure;topoplot248(mean(CorrR,2),cfg)
% title('Correct');

% for chani=1:248
%      P = circ_wwtestYH(CorrPh(chani,:),MissPh(chani,:));
%      if isempty(P)
%          p(chani)=1;
%      else
%         p(chani)=P;
%      end
% end
% 
% cfg.highlightchannel=find(p<0.05);
% cfg.zlim=[0 max([mean(MissPSD,2);mean(CorrPSD,2)])];
% figure;topoplot248(mean(MissPSD,2),cfg)
% title('Miss');
% figure;topoplot248(mean(CorrPSD,2),cfg)
% title('Correct');



% figure; % A65
% subplot(2,2,1)
% circ_plot(MissPh(13,:)','pretty','bo',true,'linewidth',2,'color','r'),
% 
% subplot(2,2,3)
% circ_plot(MissPh(13,:)','hist',[],20,true,true,'linewidth',2,'color','r')
% 
% subplot(2,2,2)
% circ_plot(CorrPh(13,:)','pretty','bo',true,'linewidth',2,'color','r'),
% 
% subplot(2,2,4)
% circ_plot(CorrPh(13,:)','hist',[],20,true,true,'linewidth',2,'color','r')
% 
% 
% 


