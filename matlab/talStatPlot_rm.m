function [P,figure1]=talStatPlot_rm(data1,data2,data3,data4,xlim,zlim,chans,midline,pthr); %#ok<INUSD>
% independent sample ttest (two groups)
%  stat=statPlot('cohLRv1pre_DM','cohLRv1pre_CM',[10 10],[],'ttest2')



cfg=[];
if exist('zlim','var')
    cfg.zlim=zlim;
else
    cfg.zlim=[];
end
if isempty(cfg.zlim)
    cfg.zlim='maxmin';
end
for datai=1:4
    istr=num2str(datai);
    eval(['[title',istr,',data',istr,']=getparts(data',istr,');'])
end

if isfield(data1,'individual')
    dataMat='individual';
elseif isfield(data1,'powspctrm')
    dataMat='powspctrm';
else
    error('needs data.individual or data.powspctrm')
end
cfg.xlim=xlim;
cfg.layout = '4D248.lay';
if length(data1.label)<35
    cfg.layout = 'WG32.lay'
end
% deleting pairs of bad chans
for datai=1:4
    istr=num2str(datai);
    eval(['data',istr,'=badchanss(data',istr,',dataMat);'])
    if exist('midline','var')
        load LRpairs
        eval(['data',istr,'=midline1(data',istr,',dataMat,LRpairs);'])
    end
end


%% repeated measure anova (2x2)
P=ones(length(data1.label),3);
geiger=1;
for chani=1:length(chans)
    [~,chi]=ismember(chans{chani,1},data1.label);
    dyslexia=[data1.powspctrm(:,chi,xlim(1)),data3.powspctrm(:,chi,xlim(1))];
    control=[data2.powspctrm(:,chi,xlim(1)),data4.powspctrm(:,chi,xlim(1))];
    
    %[p, table] = anova_rm(dyslexia)
    %[p, table] = anova_rm(control)
    %[p, table] = anova_rm({dyslexia control});
    p = anova_rm({dyslexia control},'off');
    P(chi,:)=p([1 2 4]);
    if p(2)<pthr %|| strcmp(data1.label{chi},'A210')
%         disp(data1.label{chi})
%         means=[mean(dyslexia(:,1)),mean(control(:,1)),mean(dyslexia(:,2)),mean(control(:,2))];
%         disp([title1(end-6:end),' ',title2(end-6:end),' ',title3(end-6:end),' ',title4(end-6:end)])
%         disp(means)
%         pause
        [~,table]=anova_rm({dyslexia control},'off');
        Fs(geiger)=table{3,5};
        geiger=geiger+1;
    end
end
labels={'Time','Group','Interaction'};

dataavg=data1;
dataavg.powspctrm=(mean(data1.powspctrm)+mean(data2.powspctrm)+mean(data3.powspctrm)+mean(data4.powspctrm))/4;
cfg.highlight = 'labels';
cfg.comment = 'no';
cfg.zlim=zlim;
%    cfg.highlightchannel = find(stat.prob<0.05);

figure1=figure('Units','normalized','Position',[0 0 1 1]);
for Fi=1:3
    cfg.highlightchannel=find(P(:,Fi)<pthr);
    subplot(1,3,Fi)
    ft_topoplotER(cfg,dataavg)
    title(labels{Fi});
end
figure2=figure('Units','normalized','Position',[0 0 1 1]);
for pli=1:4
    subplot(1,4,pli)
    eval(['ft_topoplotER(cfg,data',num2str(pli),');'])
    eval(['titlei=title',num2str(pli)])
    title(strrep(titlei,'_',' '));
end
Fs
function [title,data]=getparts(data) %#ok<DEFNU>
load(data)
if isempty(findstr('/',data))
    path1=pwd;
else
    [path1, data] = fileparts(data);
end
title=[path1(end-7:end),'/',data];
eval(['data=',data])

function data=badchanss(data,dataMat)
data.label=data.label([1:132,134:246],1);
eval(['data.',dataMat,'=data.',dataMat,'(:,[1:132,134:246],:);'])
data.label=data.label([1:68,70:245],1);
eval(['data.',dataMat,'=data.',dataMat,'(:,[1:68,70:245],:);'])

function data=midline1(data,dataMat,LRpairs)
eval(['tmp=data.',dataMat,';'])
eval(['data.',dataMat,'=ones(size(data.',dataMat,'));'])
[~,chi]=ismember(LRpairs(:,1),data.label); %#ok<NODEF>
chi=chi(chi>0); %#ok<*NASGU>
eval(['data.',dataMat,'(:,chi,:)=tmp(:,chi,:);']);
[~,chi]=ismember(LRpairs(:,2),data.label);
chi=chi(chi>0); %#ok<*NASGU>
eval(['data.',dataMat,'(:,chi,:)=tmp(:,chi,:);']);
clear tmp
