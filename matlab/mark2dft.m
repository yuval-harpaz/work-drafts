function mark2dft(foi,toi)
% foi is a vector of desired frequencies

% what is phase? it is how much ahead the first peak is going to be.
% if the peak is at sample 1 phase = 0. if peak (for 10Hz) is at
% sample 34 phase is pi. sRate = 678.17

        
if ~exist('method','var')
    method='mostSig';
end
if ~exist('foi','var')
    foi=[];
end
if isempty(foi)
    foi=10;
end
if ~exist('toi','var')
    toi=[];
end
if isempty(toi)
    toi=[-0.5 0];
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
    nTrl=min([length(corri),length(missi)]);
    corri=corri(1:nTrl);
    missi=missi(1:nTrl);
    s0=nearest(datafinal.time{1},toi(2));
    sBL=nearest(datafinal.time{1},toi(1));
%     [~,F]=fftBasic(datafinal.trial{1}(1,sBL:s0),datafinal.fsample);
%     foii=nearest(F,foi);
    for trli=1:length(corri)
        %[filt] = ft_preproc_dftfilter(datafinal.trial{corri(trli)}(:,sBL:s0),678.162, foi);
        [~,est] = dft(datafinal.trial{corri(trli)}(:,sBL:s0),datafinal.fsample, foi);
        ang=angle(est); % this gives instanteneous phase. maybe unwarp not necessary
        corrPh(1:248,trli)=2*pi-mod(angle(est(:,1)),2*pi);
       [~,est] = dft(datafinal.trial{missi(trli)}(:,sBL:s0),datafinal.fsample, foi);
        ang=angle(est); % this gives instanteneous phase. maybe unwarp not necessary
        missPh(1:248,trli)=2*pi-mod(angle(est(:,1)),2*pi);
    end
    MissPh(1:248,subi) = circ_mean(missPh(:,1:nTrl),[],2);
    MissR(1:248,subi) = circ_r(missPh(:,1:nTrl), [],[], 2);
    CorrPh(1:248,subi) = circ_mean(corrPh(:,1:nTrl),[],2);
    CorrR(1:248,subi) = circ_r(corrPh(:,1:nTrl), [],[], 2);
    disp(['done ',folder])
    cd ..
end


%% phase + circular colormap

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


